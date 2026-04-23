<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\Rules\Password;

class UserApiController extends Controller
{
    public function show(Request $request): JsonResponse
    {
        $user = $request->user()->load('plan');

        return response()->json([
            'id'                 => $user->id,
            'name'               => $user->name,
            'email'              => $user->email,
            'avatar_url'         => $user->avatar_url,
            'storage_used'       => $user->storage_used,
            'storage_used_human' => $user->storage_used_human,
            'storage_percent'    => $user->storage_percent,
            'plan'               => $user->plan?->only(['id', 'name', 'slug', 'storage_limit', 'price']),
            'created_at'         => $user->created_at,
        ]);
    }

    public function update(Request $request): JsonResponse
    {
        $user = $request->user();

        $data = $request->validate([
            'name'         => ['sometimes', 'string', 'max:255'],
            'email'        => ['sometimes', 'email', 'unique:users,email,' . $user->id],
            'password'     => ['sometimes', 'confirmed', Password::defaults()],
        ]);

        if (isset($data['password'])) {
            $data['password'] = Hash::make($data['password']);
        }

        $user->update($data);

        return response()->json([
            'message' => 'Profile updated.',
            'user'    => $user->fresh()->only(['id', 'name', 'email', 'updated_at']),
        ]);
    }
}