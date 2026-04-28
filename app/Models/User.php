<?php

namespace App\Models;

use App\Models\Album;
use Database\Factories\UserFactory;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Fortify\TwoFactorAuthenticatable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable, TwoFactorAuthenticatable;

    protected $fillable = [
        'name',
        'email',
        'password',
        'avatar',
        'plan_id',
        'is_admin',
        'storage_used',
    ];

    protected $hidden = [
        'password',
        'two_factor_secret',
        'two_factor_recovery_codes',
        'remember_token',
    ];

    protected $appends = [
        'storage_used_human',
        'storage_percent',
        'avatar_url',
    ];

    protected function casts(): array
    {
        return [
            'email_verified_at'       => 'datetime',
            'password'                => 'hashed',
            'two_factor_confirmed_at' => 'datetime',
            'is_admin'                => 'boolean',
            'storage_used'            => 'integer',
        ];
    }

    /*
    |--------------------------------------------------------------------------
    | Relationships
    |--------------------------------------------------------------------------
    */

    public function plan(): BelongsTo
    {
        return $this->belongsTo(Plan::class);
    }

    public function images(): HasMany
    {
        return $this->hasMany(Image::class);
    }

    public function albums(): HasMany
    {
        return $this->hasMany(Album::class);
    }

    public function sharedLinks(): HasMany
    {
        return $this->hasMany(SharedLink::class, 'created_by');
    }

    public function invitationsSent(): HasMany
    {
        return $this->hasMany(Invitation::class, 'invited_by');
    }

    public function apiCredentials(): HasMany
    {
        return $this->hasMany(ApiCredential::class);
    }

     public function tags(): HasMany
    {
        return $this->hasMany(Tag::class)->orderBy('name');
    }

    public function polls(): HasMany
    {
        return $this->hasMany(ImagePoll::class)->latest();
    }

    /*
    |--------------------------------------------------------------------------
    | Accessors
    |--------------------------------------------------------------------------
    */

    public function getStorageUsedHumanAttribute(): string
    {
        $bytes = $this->storage_used ?? 0;

        if ($bytes >= 1073741824) return number_format($bytes / 1073741824, 2) . ' GB';
        if ($bytes >= 1048576)    return number_format($bytes / 1048576, 2) . ' MB';
        if ($bytes >= 1024)       return number_format($bytes / 1024, 2) . ' KB';

        return $bytes . ' B';
    }

    public function getStoragePercentAttribute(): float
    {
        $limit = (int) ($this->plan?->storage_limit ?? config('iris.plans.free.storage_limit', 0));

        if ($limit <= 0) return 0.00;

        return round(($this->storage_used ?? 0) / $limit * 100, 2);
    }

    public function getAvatarUrlAttribute(): string
    {
        if ($this->avatar) {
            return asset('storage/' . $this->avatar);
        }

        return 'https://ui-avatars.com/api/?name=' . urlencode($this->name)
            . '&background=7B2FFF&color=fff&bold=true';
    }

    /*
    |--------------------------------------------------------------------------
    | Helpers
    |--------------------------------------------------------------------------
    */

    public function isAdmin(): bool
    {
        return $this->is_admin === true;
    }

    public function hasFeature(string $feature): bool
    {
        return $this->plan?->hasFeature($feature) ?? false;
    }

    public function storageLimit(): int
    {
        return $this->plan?->storage_limit
            ?? config('iris.plans.free.storage_limit');
    }

    public function hasStorageSpace(int $bytes): bool
    {
        return ($this->storage_used + $bytes) <= $this->storageLimit();
    }
    
}