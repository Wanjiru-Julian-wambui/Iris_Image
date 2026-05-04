<?php

namespace App\Http\Controllers;

use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Cache;

class EmojiController extends Controller
{
    public function index(): JsonResponse
    {
        $emojis = Cache::remember('emojis_all', 86400, function () {
            $response = Http::timeout(10)->get('https://emojihub.yurace.pro/api/all');

            if (!$response->successful()) {
                return [];
            }

            return $response->json() ?? [];
        });

        $transformed = array_map(function ($item) {
            // Convert U+XXXX code points to actual emoji characters
            $emoji = $this->toEmoji($item['unicode'][0] ?? $item['character'] ?? '');

            return [
                'emoji'    => $emoji,
                'name'     => $item['name'] ?? 'Unknown',
                'category' => $item['category'] ?? 'Other',
                'group'    => $item['group'] ?? 'Other',
                'keywords' => array_merge(
                    explode(' ', strtolower(str_replace('_', ' ', $item['name'] ?? ''))),
                    explode(' ', strtolower(str_replace('-', ' ', $item['category'] ?? ''))),
                    explode(' ', strtolower(str_replace('-', ' ', $item['group'] ?? '')))
                ),
            ];
        }, $emojis);

        $transformed = array_filter($transformed, fn($e) => !empty($e['emoji']));

        return response()->json(array_values($transformed));
    }

    /**
     * Convert Unicode code point string (U+1F600) to actual emoji character.
     */
    private function toEmoji(string $value): string
    {
        // If it's already an emoji character, return as-is
        if (mb_strlen($value) === 1 || preg_match('/\p{So}/u', $value)) {
            return $value;
        }

        // Handle U+XXXX format
        if (str_starts_with($value, 'U+')) {
            $hex = substr($value, 2);
            $codePoint = hexdec($hex);
            return mb_chr($codePoint, 'UTF-8') ?? '';
        }

        // Handle multiple code points separated by space (e.g., "U+1F1FA U+1F1F8")
        if (str_contains($value, 'U+')) {
            $parts = explode(' ', $value);
            $result = '';
            foreach ($parts as $part) {
                $part = trim($part);
                if (str_starts_with($part, 'U+')) {
                    $hex = substr($part, 2);
                    $codePoint = hexdec($hex);
                    $char = mb_chr($codePoint, 'UTF-8');
                    if ($char) {
                        $result .= $char;
                    }
                }
            }
            return $result;
        }

        return $value;
    }
}