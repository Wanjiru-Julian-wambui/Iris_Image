<?php

namespace App\Http\Controllers;

use App\Models\Webhook;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ZapierController extends Controller
{
    /**
     * Zapier calls this when a user sets up a Zap.
     * It sends its own callback URL — we store it as a webhook.
     */
    public function subscribe(Request $request): JsonResponse
    {
        $request->validate([
            'hookUrl' => ['required', 'url'],
            'event'   => ['required', 'string'],
        ]);

        // Avoid duplicate subscriptions for the same URL + event
        Webhook::updateOrCreate(
            [
                'user_id' => auth()->id(),
                'url'     => $request->hookUrl,
                'source'  => 'zapier',
            ],
            [
                'name'   => 'Zapier — ' . $request->event,
                'events' => [$request->event],
                'active' => true,
                'secret' => bin2hex(random_bytes(32)),
            ]
        );

        return response()->json(['ok' => true], 201);
    }

    /**
     * Zapier calls this when a user turns off a Zap.
     */
    public function unsubscribe(Request $request): JsonResponse
    {
        $request->validate([
            'hookUrl' => ['required', 'url'],
        ]);

        Webhook::where('url', $request->hookUrl)
               ->where('user_id', auth()->id())
               ->where('source', 'zapier')
               ->delete();

        return response()->json(['ok' => true]);
    }

    /**
     * Zapier polls this on first setup to show sample data in the Zap editor.
     */
    public function sample(Request $request, string $event): JsonResponse
    {
        $samples = [
            'image.uploaded' => [[
                'id'           => 1,
                'name'         => 'example-photo',
                'original_name'=> 'example-photo.jpg',
                'url'          => url('/i/abc12345'),
                'size'         => 2516582,
                'size_human'   => '2.4 MB',
                'width'        => 3840,
                'height'       => 2160,
                'mime_type'    => 'image/jpeg',
                'is_private'   => false,
                'uploaded_at'  => now()->toIso8601String(),
            ]],
            'image.deleted' => [[
                'id'         => 1,
                'name'       => 'example-photo',
                'deleted_at' => now()->toIso8601String(),
            ]],
            'link.viewed' => [[
                'link_id'    => 1,
                'link_url'   => url('/share/xyz98765'),
                'image_id'   => 1,
                'view_count' => 5,
                'country'    => 'US',
                'viewed_at'  => now()->toIso8601String(),
            ]],
            'link.expired' => [[
                'link_id'    => 1,
                'link_url'   => url('/share/xyz98765'),
                'image_id'   => 1,
                'expired_at' => now()->toIso8601String(),
            ]],
        ];

        return response()->json($samples[$event] ?? [[]]);
    }
}