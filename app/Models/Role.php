<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class Role extends Model
{
    use HasFactory;

    protected $fillable = [
        'name',         // machine slug e.g. "content_editor"
        'label',        // display name e.g. "Content Editor"
        'description',
    ];

    // ── Relationships ─────────────────────────────────────────────────────────

    public function permissions(): BelongsToMany
    {
        return $this->belongsToMany(Permission::class, 'permission_role');
    }

    public function users(): BelongsToMany
    {
        return $this->belongsToMany(User::class, 'role_user');
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    /**
     * Does this role grant the named permission?
     */
    public function hasPermission(string $ability): bool
    {
        return $this->permissions->contains('name', $ability);
    }
}