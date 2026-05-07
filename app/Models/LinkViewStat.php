<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class LinkViewStat extends Model
{
    use HasFactory;

    protected $fillable = [
        'shared_link_id',
        'country',
        'viewed_at',
    ];

    protected $casts = [
        'viewed_at' => 'datetime',
    ];

    public function sharedLink(): BelongsTo
    {
        return $this->belongsTo(SharedLink::class);
    }
}