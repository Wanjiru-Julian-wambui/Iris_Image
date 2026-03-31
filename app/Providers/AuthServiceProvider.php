<?php

namespace App\Providers;

use App\Models\Invitation;
use App\Policies\InvitationPolicy;
use Illuminate\Foundation\Support\Providers\AuthServiceProvider as ServiceProvider;

class AuthServiceProvider extends ServiceProvider
{
    protected $policies = [
        Invitation::class => InvitationPolicy::class,
    ];

    public function boot(): void
    {
        $this->registerPolicies();
    }
}