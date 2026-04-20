<?php

namespace App\Providers;

use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\Date;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\URL;
use Illuminate\Support\ServiceProvider;
use Illuminate\Validation\Rules\Password;

class AppServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        //
    }

    public function boot(): void
    {
        $this->configureDefaults();
        $this->configureStorage();
    }

    protected function configureDefaults(): void
    {
        Date::use(CarbonImmutable::class);

        DB::prohibitDestructiveCommands(
            app()->isProduction(),
        );

        Password::defaults(fn (): ?Password => app()->isProduction()
            ? Password::min(12)
                ->mixedCase()
                ->letters()
                ->numbers()
                ->symbols()
                ->uncompromised()
            : null,
        );
    }

    protected function configureStorage(): void
    {
        if (! app()->isProduction()) {
            return;
        }

        // Force HTTPS on all generated URLs in production
        URL::forceScheme('https');

        // Create the storage symlink if it doesn't exist yet.
        // Laravel Cloud has an ephemeral filesystem so the symlink
        // created during deployment may not persist. This recreates
        // it on every boot so /storage/ URLs always resolve.
        $link   = public_path('storage');
        $target = storage_path('app/public');

        if (file_exists($target) && ! file_exists($link)) {
            app('files')->link($target, $link);
        }
    }
}