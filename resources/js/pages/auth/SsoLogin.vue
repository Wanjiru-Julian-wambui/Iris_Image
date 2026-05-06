<script setup lang="ts">
import { Head } from '@inertiajs/vue3';
import { Shield } from 'lucide-vue-next';

// The SAML redirect is handled server-side by aacotroneo/laravel-saml2.
// This page just gives enterprise users a clear entry point.
const idpName = 'default'; // matches config/saml2_settings.php idp name

function redirectToIdp() {
    window.location.href = `/saml2/${idpName}/login`;
}
</script>

<template>
    <Head title="SSO Login" />

    <div class="min-h-screen flex items-center justify-center bg-background px-4">
        <div class="w-full max-w-md space-y-8 text-center">

            <div class="flex justify-center">
                <div class="flex h-16 w-16 items-center justify-center rounded-2xl bg-violet-500/15">
                    <Shield class="h-8 w-8 text-violet-400" />
                </div>
            </div>

            <div>
                <h1 class="text-2xl font-bold tracking-tight">Enterprise SSO</h1>
                <p class="mt-2 text-sm text-muted-foreground">
                    Sign in using your organisation's identity provider (Okta, Azure AD, Google Workspace).
                </p>
            </div>

            <button
                @click="redirectToIdp"
                class="w-full rounded-xl bg-gradient-to-r from-violet-500 to-cyan-400 px-6 py-3 text-sm font-semibold text-white hover:opacity-90 transition-opacity"
            >
                Continue with SSO
            </button>

            <p class="text-xs text-muted-foreground">
                Not using SSO?
                <a href="/login" class="text-violet-400 hover:text-violet-300 underline underline-offset-2">Sign in with email</a>
            </p>
        </div>
    </div>
</template>