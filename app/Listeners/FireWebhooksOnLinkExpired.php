<?php

namespace App\Listeners;

use App\Events\LinkExpired;
use App\Services\WebhookService;

class FireWebhooksOnLinkExpired
{
    public function __construct(
        protected WebhookService $webhookService,
    ) {}

    public function handle(LinkExpired $event): void
    {
        $link = $event->link;

        $this->webhookService->fire($link->user, 'link.expired', [
            'link_id'    => $link->id,
            'link_url'   => $link->url,
            'image_id'   => $link->image_id,
            'expired_at' => now()->toIso8601String(),
        ]);
    }
}