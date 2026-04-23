<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\ImageResource;
use App\Http\Resources\SharedLinkResource;
use App\Models\SharedLink;
use App\Services\SharedLinkService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class SharedLinkApiController extends Controller
{
    public function __construct(protected SharedLinkService $sharedLinkService) {}

    public function index(Request $request): JsonResponse
    {
        $links = $request->user()
            ->sharedLinks()
            ->with('image')
            ->latest()
            ->paginate($request->integer('per_page', 20));

        return response()->json(SharedLinkResource::collection($links)->response()->getData(true));
    }

    public function store(Request $request): JsonResponse
    {
        $data = $request->validate([
            'image_id'   => ['required', 'integer', 'exists:images,id'],
            'expires_in' => ['nullable', 'integer', 'min:1'],
            'password'   => ['nullable', 'string', 'min:4'],
        ]);

        // Ensure the image belongs to the authenticated user
        abort_unless(
            $request->user()->images()->where('id', $data['image_id'])->exists(),
            403,
            'Image not found.'
        );

        $link = $this->sharedLinkService->create(
            imageId:   $data['image_id'],
            user:      $request->user(),
            expiresIn: $data['expires_in'] ?? null,
            password:  $data['password']   ?? null,
        );

        return response()->json([
            'message' => 'Shared link created.',
            'link'    => (new SharedLinkResource($link->load('image')))->resolve(),
        ], 201);
    }

    public function show(Request $request, SharedLink $sharedLink): JsonResponse
    {
        abort_unless($sharedLink->created_by === $request->user()->id, 403);

        return response()->json((new SharedLinkResource($sharedLink->load('image')))->resolve());
    }

    public function destroy(Request $request, SharedLink $sharedLink): JsonResponse
    {
        abort_unless($sharedLink->created_by === $request->user()->id, 403);

        $sharedLink->delete();

        return response()->json(['message' => 'Shared link deleted.']);
    }

    /**
     * Public endpoint — resolve a share token without authentication.
     */
    public function resolve(string $token): JsonResponse
    {
        $link = SharedLink::where('token', $token)
            ->with('image')
            ->firstOrFail();

        if ($link->is_expired) {
            return response()->json(['message' => 'This link has expired.'], 410);
        }

        if ($link->password) {
            return response()->json(['message' => 'This link is password protected.'], 403);
        }

        $link->increment('view_count');

        return response()->json([
            'image' => (new ImageResource($link->image))->resolve(),
            'link'  => [
                'token'                => $link->token,
                'view_count'           => $link->view_count,
                'expires_at'           => $link->expires_at,
                'is_password_protected' => (bool) $link->password,
            ],
        ]);
    }
}