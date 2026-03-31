<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class AdminMiddleware
{
    public function handle(Request $request, Closure $next): Response
    {
        if (!$request->user()) {
            return redirect()->route('login');
        }

        if (!$request->user()->is_admin) {
            if ($request->expectsJson()) {
                return response()->json([
                    'message' => 'Unauthorized. Admin access required.',
                ], 403);
            }

            return redirect()->route('dashboard')->with('error',
                'You do not have permission to access this area.'
            );
        }

        return $next($request);
    }
}