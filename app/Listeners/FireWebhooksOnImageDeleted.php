<?php

namespace App\Listeners;

use App\Events\ImageDeleted;
use App\Services\WebhookService;

class FireWebhooksOnImageDeleted
{
    public function __construct(
        protected WebhookService $webhookService,
    ) {}

    public function handle(ImageDeleted $event): void
    {
        $image = $event->image;

        $this->webhookService->fire($image->user, 'image.deleted', [
            'id'         => $image->id,
            'name'       => $image->name,
            'deleted_at' => now()->toIso8601String(),
        ]);
    }
}