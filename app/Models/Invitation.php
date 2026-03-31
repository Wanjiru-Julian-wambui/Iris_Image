<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Str;

class Invitation extends Model
{
    protected $fillable = [
        'email',
        'token',
        'invited_by',
        'accepted_by',
        'expires_at',
        'accepted_at',
        'is_accepted',
    ];

    protected $casts = [
        'is_accepted' => 'boolean',
        'expires_at'  => 'datetime',
        'accepted_at' => 'datetime',
    ];

    protected $appends = [
        'status',
        'is_expired',
    ];

    /*
    |--------------------------------------------------------------------------
    | Relationships
    |--------------------------------------------------------------------------
    */

    public function invitedBy(): BelongsTo
    {
        return $this->belongsTo(User::class, 'invited_by');
    }

    public function acceptedBy(): BelongsTo
    {
        return $this->belongsTo(User::class, 'accepted_by');
    }

    /*
    |--------------------------------------------------------------------------
    | Accessors
    |--------------------------------------------------------------------------
    */

    public function getStatusAttribute(): string
    {
        if ($this->is_accepted) {
            return 'accepted';
        }

        if ($this->expires_at->isPast()) {
            return 'expired';
        }

        return 'pending';
    }

    public function getIsExpiredAttribute(): bool
    {
        return $this->expires_at->isPast() && !$this->is_accepted;
    }

    /*
    |--------------------------------------------------------------------------
    | Scopes
    |--------------------------------------------------------------------------
    */

    public function scopePending($query)
    {
        return $query->where('is_accepted', false)
                     ->where('expires_at', '>', now());
    }

    public function scopeExpired($query)
    {
        return $query->where('is_accepted', false)
                     ->where('expires_at', '<=', now());
    }

    /*
    |--------------------------------------------------------------------------
    | Boot
    |--------------------------------------------------------------------------
    */

    protected static function booted(): void
    {
        static::creating(function (Invitation $invitation) {
            $invitation->token = $invitation->token ?? Str::uuid()->toString();

            if (!$invitation->expires_at) {
                $invitation->expires_at = now()->addHours(
                    config('iris.invitations.expiry_hours', 72)
                );
            }
        });
    }
}