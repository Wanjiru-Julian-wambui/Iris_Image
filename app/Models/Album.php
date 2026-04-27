<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class Album extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'name',
        'slug',
        'description',
        'cover_image_id',
        'is_public',
        'password',
        'public_token',
    ];

    protected $casts = [
        'is_public' => 'boolean',
    ];

    protected $hidden = ['password'];

    protected static function boot(): void
    {
        parent::boot();

        static::creating(function (Album $album) {
            if (empty($album->public_token)) {
                $album->public_token = Str::random(8);
            }
            if (empty($album->slug)) {
                $album->slug = Str::slug($album->name) . '-' . Str::random(4);
            }
        });
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function images(): BelongsToMany
    {
        return $this->belongsToMany(Image::class, 'album_image')
            ->withPivot('sort_order')
            ->orderByPivot('sort_order', 'asc');
    }

    public function coverImage(): BelongsTo
    {
        return $this->belongsTo(Image::class, 'cover_image_id');
    }

    public function setPasswordAttribute(?string $value): void
    {
        $this->attributes['password'] = $value ? Hash::make($value) : null;
    }

    public function checkPassword(string $password): bool
    {
        return $this->password ? Hash::check($password, $this->password) : true;
    }

    public function getPublicUrlAttribute(): string
    {
        return url('/a/' . $this->public_token);
    }

    public function scopePublic($query)
    {
        return $query->where('is_public', true);
    }

    public function scopeForUser($query, int $userId)
    {
        return $query->where('user_id', $userId);
    }
}