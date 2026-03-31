<?php

namespace App\Services;

use App\Models\Image;
use App\Models\SharedLink;
use App\Models\User;

class SharedLinkService
{
    /**
     * Create a new shared link for an image.
     */
    public function create(int $imageId, User $user, int $expiresIn, ?string $password = null): SharedLink
    {
        $image = Image::where('id', $imageId)
            ->where('user_id', $user->id)
            ->firstOrFail();

        return SharedLink::create([
            'image_id'   => $image->id,
            'created_by' => $user->id,
            'password'   => $password,
            'expires_at' => now()->addHours($expiresIn),
        ]);
    }

    /**
     * Revoke (delete) a shared link.
     */
    public function revoke(SharedLink $link): bool
    {
        return $link->delete();
    }

    /**
     * Verify a password-protected shared link.
     */
    public function verifyPassword(SharedLink $link, string $password): bool
    {
        return \Hash::check($password, $link->password);
    }

    /**
     * Check if a shared link is still valid.
     */
    public function isValid(SharedLink $link): bool
    {
        return !$link->is_expired;
    }

    /**
     * Extend the expiry of a shared link.
     */
    public function extend(SharedLink $link, int $additionalHours): SharedLink
    {
        $newExpiry = $link->expires_at?->isFuture()
            ? $link->expires_at->addHours($additionalHours)
            : now()->addHours($additionalHours);

        $link->update(['expires_at' => $newExpiry]);

        return $link->fresh();
    }

    /**
     * Delete all expired shared links (for cleanup command).
     */
    public function deleteExpired(): int
    {
        return SharedLink::expired()->delete();
    }
}