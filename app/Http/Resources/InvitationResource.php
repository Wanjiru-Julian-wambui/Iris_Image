<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class InvitationResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     */
    public function toArray($request): array
    {
        return [
            'id'         => $this->id,
            'email'      => $this->email,
            'token'      => $this->token,
            'status'     => $this->status,          // accessor
            'isExpired'  => $this->is_expired,      // accessor
            'expiresAt'  => $this->expires_at?->toIso8601String(),
            'acceptedAt' => $this->accepted_at?->toIso8601String(),
            'invitedBy'  => $this->invitedBy?->only(['id', 'name', 'email']),
            'acceptedBy' => $this->acceptedBy?->only(['id', 'name', 'email']),
            'createdAt'  => $this->created_at?->toIso8601String(),
        ];
    }
}