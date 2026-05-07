<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use LdapRecord\Container;
use LdapRecord\Models\ActiveDirectory\User as LdapUser;
use Throwable;

class LdapLoginController extends Controller
{
    /**
     * POST /ldap/login
     *
     * Attempts LDAP bind first, falls back to local Eloquent auth if LDAP
     * is unreachable or the user is not found in the directory.
     */
    public function login(Request $request): RedirectResponse
    {
        $request->validate([
            'email'    => ['required', 'email'],
            'password' => ['required', 'string'],
        ]);

        // ── 1. Attempt LDAP bind ──────────────────────────────────────────────
        try {
            $ldapUser = LdapUser::where('mail', '=', $request->email)->first();

            if ($ldapUser && $this->bindAsUser($ldapUser->getDn(), $request->password)) {
                $user = $this->syncLocalUser($ldapUser, $request->email);
                Auth::login($user, $request->boolean('remember'));
                $request->session()->regenerate();

                return redirect()->intended(route('dashboard'));
            }
        } catch (Throwable) {
            // LDAP unavailable — fall through to local auth
        }

        // ── 2. Fall back to local Eloquent auth ───────────────────────────────
        if (Auth::attempt($request->only('email', 'password'), $request->boolean('remember'))) {
            $request->session()->regenerate();

            return redirect()->intended(route('dashboard'));
        }

        return back()->withErrors([
            'email' => __('auth.failed'),
        ])->onlyInput('email');
    }

    // ─────────────────────────────────────────────────────────────────────────

    private function bindAsUser(string $dn, string $password): bool
    {
        $connection = Container::getDefaultConnection();
        $connection->auth()->attempt($dn, $password, stayBound: true);

        return $connection->auth()->passed();
    }

    private function syncLocalUser(LdapUser $ldapUser, string $email): User
    {
        $attrs = $ldapUser->getAttributes();

        $name = $attrs['displayname'][0]
            ?? $attrs['cn'][0]
            ?? $email;

        return User::updateOrCreate(
            ['email' => $email],
            [
                'name'              => $name,
                'password'          => Hash::make(Str::random(32)),
                'email_verified_at' => now(),
            ]
        );
    }
}