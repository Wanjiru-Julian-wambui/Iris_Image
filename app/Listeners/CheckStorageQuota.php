<?php

namespace App\Listeners;

use App\Events\ImageUploaded;
use App\Mail\StorageWarningMail;
use App\Models\User;
use Illuminate\Support\Facades\Mail;

class CheckStorageQuota
{
    public function handle(ImageUploaded $event): void
    {
        $user = $event->image->user;

        if (! $user->storage_limit || $user->storage_limit === 0) {
            return;
        }

        $percent = ($user->storage_used / $user->storage_limit) * 100;

        foreach ([70, 90] as $threshold) {
            if ($percent >= $threshold && ! $this->alreadySent($user, $threshold)) {
                Mail::to($user->email)->queue(new StorageWarningMail($user, $threshold, $percent));
                $this->markSent($user, $threshold);
            }
        }
    }

    private function alreadySent(User $user, int $threshold): bool
    {
        $column = "storage_warning_{$threshold}_sent_at";
        if (! isset($user->$column)) return false;

        // Reset if usage has dropped below threshold since last send
        $currentPercent = ($user->storage_used / $user->storage_limit) * 100;
        if ($currentPercent < $threshold) {
            $user->update([$column => null]);
            return false;
        }

        return $user->$column !== null;
    }

    private function markSent(User $user, int $threshold): void
    {
        $column = "storage_warning_{$threshold}_sent_at";
        $user->update([$column => now()]);
    }
}