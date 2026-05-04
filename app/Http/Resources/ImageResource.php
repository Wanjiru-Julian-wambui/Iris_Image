<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ImageResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id'             => $this->id,
            'name'           => $this->name,
            'original_name'  => $this->original_name,
            'url'            => $this->url,
            'thumbnail_url'  => $this->thumbnail_url,
            'public_url'     => $this->public_url,
            'public_token'   => $this->public_token,
            'embed_codes'    => $this->embed_codes,
            'mime_type'      => $this->mime_type,
            'extension'      => $this->extension,
            'size'           => $this->size,
            'size_human'     => $this->size_human,
            'width'          => $this->width,
            'height'         => $this->height,
            'is_private'     => $this->is_private,
            'exif_stripped'  => $this->exif_stripped,
            'sort_order'     => $this->sort_order,
            'download_count' => $this->download_count,
            'caption'        => $this->caption,
            'alt_text'       => $this->alt_text,
            'created_at'     => $this->created_at->diffForHumans(),

            // Shaped as { emoji: Record<string,number>, gifs: [...], stickers: [...] }
            // Falls back to empty structure when reactions are not eager-loaded
            'reactions' => $this->whenLoaded(
                'reactions',
                fn() => $this->reactions_summary,
                ['emoji' => [], 'gifs' => [], 'stickers' => []]
            ),

            'shared_links' => SharedLinkResource::collection($this->whenLoaded('sharedLinks')),
            'notes'        => ImageNoteResource::collection($this->whenLoaded('notes')),
            'tags'         => TagResource::collection($this->whenLoaded('tags')),
            'versions'     => ImageVersionResource::collection($this->whenLoaded('versions')),
            'user'         => $this->whenLoaded('user', fn() => [
                'id'   => $this->user->id,
                'name' => $this->user->name,
            ]),
        ];
    }
}