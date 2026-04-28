<?php

namespace App\Providers;

use Carbon\CarbonImmutable;
use Illuminate\Http\Resources\Json\JsonResource;
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
        JsonResource::withoutWrapping();

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

        URL::forceScheme('https');

        $link   = public_path('storage');
        $target = storage_path('app/public');

        if (file_exists($target) && ! file_exists($link)) {
            app('files')->link($target, $link);
        }
    }
}