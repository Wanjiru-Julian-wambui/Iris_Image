<?php

namespace App\Services;

use App\Models\Image;
use Illuminate\Support\Facades\Storage;

class WatermarkService
{
    /**
     * Available font styles mapped to system TTF paths.
     */
    private const FONTS = [
        'sans'       => '/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf',
        'sans-bold'  => '/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf',
        'serif'      => '/usr/share/fonts/truetype/dejavu/DejaVuSerif.ttf',
        'serif-bold' => '/usr/share/fonts/truetype/dejavu/DejaVuSerif-Bold.ttf',
        'mono'       => '/usr/share/fonts/truetype/dejavu/DejaVuSansMono.ttf',
        'oblique'    => '/usr/share/fonts/truetype/dejavu/DejaVuSans-Oblique.ttf',
    ];

    public function apply(Image $image, string $text, array $options = []): string
    {
        $opts = array_merge([
            'mode'     => 'single',
            'position' => 'bottom-right',
            'opacity'  => 60,
            'font'     => 'sans-bold',
            'size'     => 24,
            'angle'    => -30,
            'density'  => 3,
            'color'    => 'white',
            'padding'  => 30,
        ], $options);

        $disk     = config('filesystems.default');
        $contents = Storage::disk($disk)->get($image->path);

        if ($contents === null) {
            throw new \RuntimeException("Image not found on disk: {$image->path}");
        }

        $gd = imagecreatefromstring($contents);
        if (!$gd) {
            throw new \RuntimeException('GD could not decode image.');
        }

        imagesavealpha($gd, true);
        imagealphablending($gd, true);

        $fontPath = $this->resolveFontPath($opts['font']);
        $fontSize = max(8, min(120, (int) $opts['size']));
        $alpha    = (int) round(127 - ($opts['opacity'] / 100 * 127));
        $angle    = (int) $opts['angle'];

        [$r, $g, $b]    = $this->resolveColor($opts['color']);
        $textColor      = imagecolorallocatealpha($gd, $r, $g, $b, $alpha);

        [$sr, $sg, $sb] = $this->shadowColor($opts['color']);
        $shadowColor    = imagecolorallocatealpha($gd, $sr, $sg, $sb, max(0, $alpha - 25));

        if ($opts['mode'] === 'tiled') {
            $this->applyTiled($gd, $text, $fontPath, $fontSize, $angle, $textColor, $shadowColor, (int) $opts['density']);
        } else {
            $this->applySingle($gd, $text, $fontPath, $fontSize, $angle, $textColor, $shadowColor, $opts['position'], (int) $opts['padding']);
        }

        $tempDir = storage_path('app/temp');
        if (!is_dir($tempDir)) {
            mkdir($tempDir, 0755, true);
        }

        $tempPath = "{$tempDir}/wm-" . uniqid() . ".{$image->extension}";
        $this->save($gd, $tempPath, $image->mime_type);
        imagedestroy($gd);

        return $tempPath;
    }

    private function applySingle(\GdImage $gd, string $text, string $fontPath, int $fontSize, int $angle, int $textColor, int $shadowColor, string $position, int $padding): void
    {
        $iW   = imagesx($gd);
        $iH   = imagesy($gd);
        $bbox = imagettfbbox($fontSize, $angle, $fontPath, $text);
        $tW   = abs($bbox[4] - $bbox[0]);
        $tH   = abs($bbox[5] - $bbox[1]);

        [$x, $y] = $this->resolvePosition($position, $iW, $iH, $tW, $tH, $padding);
        imagettftext($gd, $fontSize, $angle, $x + 2, $y + 2, $shadowColor, $fontPath, $text);
        imagettftext($gd, $fontSize, $angle, $x,     $y,     $textColor,   $fontPath, $text);
    }

    private function applyTiled(\GdImage $gd, string $text, string $fontPath, int $fontSize, int $angle, int $textColor, int $shadowColor, int $density): void
    {
        $iW      = imagesx($gd);
        $iH      = imagesy($gd);
        $bbox    = imagettfbbox($fontSize, $angle, $fontPath, $text);
        $tW      = abs($bbox[4] - $bbox[0]) + 20;
        $tH      = abs($bbox[5] - $bbox[1]) + 20;
        $density = max(1, min(6, $density));

        // spacingX based on density: more density = tighter spacing
        $spacingX = (int) ($iW / max(1, $density));
        $spacingY = max((int) ($tH * (3.5 - ($density * 0.3))), $tH + 20);

        $row = 0;
        for ($y = (int)($tH * 1.5); $y < $iH + $tH * 2; $y += $spacingY) {
            $offsetX = ($row % 2 === 1) ? (int) ($spacingX / 2) : 0;
            for ($x = $offsetX - $tW; $x < $iW + $tW; $x += $spacingX) {
                $baseY = $y + $tH;
                imagettftext($gd, $fontSize, $angle, $x + 2, $baseY + 2, $shadowColor, $fontPath, $text);
                imagettftext($gd, $fontSize, $angle, $x,     $baseY,     $textColor,   $fontPath, $text);
            }
            $row++;
        }
    }

    private function resolvePosition(string $pos, int $iW, int $iH, int $tW, int $tH, int $pad): array
    {
        return match ($pos) {
            'top-left'     => [$pad,             $tH + $pad],
            'top-right'    => [$iW - $tW - $pad, $tH + $pad],
            'bottom-left'  => [$pad,             $iH - $pad],
            'center'       => [(int)(($iW - $tW) / 2), (int)(($iH + $tH) / 2)],
            default        => [$iW - $tW - $pad, $iH - $pad], // bottom-right
        };
    }

    private function resolveFontPath(string $font): string
    {
        $path     = self::FONTS[$font] ?? self::FONTS['sans-bold'];
        $fallback = '/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf';

        if (!file_exists($path)) {
            if (!file_exists($fallback)) {
                throw new \RuntimeException('No TTF font found. Run: apt-get install fonts-dejavu-core');
            }
            return $fallback;
        }
        return $path;
    }

    private function resolveColor(string $color): array
    {
        return match ($color) {
            'black' => [0,   0,   0  ],
            'gray'  => [150, 150, 150],
            default => [255, 255, 255],
        };
    }

    private function shadowColor(string $color): array
    {
        return match ($color) {
            'white' => [0,   0,   0  ],
            'black' => [220, 220, 220],
            default => [80,  80,  80 ],
        };
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
}