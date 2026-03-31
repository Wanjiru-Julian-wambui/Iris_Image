<?php

namespace Tests\Feature;

use App\Mail\InvitationMail;
use App\Models\Invitation;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Mail;
use Tests\TestCase;

class InvitationTest extends TestCase
{
    use RefreshDatabase;

    public function test_authenticated_user_can_send_invitation(): void
    {
        Mail::fake();

        $user = User::factory()->create();

        $response = $this->actingAs($user)
            ->post(route('invitations.store'), [
                'email' => 'test@example.com',
            ]);

        $response->assertRedirect();
        $this->assertDatabaseHas('invitations', [
            'email'       => 'test@example.com',
            'invited_by'  => $user->id,
            'is_accepted' => false,
        ]);

        Mail::assertSent(InvitationMail::class);
    }

    public function test_invited_user_can_accept_invitation(): void
    {
        $invitation = Invitation::factory()->create([
            'email'       => 'new-user@example.com',
            'is_accepted' => false,
            'expires_at'  => now()->addDay(),
        ]);

        $response = $this->post(route('invitations.accept', $invitation->token), [
            'name'                  => 'New User',
            'password'              => 'password123',
            'password_confirmation' => 'password123',
        ]);

        $response->assertRedirect(route('dashboard'));

        $this->assertDatabaseHas('users', [
            'email' => 'new-user@example.com',
            'name'  => 'New User',
        ]);

        $this->assertDatabaseHas('invitations', [
            'id'          => $invitation->id,
            'is_accepted' => true,
        ]);
    }
}