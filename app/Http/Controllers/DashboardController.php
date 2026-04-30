<?php

namespace App\Http\Controllers;

use App\Models\Image;
use App\Models\SharedLink;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Inertia\Inertia;
use Inertia\Response;

class DashboardController extends Controller
{
    public function index(Request $request): Response
    {
        $user = $request->user();
        $days = 30;
        $since = Carbon::now()->subDays($days)->startOfDay();

        // ── 1. Upload history — bar chart of images uploaded per day ──
        $uploadHistory = DB::table('images')
            ->selectRaw("DATE(created_at) as date, COUNT(*) as count")
            ->where('user_id', $user->id)
            ->where('created_at', '>=', $since)
            ->groupByRaw("DATE(created_at)")
            ->orderBy('date')
            ->get()
            ->map(fn ($row) => [
                'date'  => $row->date,
                'count' => (int) $row->count,
            ]);

        // Fill missing days with 0
        $uploadHistory = $this->fillDateRange($uploadHistory, $days, 'count');

        // ── 2. Storage trend — line chart of cumulative storage used over time ──
        $storageTrend = DB::table('images')
            ->selectRaw("DATE(created_at) as date, SUM(size) as daily_bytes")
            ->where('user_id', $user->id)
            ->where('created_at', '>=', $since)
            ->groupByRaw("DATE(created_at)")
            ->orderBy('date')
            ->get();

        // Calculate running cumulative total
        $cumulative = 0;
        $storageTrend = $storageTrend->map(function ($row) use (&$cumulative) {
            $cumulative += (int) $row->daily_bytes;
            return [
                'date'  => $row->date,
                'bytes' => $cumulative,
            ];
        });

        $storageTrend = $this->fillDateRange($storageTrend, $days, 'bytes', true);

        // ── 3. Link views — line chart of shared link views per day ──
        $linkViews = DB::table('shared_links')
            ->selectRaw("DATE(accessed_at) as date, COUNT(*) as views")
            ->where('created_by', $user->id)
            ->whereNotNull('accessed_at')
            ->where('accessed_at', '>=', $since)
            ->groupByRaw("DATE(accessed_at)")
            ->orderBy('date')
            ->get()
            ->map(fn ($row) => [
                'date'  => $row->date,
                'views' => (int) $row->views,
            ]);

        $linkViews = $this->fillDateRange($linkViews, $days, 'views');

        // ── Quick stats ──
        $stats = [
            'total_images'    => Image::where('user_id', $user->id)->count(),
            'total_albums'    => $user->albums()->count(),
            'total_links'     => SharedLink::where('created_by', $user->id)->count(),
            'total_views'     => SharedLink::where('created_by', $user->id)->sum('views') ?? 0,
            'storage_used'    => $user->storage_used_human,
            'storage_percent' => $user->storage_percent,
        ];

        return Inertia::render('Dashboard', [
            'stats'         => $stats,
            'uploadHistory' => $uploadHistory,
            'storageTrend'  => $storageTrend,
            'linkViews'     => $linkViews,
        ]);
    }

    /**
     * Fill missing dates in a range with zero/default values.
     */
    private function fillDateRange($collection, int $days, string $valueKey, bool $carryForward = false): array
    {
        $map = $collection->keyBy('date');
        $result = [];
        $carry = 0;

        for ($i = $days - 1; $i >= 0; $i--) {
            $date = Carbon::now()->subDays($i)->toDateString();

            if ($map->has($date)) {
                $value = $map[$date][$valueKey];
                if ($carryForward) {
                    $carry = $value;
                }
                $result[] = ['date' => $date, $valueKey => $value];
            } else {
                $result[] = ['date' => $date, $valueKey => $carryForward ? $carry : 0];
            }
        }

        return $result;
    }
}