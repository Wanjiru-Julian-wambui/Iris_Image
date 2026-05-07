<?php

namespace App\Listeners;

use App\Events\ImageUploaded;
use App\Services\WebhookService;

class FireWebhooksOnImageUploaded
{
    public function __construct(
        protected WebhookService $webhookService,
    ) {}

    public function handle(ImageUploaded $event): void
    {
        $image = $event->image;

        $this->webhookService->fire($image->user, 'image.uploaded', [
            'id'          => $image->id,
            'name'        => $image->name,
            'original_name' => $image->original_name,
            'url'         => $image->public_url,
            'size'        => $image->size,
            'size_human'  => $image->size_human,
            'width'       => $image->width,
            'height'      => $image->height,
            'mime_type'   => $image->mime_type,
            'is_private'  => $image->is_private,
            'uploaded_at' => $image->created_at->toIso8601String(),
        ]);
    }
}