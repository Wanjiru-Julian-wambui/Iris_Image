<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

class Role extends Model
{
    protected $fillable = ['name', 'label', 'description'];

    // ── Relationships ─────────────────────────────────────────────────────────

    public function permissions(): BelongsToMany
    {
        return $this->belongsToMany(Permission::class, 'role_permission');
    }

    public function users(): BelongsToMany
    {
        return $this->belongsToMany(User::class, 'role_user');
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    /**
     * Grant a permission (by name or model) to this role.
     */
    public function grantPermission(string|Permission $permission): void
    {
        $permission = $permission instanceof Permission
            ? $permission
            : Permission::whereName($permission)->firstOrFail();

        $this->permissions()->syncWithoutDetaching($permission);
    }

    /**
     * Revoke a permission from this role.
     */
    public function revokePermission(string|Permission $permission): void
    {
        $permission = $permission instanceof Permission
            ? $permission
            : Permission::whereName($permission)->firstOrFail();

        $this->permissions()->detach($permission);
    }

    public function hasPermission(string $name): bool
    {
        return $this->permissions->contains('name', $name);
    }
}