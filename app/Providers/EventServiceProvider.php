<?php

namespace App\Providers;

use App\Events\ImageDeleted;
use App\Events\ImageUploaded;
use App\Events\LinkExpired;
use App\Events\LinkViewed;
use App\Listeners\CheckStorageQuota;
use App\Listeners\FireWebhooksOnImageDeleted;
use App\Listeners\FireWebhooksOnImageUploaded;
use App\Listeners\FireWebhooksOnLinkExpired;
use App\Listeners\FireWebhooksOnLinkViewed;
use Illuminate\Foundation\Support\Providers\EventServiceProvider as ServiceProvider;

class EventServiceProvider extends ServiceProvider
{
    protected $listen = [
        ImageUploaded::class => [
            FireWebhooksOnImageUploaded::class,
            CheckStorageQuota::class,
        ],

        ImageDeleted::class => [
            FireWebhooksOnImageDeleted::class,
        ],

        LinkViewed::class => [
            FireWebhooksOnLinkViewed::class,
        ],

        LinkExpired::class => [
            FireWebhooksOnLinkExpired::class,
        ],
    ];

    public function boot(): void {}

    public function shouldDiscoverEvents(): bool
    {
        return false;
    }
}