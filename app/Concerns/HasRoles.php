<?php

namespace App\Concerns;

use App\Models\Permission;
use App\Models\Role;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

/**
 * Add this trait to the User model alongside the existing `HasApiTokens`.
 *
 * Usage in User.php:
 *   use HasRoles;
 *
 * To wire into Laravel's Gate/can() system, add this to AuthServiceProvider::boot():
 *   Gate::before(fn ($user, $ability) => $user->hasPermission($ability) ?: null);
 */
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
     *
     * Named hasPermission() to avoid conflicting with Authenticatable::can().
     * Hook into Gate via Gate::before() in AuthServiceProvider if you want
     * $user->can('images.upload') to work automatically.
     */
    public function hasPermission(string $ability): bool
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
     * Check that the user has ALL of the given permissions.
     */
    public function hasAllPermissions(string ...$abilities): bool
    {
        foreach ($abilities as $ability) {
            if (! $this->hasPermission($ability)) {
                return false;
            }
        }

        return true;
    }

    /**
     * Check that the user has at least one of the given permissions.
     */
    public function hasAnyPermission(string ...$abilities): bool
    {
        foreach ($abilities as $ability) {
            if ($this->hasPermission($ability)) {
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