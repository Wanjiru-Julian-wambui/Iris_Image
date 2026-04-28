<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Support\Str;

class ImagePoll extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'question',
        'image_a_id',
        'image_b_id',
        'public_token',
    ];

    protected static function boot(): void
    {
        parent::boot();

        static::creating(function (ImagePoll $poll) {
            if (empty($poll->public_token)) {
                $poll->public_token = Str::random(8);
            }
        });
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function imageA(): BelongsTo
    {
        return $this->belongsTo(Image::class, 'image_a_id');
    }

    public function imageB(): BelongsTo
    {
        return $this->belongsTo(Image::class, 'image_b_id');
    }

    public function votes(): HasMany
    {
        return $this->hasMany(ImagePollVote::class, 'poll_id');
    }

    public function getResultsAttribute(): array
    {
        $total = $this->votes()->count();
        $aCount = $this->votes()->where('choice', 'a')->count();
        $bCount = $this->votes()->where('choice', 'b')->count();

        return [
            'total'      => $total,
            'a_count'    => $aCount,
            'b_count'    => $bCount,
            'a_percent'  => $total > 0 ? round(($aCount / $total) * 100, 1) : 0,
            'b_percent'  => $total > 0 ? round(($bCount / $total) * 100, 1) : 0,
        ];
    }

    public function getPublicUrlAttribute(): string
    {
        return url('/poll/' . $this->public_token);
    }

    public function hasVoted(?string $ip = null, ?string $fingerprint = null, ?int $userId = null): bool
    {
        if ($userId) {
            return $this->votes()->where('user_id', $userId)->exists();
        }

        return $this->votes()
            ->where('ip_address', $ip)
            ->where('session_fingerprint', $fingerprint)
            ->exists();
    }
}