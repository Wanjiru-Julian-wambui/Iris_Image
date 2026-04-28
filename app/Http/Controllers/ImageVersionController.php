<?php

namespace App\Http\Controllers;

use App\Http\Resources\ImageVersionResource;
use App\Models\Image;
use App\Models\ImageVersion;
use App\Services\ImageService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class ImageVersionController extends Controller
{
    public function __construct(protected ImageService $imageService) {}

    public function index(Image $image)
    {
        abort_unless($image->user_id === auth()->id(), 403);

        $versions = $image->versions()->paginate(20);

        return response()->json([
            'versions' => ImageVersionResource::collection($versions),
        ]);
    }

    public function store(Request $request, Image $image)
    {
        abort_unless($image->user_id === auth()->id(), 403);

        $data = $request->validate([
            'file'        => ['required', 'file', 'image', 'mimes:jpg,jpeg,png,gif,webp,svg,tiff', 'max:102400'],
            'label'       => ['nullable', 'string', 'max:100'],
            'change_note' => ['nullable', 'string', 'max:500'],
        ]);

        $this->imageService->replace(
            $image,
            $request->file('file'),
            ['strip_exif' => $request->boolean('strip_exif', config('iris.strip_exif'))],
            $data['label'] ?? null,
            $data['change_note'] ?? null
        );

        return back()->with('success', 'New version uploaded. Previous version saved.');
    }

    public function restore(Image $image, ImageVersion $version)
    {
        abort_unless($image->user_id === auth()->id(), 403);
        abort_unless($version->image_id === $image->id, 403);

        $this->imageService->restoreVersion($image, $version);

        return back()->with('success', 'Restored to version ' . $version->version_number . '.');
    }

    public function download(Image $image, ImageVersion $version)
    {
        abort_unless($image->user_id === auth()->id(), 403);
        abort_unless($version->image_id === $image->id, 403);

        return redirect($version->url);
    }

    public function destroy(Image $image, ImageVersion $version)
    {
        abort_unless($image->user_id === auth()->id(), 403);
        abort_unless($version->image_id === $image->id, 403);

        $disk = config('filesystems.default');
        Storage::disk($disk)->delete($version->path);

        $image->user->decrement('storage_used', $version->size);
        $version->delete();

        return back()->with('success', 'Version deleted.');
    }

    public function updateLabel(Request $request, Image $image, ImageVersion $version)
    {
        abort_unless($image->user_id === auth()->id(), 403);
        abort_unless($version->image_id === $image->id, 403);

        $data = $request->validate([
            'label'       => ['nullable', 'string', 'max:100'],
            'change_note' => ['nullable', 'string', 'max:500'],
        ]);

        $version->update($data);

        return back()->with('success', 'Version updated.');
    }
}