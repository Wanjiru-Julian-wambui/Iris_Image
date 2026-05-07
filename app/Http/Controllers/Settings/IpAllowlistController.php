<?php

namespace App\Http\Controllers\Settings;

use App\Http\Controllers\Controller;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class IpAllowlistController extends Controller
{
    public function edit(Request $request): Response
    {
        return Inertia::render('settings/IpAllowlist', [
            'allowlist' => $request->user()->ip_allowlist ?? [],
        ]);
    }

    public function update(Request $request): RedirectResponse
    {
        $data = $request->validate([
            'entries'   => ['present', 'array', 'max:50'],
            'entries.*' => ['required', 'string', 'max:50', function ($attr, $value, $fail) {
                if (! $this->isValidIpOrCidr($value)) {
                    $fail("\"$value\" is not a valid IP address or CIDR range.");
                }
            }],
        ]);

        $request->user()->update([
            'ip_allowlist' => array_values(array_unique($data['entries'])),
        ]);

        return back()->with('success', 'IP allowlist updated.');
    }

    private function isValidIpOrCidr(string $value): bool
    {
        // Bare IP address
        if (filter_var($value, FILTER_VALIDATE_IP)) {
            return true;
        }

        // CIDR notation
        if (str_contains($value, '/')) {
            [$ip, $prefix] = explode('/', $value, 2);
            $prefix = (int) $prefix;

            if (filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_IPV4)) {
                return $prefix >= 0 && $prefix <= 32;
            }

            if (filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_IPV6)) {
                return $prefix >= 0 && $prefix <= 128;
            }
        }

        return false;
    }
}