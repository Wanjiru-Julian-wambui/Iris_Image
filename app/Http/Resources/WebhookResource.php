<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class WebhookResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id'             => $this->id,
            'name'           => $this->name,
            'url'            => $this->url,
            'events'         => $this->events,
            'active'         => $this->active,
            'source'         => $this->source,
            'last_fired_at'  => $this->last_fired_at?->diffForHumans(),
            'last_status'    => $this->last_status,
            'failure_count'  => $this->failure_count,
            'created_at'     => $this->created_at->diffForHumans(),
            'deliveries'     => $this->whenLoaded('deliveries', fn() =>
                $this->deliveries->map(fn($d) => [
                    'id'              => $d->id,
                    'event'           => $d->event,
                    'response_status' => $d->response_status,
                    'duration_ms'     => $d->duration_ms,
                    'attempt'         => $d->attempt,
                    'succeeded'       => $d->succeeded,
                    'fired_at'        => $d->fired_at?->diffForHumans(),
                ])
            ),
        ];
    }
}