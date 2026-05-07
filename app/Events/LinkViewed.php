<?php

namespace App\Events;

use App\Models\SharedLink;
use Illuminate\Broadcasting\InteractsWithSockets;
use Illuminate\Foundation\Events\Dispatchable;
use Illuminate\Queue\SerializesModels;

class LinkViewed
{
    use Dispatchable, InteractsWithSockets, SerializesModels;

    public function __construct(
        public readonly SharedLink $link,
        public readonly ?string    $country = null,
    ) {}
}