<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class AlbumResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id'             => $this->id,
            'name'           => $this->name,
            'slug'           => $this->slug,
            'description'    => $this->description,
            'is_public'      => $this->is_public,
            'has_password'   => !empty($this->password),
            'public_token'   => $this->public_token,
            'public_url'     => $this->public_url,
            'cover_image'    => $this->coverImage ? new ImageResource($this->coverImage) : null,
            'images_count'   => $this->whenCounted('images'),
            'images'         => ImageResource::collection($this->whenLoaded('images')),
            'created_at'     => $this->created_at->diffForHumans(),
            'updated_at'     => $this->updated_at->diffForHumans(),
            'user'           => $this->whenLoaded('user', fn() => [
                'id'   => $this->user->id,
                'name' => $this->user->name,
            ]),
        ];
    }
}