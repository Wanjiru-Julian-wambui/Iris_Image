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
            return [
                'emoji'    => $item['unicode'][0] ?? $item['character'] ?? '',
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
}