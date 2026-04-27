<?php

namespace App\Http\Controllers;

use App\Models\Image;
use Illuminate\Http\RedirectResponse;

class PublicImageController extends Controller
{
    public function show(string $token): RedirectResponse
    {
        $image = Image::where('public_token', $token)
            ->where('is_private', false)
            ->firstOrFail();

        return redirect($image->url);
    }
}