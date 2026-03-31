<?php

namespace App\Policies;

use App\Models\Invitation;
use App\Models\User;

class InvitationPolicy
{
    public function viewAny(User $user): bool
    {
        // Adjust as needed for roles/permissions.
        return true;
    }

    public function view(User $user, Invitation $invitation): bool
    {
        return $user->id === $invitation->invited_by;
    }

    public function create(User $user): bool
    {
        return true; // or some role check
    }

    public function update(User $user, Invitation $invitation): bool
    {
        return $user->id === $invitation->invited_by;
    }

    public function delete(User $user, Invitation $invitation): bool
    {
        return $user->id === $invitation->invited_by;
    }
}