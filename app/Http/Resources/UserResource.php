<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class UserResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id'                => $this->id,
            'name'              => $this->name,
            'email'             => $this->email,
            'avatar'            => $this->avatar_url,
            'is_admin'          => $this->is_admin,
            'plan'              => new PlanResource($this->whenLoaded('plan')),
            'storage_used'      => $this->storage_used,
            'storage_used_human'=> $this->storage_used_human,
            'storage_limit'     => $this->plan?->storage_limit,
            'storage_percent'   => $this->storage_percent,
            'image_count'       => $this->when(
                $request->user()?->id === $this->id || $request->user()?->is_admin,
                $this->images_count
            ),
            'email_verified_at' => $this->email_verified_at?->toDateTimeString(),
            'created_at'        => $this->created_at->toDateTimeString(),
        ];
    }
}