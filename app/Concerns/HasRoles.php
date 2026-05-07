<?php

namespace App\Concerns;

use App\Models\Permission;
use App\Models\Role;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;

/**
 * Mixed into App\Models\User via: use HasRoles;
 *
 * To hook into Laravel's Gate/can() system, add this to AuthServiceProvider::boot():
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

    // ── IP allowlist helpers ──────────────────────────────────────────────────
    // The User model already casts ip_allowlist as 'array' (JSON column).
    // Stores plain CIDR strings: ['10.0.0.0/8', '203.0.113.42/32']

    /**
     * Check whether the given IP passes this user's IP allowlist.
     * Returns true when the allowlist is null/empty (no restriction).
     */
    public function isIpAllowed(string $ip): bool
    {
        $list = $this->ip_allowlist;

        if (empty($list)) {
            return true;
        }

        foreach ($list as $cidr) {
            if ($this->ipMatchesCidr($ip, (string) $cidr)) {
                return true;
            }
        }

        return false;
    }

    private function ipMatchesCidr(string $ip, string $cidr): bool
    {
        // Bare IP with no prefix — treat as /32 or /128
        if (! str_contains($cidr, '/')) {
            $cidr .= filter_var($cidr, FILTER_VALIDATE_IP, FILTER_FLAG_IPV6)
                ? '/128'
                : '/32';
        }

        [$subnet, $prefixLen] = explode('/', $cidr, 2);
        $prefixLen = (int) $prefixLen;

        // IPv6
        if (filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_IPV6)) {
            $ipBin     = inet_pton($ip);
            $subnetBin = inet_pton($subnet);
            if ($ipBin === false || $subnetBin === false) return false;

            $fullBytes = (int) floor($prefixLen / 8);
            $partBits  = $prefixLen % 8;
            $mask      = str_repeat("\xff", $fullBytes);
            if ($partBits) {
                $mask .= chr(0xff << (8 - $partBits));
            }
            $mask = str_pad($mask, 16, "\x00");

            return ($ipBin & $mask) === ($subnetBin & $mask);
        }

        // IPv4
        $ipLong     = ip2long($ip);
        $subnetLong = ip2long($subnet);
        $maskLong   = $prefixLen === 0 ? 0 : (~0 << (32 - $prefixLen));

        return ($ipLong & $maskLong) === ($subnetLong & $maskLong);
    }
}