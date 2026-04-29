<?php

namespace App\Http\Controllers;

use App\Models\Tag;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Inertia\Inertia;

class TagController extends Controller
{
    public function index(Request $request)
    {
        $tags = Tag::whereHas('images', fn ($q) => $q->where('user_id', $request->user()->id))
            ->withCount(['images' => fn ($q) => $q->where('user_id', $request->user()->id)])
            ->orderBy('name')
            ->get(['id', 'name', 'slug', 'created_at']);

        return Inertia::render('tags/Index', [
            'tags' => $tags,
        ]);
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'name' => ['required', 'string', 'max:50'],
        ]);

        $name = trim($data['name']);
        $slug = Str::slug($name);

        Tag::firstOrCreate(
            ['slug' => $slug],
            ['name' => $name]
        );

        return back()->with('success', 'Tag created.');
    }

    public function destroy(Tag $tag)
    {
        $tag->delete();

        return back()->with('success', 'Tag deleted.');
    }

    public function batchTag(Request $request)
    {
        $data = $request->validate([
            'image_ids'   => ['required', 'array', 'min:1'],
            'image_ids.*' => ['integer', 'exists:images,id'],
            'tags'        => ['required', 'array'],
            'tags.*'      => ['string', 'max:50'],
            'action'      => ['required', 'in:attach,detach'],
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
                $slugs  = array_map(fn ($n) => Str::slug($n), $tagNames);
                $tagIds = Tag::whereIn('slug', $slugs)->pluck('id');

                foreach ($images as $image) {
                    $image->tags()->detach($tagIds);
                }
            }
        });

        $actionText = $data['action'] === 'attach' ? 'applied to' : 'removed from';

        return back()->with('success', count($tagNames) . ' tag(s) ' . $actionText . ' ' . $images->count() . ' image(s).');
    }
}