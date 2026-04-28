<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ImagePollResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id'           => $this->id,
            'question'     => $this->question,
            'public_token' => $this->public_token,
            'public_url'   => $this->public_url,
            'image_a'      => new ImageResource($this->whenLoaded('imageA')),
            'image_b'      => new ImageResource($this->whenLoaded('imageB')),
            'results'      => $this->results,
            'has_voted'    => $this->has_voted,
            'user_vote'    => $this->user_vote,
            'created_at'   => $this->created_at->diffForHumans(),
        ];
    }
}