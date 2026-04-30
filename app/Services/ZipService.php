<?php

namespace App\Services;

use Illuminate\Support\Collection;
use Illuminate\Support\Facades\Storage;
use ZipArchive;

class ZipService
{
    public function createFromImages(Collection $images, array $watermark = []): string
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

        $watermarkService = !empty($watermark['enabled'])
            ? app(WatermarkService::class)
            : null;

        foreach ($images as $image) {
            $disk     = config('filesystems.default');
            $contents = Storage::disk($disk)->get($image->path);

            if ($contents === null) {
                continue;
            }

            // Apply watermark if requested
            if ($watermarkService) {
                try {
                    $tempPath = $watermarkService->apply($image, $watermark['text'], [
                        'position' => $watermark['position'] ?? 'bottom-right',
                        'opacity'  => $watermark['opacity']  ?? 60,
                    ]);
                    $contents = file_get_contents($tempPath);
                    @unlink($tempPath);
                } catch (\Throwable) {
                    // Watermark failed — fall back to original contents
                }
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