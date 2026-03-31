<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Resources\UserResource;
use App\Models\User;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class UserController extends Controller
{
    public function index(Request $request): Response
    {
        $users = User::with('plan')
            ->withCount('images')
            ->when($request->search, function ($query, $search) {
                $query->where('name', 'like', "%{$search}%")
                      ->orWhere('email', 'like', "%{$search}%");
            })
            ->latest()
            ->paginate(20);

        return Inertia::render('admin/Users/Index', [
            'users'  => UserResource::collection($users),
            'search' => $request->search,
            'stats'  => [
                'total_users'   => User::count(),
                'admin_users'   => User::where('is_admin', true)->count(),
                'total_storage' => User::sum('storage_used'),
            ],
        ]);
    }

    public function show(User $user): Response
    {
        $user->load('plan')->loadCount('images');

        return Inertia::render('admin/Users/Show', [
            'user'   => new UserResource($user),
            'images' => $user->images()->latest()->paginate(12),
        ]);
    }

    public function destroy(User $user)
    {
        abort_if($user->is_admin, 403, 'Cannot delete an admin user.');
        abort_if($user->id === auth()->id(), 403, 'Cannot delete your own account.');

        $user->images()->each(fn ($image) => $image->delete());
        $user->delete();

        return redirect()->route('admin.users.index')->with('success',
            'User and all their images deleted.'
        );
    }

    public function toggleAdmin(User $user)
    {
        abort_if($user->id === auth()->id(), 403, 'Cannot change your own admin status.');

        $user->update(['is_admin' => !$user->is_admin]);

        return back()->with('success',
            $user->is_admin ? $user->name . ' is now an admin.' : $user->name . ' is no longer an admin.'
        );
    }
}