<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class EnforceIpAllowlist
{
    public function handle(Request $request, Closure $next): Response
    {
        $user = $request->user();

        // Only enforce for authenticated users who have an allowlist set
        if ($user && ! empty($user->ip_allowlist) && ! $user->isIpAllowed($request->ip())) {
            auth()->logout();
            $request->session()->invalidate();
            $request->session()->regenerateToken();

            return redirect()->route('login')
                ->withErrors(['email' => 'Access denied: your IP address is not on the allowlist.']);
        }

        return $next($request);
    }
}