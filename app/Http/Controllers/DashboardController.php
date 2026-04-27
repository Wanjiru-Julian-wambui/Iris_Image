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

        $storageTrend = $request->user()
            ->images()
            ->selectRaw('DATE(created_at) as date, SUM(size) as total_size')
            ->where('created_at', '>=', now()->subDays(30))
            ->groupBy('date')
            ->orderBy('date')
            ->get()
            ->map(fn($row) => [
                'date' => $row->date,
                'size' => (int) $row->total_size,
            ]);

        $uploadsPerDay = $request->user()
            ->images()
            ->selectRaw('DATE(created_at) as date, COUNT(*) as count')
            ->where('created_at', '>=', now()->subDays(30))
            ->groupBy('date')
            ->orderBy('date')
            ->get()
            ->map(fn($row) => [
                'date'  => $row->date,
                'count' => (int) $row->count,
            ]);

        $linkViews = \DB::table('shared_links')
            ->selectRaw('DATE(created_at) as date, SUM(view_count) as views')
            ->where('user_id', $request->user()->id)
            ->where('created_at', '>=', now()->subDays(30))
            ->groupBy('date')
            ->orderBy('date')
            ->get()
            ->map(fn($row) => [
                'date'  => $row->date,
                'views' => (int) $row->views,
            ]);

        return Inertia::render('Dashboard', [
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
                'total_images'    => $user->images()->count(),
                'shared_links'    => $user->sharedLinks()->active()->count(),
                'download_count'  => $user->images()->sum('download_count'),
            ],

            'charts' => [
                'storageTrend'  => $storageTrend,
                'uploadsPerDay' => $uploadsPerDay,
                'linkViews'     => $linkViews,
            ],
        ]);
    }
}