<?php

namespace App\Services;

use App\Models\User;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class StorageService
{
    protected string $disk = 'public';

    /**
     * Store an uploaded file and return its storage path.
     */
    public function store(UploadedFile $file, User $user): string
    {
        $folder   = "images/{$user->id}/" . now()->format('Y/m');
        $filename = Str::uuid() . '.' . $file->getClientOriginalExtension();

        return Storage::disk($this->disk)->putFileAs(
            $folder,
            $file,
            $filename
        );
    }

    /**
     * Get absolute file path.
     */
    public function path(string $path): string
    {
        return Storage::disk($this->disk)->path($path);
    }

    /**
     * Delete file.
     */
    public function delete(string $path): bool
    {
        return Storage::disk($this->disk)->delete($path);
    }

    /**
     * Check storage space.
     */
    public function hasSpace(User $user, int $fileSize): bool
    {
        $limit = $user->plan?->storage_limit
            ?? config('iris.plans.free.storage_limit');

        return ($user->storage_used + $fileSize) <= $limit;
    }

    public function usagePercent(User $user): float
    {
        $limit = $user->plan?->storage_limit
            ?? config('iris.plans.free.storage_limit');

        if ($limit === 0) return 100;

        return round(($user->storage_used / $limit) * 100, 2);
    }

    public function humanSize(int $bytes): string
    {
        if ($bytes >= 1073741824) return number_format($bytes / 1073741824, 2) . ' GB';
        if ($bytes >= 1048576) return number_format($bytes / 1048576, 2) . ' MB';
        if ($bytes >= 1024) return number_format($bytes / 1024, 2) . ' KB';

        return $bytes . ' B';
    }
}