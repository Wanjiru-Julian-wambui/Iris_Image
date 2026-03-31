<?php

namespace App\Http\Controllers;

use App\Http\Requests\ImageUploadRequest;
use App\Http\Resources\ImageResource;
use App\Models\Image;
use App\Services\ImageService;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class ImageController extends Controller
{
    public function __construct(protected ImageService $imageService) {}

    public function index(Request $request): Response
    {
        $images = $request->user()
            ->images()
            ->latest()
            ->paginate(24);

        return Inertia::render('images/Index', [
            'images' => ImageResource::collection($images),
        ]);
    }

    public function create(): Response
    {
        return Inertia::render('images/Create');
    }

    public function store(ImageUploadRequest $request)
    {
        $uploaded = $this->imageService->uploadMany(
            $request->file('images'),
            $request->user(),
            [
                'is_private'  => $request->boolean('is_private', false),
                'strip_exif'  => $request->boolean('strip_exif', config('iris.strip_exif')),
            ]
        );

        return redirect()->route('images.index')->with('success',
            count($uploaded) . ' image(s) uploaded successfully.'
        );
    }

    public function show(Image $image): Response
    {
        $this->authorize('view', $image);

        $image->load(['user', 'sharedLinks']);

        return Inertia::render('images/Show', [
            'image' => new ImageResource($image),
        ]);
    }

    public function destroy(Image $image)
    {
        $this->authorize('delete', $image);

        $this->imageService->delete($image);

        return redirect()->route('images.index')->with('success',
            'Image deleted successfully.'
        );
    }
}