<?php

namespace App\Services;

use App\Models\Image;
use Illuminate\Support\Facades\Storage;

class WatermarkService
{
    public function apply(Image $image, string $text, array $options = []): string
    {
        $opts = array_merge([
            'position' => 'bottom-right',
            'opacity'  => 60,
            'padding'  => 20,
        ], $options);

        // Pull file bytes from disk (local or S3)
        $disk     = config('filesystems.default');
        $contents = Storage::disk($disk)->get($image->path);

        if (!$contents) {
            throw new \RuntimeException('Image not found on disk.');
        }

        $gd = $this->createFromBytes($contents, $image->mime_type);

        if (!$gd) {
            throw new \RuntimeException('GD could not load image.');
        }

        $width  = imagesx($gd);
        $height = imagesy($gd);

        $alpha     = (int) (127 - ($opts['opacity'] / 100 * 127));
        $textCol   = imagecolorallocatealpha($gd, 255, 255, 255, $alpha);
        $shadowCol = imagecolorallocatealpha($gd, 0, 0, 0, max(0, $alpha - 20));

        $font  = 5;
        $textW = strlen($text) * imagefontwidth($font);
        $textH = imagefontheight($font);

        [$x, $y] = $this->position($opts['position'], $width, $height, $textW, $textH, $opts['padding']);

        imagestring($gd, $font, $x + 2, $y + 2, $text, $shadowCol);
        imagestring($gd, $font, $x,     $y,     $text, $textCol);

        $tempDir  = storage_path('app/temp');
        if (!is_dir($tempDir)) mkdir($tempDir, 0755, true);

        $tempPath = "{$tempDir}/wm-" . uniqid() . ".{$image->extension}";
        $this->save($gd, $tempPath, $image->mime_type);
        imagedestroy($gd);

        return $tempPath;
    }

    private function createFromBytes(string $bytes, string $mime): \GdImage|false
    {
        $img = imagecreatefromstring($bytes); // works for jpeg/png/gif/webp
        return $img;
    }

    private function save(\GdImage $gd, string $path, string $mime): void
    {
        match (true) {
            str_contains($mime, 'png')  => imagepng($gd, $path, 6),
            str_contains($mime, 'gif')  => imagegif($gd, $path),
            str_contains($mime, 'webp') => imagewebp($gd, $path, 90),
            default                     => imagejpeg($gd, $path, 90),
        };
    }

    private function position(
        string $pos, int $iW, int $iH, int $tW, int $tH, int $pad
    ): array {
        return match ($pos) {
            'top-left'    => [$pad, $pad],
            'top-right'   => [$iW - $tW - $pad, $pad],
            'bottom-left' => [$pad, $iH - $tH - $pad],
            'center'      => [($iW - $tW) / 2, ($iH - $tH) / 2],
            default       => [$iW - $tW - $pad, $iH - $tH - $pad],
        };
    }
}