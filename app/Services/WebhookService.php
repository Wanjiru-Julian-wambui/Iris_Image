<?php

namespace App\Services;

use App\Models\User;
use App\Models\Webhook;
use App\Models\WebhookDelivery;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class WebhookService
{
    private const MAX_ATTEMPTS = 3;
    private const TIMEOUT_SECONDS = 10;

    /**
     * Fire an event to all active webhooks registered by the user.
     *
     * @param  User   $user    The owner whose webhooks should receive this event.
     * @param  string $event   e.g. 'image.uploaded', 'image.deleted', 'link.viewed'
     * @param  array  $payload The event data sent as JSON.
     */
    public function fire(User $user, string $event, array $payload): void
    {
        $webhooks = Webhook::query()
            ->where('user_id', $user->id)
            ->where('active', true)
            ->get()
            ->filter(fn(Webhook $wh) => $wh->listensTo($event));

        foreach ($webhooks as $webhook) {
            $this->dispatch($webhook, $event, $payload);
        }
    }

    /**
     * Dispatch to a single webhook, retrying up to MAX_ATTEMPTS.
     */
    public function dispatch(Webhook $webhook, string $event, array $payload, int $attempt = 1): void
    {
        $body      = json_encode($payload, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
        $signature = $this->sign($body, $webhook->secret ?? '');
        $startedAt = microtime(true);

        try {
            $response = Http::timeout(self::TIMEOUT_SECONDS)
                ->withHeaders([
                    'Content-Type'           => 'application/json',
                    'X-Iris-Event'           => $event,
                    'X-Iris-Signature'       => 'sha256=' . $signature,
                    'X-Iris-Delivery'        => \Illuminate\Support\Str::uuid()->toString(),
                    'X-Iris-Timestamp'       => time(),
                ])
                ->send('POST', $webhook->url, ['body' => $body]);

            $durationMs = (int) round((microtime(true) - $startedAt) * 1000);
            $succeeded  = $response->successful();

            WebhookDelivery::create([
                'webhook_id'      => $webhook->id,
                'event'           => $event,
                'payload'         => $payload,
                'response_status' => $response->status(),
                'response_body'   => substr($response->body(), 0, 1000),
                'duration_ms'     => $durationMs,
                'attempt'         => $attempt,
                'succeeded'       => $succeeded,
                'fired_at'        => now(),
            ]);

            if ($succeeded) {
                $webhook->markSuccess();
            } else {
                $this->retryOrFail($webhook, $event, $payload, $attempt, "HTTP {$response->status()}");
            }
        } catch (\Throwable $e) {
            $durationMs = (int) round((microtime(true) - $startedAt) * 1000);

            WebhookDelivery::create([
                'webhook_id'      => $webhook->id,
                'event'           => $event,
                'payload'         => $payload,
                'response_status' => null,
                'response_body'   => substr($e->getMessage(), 0, 1000),
                'duration_ms'     => $durationMs,
                'attempt'         => $attempt,
                'succeeded'       => false,
                'fired_at'        => now(),
            ]);

            $this->retryOrFail($webhook, $event, $payload, $attempt, $e->getMessage());
        }
    }

    // ─── Private helpers ──────────────────────────────────────────────────────

    private function sign(string $body, string $secret): string
    {
        return hash_hmac('sha256', $body, $secret);
    }

    private function retryOrFail(
        Webhook $webhook,
        string  $event,
        array   $payload,
        int     $attempt,
        string  $reason,
    ): void {
        if ($attempt < self::MAX_ATTEMPTS) {
            // Exponential back-off: 5s, 25s
            $delay = pow(5, $attempt);
            Log::warning("Webhook #{$webhook->id} failed (attempt {$attempt}): {$reason}. Retrying in {$delay}s.");

            \App\Jobs\RetryWebhookDelivery::dispatch($webhook, $event, $payload, $attempt + 1)
                ->delay(now()->addSeconds($delay));
        } else {
            Log::error("Webhook #{$webhook->id} permanently failed after " . self::MAX_ATTEMPTS . " attempts.");
            $webhook->markFailed();
        }
    }
}