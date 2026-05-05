<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Support\Str;

class ImagePoll extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'question',
        'type',
        'max_choices',
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

    // ─── Relationships ────────────────────────────────────────────────────────

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

    public function images(): BelongsToMany
    {
        return $this->belongsToMany(Image::class, 'image_poll_items')
            ->withPivot('sort_order')
            ->orderByPivot('sort_order');
    }

    public function votes(): HasMany
    {
        return $this->hasMany(ImagePollVote::class, 'poll_id');
    }

    public function multiVotes(): HasMany
    {
        return $this->hasMany(ImagePollMultiVote::class);
    }

    // ─── Helpers ─────────────────────────────────────────────────────────────

    public function isAb(): bool
    {
        return $this->type === 'ab';
    }

    public function isMulti(): bool
    {
        return $this->type === 'multi';
    }

    public function hasVoted(string $ip, string $fingerprint, ?int $userId): bool
    {
        if ($this->isAb()) {
            return $this->votes()
                ->when($userId, fn($q) => $q->where('user_id', $userId))
                ->when(!$userId, fn($q) => $q->where('ip_address', $ip)->where('session_fingerprint', $fingerprint))
                ->exists();
        }

        return $this->multiVotes()
            ->when($userId, fn($q) => $q->where('user_id', $userId))
            ->when(!$userId, fn($q) => $q->where('ip_address', $ip)->where('session_fingerprint', $fingerprint))
            ->exists();
    }

    // ─── Results ─────────────────────────────────────────────────────────────

    public function getResultsAttribute(): array
    {
        if ($this->isAb()) {
            $total  = $this->votes()->count();
            $aCount = $this->votes()->where('choice', 'a')->count();
            $bCount = $this->votes()->where('choice', 'b')->count();

            return [
                'a_count'   => $aCount,
                'b_count'   => $bCount,
                'a_percent' => $total > 0 ? round($aCount / $total * 100) : 0,
                'b_percent' => $total > 0 ? round($bCount / $total * 100) : 0,
                'total'     => $total,
            ];
        }

        // Multi poll results
        $total  = $this->multiVotes()->count();
        $counts = $this->multiVotes()
            ->selectRaw('image_id, COUNT(*) as vote_count')
            ->groupBy('image_id')
            ->pluck('vote_count', 'image_id');

        // Unique voters — using COALESCE with CAST for MySQL/Postgres compatibility
        $voters = $this->multiVotes()
            ->selectRaw('COALESCE(CAST(user_id AS CHAR), ip_address) as voter')
            ->distinct()
            ->count();

        $imageIds = $this->images()->pluck('images.id');

        $results = $imageIds->map(function ($imageId) use ($counts, $voters) {
            $count = $counts->get($imageId, 0);
            return [
                'image_id' => $imageId,
                'count'    => $count,
                'percent'  => $voters > 0 ? round($count / $voters * 100) : 0,
            ];
        })->values()->all();

        return [
            'items'        => $results,
            'total_votes'  => $total,
            'total_voters' => $voters,
        ];
    }

    // ─── Accessor ────────────────────────────────────────────────────────────

    public function getPublicUrlAttribute(): string
    {
        return route('polls.show', $this->public_token);
    }
}