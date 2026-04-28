<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ImageVersionResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id'             => $this->id,
            'version_number' => $this->version_number,
            'url'            => $this->url,
            'thumbnail_url'  => $this->thumbnail_url,
            'size'           => $this->size,
            'size_human'     => $this->size_human,
            'width'          => $this->width,
            'height'         => $this->height,
            'label'          => $this->label,
            'change_note'    => $this->change_note,
            'created_at'     => $this->created_at->diffForHumans(),
        ];
    }
}