<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Support\Facades\Storage;

class Image extends Model
{
    protected $fillable = [
        'user_id',
        'name',
        'original_name',
        'path',
        'thumbnail_path',
        'mime_type',
        'extension',
        'size',
        'width',
        'height',
        'exif_stripped',
        'is_private',
    ];

    protected $casts = [
        'exif_stripped' => 'boolean',
        'is_private'    => 'boolean',
        'size'          => 'integer',
        'width'         => 'integer',
        'height'        => 'integer',
    ];

    protected $appends = [
        'url',
        'thumbnail_url',
        'size_human',
    ];

    /*
    |--------------------------------------------------------------------------
    | Relationships
    |--------------------------------------------------------------------------
    */

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function sharedLinks(): HasMany
    {
        return $this->hasMany(SharedLink::class);
    }

    /*
    |--------------------------------------------------------------------------
    | Accessors
    |--------------------------------------------------------------------------
    */

    public function getUrlAttribute(): string
    {
        return Storage::url($this->path);
    }

    public function getThumbnailUrlAttribute(): string
    {
        return Storage::url($this->thumbnail_path ?? $this->path);
    }

    public function getSizeHumanAttribute(): string
    {
        $bytes = $this->size;

        if ($bytes >= 1073741824) {
            return number_format($bytes / 1073741824, 2) . ' GB';
        } elseif ($bytes >= 1048576) {
            return number_format($bytes / 1048576, 2) . ' MB';
        } elseif ($bytes >= 1024) {
            return number_format($bytes / 1024, 2) . ' KB';
        }

        return $bytes . ' B';
    }

    /*
    |--------------------------------------------------------------------------
    | Boot
    |--------------------------------------------------------------------------
    */

    protected static function booted(): void
    {
        static::deleted(function (Image $image) {
            Storage::delete($image->path);

            if ($image->thumbnail_path) {
                Storage::delete($image->thumbnail_path);
            }

            $image->user->decrement('storage_used', $image->size);
        });
    }
}