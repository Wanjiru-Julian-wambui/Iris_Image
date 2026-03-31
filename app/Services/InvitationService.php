<?php

namespace App\Services;

use App\Models\Invitation;
use App\Models\Plan;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;

class InvitationService
{
    /**
     * Send an invitation email to the given address.
     */
    public function send(string $email, User $invitedBy, int $expiresIn): Invitation
    {
        $invitation = Invitation::create([
            'email'      => $email,
            'invited_by' => $invitedBy->id,
            'expires_at' => now()->addHours($expiresIn),
        ]);

        Mail::to($email)->send(new \App\Mail\InvitationMail($invitation));

        return $invitation;
    }

    /**
     * Accept an invitation and create the new user account.
     */
    public function accept(Invitation $invitation, array $data): User
    {
        return DB::transaction(function () use ($invitation, $data) {
            $freePlan = Plan::where('slug', 'free')->first();

            $user = User::create([
                'name'              => $data['name'],
                'email'             => $invitation->email,
                'password'          => Hash::make($data['password']),
                'plan_id'           => $freePlan?->id,
                'email_verified_at' => now(),
            ]);

            $invitation->update([
                'is_accepted' => true,
                'accepted_by' => $user->id,
                'accepted_at' => now(),
            ]);

            Auth::login($user);

            return $user;
        });
    }

    /**
     * Resend an invitation email.
     */
    public function resend(Invitation $invitation): Invitation
    {
        $invitation->update([
            'expires_at' => now()->addHours(config('iris.invitations.expiry_hours', 72)),
        ]);

        Mail::to($invitation->email)->send(new \App\Mail\InvitationMail($invitation));

        return $invitation;
    }
}