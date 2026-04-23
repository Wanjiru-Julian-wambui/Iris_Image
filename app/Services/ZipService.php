<?php

namespace App\Services;

use Illuminate\Support\Collection;
use Illuminate\Support\Facades\Storage;
use ZipArchive;

class ZipService
{
    public function createFromImages(Collection $images): string
    {
        $tempDir = storage_path('app/temp');

        if (!is_dir($tempDir)) {
            mkdir($tempDir, 0755, true);
        }

        $zipPath = "{$tempDir}/iris-" . now()->timestamp . '.zip';
        $zip     = new ZipArchive();

        if ($zip->open($zipPath, ZipArchive::CREATE | ZipArchive::OVERWRITE) !== true) {
            throw new \RuntimeException('Could not create ZIP archive.');
        }

        foreach ($images as $image) {
            $disk = config('filesystems.default');

            // Works with both local and S3
            $contents = Storage::disk($disk)->get($image->path);

            if ($contents === null) {
                continue;
            }

            $filename = $this->uniqueFilename($zip, $image->original_name ?? $image->name);
            $zip->addFromString($filename, $contents);
        }

        $zip->close();

        return $zipPath;
    }

    private function uniqueFilename(ZipArchive $zip, string $filename): string
    {
        $info      = pathinfo($filename);
        $base      = $info['filename'];
        $ext       = isset($info['extension']) ? '.' . $info['extension'] : '';
        $counter   = 1;
        $candidate = $filename;

        while ($zip->locateName($candidate) !== false) {
            $candidate = "{$base} ({$counter}){$ext}";
            $counter++;
        }

        return $candidate;
    }
}