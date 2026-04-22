<?php

namespace App\Http\Controllers;

use App\Http\Resources\ImageResource;
use App\Http\Resources\UserResource;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class DashboardController extends Controller
{
    public function index(Request $request): Response
    {
        $user   = $request->user()->load('plan');
        $images = $request->user()
            ->images()
            ->latest()
            ->take(8)
            ->get();

        return Inertia::render('Dashboard', [
            // UserResource already exposes: name, email, avatar, storage_used_human,
            // storage_limit (raw bytes from plan), storage_percent
            'user'         => new UserResource($user),

            'recentImages' => ImageResource::collection($images),

            'stats'        => [
                'total_images' => $request->user()->images()->count(),
                'shared_links' => $request->user()->sharedLinks()->active()->count(),
            ],
        ]);
    }
}