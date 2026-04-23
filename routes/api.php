<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ImageApiController;
use App\Http\Controllers\Api\SharedLinkApiController;
use App\Http\Controllers\Api\UserApiController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| All routes here are prefixed with /api and use the Sanctum guard.
| Authenticate by sending:  Authorization: Bearer {token}
|
*/

// ── Public: auth ──────────────────────────────────────────────────────────
Route::prefix('auth')->group(function () {
    Route::post('register', [AuthController::class, 'register']);
    Route::post('login',    [AuthController::class, 'login']);
});

// ── Protected ─────────────────────────────────────────────────────────────
Route::middleware('auth:sanctum')->group(function () {

    // Auth
    Route::post('auth/logout',  [AuthController::class, 'logout']);
    Route::get('auth/me',       [AuthController::class, 'me']);

    // User
    Route::get('user',          [UserApiController::class, 'show']);
    Route::patch('user',        [UserApiController::class, 'update']);

    // Images
    Route::get('images',             [ImageApiController::class, 'index']);
    Route::post('images',            [ImageApiController::class, 'store']);
    Route::get('images/{image}',     [ImageApiController::class, 'show']);
    Route::patch('images/{image}',   [ImageApiController::class, 'update']);
    Route::delete('images/{image}',  [ImageApiController::class, 'destroy']);

    // Shared links
    Route::get('shared-links',                      [SharedLinkApiController::class, 'index']);
    Route::post('shared-links',                     [SharedLinkApiController::class, 'store']);
    Route::get('shared-links/{sharedLink}',         [SharedLinkApiController::class, 'show']);
    Route::delete('shared-links/{sharedLink}',      [SharedLinkApiController::class, 'destroy']);
});

// ── Public: resolve shared link by token ─────────────────────────────────
Route::get('share/{token}', [SharedLinkApiController::class, 'resolve']);