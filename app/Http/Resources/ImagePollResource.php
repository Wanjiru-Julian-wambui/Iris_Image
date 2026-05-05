<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ImagePollResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        $isAb   = $this->type === 'ab';
        $imageA = $isAb ? $this->whenLoaded('imageA') : null;
        $imageB = $isAb ? $this->whenLoaded('imageB') : null;
        $images = !$isAb ? $this->whenLoaded('images') : null;

        return [
            'id'           => $this->id,
            'type'         => $this->type,
            'question'     => $this->question,
            'max_choices'  => $this->max_choices,
            'public_token' => $this->public_token,
            'public_url'   => $this->public_url,

            // A/B only
            'image_a'      => $imageA ? new ImageResource($imageA) : null,
            'image_b'      => $imageB ? new ImageResource($imageB) : null,

            // Multi only
            'images'       => $images ? ImageResource::collection($images) : null,

            'results'      => $this->results,
            'has_voted'    => $this->has_voted ?? false,
            'user_vote'    => $this->user_vote ?? null,
            'user_votes'   => $this->user_votes ?? null,

            'created_at'   => $this->created_at->diffForHumans(),
        ];
    }
}