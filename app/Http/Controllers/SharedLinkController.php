<?php

namespace App\Http\Controllers;

use App\Http\Requests\SharedLinkRequest;
use App\Http\Resources\ImageResource;
use App\Http\Resources\SharedLinkResource;
use App\Models\SharedLink;
use App\Services\SharedLinkService;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class SharedLinkController extends Controller
{
    public function __construct(protected SharedLinkService $sharedLinkService) {}

    public function index(Request $request): Response
    {
        $links = $request->user()
            ->sharedLinks()
            ->with('image')
            ->latest()
            ->paginate(20);

        return Inertia::render('shared-links/Index', [
            'links' => SharedLinkResource::collection($links),
        ]);
    }

    public function store(SharedLinkRequest $request)
    {
        $link = $this->sharedLinkService->create(
            imageId:   $request->validated('image_id'),
            user:      $request->user(),
            expiresIn: $request->validated('expires_in'),
            password:  $request->validated('password'),
        );

        return back()->with([
            'success'    => 'Shared link created.',
            'share_url'  => route('shared-links.show', $link->token),
        ]);
    }

    public function show(string $token): Response
    {
        $link = SharedLink::where('token', $token)
            ->with('image')
            ->firstOrFail();

        abort_if($link->is_expired, 410, 'This link has expired.');

        if ($link->password && !session("link_verified_{$link->token}")) {
            return Inertia::render('shared-links/Verify', [
                'token' => $token,
            ]);
        }

        $link->increment('view_count');

        return Inertia::render('shared-links/Show', [
            'image' => new ImageResource($link->image),
            'link'  => new SharedLinkResource($link),
        ]);
    }

    public function verify(string $token, Request $request)
    {
        $link = SharedLink::where('token', $token)->firstOrFail();

        $request->validate([
            'password' => ['required', 'string'],
        ]);

        if (!\Hash::check($request->password, $link->password)) {
            return back()->withErrors(['password' => 'Incorrect password.']);
        }

        session(["link_verified_{$link->token}" => true]);

        return redirect()->route('shared-links.show', $token);
    }

    public function destroy(SharedLink $sharedLink)
    {
        $this->authorize('delete', $sharedLink);

        $sharedLink->delete();

        return redirect()->route('shared-links.index')->with('success',
            'Shared link deleted.'
        );
    }
}