<?php

namespace App\Http\Controllers;

use Inertia\Inertia;
use Inertia\Response;

class SamlController extends Controller
{
    /**
     * GET /sso/login
     *
     * Renders the enterprise SSO landing page.
     * The actual SAML redirect is handled client-side in SsoLogin.vue
     * by navigating to /saml2/{idpName}/login, which the
     * aacotroneo/laravel-saml2 package intercepts.
     */
    public function loginPage(): Response
    {
        return Inertia::render('auth/SsoLogin');
    }
}