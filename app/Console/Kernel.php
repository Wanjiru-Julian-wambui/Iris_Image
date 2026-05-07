<?php

namespace App\Console;

use App\Jobs\ExpireSharedLinks;
use App\Jobs\SendLinkViewDigest;
use Illuminate\Console\Scheduling\Schedule;
use Illuminate\Foundation\Console\Kernel as ConsoleKernel;

class Kernel extends ConsoleKernel
{
    protected function schedule(Schedule $schedule): void
    {
        // ── Weekly link view digest — every Monday at 9am ─────────────────────
        $schedule->job(new SendLinkViewDigest)->weeklyOn(1, '9:00');

        // ── Expire shared links — check every 5 minutes ───────────────────────
        $schedule->job(new ExpireSharedLinks)->everyFiveMinutes();
    }

    protected function commands(): void
    {
        $this->load(__DIR__ . '/Commands');

        require base_path('routes/console.php');
    }
}