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
            'user'          => new UserResource($user),
            'recentImages'  => ImageResource::collection($images),
            'stats'         => [
                'total_images'   => $request->user()->images()->count(),
                'storage_used'   => $request->user()->storage_used,
                'storage_limit'  => $user->plan?->storage_limit ?? config('iris.plans.free.storage_limit'),
                'storage_percent'=> $request->user()->storage_percent,
                'shared_links'   => $request->user()->sharedLinks()->active()->count(),
            ],
        ]);
    }
}