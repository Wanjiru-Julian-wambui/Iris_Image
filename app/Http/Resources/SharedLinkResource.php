<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class SharedLinkResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id'               => $this->id,
            'token'            => $this->token,
            'url'              => url('/share/' . $this->token),
            'image'            => new ImageResource($this->whenLoaded('image')),
            'created_by'       => new UserResource($this->whenLoaded('createdBy')),
            'is_password_protected' => !is_null($this->password),
            'is_expired'       => $this->expires_at?->isPast() ?? false,
            'expires_at'       => $this->expires_at?->toDateTimeString(),
            'expires_in_human' => $this->expires_at?->diffForHumans(),
            'view_count'       => $this->view_count,
            'created_at'       => $this->created_at->toDateTimeString(),
        ];
    }
}