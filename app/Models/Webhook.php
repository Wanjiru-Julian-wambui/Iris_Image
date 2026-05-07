<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Webhook extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'name',
        'url',
        'events',
        'secret',
        'active',
        'source',        // 'custom' | 'zapier' | 'make'
        'last_fired_at',
        'last_status',   // 'success' | 'failed'
        'failure_count',
    ];

    protected $casts = [
        'events'        => 'array',
        'active'        => 'boolean',
        'last_fired_at' => 'datetime',
        'failure_count' => 'integer',
    ];

    // ─── Relationships ────────────────────────────────────────────────────────

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function deliveries(): \Illuminate\Database\Eloquent\Relations\HasMany
    {
        return $this->hasMany(WebhookDelivery::class)->latest()->limit(50);
    }

    // ─── Helpers ──────────────────────────────────────────────────────────────

    public function listensTo(string $event): bool
    {
        return in_array($event, $this->events ?? [], true)
            || in_array('*', $this->events ?? [], true);
    }

    public function generateSecret(): string
    {
        $secret        = bin2hex(random_bytes(32));
        $this->secret  = $secret;
        $this->saveQuietly();

        return $secret;
    }

    public function markSuccess(): void
    {
        $this->update([
            'last_fired_at' => now(),
            'last_status'   => 'success',
            'failure_count' => 0,
        ]);
    }

    public function markFailed(): void
    {
        $this->increment('failure_count');
        $this->update([
            'last_fired_at' => now(),
            'last_status'   => 'failed',
        ]);

        // Auto-disable after 10 consecutive failures
        if ($this->failure_count >= 10) {
            $this->update(['active' => false]);
        }
    }
}