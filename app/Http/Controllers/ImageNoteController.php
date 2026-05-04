<?php

namespace App\Http\Controllers;

use App\Models\Image;
use App\Models\ImageNote;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Session;

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

    /**
     * Store a public note from a guest user.
     */
    public function storePublic(Request $request, Image $image)
    {
        // Allow public notes on public images only
        abort_if($image->is_private, 403, 'Cannot add notes to private images.');

        $data = $request->validate([
            'body' => ['required', 'string', 'max:2000'],
        ]);

        $image->notes()->create([
            'body'                => $data['body'],
            'user_id'             => null, // Guest note
            'ip_address'          => $request->ip(),
            'session_fingerprint' => $this->getFingerprint($request),
        ]);

           return back()->with('success', 'Note added.');
    }

    private function getFingerprint(Request $request): string
    {
        $sessionId = Session::getId();
        $userAgent = substr($request->userAgent() ?? 'unknown', 0, 100);

        return hash('sha256', $sessionId . $userAgent);
    }

}