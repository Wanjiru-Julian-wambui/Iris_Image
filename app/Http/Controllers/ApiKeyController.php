<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class ApiKeyController extends Controller
{
    public function index(Request $request): Response
    {
        $tokens = $request->user()
            ->tokens()
            ->latest()
            ->get()
            ->map(fn($token) => [
                'id'           => $token->id,
                'name'         => $token->name,
                'abilities'    => $token->abilities,
                'last_used_at' => $token->last_used_at?->diffForHumans(),
                'created_at'   => $token->created_at->toDateTimeString(),
                'expires_at'   => $token->expires_at?->toDateTimeString(),
            ]);

        return Inertia::render('settings/ApiKeys', [
            'tokens' => $tokens,
        ]);
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'name'       => ['required', 'string', 'max:100'],
            'abilities'  => ['array'],
            'abilities.*'=> ['string', 'in:read,write,delete'],
            'expires_in' => ['nullable', 'integer', 'min:1', 'max:365'],
        ]);

        $abilities  = $data['abilities'] ?? ['read'];
        $expiresAt  = isset($data['expires_in'])
            ? now()->addDays($data['expires_in'])
            : null;

        $token = $request->user()->createToken(
            $data['name'],
            $abilities,
            $expiresAt,
        );

        return back()->with([
            'new_token' => $token->plainTextToken,
            'success'   => 'API key created. Copy it now — it will not be shown again.',
        ]);
    }

    public function destroy(Request $request, int $tokenId)
    {
        $request->user()->tokens()->where('id', $tokenId)->delete();

        return back()->with('success', 'API key revoked.');
    }

    public function destroyAll(Request $request)
    {
        $request->user()->tokens()->delete();

        return back()->with('success', 'All API keys revoked.');
    }
}