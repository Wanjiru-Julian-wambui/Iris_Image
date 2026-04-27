<?php

namespace App\Http\Controllers;

use App\Http\Resources\AlbumResource;
use App\Http\Resources\ImageResource;
use App\Models\Album;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class PublicAlbumController extends Controller
{
    public function show(Request $request, string $token): Response
    {
        $album = Album::public()
            ->where('public_token', $token)
            ->with(['images', 'user'])
            ->firstOrFail();

        if ($album->password) {
            $sessionKey = 'album_access_' . $album->id;
            
            if (!$request->session()->has($sessionKey)) {
                return Inertia::render('albums/PasswordPrompt', [
                    'album' => new AlbumResource($album),
                ]);
            }
        }

        $album->load('images');

        return Inertia::render('albums/PublicShow', [
            'album'  => new AlbumResource($album),
            'images' => ImageResource::collection($album->images),
        ]);
    }

    public function verify(Request $request, string $token)
    {
        $album = Album::public()
            ->where('public_token', $token)
            ->firstOrFail();

        $request->validate([
            'password' => ['required', 'string'],
        ]);

        if (!$album->checkPassword($request->input('password'))) {
            return back()->withErrors(['password' => 'Incorrect password.']);
        }

        $request->session()->put('album_access_' . $album->id, true);

        return redirect()->route('albums.public.show', $token);
    }
}