<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Plan extends Model
{
    protected $fillable = [
        'name',
        'slug',
        'price',
        'storage_limit',
        'features',
        'is_active',
        'stripe_price_id',
    ];

    protected $casts = [
        'price'         => 'integer',
        'storage_limit' => 'integer',
        'features'      => 'array',
        'is_active'     => 'boolean',
    ];

    protected $appends = [
        'storage_limit_human',
        'price_formatted',
        'is_free',
    ];

    /*
    |--------------------------------------------------------------------------
    | Relationships
    |--------------------------------------------------------------------------
    */

    public function users(): HasMany
    {
        return $this->hasMany(User::class);
    }

    /*
    |--------------------------------------------------------------------------
    | Accessors
    |--------------------------------------------------------------------------
    */

    public function getStorageLimitHumanAttribute(): string
    {
        $bytes = $this->storage_limit;

        if ($bytes >= 1073741824) {
            return number_format($bytes / 1073741824, 0) . ' GB';
        } elseif ($bytes >= 1048576) {
            return number_format($bytes / 1048576, 0) . ' MB';
        }

        return $bytes . ' B';
    }

    public function getPriceFormattedAttribute(): string
    {
        return $this->price === 0 ? 'Free' : '$' . number_format($this->price, 2);
    }

    public function getIsFreeAttribute(): bool
    {
        return $this->price === 0;
    }

    /*
    |--------------------------------------------------------------------------
    | Scopes
    |--------------------------------------------------------------------------
    */

    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }

    public function hasFeature(string $feature): bool
    {
        return in_array($feature, $this->features ?? []);
    }
}