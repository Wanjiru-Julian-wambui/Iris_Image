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
        'user_id', 'name', 'original_name', 'path', 'thumbnail_path',
        'url', 'thumbnail_url', 'mime_type', 'extension', 'size',
        'width', 'height', 'is_private', 'exif_stripped', 'public_token',
        'sort_order', 'download_count', 'caption', 'alt_text', 'hash',
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

    protected $appends = [
        'size_human',
        'public_url',
        'reactions_summary',
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

    public function tags(): BelongsToMany
    {
        return $this->belongsToMany(Tag::class, 'image_tag');
    }

    public function reactions(): HasMany
    {
        return $this->hasMany(ImageReaction::class);
    }

    public function versions(): HasMany
    {
        return $this->hasMany(ImageVersion::class)
            ->orderBy('version_number', 'desc');
    }

    public function pollsAsA(): HasMany
    {
        return $this->hasMany(ImagePoll::class, 'image_a_id');
    }

    public function pollsAsB(): HasMany
    {
        return $this->hasMany(ImagePoll::class, 'image_b_id');
    }

    // ─── Scopes ───────────────────────────────────────────────────────────────

    public function scopeSearch($query, string $term)
    {
        if (empty($term)) return $query;

        $like = '%' . $term . '%';

        return $query->where(function ($q) use ($like) {
            $q->where('name', 'like', $like)
              ->orWhere('original_name', 'like', $like)
              ->orWhere('caption', 'like', $like)
              ->orWhere('alt_text', 'like', $like)
              ->orWhereHas('tags', fn($tq) => $tq->where('name', 'like', $like));
        });
    }

    // ─── URL Accessors ────────────────────────────────────────────────────────

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

    public function getThumbnailUrlAttribute(): string
    {
        if (!empty($this->attributes['thumbnail_url'])) {
            return $this->attributes['thumbnail_url'];
        }
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
            'markdown' => '![' . ($this->alt_text ?? $this->name) . '](' . $url . ')',
            'bbcode'   => '[img]' . $url . '[/img]',
        ];
    }

    public function getNextVersionNumberAttribute(): int
    {
        return ($this->versions()->max('version_number') ?? 0) + 1;
    }

    public function getReactionsSummaryAttribute(): array
    {
        $all = $this->reactions()->get();

        $emoji = $all->where('type', 'emoji')
            ->groupBy('emoji')
            ->map(fn($g) => $g->count())
            ->toArray();

        $gifs = $all->where('type', 'gif')
            ->groupBy('media_url')
            ->map(fn($g) => [
                'media_url'    => $g->first()->media_url,
                'media_label'  => $g->first()->media_label,
                'media_source' => $g->first()->media_source,
                'count'        => $g->count(),
            ])
            ->values()
            ->toArray();

        $stickers = $all->where('type', 'sticker')
            ->groupBy('media_url')
            ->map(fn($g) => [
                'media_url'    => $g->first()->media_url,
                'media_label'  => $g->first()->media_label,
                'media_source' => $g->first()->media_source,
                'count'        => $g->count(),
            ])
            ->values()
            ->toArray();

        return compact('emoji', 'gifs', 'stickers');
    }

    public function getSizeHumanAttribute(): string
    {
        $bytes = $this->size ?? 0;
        if ($bytes === 0) return '0 B';
        $units = ['B', 'KB', 'MB', 'GB', 'TB'];
        $i = min((int) floor(log($bytes) / log(1024)), count($units) - 1);
        $val = $bytes / pow(1024, $i);
        return round($val, 2) . ' ' . $units[$i];
    }

    public function incrementDownload(): void
    {
        $this->increment('download_count');
    }
}