<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;

class Image extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'name',
        'original_name',
        'path',
        'thumbnail_path',
        'url',
        'thumbnail_url',
        'mime_type',
        'extension',
        'size',
        'width',
        'height',
        'is_private',
        'exif_stripped',
        'public_token',
        'sort_order',
        'download_count',
        'caption',
        'alt_text',
        'hash',
    ];

    protected $casts = [
        'is_private'     => 'boolean',
        'exif_stripped'  => 'boolean',
        'size'           => 'integer',
        'width'          => 'integer',
        'height'         => 'integer',
        'sort_order'     => 'integer',
        'download_count' => 'integer',
    ];

    protected static function boot(): void
    {
        parent::boot();

        static::creating(function (Image $image) {
            if (empty($image->public_token)) {
                $image->public_token = Str::random(8);
            }
        });
    }

    // ─── Relationships ────────────────────────────────────────────────────────

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function sharedLinks(): HasMany
    {
        return $this->hasMany(SharedLink::class);
    }

    public function notes(): HasMany
    {
        return $this->hasMany(ImageNote::class)->latest();
    }

    public function albums(): BelongsToMany
    {
        return $this->belongsToMany(Album::class, 'album_image')
            ->withPivot('sort_order');
    }

    // ─── URL Accessors ────────────────────────────────────────────────────────

    /**
     * Return the stored URL, or compute it from path as a fallback.
     * This ensures existing records with null url still resolve correctly.
     */
    public function getUrlAttribute(): string
    {
        if (!empty($this->attributes['url'])) {
            return $this->attributes['url'];
        }

        if (!empty($this->path)) {
            return Storage::disk(config('filesystems.default'))->url($this->path);
        }

        return '';
    }

    /**
     * Return the stored thumbnail URL, or fall back to the full image URL.
     */
    public function getThumbnailUrlAttribute(): string
    {
        if (!empty($this->attributes['thumbnail_url'])) {
            return $this->attributes['thumbnail_url'];
        }

        // Fall back to thumbnail_path if available, otherwise the main image
        if (!empty($this->thumbnail_path)) {
            return Storage::disk(config('filesystems.default'))->url($this->thumbnail_path);
        }

        return $this->url;
    }

    // ─── Other Accessors ─────────────────────────────────────────────────────

    public function getPublicUrlAttribute(): string
    {
        return url('/i/' . $this->public_token);
    }

    public function getEmbedCodesAttribute(): array
    {
        $url = $this->public_url;

        return [
            'url'      => $url,
            'html'     => '<img src="' . e($url) . '" alt="' . e($this->alt_text ?? $this->name) . '" />',
            'markdown' => '![' . e($this->alt_text ?? $this->name) . '](' . $url . ')',
            'bbcode'   => '[img]' . $url . '[/img]',
        ];
    }

    public function incrementDownload(): void
    {
        $this->increment('download_count');
    }

    public function getSizeHumanAttribute(): string
    {
        $bytes = $this->size;
        if ($bytes === 0) return '0 B';
        $units = ['B', 'KB', 'MB', 'GB', 'TB'];
        $i = min(floor(log($bytes) / log(1024)), count($units) - 1);
        $val = $bytes / pow(1024, $i);
        return (is_int($val) ? $val : round($val, 2)) . ' ' . $units[$i];
    }
}