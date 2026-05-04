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
            $this->applySingle($gd, $text, $fontPath, $fontSize, $angle, $textColor, $shadowColor, $opts['position'], (int) $opts['padding'], (int) $opts['density']);
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

    private function applySingle(\GdImage $gd, string $text, string $fontPath, int $fontSize, int $angle, int $textColor, int $shadowColor, string $position, int $padding, int $density = 1): void
    {
        $iW   = imagesx($gd);
        $iH   = imagesy($gd);

        // Measure at 0° for reliable sizing
        $bboxFlat = imagettfbbox($fontSize, 0, $fontPath, $text);
        $tW       = abs($bboxFlat[4] - $bboxFlat[0]);
        $tH       = abs($bboxFlat[5] - $bboxFlat[1]);

        if ($density <= 1) {
            // Single copy at chosen position
            [$x, $y] = $this->resolvePosition($position, $iW, $iH, $tW, $tH, $padding);
            imagettftext($gd, $fontSize, $angle, $x + 2, $y + 2, $shadowColor, $fontPath, $text);
            imagettftext($gd, $fontSize, $angle, $x,     $y,     $textColor,   $fontPath, $text);
            return;
        }

        // Multiple copies: spread evenly across the image in a diagonal line
        $stepX = (int) ($iW / ($density + 1));
        $stepY = (int) ($iH / ($density + 1));
        for ($i = 1; $i <= $density; $i++) {
            $x = $stepX * $i - (int)($tW / 2);
            $y = $stepY * $i;
            imagettftext($gd, $fontSize, $angle, $x + 2, $y + 2, $shadowColor, $fontPath, $text);
            imagettftext($gd, $fontSize, $angle, $x,     $y,     $textColor,   $fontPath, $text);
        }
    }

    private function applyTiled(\GdImage $gd, string $text, string $fontPath, int $fontSize, int $angle, int $textColor, int $shadowColor, int $density): void
    {
        $iW      = imagesx($gd);
        $iH      = imagesy($gd);
        $density = max(1, min(6, $density));

        // Measure at 0° so the bbox reflects the raw text size, not the rotated envelope.
        // Using the rotated bbox inflates spacing dramatically and causes only 1 tile to appear.
        $bboxFlat = imagettfbbox($fontSize, 0, $fontPath, $text);
        $textW    = abs($bboxFlat[4] - $bboxFlat[0]);
        $textH    = abs($bboxFlat[5] - $bboxFlat[1]);

        // Gap between tiles — density 1 = loose, density 6 = tight
        $gapMultiplier = 4.5 - ($density * 0.5);           // 4.0 … 1.5
        $spacingX = (int) ($textW * $gapMultiplier) + 20;
        $spacingY = (int) ($textH * $gapMultiplier * 1.8) + 20;

        // Ensure we always have enough columns and rows to cover the image
        $spacingX = max($spacingX, 60);
        $spacingY = max($spacingY, 40);

        $row = 0;
        // Start above the image top so rotated text at the top edge is visible
        for ($y = -$spacingY; $y < $iH + $spacingY * 2; $y += $spacingY) {
            // Stagger every other row by half the column spacing
            $offsetX = ($row % 2 === 1) ? (int) ($spacingX / 2) : 0;
            for ($x = $offsetX - $spacingX; $x < $iW + $spacingX; $x += $spacingX) {
                // baseline for imagettftext = y + textH (text renders above baseline)
                $baseY = $y + $textH;
                imagettftext($gd, $fontSize, $angle, $x + 1, $baseY + 1, $shadowColor, $fontPath, $text);
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