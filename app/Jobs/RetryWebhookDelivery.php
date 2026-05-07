<?php

namespace App\Jobs;

use App\Models\Webhook;
use App\Services\WebhookService;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;

class RetryWebhookDelivery implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public int $tries = 1; // WebhookService already controls retry logic

    public function __construct(
        public readonly Webhook $webhook,
        public readonly string  $event,
        public readonly array   $payload,
        public readonly int     $attempt,
    ) {}

    public function handle(WebhookService $webhookService): void
    {
        if (! $this->webhook->active) {
            return; // Was disabled between retries — skip
        }

        $webhookService->dispatch($this->webhook, $this->event, $this->payload, $this->attempt);
    }
}