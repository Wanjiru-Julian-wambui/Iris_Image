<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class EmailTemplate extends Model
{
    use HasFactory;

    /**
     * Available template keys and their default variable sets.
     */
    public const TEMPLATES = [
        'invite'         => ['{{user_name}}', '{{invite_url}}', '{{expires_in}}', '{{app_name}}'],
        'digest'         => ['{{user_name}}', '{{app_name}}', '{{week_start}}', '{{week_end}}', '{{total_views}}', '{{link_rows}}'],
        'quota_warning'  => ['{{user_name}}', '{{app_name}}', '{{used_percent}}', '{{used_human}}', '{{limit_human}}', '{{upgrade_url}}'],
    ];

    protected $fillable = [
        'user_id',      // null = system default; set = tenant override
        'key',          // 'invite' | 'digest' | 'quota_warning'
        'subject',
        'html_body',
        'text_body',
    ];

    // ─── Relationships ────────────────────────────────────────────────────────

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    // ─── Helpers ──────────────────────────────────────────────────────────────

    /**
     * Replace {{variable}} placeholders with actual values.
     */
    public function render(array $variables): array
    {
        $search  = array_keys($variables);
        $replace = array_values($variables);

        return [
            'subject'   => str_replace($search, $replace, $this->subject),
            'html_body' => str_replace($search, $replace, $this->html_body),
            'text_body' => str_replace($search, $replace, $this->text_body),
        ];
    }

    /**
     * Fetch a template for a user, falling back to the system default.
     */
    public static function forUser(int $userId, string $key): ?static
    {
        return static::where('key', $key)
            ->where(fn($q) => $q->where('user_id', $userId)->orWhereNull('user_id'))
            ->orderByRaw('user_id IS NULL ASC') // user override wins
            ->first();
    }
}