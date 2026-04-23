<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class SharedLinkView extends Model
{
    public $timestamps = false;

    protected $fillable = [
        'shared_link_id',
        'ip_address',
        'user_agent',
        'viewed_at',
    ];

    protected $casts = [
        'viewed_at' => 'datetime',
    ];

    public function sharedLink(): BelongsTo
    {
        return $this->belongsTo(SharedLink::class);
    }

    public function getBrowserAttribute(): string
    {
        $ua = $this->user_agent ?? '';
        if (str_contains($ua, 'Edg/'))     return 'Edge';
        if (str_contains($ua, 'OPR/'))     return 'Opera';
        if (str_contains($ua, 'Chrome/'))  return 'Chrome';
        if (str_contains($ua, 'Firefox/')) return 'Firefox';
        if (str_contains($ua, 'Safari/'))  return 'Safari';
        return 'Unknown';
    }

    public function getMaskedIpAttribute(): string
    {
        if (!$this->ip_address) return '—';
        $parts = explode('.', $this->ip_address);
        if (count($parts) === 4) {
            $parts[3] = 'xxx';
            return implode('.', $parts);
        }
        $segs = explode(':', $this->ip_address);
        $segs[count($segs) - 1] = 'xxxx';
        return implode(':', $segs);
    }
}