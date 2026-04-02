<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class PlanResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        if (is_null($this->resource)) {
            return [];
        }

        return [
            'id'                  => $this->id,
            'name'                => $this->name,
            'slug'                => $this->slug,
            'price'               => $this->price,
            'price_formatted'     => $this->price_formatted,
            'storage_limit'       => $this->storage_limit,
            'storage_limit_human' => $this->storage_limit_human,
            'features'            => $this->features ?? [],
            'is_active'           => $this->is_active,
            'is_free'             => $this->is_free,
            'stripe_price_id'     => $this->stripe_price_id,
            'created_at'          => $this->created_at?->toDateTimeString(),
        ];
    }
}