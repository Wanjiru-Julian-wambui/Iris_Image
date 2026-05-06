<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class CheckIpAllowlist
{
    /**
     * Block authenticated requests that originate outside the user's (or
     * team owner's) IP allowlist.  CIDR ranges (e.g. 192.168.1.0/24) are
     * supported as well as plain IPv4/IPv6 addresses.
     */
    public function handle(Request $request, Closure $next): Response
    {
        $user = $request->user();

        if (! $user) {
            return $next($request);
        }

        // Allowlist is stored as a JSON array on the users table.
        $allowlist = $user->ip_allowlist ?? [];

        // If no allowlist is configured, skip the check.
        if (empty($allowlist)) {
            return $next($request);
        }

        $clientIp = $request->ip();

        foreach ($allowlist as $entry) {
            if ($this->matches($clientIp, trim($entry))) {
                return $next($request);
            }
        }

        if ($request->expectsJson()) {
            return response()->json([
                'message' => 'Access denied: your IP address is not allowed.',
            ], 403);
        }

        abort(403, 'Access denied: your IP address is not on the allowlist.');
    }

    // ─────────────────────────────────────────────────────────────────────────

    private function matches(string $ip, string $entry): bool
    {
        // Exact match (plain IP)
        if (! str_contains($entry, '/')) {
            return $ip === $entry;
        }

        // CIDR range
        [$subnet, $prefix] = explode('/', $entry, 2);
        $prefix = (int) $prefix;

        // IPv4
        if (filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_IPV4)
            && filter_var($subnet, FILTER_VALIDATE_IP, FILTER_FLAG_IPV4)) {
            $ipLong     = ip2long($ip);
            $subnetLong = ip2long($subnet);
            $mask       = $prefix === 0 ? 0 : (~0 << (32 - $prefix));

            return ($ipLong & $mask) === ($subnetLong & $mask);
        }

        // IPv6 (simple binary comparison)
        if (filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_IPV6)
            && filter_var($subnet, FILTER_VALIDATE_IP, FILTER_FLAG_IPV6)) {
            $ipBin     = inet_pton($ip);
            $subnetBin = inet_pton($subnet);

            if ($ipBin === false || $subnetBin === false) {
                return false;
            }

            $fullBytes = intdiv($prefix, 8);
            $leftover  = $prefix % 8;

            // Compare full bytes
            if (substr($ipBin, 0, $fullBytes) !== substr($subnetBin, 0, $fullBytes)) {
                return false;
            }

            // Compare partial byte
            if ($leftover > 0) {
                $mask = 0xFF & (0xFF << (8 - $leftover));
                if ((ord($ipBin[$fullBytes]) & $mask) !== (ord($subnetBin[$fullBytes]) & $mask)) {
                    return false;
                }
            }

            return true;
        }

        return false;
    }
}