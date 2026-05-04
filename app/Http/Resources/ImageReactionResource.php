<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ImageReactionResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id'           => $this->id,
            'type'         => $this->type,
            'emoji'        => $this->when($this->isEmoji(), $this->emoji),
            'media_url'    => $this->when($this->isGif() || $this->isSticker(), $this->media_url),
            'media_label'  => $this->media_label,
            'media_source' => $this->media_source,
            'user'         => $this->whenLoaded('user', fn() => [
                'id'   => $this->user->id,
                'name' => $this->user->name,
            ]),
            'created_at'   => $this->created_at->diffForHumans(),
        ];
    }
}