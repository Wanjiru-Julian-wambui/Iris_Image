<?php

namespace App\Providers;

use Illuminate\Foundation\Support\Providers\AuthServiceProvider as ServiceProvider;
use Illuminate\Support\Facades\Gate;

class AuthServiceProvider extends ServiceProvider
{
    protected $policies = [];

    public function boot(): void
    {
        $this->registerPolicies();

        /**
         * Hook the HasRoles::hasPermission() method into Laravel's Gate.
         *
         * This means $user->can('images.upload') and @can('images.upload')
         * in Blade both work automatically via roles.
         *
         * Returning null (not false) when the user lacks the ability lets
         * other Gate checks (policies etc.) still run.
         */
        Gate::before(function ($user, string $ability): ?bool {
            // hasPermission() returns true for admins and role-matched users
            if ($user->hasPermission($ability)) {
                return true;
            }

            return null; // let other checks proceed
        });
    }
}