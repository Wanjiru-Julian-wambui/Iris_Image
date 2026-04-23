<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Resources\ImageResource;
use App\Models\Image;
use App\Services\ImageService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

class ImageApiController extends Controller
{
    public function __construct(protected ImageService $imageService) {}

    public function index(Request $request): AnonymousResourceCollection
    {
        $images = $request->user()
            ->images()
            ->when($request->search, fn($q, $s) => $q->where('name', 'like', "%{$s}%"))
            ->when($request->sort === 'oldest',   fn($q) => $q->oldest())
            ->when($request->sort === 'largest',  fn($q) => $q->orderByDesc('size'))
            ->when($request->sort === 'smallest', fn($q) => $q->orderBy('size'))
            ->when($request->sort === 'name',     fn($q) => $q->orderBy('name'))
            ->when(!$request->sort || $request->sort === 'latest', fn($q) => $q->latest())
            ->paginate($request->integer('per_page', 24));

        return ImageResource::collection($images);
    }

    public function store(Request $request): JsonResponse
    {
        $request->validate([
            'images'     => ['required', 'array', 'min:1'],
            'images.*'   => ['required', 'file', 'image', 'max:20480'],
            'is_private' => ['boolean'],
            'strip_exif' => ['boolean'],
        ]);

        $result = $this->imageService->uploadMany(
            $request->file('images'),
            $request->user(),
            [
                'is_private' => $request->boolean('is_private'),
                'strip_exif' => $request->boolean('strip_exif', true),
            ]
        );

        return response()->json([
            'message'  => count($result['uploaded']) . ' image(s) uploaded.',
            'uploaded' => ImageResource::collection($result['uploaded']),
            'skipped'  => count($result['skipped']),
        ], 201);
    }

    public function show(Request $request, Image $image): ImageResource
    {
        abort_unless($image->user_id === $request->user()->id, 403);

        return new ImageResource($image->load('sharedLinks'));
    }

    public function update(Request $request, Image $image): JsonResponse
    {
        abort_unless($image->user_id === $request->user()->id, 403);

        $data = $request->validate([
            'name'       => ['sometimes', 'string', 'max:255'],
            'is_private' => ['sometimes', 'boolean'],
        ]);

        $image->update($data);

        return response()->json([
            'message' => 'Image updated.',
            'image'   => new ImageResource($image->fresh()),
        ]);
    }

    public function destroy(Request $request, Image $image): JsonResponse
    {
        abort_unless($image->user_id === $request->user()->id, 403);

        $this->imageService->delete($image);

        return response()->json(['message' => 'Image deleted.']);
    }
}