<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ImagePollMultiVote extends Model
{
    protected $fillable = [
        'image_poll_id',
        'image_id',
        'user_id',
        'ip_address',
        'session_fingerprint',
    ];

    public function poll(): BelongsTo
    {
        return $this->belongsTo(ImagePoll::class, 'image_poll_id');
    }

    public function image(): BelongsTo
    {
        return $this->belongsTo(Image::class);
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}