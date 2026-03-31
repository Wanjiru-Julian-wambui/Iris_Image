<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Str;

class SharedLink extends Model
{
    protected $fillable = [
        'image_id',
        'created_by',
        'token',
        'password',
        'expires_at',
        'view_count',
    ];

    protected $hidden = [
        'password',
    ];

    protected $casts = [
        'expires_at' => 'datetime',
        'view_count' => 'integer',
    ];

    protected $appends = [
        'is_expired',
        'is_password_protected',
        'url',
    ];

    /*
    |--------------------------------------------------------------------------
    | Relationships
    |--------------------------------------------------------------------------
    */

    public function image(): BelongsTo
    {
        return $this->belongsTo(Image::class);
    }

    public function createdBy(): BelongsTo
    {
        return $this->belongsTo(User::class, 'created_by');
    }

    /*
    |--------------------------------------------------------------------------
    | Accessors
    |--------------------------------------------------------------------------
    */

    public function getIsExpiredAttribute(): bool
    {
        return $this->expires_at?->isPast() ?? false;
    }

    public function getIsPasswordProtectedAttribute(): bool
    {
        return !is_null($this->password);
    }

    public function getUrlAttribute(): string
    {
        return route('shared-links.show', $this->token);
    }

    /*
    |--------------------------------------------------------------------------
    | Scopes
    |--------------------------------------------------------------------------
    */

    public function scopeActive($query)
    {
        return $query->where(function ($q) {
            $q->whereNull('expires_at')
              ->orWhere('expires_at', '>', now());
        });
    }

    public function scopeExpired($query)
    {
        return $query->whereNotNull('expires_at')
                     ->where('expires_at', '<=', now());
    }

    /*
    |--------------------------------------------------------------------------
    | Boot
    |--------------------------------------------------------------------------
    */

    protected static function booted(): void
    {
        static::creating(function (SharedLink $link) {
            $link->token = $link->token ?? Str::random(32);

            if ($link->password) {
                $link->password = bcrypt($link->password);
            }
        });
    }
}