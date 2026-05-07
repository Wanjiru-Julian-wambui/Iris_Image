<?php

namespace App\Http\Controllers\Settings;

use App\Http\Requests\WebhookRequest;
use App\Http\Resources\WebhookResource;
use App\Models\Webhook;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Inertia\Inertia;
use Inertia\Response;

class WebhookController extends Controller
{
    public function index(Request $request): Response
    {
        $webhooks = $request->user()
            ->webhooks()
            ->with('deliveries')
            ->latest()
            ->get();

        return Inertia::render('Settings/Webhooks/Index', [
            'webhooks'       => WebhookResource::collection($webhooks),
            'availableEvents' => $this->availableEvents(),
        ]);
    }

    public function store(WebhookRequest $request)
    {
        $webhook = $request->user()->webhooks()->create([
            'name'   => $request->name,
            'url'    => $request->url,
            'events' => $request->events,
            'active' => true,
            'secret' => bin2hex(random_bytes(32)),
            'source' => 'custom',
        ]);

        return back()->with('success', 'Webhook created. Copy your secret — it won\'t be shown again.')
                     ->with('webhook_secret', $webhook->secret);
    }

    public function update(WebhookRequest $request, Webhook $webhook)
    {
        abort_unless($webhook->user_id === $request->user()->id, 403);

        $webhook->update([
            'name'   => $request->name,
            'url'    => $request->url,
            'events' => $request->events,
            'active' => $request->boolean('active', $webhook->active),
        ]);

        return back()->with('success', 'Webhook updated.');
    }

    public function destroy(Request $request, Webhook $webhook)
    {
        abort_unless($webhook->user_id === $request->user()->id, 403);

        $webhook->delete();

        return back()->with('success', 'Webhook deleted.');
    }

    public function regenerateSecret(Request $request, Webhook $webhook)
    {
        abort_unless($webhook->user_id === $request->user()->id, 403);

        $secret = $webhook->generateSecret();

        return back()->with('success', 'Secret regenerated.')
                     ->with('webhook_secret', $secret);
    }

    public function toggle(Request $request, Webhook $webhook)
    {
        abort_unless($webhook->user_id === $request->user()->id, 403);

        $webhook->update(['active' => ! $webhook->active]);

        $status = $webhook->active ? 'enabled' : 'disabled';

        return back()->with('success', "Webhook {$status}.");
    }

    private function availableEvents(): array
    {
        return [
            ['value' => 'image.uploaded', 'label' => 'Image Uploaded'],
            ['value' => 'image.deleted',  'label' => 'Image Deleted' ],
            ['value' => 'link.viewed',    'label' => 'Link Viewed'   ],
            ['value' => 'link.expired',   'label' => 'Link Expired'  ],
            ['value' => '*',              'label' => 'All Events'    ],
        ];
    }
}