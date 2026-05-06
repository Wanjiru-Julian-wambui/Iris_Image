<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Str;
use Aacotroneo\Saml2\Events\Saml2LoginEvent;

class SamlController extends Controller
{
    /**
     * Handle a successful SAML2 login assertion.
     * Fired via the Saml2LoginEvent listener registered in EventServiceProvider.
     */
    public function handleLogin(Saml2LoginEvent $event): void
    {
        $messageId = $event->getSaml2Auth()->getLastMessageId();
        $samlUser  = $event->getSaml2User();

        $email = $samlUser->getUserId();
        $attrs = $samlUser->getAttributes();

        $user = User::firstOrCreate(
            ['email' => $email],
            [
                'name'              => $attrs['displayName'][0]
                                        ?? $attrs['givenName'][0] ?? $email,
                'password'          => bcrypt(Str::random(32)),
                'email_verified_at' => now(),
            ]
        );

        // Sync name if it has changed in IdP
        if (isset($attrs['displayName'][0]) && $user->name !== $attrs['displayName'][0]) {
            $user->update(['name' => $attrs['displayName'][0]]);
        }

        Auth::login($user, remember: true);
    }

    /**
     * Show the enterprise SSO login page (IdP selector / redirect).
     */
    public function loginPage(): \Inertia\Response
    {
        return inertia('auth/SsoLogin');
    }
}