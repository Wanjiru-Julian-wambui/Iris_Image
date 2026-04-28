<?php

namespace App\Http\Controllers;

use App\Models\Image;
use App\Models\Tag;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class TagController extends Controller
{
    /**
     * Batch apply / remove tags from selected images.
     */
    public function batchTag(Request $request)
    {
        $data = $request->validate([
            'image_ids' => ['required', 'array', 'min:1'],
            'image_ids.*' => ['integer', 'exists:images,id'],
            'tags'      => ['required', 'array'],
            'tags.*'    => ['string', 'max:50'],
            'action'    => ['required', 'in:attach,detach'],
        ]);

        $images = $request->user()
            ->images()
            ->whereIn('id', $data['image_ids'])
            ->get();

        if ($images->isEmpty()) {
            return back()->with('error', 'No images found.');
        }

        $tagNames = array_unique(array_map('trim', array_filter($data['tags'])));

        if (empty($tagNames)) {
            return back()->with('error', 'No valid tags provided.');
        }

        DB::transaction(function () use ($images, $tagNames, $data) {
            if ($data['action'] === 'attach') {
                // Find or create tags, then attach to each image
                $tagIds = [];
                foreach ($tagNames as $name) {
                    $tag = Tag::firstOrCreate(
                        ['slug' => Str::slug($name)],
                        ['name' => $name]
                    );
                    $tagIds[] = $tag->id;
                }

                foreach ($images as $image) {
                    $image->tags()->syncWithoutDetaching($tagIds);
                }
            } else {
                // Detach: find existing tags by name/slug and detach
                $slugs = array_map(fn ($n) => Str::slug($n), $tagNames);
                $tagIds = Tag::whereIn('slug', $slugs)->pluck('id');

                foreach ($images as $image) {
                    $image->tags()->detach($tagIds);
                }
            }
        });

        $actionText = $data['action'] === 'attach' ? 'applied to' : 'removed from';

        return back()->with('success', count($tagNames) . ' tag(s) ' . $actionText . ' ' . $images->count() . ' image(s).');
    }

    /**
     * Get all tags for the authenticated user (via their images).
     */
    public function index(Request $request)
    {
        $tags = Tag::whereHas('images', fn ($q) => $q->where('user_id', $request->user()->id))
            ->orderBy('name')
            ->get(['id', 'name', 'slug']);

        return response()->json($tags);
    }
}