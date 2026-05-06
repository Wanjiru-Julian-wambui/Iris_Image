<?php

namespace App\Concerns;

use App\Models\Permission;
use App\Models\Role;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;


trait HasRoles
{
    // ── Relationships ─────────────────────────────────────────────────────────

    public function roles(): BelongsToMany
    {
        return $this->belongsToMany(Role::class, 'role_user')->with('permissions');
    }

    // ── Permission checks ─────────────────────────────────────────────────────

    /**
     * Check whether the user has a given permission via any of their roles.
     * Admins (is_admin === true) bypass all permission checks.
     */
    public function can(string $ability, mixed $arguments = []): bool
    {
        if ($this->is_admin) {
            return true;
        }

        foreach ($this->roles as $role) {
            if ($role->hasPermission($ability)) {
                return true;
            }
        }

        return false;
    }

    /**
     * Convenience: check that the user has ALL of the given permissions.
     */
    public function canAll(string ...$abilities): bool
    {
        foreach ($abilities as $ability) {
            if (! $this->can($ability)) {
                return false;
            }
        }

        return true;
    }

    /**
     * Convenience: check that the user has at least one of the given permissions.
     */
    public function canAny(string ...$abilities): bool
    {
        foreach ($abilities as $ability) {
            if ($this->can($ability)) {
                return true;
            }
        }

        return false;
    }

    // ── Role helpers ──────────────────────────────────────────────────────────

    public function hasRole(string $name): bool
    {
        return $this->roles->contains('name', $name);
    }

    public function assignRole(string|Role $role): void
    {
        $role = $role instanceof Role ? $role : Role::whereName($role)->firstOrFail();
        $this->roles()->syncWithoutDetaching($role);
    }

    public function removeRole(string|Role $role): void
    {
        $role = $role instanceof Role ? $role : Role::whereName($role)->firstOrFail();
        $this->roles()->detach($role);
    }
}