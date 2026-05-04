<?php

namespace App\Http\Controllers;

use App\Models\Image;
use App\Models\ImageReaction;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Session;

class ImageReactionController extends Controller
{
    private const MAX_EMOJI_LENGTH = 8;

    public function store(Request $request, Image $image)
    {
        abort_if($image->is_private, 403, 'Cannot react to private images.');

        $data = $request->validate([
            'type'         => ['required', 'in:emoji,gif,sticker'],
            'emoji'        => ['required_if:type,emoji', 'nullable', 'string', 'max:' . self::MAX_EMOJI_LENGTH],
            'media_url'    => ['required_if:type,gif', 'required_if:type,sticker', 'nullable', 'url', 'max:500'],
            'media_label'  => ['nullable', 'string', 'max:100'],
            'media_source' => ['required_if:type,gif', 'required_if:type,sticker', 'nullable', 'in:giphy,upload'],
        ]);

        if ($data['type'] === 'emoji') {
            if (!$this->isEmoji($data['emoji'])) {
                return back()->withErrors(['emoji' => 'Must be a valid emoji.']);
            }
        }

        if (in_array($data['type'], ['gif', 'sticker']) && isset($data['media_url'])) {
            abort_unless($this->isAllowedMediaUrl($data['media_url']), 422, 'Media URL not from an allowed source.');
        }

        $userId      = auth()->id();
        $ip          = $request->ip();
        $fingerprint = $this->getFingerprint($request);

        $existing = $image->reactions()
            ->where('type', $data['type'])
            ->when($data['type'] === 'emoji',
                fn($q) => $q->where('emoji', $data['emoji']),
                fn($q) => $q->where('media_url', $data['media_url'])
            )
            ->when($userId,  fn($q) => $q->where('user_id', $userId))
            ->when(!$userId, fn($q) => $q->where('ip_address', $ip)->where('session_fingerprint', $fingerprint))
            ->first();

        if ($existing) {
            $existing->delete();
            return back()->with('success', 'Reaction removed.');
        }

        $image->reactions()
            ->where('type', $data['type'])
            ->when($userId,  fn($q) => $q->where('user_id', $userId))
            ->when(!$userId, fn($q) => $q->where('ip_address', $ip)->where('session_fingerprint', $fingerprint))
            ->delete();

        $image->reactions()->create([
            'type'                => $data['type'],
            'emoji'               => $data['type'] === 'emoji' ? $data['emoji'] : null,
            'media_url'           => $data['media_url'] ?? null,
            'media_label'         => $data['media_label'] ?? null,
            'media_source'        => $data['media_source'] ?? null,
            'user_id'             => $userId,
            'ip_address'          => $ip,
            'session_fingerprint' => $fingerprint,
        ]);

        return back()->with('success', 'Reaction added.');
    }

    public function searchGiphy(Request $request)
    {
        $request->validate([
            'q'      => ['required', 'string', 'max:100'],
            'offset' => ['sometimes', 'integer', 'min:0'],
            'type'   => ['sometimes', 'in:gif,sticker'],
        ]);

        $apiKey   = config('services.giphy.key');
        $endpoint = ($request->input('type', 'gif') === 'sticker')
            ? 'https://api.giphy.com/v1/stickers/search'
            : 'https://api.giphy.com/v1/gifs/search';

        $response = Http::get($endpoint, [
            'api_key' => $apiKey,
            'q'       => $request->q,
            'limit'   => 20,
            'offset'  => $request->input('offset', 0),
            'rating'  => 'g',
            'lang'    => 'en',
        ]);

        return response()->json($response->json());
    }

    private function isAllowedMediaUrl(string $url): bool
    {
        $allowed = [
            'media.giphy.com',
            'media0.giphy.com',
            'media1.giphy.com',
            'media2.giphy.com',
            'media3.giphy.com',
            'media4.giphy.com',
        ];

        $host = parse_url($url, PHP_URL_HOST);

        $ownDomain = parse_url(config('app.url'), PHP_URL_HOST);
        $allowed[] = $ownDomain;

        foreach ($allowed as $a) {
            if ($host === $a || str_ends_with($host, '.' . $a)) {
                return true;
            }
        }

        return false;
    }

    private function isEmoji(string $value): bool
    {
        $stripped = preg_replace(
            '/[\x{1F000}-\x{1FFFF}' .
            '\x{2600}-\x{27BF}'     .
            '\x{2B00}-\x{2BFF}'     .
            '\x{FE00}-\x{FE0F}'     .
            '\x{1F1E0}-\x{1F1FF}'   .
            '\x{200D}'              .
            '\x{20E3}'              .
            '\x{E0020}-\x{E007F}'   .
            ']/u',
            '',
            $value
        );

        return $stripped === '' && mb_strlen($value) > 0;
    }

    private function getFingerprint(Request $request): string
    {
        $sessionId = Session::getId();
        $userAgent = substr($request->userAgent() ?? 'unknown', 0, 100);

        return hash('sha256', $sessionId . $userAgent);
    }
}