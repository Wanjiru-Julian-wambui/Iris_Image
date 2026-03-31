<?php

namespace App\Services;

use Illuminate\Http\UploadedFile;

class ExifService
{
    /**
     * Read EXIF data from an image file.
     */
    public function read(UploadedFile|string $file): array
    {
        $path = $file instanceof UploadedFile ? $file->getRealPath() : $file;

        if (!function_exists('exif_read_data')) {
            return [];
        }

        try {
            $exif = @exif_read_data($path, null, true);
            return $exif ?: [];
        } catch (\Throwable) {
            return [];
        }
    }

    /**
     * Strip EXIF metadata from an image and save it back.
     * Works for JPEG files. PNG/GIF/WEBP don't carry EXIF.
     */
    public function strip(string $filePath): bool
    {
        $mime = mime_content_type($filePath);

        if (!in_array($mime, ['image/jpeg', 'image/jpg', 'image/tiff'])) {
            return true;
        }

        if (!extension_loaded('imagick')) {
            return $this->stripWithGd($filePath);
        }

        return $this->stripWithImagick($filePath);
    }

    private function stripWithImagick(string $filePath): bool
    {
        try {
            $imagick = new \Imagick($filePath);
            $imagick->stripImage();
            $imagick->writeImage($filePath);
            $imagick->destroy();
            return true;
        } catch (\Throwable) {
            return false;
        }
    }

    private function stripWithGd(string $filePath): bool
    {
        try {
            $image = imagecreatefromjpeg($filePath);
            if (!$image) return false;
            imagejpeg($image, $filePath, 95);
            imagedestroy($image);
            return true;
        } catch (\Throwable) {
            return false;
        }
    }

    /**
     * Extract GPS coordinates if present.
     */
    public function getGps(array $exif): ?array
    {
        if (empty($exif['GPS'])) {
            return null;
        }

        try {
            $lat = $this->convertGps(
                $exif['GPS']['GPSLatitude'],
                $exif['GPS']['GPSLatitudeRef']
            );
            $lng = $this->convertGps(
                $exif['GPS']['GPSLongitude'],
                $exif['GPS']['GPSLongitudeRef']
            );

            return ['lat' => $lat, 'lng' => $lng];
        } catch (\Throwable) {
            return null;
        }
    }

    private function convertGps(array $coords, string $ref): float
    {
        [$deg, $min, $sec] = array_map(function ($val) {
            [$num, $den] = array_map('intval', explode('/', $val));
            return $den ? $num / $den : 0;
        }, $coords);

        $decimal = $deg + ($min / 60) + ($sec / 3600);

        return in_array($ref, ['S', 'W']) ? -$decimal : $decimal;
    }
}