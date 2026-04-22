<?php

namespace App\Http\Controllers;

use App\Http\Resources\ImageResource;
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
            // Pass user fields directly — avoids the { data: {...} } wrapper
            // that JsonResource adds, which breaks Vue prop destructuring.
            'user' => [
                'id'                 => $user->id,
                'name'               => $user->name,
                'email'              => $user->email,
                'avatar'             => $user->avatar_url,
                'is_admin'           => $user->is_admin,
                'storage_used'       => $user->storage_used,
                'storage_used_human' => $user->storage_used_human,
                'storage_limit'      => $user->plan?->storage_limit
                                        ?? config('iris.plans.free.storage_limit'),
                'storage_percent'    => $user->storage_percent,
            ],

            'recentImages' => ImageResource::collection($images),

            'stats' => [
                'total_images' => $user->images()->count(),
                'shared_links' => $user->sharedLinks()->active()->count(),
            ],
        ]);
    }
}