<?php

namespace App\Http\Controllers;

use App\Http\Resources\ImageResource;
use App\Models\Image;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Session;
use Inertia\Inertia;
use Inertia\Response;

class PublicImageController extends Controller
{
    public function show(string $token)
    {
        $image = Image::where('public_token', $token)
            ->where('is_private', false)
            ->with(['user', 'tags', 'reactions'])
            ->firstOrFail();

        $userId = auth()->id();
        $ip = request()->ip();
        $fingerprint = $this->getFingerprint();

        // Get user's current reaction if any
        $userReaction = $image->reactions()
            ->when($userId, fn($q) => $q->where('user_id', $userId))
            ->when(!$userId, fn($q) => $q->where('ip_address', $ip)->where('session_fingerprint', $fingerprint))
            ->first();

        $image->setAttribute('user_reaction', $userReaction?->emoji);

        return Inertia::render('PublicImage', [
            'image' => new ImageResource($image),
        ]);
    }

    private function getFingerprint(): string
    {
        $sessionId = Session::getId();
        $userAgent = substr(request()->userAgent() ?? 'unknown', 0, 100);

        return hash('sha256', $sessionId . $userAgent);
    }
}