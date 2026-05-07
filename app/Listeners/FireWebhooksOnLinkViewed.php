<?php

namespace App\Listeners;

use App\Events\LinkViewed;
use App\Models\LinkViewStat;
use App\Services\WebhookService;

class FireWebhooksOnLinkViewed
{
    public function __construct(
        protected WebhookService $webhookService,
    ) {}

    public function handle(LinkViewed $event): void
    {
        $link = $event->link;

        // Persist view stat for the weekly digest
        LinkViewStat::create([
            'shared_link_id' => $link->id,
            'country'        => $event->country,
            'viewed_at'      => now(),
        ]);

        $this->webhookService->fire($link->user, 'link.viewed', [
            'link_id'    => $link->id,
            'link_url'   => $link->url,
            'image_id'   => $link->image_id,
            'view_count' => $link->view_count,
            'country'    => $event->country,
            'viewed_at'  => now()->toIso8601String(),
        ]);
    }
}