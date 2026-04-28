<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ImagePollVote extends Model
{
    use HasFactory;

    protected $fillable = [
        'poll_id',
        'choice',
        'user_id',
        'ip_address',
        'session_fingerprint',
    ];

    public function poll(): BelongsTo
    {
        return $this->belongsTo(ImagePoll::class, 'poll_id');
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}