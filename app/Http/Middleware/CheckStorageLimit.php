<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class CheckStorageLimit
{
    public function handle(Request $request, Closure $next): Response
    {
        $user = $request->user();

        if (!$user) {
            return $next($request);
        }

        $plan          = $user->plan;
        $storageLimit  = $plan?->storage_limit ?? config('iris.plans.free.storage_limit');
        $storageUsed   = $user->storage_used ?? 0;

        if ($storageUsed >= $storageLimit) {
            if ($request->expectsJson()) {
                return response()->json([
                    'message'       => 'You have reached your storage limit. Please upgrade your plan.',
                    'storage_used'  => $storageUsed,
                    'storage_limit' => $storageLimit,
                ], 403);
            }

            return redirect()->route('plans.index')->with('error',
                'You have reached your storage limit. Please upgrade your plan to continue uploading.'
            );
        }

        return $next($request);
    }
}