<?php

namespace App\Http\Controllers;

use App\Http\Requests\AcceptInvitationRequest;
use App\Http\Requests\SendInvitationRequest;
use App\Http\Resources\InvitationResource;
use App\Mail\InvitationMail;
use App\Models\Invitation;
use App\Models\User;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Http\RedirectResponse;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Inertia\Inertia;
use Inertia\Response;

class InvitationController extends Controller
{
    use AuthorizesRequests;

    public function index(): Response
    {
        $this->authorize('viewAny', Invitation::class);

        $invitations = Invitation::with(['invitedBy', 'acceptedBy'])
            ->latest()
            ->paginate(10);

        return Inertia::render('invitations/Index', [
            'invitations' => InvitationResource::collection($invitations),
        ]);
    }

    public function create(): Response
    {
        $this->authorize('create', Invitation::class);

        return Inertia::render('invitations/Create');
    }

    public function store(SendInvitationRequest $request): RedirectResponse
    {
        $this->authorize('create', Invitation::class);

        $invitation = Invitation::create([
            'email'      => $request->validated('email'),
            'invited_by' => Auth::id(),
        ]);

        Mail::to($invitation->email)->send(new InvitationMail($invitation));

        return back()->with('success', 'Invitation sent successfully!');
    }

    public function show(string $token): Response
    {
        // No auth here: invited person usually isn't registered yet
        $invitation = Invitation::with('invitedBy')
            ->where('token', $token)
            ->pending()
            ->firstOrFail();

        return Inertia::render('auth/AcceptInvitation', [
            'invitation' => InvitationResource::make($invitation),
        ]);
    }

    public function accept(AcceptInvitationRequest $request, string $token): RedirectResponse
    {
        $invitation = Invitation::where('token', $token)
            ->pending()
            ->firstOrFail();

        // Optionally, check if a user with this email already exists
        if (User::where('email', $invitation->email)->exists()) {
            return redirect()
                ->route('login')
                ->withErrors(['email' => 'An account with this email already exists.']);
        }

        $user = User::create([
            'name'     => $request->validated('name'),
            'email'    => $invitation->email,
            'password' => Hash::make($request->validated('password')),
        ]);

        $invitation->update([
            'is_accepted' => true,
            'accepted_by' => $user->id,
            'accepted_at' => now(),
        ]);

        Auth::login($user);

        return redirect()->route('dashboard');
    }

    public function destroy(Invitation $invitation): RedirectResponse
{
    $this->authorize('delete', $invitation);
    $invitation->delete();
    return back()->with('success', 'Invitation deleted.');
}
}