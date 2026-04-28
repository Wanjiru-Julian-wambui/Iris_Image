<?php

namespace App\Http\Controllers;

use App\Models\Image;
use App\Models\ImageReaction;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Session;

class ImageReactionController extends Controller
{
    private const MAX_EMOJI_LENGTH = 8; // Covers multi-codepoint emoji like flags/ZWJ sequences

    public function store(Request $request, Image $image)
    {
        abort_if($image->is_private, 403, 'Cannot react to private images.');

        $data = $request->validate([
            'emoji' => [
                'required',
                'string',
                'max:' . self::MAX_EMOJI_LENGTH,
                function ($attribute, $value, $fail) {
                    if (!$this->isEmoji($value)) {
                        $fail('The ' . $attribute . ' must be a valid emoji.');
                    }
                },
            ],
        ]);

        $userId = auth()->id();
        $ip = $request->ip();
        $fingerprint = $this->getFingerprint($request);

        // Check for existing reaction
        $existing = $image->reactions()
            ->when($userId, fn($q) => $q->where('user_id', $userId))
            ->when(!$userId, fn($q) => $q->where('ip_address', $ip)->where('session_fingerprint', $fingerprint))
            ->where('emoji', $data['emoji'])
            ->first();

        if ($existing) {
            $existing->delete();
            return back()->with('success', 'Reaction removed.');
        }

        // Remove any other emoji reaction from same user/guest
        $image->reactions()
            ->when($userId, fn($q) => $q->where('user_id', $userId))
            ->when(!$userId, fn($q) => $q->where('ip_address', $ip)->where('session_fingerprint', $fingerprint))
            ->delete();

        $image->reactions()->create([
            'user_id'             => $userId,
            'emoji'               => $data['emoji'],
            'ip_address'          => $ip,
            'session_fingerprint' => $fingerprint,
        ]);

        return back()->with('success', 'Reaction added.');
    }

    private function isEmoji(string $value): bool
    {
        // Strip all valid emoji-related Unicode ranges and check nothing non-emoji remains
        $stripped = preg_replace(
            '/[\x{1F000}-\x{1FFFF}' .  // Misc symbols, emoticons, mahjong, etc.
            '\x{2600}-\x{27BF}'      .  // Misc symbols, dingbats, arrows
            '\x{2B00}-\x{2BFF}'      .  // Misc symbols and arrows
            '\x{FE00}-\x{FE0F}'      .  // Variation selectors (e.g. ️)
            '\x{1F1E0}-\x{1F1FF}'    .  // Regional indicator symbols (flags)
            '\x{200D}'               .  // Zero-width joiner (ZWJ sequences)
            '\x{20E3}'               .  // Combining enclosing keycap
            '\x{E0020}-\x{E007F}'    .  // Tags block (used in flag sequences)
            ']/u',
            '',
            $value
        );

        // After removing emoji chars, nothing should remain
        return $stripped === '' && mb_strlen($value) > 0;
    }

    private function getFingerprint(Request $request): string
    {
        $sessionId = Session::getId();
        $userAgent = substr($request->userAgent() ?? 'unknown', 0, 100);

        return hash('sha256', $sessionId . $userAgent);
    }
}