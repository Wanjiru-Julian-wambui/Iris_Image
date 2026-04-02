<?php

namespace App\Mail;

use App\Models\Invitation;
use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

class InvitationMail extends Mailable
{
    use Queueable, SerializesModels;

    public Invitation $invitation;

    public function __construct(Invitation $invitation)
    {
        $this->invitation = $invitation;
    }

    public function build(): self
    {
        $this->invitation->loadMissing('invitedBy');

        $inviteUrl = route('invitations.show', $this->invitation->token);
        $invitedBy = $this->invitation->invitedBy?->name ?? 'Someone';
        $expiresAt = $this->invitation->expires_at
            ? $this->invitation->expires_at->format('F j, Y \a\t g:i A')
            : 'N/A';

        // Send from the inviter's email so recipients know who invited them
        $fromEmail = $this->invitation->invitedBy?->email ?? config('mail.from.address');
        $fromName  = $this->invitation->invitedBy?->name ?? config('mail.from.name');

        return $this->from($fromEmail, $fromName)
            ->subject("{$invitedBy} invited you to join Iris")
            ->view('emails.invitation')
            ->with([
                'invitation' => $this->invitation,
                'inviteUrl'  => $inviteUrl,
                'invitedBy'  => $invitedBy,
                'expiresAt'  => $expiresAt,
            ]);
    }
}