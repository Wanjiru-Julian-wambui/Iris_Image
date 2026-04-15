<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Symfony\Component\HttpFoundation\Response;

class RequiresPlanSelection
{
    /**
     * Routes that should never redirect to the plan chooser.
     * Add any API / webhook / upload paths here.
     */
    protected array $except = [
        'plans/choose',
        'plans/select',
        'plans/*/checkout',
        'plans/*/capture',
    ];

    public function handle(Request $request, Closure $next): Response
    {
        if (Auth::check() && ! Auth::user()->plan_id) {
            // Don't loop on the chooser / payment routes themselves
            if (! $request->routeIs('plans.choose', 'plans.select', 'plans.checkout', 'plans.capture')) {
                return redirect()->route('plans.choose');
            }
        }

        return $next($request);
    }
}