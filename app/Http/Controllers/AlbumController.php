<?php

namespace App\Http\Controllers;

use App\Http\Requests\AlbumStoreRequest;
use App\Http\Requests\AlbumUpdateRequest;
use App\Http\Resources\AlbumResource;
use App\Http\Resources\ImageResource;
use App\Models\Album;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class AlbumController extends Controller
{
    public function index(Request $request): Response
    {
        $albums = $request->user()
            ->albums()
            ->withCount('images')
            ->with('coverImage')
            ->latest()
            ->get();

        return Inertia::render('albums/Index', [
            'albums' => AlbumResource::collection($albums),
        ]);
    }

    public function create(Request $request): Response
    {
        $images = $request->user()
            ->images()
            ->latest()
            ->get();

        return Inertia::render('albums/Create', [
            'images' => ImageResource::collection($images),
        ]);
    }

    public function store(AlbumStoreRequest $request)
    {
        $album = $request->user()->albums()->create($request->validated());

        if ($request->has('image_ids')) {
            $album->images()->attach($request->input('image_ids'));
        }

        return redirect()->route('albums.show', $album->id)
            ->with('success', 'Album created successfully.');
    }

    public function show(Request $request, Album $album): Response
    {
        abort_unless($album->user_id === $request->user()->id, 403);

        $album->load(['images.user', 'coverImage']);

        return Inertia::render('albums/Show', [
            'album'  => new AlbumResource($album),
            'images' => ImageResource::collection($album->images),
        ]);
    }

    public function edit(Request $request, Album $album): Response
    {
        abort_unless($album->user_id === $request->user()->id, 403);

        $album->load('images');
        $userImages = $request->user()->images()->latest()->get();

        return Inertia::render('albums/Edit', [
            'album'      => new AlbumResource($album),
            'userImages' => ImageResource::collection($userImages),
        ]);
    }

    public function update(AlbumUpdateRequest $request, Album $album)
    {
        abort_unless($album->user_id === $request->user()->id, 403);

        $album->update($request->validated());

        return back()->with('success', 'Album updated.');
    }

    public function destroy(Album $album)
    {
        abort_unless($album->user_id === auth()->id(), 403);

        $album->delete();

        return redirect()->route('albums.index')
            ->with('success', 'Album deleted.');
    }

    public function addImages(Request $request, Album $album)
    {
        abort_unless($album->user_id === $request->user()->id, 403);

        $data = $request->validate([
            'image_ids'   => ['required', 'array'],
            'image_ids.*' => ['integer', 'exists:images,id'],
        ]);

        $existingIds = $album->images()->pluck('images.id')->toArray();
        $newIds = array_diff($data['image_ids'], $existingIds);

        $album->images()->attach($newIds);

        return back()->with('success', count($newIds) . ' image(s) added.');
    }

    public function removeImage(Request $request, Album $album, int $imageId)
    {
        abort_unless($album->user_id === $request->user()->id, 403);

        $album->images()->detach($imageId);

        return back()->with('success', 'Image removed from album.');
    }

    public function reorder(Request $request, Album $album)
    {
        abort_unless($album->user_id === $request->user()->id, 403);

        $ordered = $request->input('ordered_ids', []);

        foreach ($ordered as $index => $imageId) {
            $album->images()->updateExistingPivot($imageId, ['sort_order' => $index]);
        }

        return back()->with('success', 'Album reordered.');
    }
}