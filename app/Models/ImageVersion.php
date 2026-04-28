<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Facades\Storage;

class ImageVersion extends Model
{
    use HasFactory;

    protected $fillable = [
        'image_id',
        'path',
        'url',
        'thumbnail_path',
        'thumbnail_url',
        'size',
        'width',
        'height',
        'version_number',
        'label',
        'change_note',
    ];

    protected $casts = [
        'size'           => 'integer',
        'width'          => 'integer',
        'height'         => 'integer',
        'version_number' => 'integer',
    ];

    public function image(): BelongsTo
    {
        return $this->belongsTo(Image::class);
    }

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