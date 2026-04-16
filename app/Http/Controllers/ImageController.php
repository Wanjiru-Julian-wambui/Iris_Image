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
                'is_private' => $request->boolean('is_private', false),
                'strip_exif' => $request->boolean('strip_exif', config('iris.strip_exif')),
            ]
        );

        return redirect()->route('images.index')->with('success',
            count($uploaded) . ' image(s) uploaded successfully.'
        );
    }

    public function show(Image $image): Response
    {
        abort_unless($image->user_id === auth()->id(), 403);

        $image->load(['user', 'sharedLinks']);

        return Inertia::render('images/Show', [
            'image' => new ImageResource($image),
        ]);
    }

    public function gallery(Request $request): Response
    {
        $images = $request->user()
            ->images()
            ->when($request->search, fn($q, $s) => $q->where('name', 'like', "%{$s}%"))
            ->when($request->sort === 'oldest',   fn($q) => $q->oldest())
            ->when($request->sort === 'largest',  fn($q) => $q->orderByDesc('size'))
            ->when($request->sort === 'smallest', fn($q) => $q->orderBy('size'))
            ->when($request->sort === 'name',     fn($q) => $q->orderBy('name'))
            ->when(!$request->sort || $request->sort === 'latest', fn($q) => $q->latest())
            ->paginate(40);

        return Inertia::render('Gallery', [
            'images'  => ImageResource::collection($images),
            'filters' => $request->only(['search', 'sort']),
        ]);
    }

    public function destroy(Image $image)
    {
        abort_unless($image->user_id === auth()->id(), 403);

        $this->imageService->delete($image);

        return redirect()->route('images.index')->with('success',
            'Image deleted successfully.'
        );
    }
}
