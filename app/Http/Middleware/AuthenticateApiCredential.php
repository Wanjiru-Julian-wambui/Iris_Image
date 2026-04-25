<?php

namespace App\Http\Middleware;

use App\Models\ApiCredential;
use Closure;
use Illuminate\Http\Request;
use Laravel\Sanctum\PersonalAccessToken;

/**
 * Accepts either:
 *  - Authorization: Bearer {sanctum_token}
 *  - X-API-Key + X-API-Secret headers
 */
class AuthenticateApiCredential
{
    public function handle(Request $request, Closure $next)
    {
        // Try Sanctum bearer token first
        if ($bearer = $request->bearerToken()) {
            $token = PersonalAccessToken::findToken($bearer);
            if ($token) {
                $token->forceFill(['last_used_at' => now()])->save();
                auth()->setUser($token->tokenable);
                return $next($request);
            }
        }

        // Try API Key + Secret
        $key    = $request->header('X-API-Key');
        $secret = $request->header('X-API-Secret');

        if ($key && $secret) {
            $credential = ApiCredential::where('api_key', $key)->first();
            if ($credential && password_verify($secret, $credential->api_secret)) {
                $credential->update(['last_used_at' => now()]);
                auth()->setUser($credential->user);
                return $next($request);
            }
        }

        return response()->json(['message' => 'Unauthenticated.'], 401);
    }
}