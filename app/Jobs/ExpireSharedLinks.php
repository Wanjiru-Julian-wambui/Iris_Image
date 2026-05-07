<?php

namespace App\Jobs;

use App\Events\LinkExpired;
use App\Models\SharedLink;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;

class ExpireSharedLinks implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public function handle(): void
    {
        SharedLink::query()
            ->where('is_expired', false)
            ->whereNotNull('expires_at')
            ->where('expires_at', '<=', now())
            ->each(function (SharedLink $link) {
                $link->update(['is_expired' => true]);
                LinkExpired::dispatch($link);
            });
    }
}