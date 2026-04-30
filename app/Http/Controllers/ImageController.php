<?php

namespace App\Http\Controllers;

use App\Http\Requests\ImageUploadRequest;
use App\Http\Resources\ImageResource;
use App\Models\Image;
use App\Models\Tag;
use App\Services\ImageService;
use App\Services\ZipService;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Inertia\Inertia;
use Inertia\Response;

class ImageController extends Controller
{
    public function __construct(
        protected ImageService $imageService,
        protected ZipService   $zipService,
    ) {}

    public function index(Request $request): Response
    {
        $images = $request->user()
            ->images()
            ->with('tags')
            ->when($request->search, fn($q, $s) => $q->search($s))
            ->orderBy('sort_order', 'asc')
            ->orderBy('created_at', 'desc')
            ->paginate(24);

        return Inertia::render('images/Index', [
            'images'  => ImageResource::collection($images),
            'filters' => $request->only(['search']),
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

        $image->load(['user', 'sharedLinks', 'notes.user', 'tags', 'reactions', 'versions']);

        return Inertia::render('images/Show', [
            'image' => new ImageResource($image),
        ]);
    }

    public function gallery(Request $request): Response
    {
        $images = $request->user()
            ->images()
            ->with('tags')
            ->when($request->search, fn($q, $s) => $q->search($s))
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

    public function bulkDestroy(Request $request)
    {
        $ids = $request->input('ids', []);

        $images = $request->user()
            ->images()
            ->whereIn('id', $ids)
            ->get();

        foreach ($images as $image) {
            $this->imageService->delete($image);
        }

        return back()->with('success', $images->count() . ' image(s) deleted.');
    }

    public function reorder(Request $request)
    {
        $ordered = $request->input('ordered_ids', []);

        foreach ($ordered as $index => $id) {
            $request->user()
                ->images()
                ->where('id', $id)
                ->update(['sort_order' => $index]);
        }

        return back()->with('success', 'Images reordered.');
    }

    public function update(Request $request, Image $image)
    {
        abort_unless($image->user_id === auth()->id(), 403);

        $data = $request->validate([
            'caption'  => ['nullable', 'string', 'max:2000'],
            'alt_text' => ['nullable', 'string', 'max:500'],
        ]);

        $image->update($data);

        return back()->with('success', 'Image updated.');
    }

    public function download(Image $image)
    {
        abort_unless($image->user_id === auth()->id(), 403);

        $image->incrementDownload();

        return redirect($image->url);
    }

    public function replace(Request $request, Image $image)
    {
        abort_unless($image->user_id === auth()->id(), 403);

        $data = $request->validate([
            'file'        => ['required', 'file', 'image', 'mimes:jpg,jpeg,png,gif,webp,svg,tiff', 'max:102400'],
            'label'       => ['nullable', 'string', 'max:100'],
            'change_note' => ['nullable', 'string', 'max:500'],
            'strip_exif'  => ['sometimes', 'boolean'],
        ]);

        $this->imageService->replace(
            $image,
            $request->file('file'),
            ['strip_exif' => $data['strip_exif'] ?? config('iris.strip_exif')],
            $data['label'] ?? null,
            $data['change_note'] ?? null
        );

        return back()->with('success', 'Image replaced. Previous version saved.');
    }

    public function batchTag(Request $request)
    {
        $data = $request->validate([
            'ids'    => ['required', 'array', 'min:1'],
            'ids.*'  => ['integer', 'exists:images,id'],
            'tags'   => ['required', 'array'],
            'tags.*' => ['string', 'max:50'],
            'action' => ['required', 'in:add,remove'],
        ]);

        $user = $request->user();

        $imageIds = $user->images()
            ->whereIn('id', $data['ids'])
            ->pluck('id')
            ->toArray();

        if (empty($imageIds)) {
            return back()->with('error', 'Invalid image selection.');
        }

        $tagIds = [];
        foreach ($data['tags'] as $tagName) {
            $name = trim($tagName);
            if (empty($name)) continue;

            $tag = Tag::firstOrCreate(
                ['slug' => Str::slug($name)],
                ['name' => $name]
            );
            $tagIds[] = $tag->id;
        }

        $images = Image::whereIn('id', $imageIds)->get();

        foreach ($images as $image) {
            if ($data['action'] === 'add') {
                $image->tags()->syncWithoutDetaching($tagIds);
            } else {
                $image->tags()->detach($tagIds);
            }
        }

        $actionText = $data['action'] === 'add' ? 'added to' : 'removed from';

        return back()->with('success', 'Tags ' . $actionText . ' ' . count($images) . ' image(s).');
    }

    public function bulkDownload(Request $request)
    {
        $request->validate([
            'ids'                    => ['required', 'array', 'min:1'],
            'ids.*'                  => ['integer', 'exists:images,id'],
            'watermark'              => ['sometimes', 'boolean'],
            'watermark_text_type'    => ['sometimes', 'string', 'in:username,site_name,custom'],
            'watermark_text'         => ['required_if:watermark_text_type,custom', 'nullable', 'string', 'max:100'],
            'watermark_mode'         => ['sometimes', 'string', 'in:single,tiled'],
            'watermark_position'     => ['sometimes', 'string', 'in:bottom-right,bottom-left,top-right,top-left,center'],
            'watermark_opacity'      => ['sometimes', 'integer', 'min:10', 'max:100'],
            'watermark_font'         => ['sometimes', 'string', 'in:sans,sans-bold,serif,serif-bold,mono,oblique'],
            'watermark_size'         => ['sometimes', 'integer', 'min:8', 'max:120'],
            'watermark_angle'        => ['sometimes', 'integer', 'min:-90', 'max:90'],
            'watermark_density'      => ['sometimes', 'integer', 'min:1', 'max:6'],
            'watermark_color'        => ['sometimes', 'string', 'in:white,black,gray'],
            'watermark_symbol'       => ['sometimes', 'nullable', 'string', 'max:5'],
        ]);

        $images = $request->user()
            ->images()
            ->whereIn('id', $request->ids)
            ->get();

        if ($images->isEmpty()) {
            return response()->json(['message' => 'No images found.'], 404);
        }

        // Build watermark options
        $watermarkOptions = [];
        if ($request->boolean('watermark')) {
            $watermarkOptions = [
                'enabled'  => true,
                'text'     => $this->resolveWatermarkText($request),
                'mode'     => $request->input('watermark_mode',     'single'),
                'position' => $request->input('watermark_position', 'bottom-right'),
                'opacity'  => (int) $request->input('watermark_opacity', 60),
                'font'     => $request->input('watermark_font',     'sans-bold'),
                'size'     => (int) $request->input('watermark_size', 24),
                'angle'    => (int) $request->input('watermark_angle', -30),
                'density'  => (int) $request->input('watermark_density', 3),
                'color'    => $request->input('watermark_color',    'white'),
                'symbol'   => $request->input('watermark_symbol',   ''),
            ];
        }

        // Single image — always stream as a blob (fetch() cannot follow S3 redirects)
        if ($images->count() === 1) {
            $image = $images->first();
            $image->incrementDownload();

            if (!empty($watermarkOptions)) {
                $tempPath = app(\App\Services\WatermarkService::class)->apply(
                    $image,
                    $watermarkOptions['text'],
                    [
                        'position' => $watermarkOptions['position'],
                        'opacity'  => (int) $watermarkOptions['opacity'],
                    ]
                );

                return response()->download(
                    $tempPath,
                    $image->original_name ?? $image->name
                )->deleteFileAfterSend(true);
            }

            // No watermark — stream S3 bytes directly so fetch() receives the blob
            $disk     = config('filesystems.default');
            $contents = \Illuminate\Support\Facades\Storage::disk($disk)->get($image->path);

            return response($contents, 200, [
                'Content-Type'        => $image->mime_type,
                'Content-Disposition' => 'attachment; filename="' . ($image->original_name ?? $image->name) . '"',
            ]);
        }

        // Multiple images — zip (ZipService handles S3 + optional watermark)
        $zipPath = $this->zipService->createFromImages($images, $watermarkOptions);

        $images->each->incrementDownload();

        return response()->download(
            $zipPath,
            'iris-images-' . now()->format('Y-m-d') . '.zip'
        )->deleteFileAfterSend(true);
    }

    private function resolveWatermarkText(Request $request): string
    {
        $base = match ($request->input('watermark_text_type', 'site_name')) {
            'username' => $request->user()->name,
            'custom'   => $request->input('watermark_text', config('app.name')),
            default    => config('app.name'),
        };

        $symbol = trim($request->input('watermark_symbol', ''));

        return $symbol ? "{$symbol} {$base}" : $base;
    }
}