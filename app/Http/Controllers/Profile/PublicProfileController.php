<?php


namespace App\Http\Controllers\Profile;

use App\Http\Controllers\Controller;
use App\Models\User;
use Inertia\Inertia;
use Inertia\Response;
use Symfony\Component\HttpKernel\Exception\NotFoundHttpException;

class PublicProfileController extends Controller
{
    public function show(string $username): Response
    {
        $user = User::where('username', $username)
            ->wherePublicProfile()
            ->firstOrFail();

        $images = $user->publicImages()
            ->select(['id', 'uuid', 'filename', 'title', 'created_at', 'file_size', 'width', 'height'])
            ->paginate(24);

        return Inertia::render('Profile/Public', [
            'user' => [
                'name'        => $user->name,
                'username'    => $user->username,
                'bio'         => $user->bio,
                'website'     => $user->website,
                'avatar_url'  => $user->avatar_url,
                'joined_at'   => $user->created_at->format('F Y'),
            ],
            'images' => $images,
        ]);
    }
}