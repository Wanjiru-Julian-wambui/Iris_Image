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
        $url = route('invitations.show', $this->invitation->token);

        return $this->subject('You have been invited')
            ->view('emails.invitation')
            ->with([
                'invitation' => $this->invitation,
                'url'        => $url,
            ]);
    }
}