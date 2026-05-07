<?php

namespace App\Jobs;

use App\Mail\LinkViewDigestMail;
use App\Models\LinkViewStat;
use App\Models\SharedLink;
use App\Models\User;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Mail;

class SendLinkViewDigest implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public function handle(): void
    {
        $weekStart = now()->subDays(7)->startOfDay();
        $weekEnd   = now()->endOfDay();

        // Find users who have at least one shared link with views in the last 7 days
        $userIds = LinkViewStat::query()
            ->where('viewed_at', '>=', $weekStart)
            ->join('shared_links', 'shared_links.id', '=', 'link_view_stats.shared_link_id')
            ->select('shared_links.user_id')
            ->distinct()
            ->pluck('user_id');

        User::whereIn('id', $userIds)->each(function (User $user) use ($weekStart, $weekEnd) {
            $this->sendDigest($user, $weekStart, $weekEnd);
        });
    }

    private function sendDigest(User $user, \Carbon\Carbon $weekStart, \Carbon\Carbon $weekEnd): void
    {
        // Fetch view stats grouped by shared link
        $linkStats = SharedLink::query()
            ->where('shared_links.user_id', $user->id)
            ->join('link_view_stats', 'link_view_stats.shared_link_id', '=', 'shared_links.id')
            ->where('link_view_stats.viewed_at', '>=', $weekStart)
            ->where('link_view_stats.viewed_at', '<=', $weekEnd)
            ->selectRaw('shared_links.id, shared_links.token, COUNT(*) as view_count')
            ->selectRaw('GROUP_CONCAT(DISTINCT link_view_stats.country ORDER BY link_view_stats.country SEPARATOR ",") as countries')
            ->groupBy('shared_links.id', 'shared_links.token')
            ->orderByDesc('view_count')
            ->get();

        if ($linkStats->isEmpty()) {
            return;
        }

        Mail::to($user->email)->queue(
            new LinkViewDigestMail($user, $linkStats, $weekStart, $weekEnd)
        );
    }
}