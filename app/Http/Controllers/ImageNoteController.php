<?php

namespace App\Http\Controllers;

use App\Models\Image;
use App\Models\ImageNote;
use Illuminate\Http\Request;

class ImageNoteController extends Controller
{
    public function store(Request $request, Image $image)
    {
        abort_unless($image->user_id === auth()->id(), 403);

        $data = $request->validate([
            'body' => ['required', 'string', 'max:5000'],
        ]);

        $note = $image->notes()->create([
            'user_id' => $request->user()->id,
            'body'    => $data['body'],
        ]);

        return back()->with('success', 'Note added.');
    }

    public function update(Request $request, Image $image, ImageNote $note)
    {
        abort_unless($image->user_id === auth()->id(), 403);
        abort_unless($note->user_id === auth()->id(), 403);

        $data = $request->validate([
            'body' => ['required', 'string', 'max:5000'],
        ]);

        $note->update($data);

        return back()->with('success', 'Note updated.');
    }

    public function destroy(Image $image, ImageNote $note)
    {
        abort_unless($image->user_id === auth()->id(), 403);
        abort_unless($note->user_id === auth()->id(), 403);

        $note->delete();

        return back()->with('success', 'Note deleted.');
    }
}