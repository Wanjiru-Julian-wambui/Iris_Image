<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Str;

class ApiCredential extends Model
{
    protected $fillable = [
        'user_id',
        'api_key',
        'api_secret',
        'label',
        'last_used_at',
    ];

    protected $casts = [
        'last_used_at' => 'datetime',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Generate a new key/secret pair.
     * Returns ['key' => ..., 'secret' => ...] with the plain secret.
     */
    public static function generate(int $userId, string $label = 'Default'): array
    {
        $plainKey    = 'ik_' . Str::random(32);   // iris key
        $plainSecret = 'is_' . Str::random(48);   // iris secret

        static::create([
            'user_id'    => $userId,
            'api_key'    => $plainKey,
            'api_secret' => bcrypt($plainSecret),
            'label'      => $label,
        ]);

        return [
            'key'    => $plainKey,
            'secret' => $plainSecret,
        ];
    }
}