<?php

namespace App\Services;

use App\Models\Image;
use App\Models\User;
use Illuminate\Http\UploadedFile;

class DuplicateDetectorService
{
    public function hashFile(UploadedFile $file): string
    {
        return hash_file('sha256', $file->getRealPath());
    }

    public function findDuplicate(string $hash, User $user): ?Image
    {
        return Image::where('user_id', $user->id)
            ->where('hash', $hash)
            ->first();
    }

    /**
     * @param  UploadedFile[]  $files
     * @return array<int, array{ hash: string, file: UploadedFile, duplicate: ?Image }>
     */
    public function checkBatch(array $files, User $user): array
    {
        $results = [];

        foreach ($files as $index => $file) {
            $hash      = $this->hashFile($file);
            $duplicate = $this->findDuplicate($hash, $user);

            $results[$index] = [
                'hash'      => $hash,
                'file'      => $file,
                'duplicate' => $duplicate,
            ];
        }

        return $results;
    }
}