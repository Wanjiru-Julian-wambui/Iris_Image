<?php

namespace App\Services;

use Illuminate\Http\UploadedFile;

class ExifService
{
    public function read(UploadedFile|string $file): array
    {
        $path = $file instanceof UploadedFile ? $file->getRealPath() : $file;

        if (!function_exists('exif_read_data') || !$path || !file_exists($path)) {
            return [];
        }

        try {
            return @exif_read_data($path, null, true) ?: [];
        } catch (\Throwable) {
            return [];
        }
    }

    public function strip(string $filePath): bool
    {
        if (!$filePath || !file_exists($filePath)) {
            return false;
        }

        $mime = mime_content_type($filePath);

        if (!in_array($mime, ['image/jpeg', 'image/jpg', 'image/tiff'])) {
            return true;
        }

        return extension_loaded('imagick')
            ? $this->stripWithImagick($filePath)
            : $this->stripWithGd($filePath);
    }

    private function stripWithImagick(string $filePath): bool
    {
        try {
            $img = new \Imagick($filePath);
            $img->stripImage();
            $img->writeImage($filePath);
            $img->destroy();
            return true;
        } catch (\Throwable) {
            return false;
        }
    }

    private function stripWithGd(string $filePath): bool
    {
        try {
            $img = imagecreatefromjpeg($filePath);
            if (!$img) return false;

            imagejpeg($img, $filePath, 95);
            imagedestroy($img);

            return true;
        } catch (\Throwable) {
            return false;
        }
    }
}