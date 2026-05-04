<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ImageReaction extends Model
{
    use HasFactory;

    protected $fillable = [
        'image_id',
        'user_id',
        'type',         // 'emoji' | 'gif' | 'sticker'
        'emoji',        // set when type = 'emoji'
        'media_url',    // set when type = 'gif' | 'sticker'
        'media_label',  // friendly label (GIF title etc.)
        'media_source', // 'giphy' | 'tenor' | 'upload'
        'ip_address',
        'session_fingerprint',
    ];

    public function image(): BelongsTo
    {
        return $this->belongsTo(Image::class);
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    // ─── Helpers ─────────────────────────────────────────────────────────────

    public function isEmoji(): bool  { return $this->type === 'emoji';   }
    public function isGif(): bool    { return $this->type === 'gif';     }
    public function isSticker(): bool { return $this->type === 'sticker'; }
}