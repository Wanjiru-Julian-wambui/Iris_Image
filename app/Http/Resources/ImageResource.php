<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ImageResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id'           => $this->id,
            'name'         => $this->name,
            'original_name'=> $this->original_name,
            'url'          => $this->url,
            'thumbnail_url'=> $this->thumbnail_url,
            'mime_type'    => $this->mime_type,
            'extension'    => $this->extension,
            'size'         => $this->size,
            'size_human'   => $this->size_human,
            'width'        => $this->width,
            'height'       => $this->height,
            'exif_stripped'=> $this->exif_stripped,
            'is_private'   => $this->is_private,
            'uploaded_by'  => new UserResource($this->whenLoaded('user')),
            'shared_links' => SharedLinkResource::collection($this->whenLoaded('sharedLinks')),
            'created_at'   => $this->created_at->toDateTimeString(),
            'updated_at'   => $this->updated_at->toDateTimeString(),
        ];
    }
}