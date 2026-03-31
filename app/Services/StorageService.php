<?php

namespace App\Services;

use App\Models\User;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class StorageService
{
    /**
     * Store an uploaded file and return its storage path.
     */
    public function store(UploadedFile $file, User $user): string
    {
        $folder    = "images/{$user->id}/" . now()->format('Y/m');
        $filename  = Str::uuid() . '.' . $file->getClientOriginalExtension();

        return $file->storeAs($folder, $filename, 'public');
    }

    /**
     * Delete a file from storage.
     */
    public function delete(string $path): bool
    {
        return Storage::disk('public')->delete($path);
    }

    /**
     * Check if user has enough space for the given file size.
     */
    public function hasSpace(User $user, int $fileSize): bool
    {
        $limit = $user->plan?->storage_limit
            ?? config('iris.plans.free.storage_limit');

        return ($user->storage_used + $fileSize) <= $limit;
    }

    /**
     * Get the storage usage percentage for a user.
     */
    public function usagePercent(User $user): float
    {
        $limit = $user->plan?->storage_limit
            ?? config('iris.plans.free.storage_limit');

        if ($limit === 0) return 100;

        return round(($user->storage_used / $limit) * 100, 2);
    }

    /**
     * Get human-readable size string.
     */
    public function humanSize(int $bytes): string
    {
        if ($bytes >= 1073741824) {
            return number_format($bytes / 1073741824, 2) . ' GB';
        } elseif ($bytes >= 1048576) {
            return number_format($bytes / 1048576, 2) . ' MB';
        } elseif ($bytes >= 1024) {
            return number_format($bytes / 1024, 2) . ' KB';
        }

        return $bytes . ' B';
    }
}