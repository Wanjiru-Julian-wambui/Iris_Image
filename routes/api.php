<?php

use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ImageApiController;
use App\Http\Controllers\Api\SharedLinkApiController;
use App\Http\Controllers\Api\UserApiController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Two authentication methods supported:
|
| 1. Bearer token (Sanctum):   Authorization: Bearer {token}
|    - Obtained via POST /api/auth/login
|
| 2. API Key + Secret:         X-API-Key: ik_xxx  +  X-API-Secret: is_xxx
|    - Generated in Settings > API Credentials
|--------------------------------------------------------------------------
*/

// ── Public: auth ─────────────────────────────────────────────────────────
Route::prefix('auth')->group(function () {
    Route::post('register', [AuthController::class, 'register']);
    Route::post('login',    [AuthController::class, 'login']);
});

// ── Sanctum-only routes ───────────────────────────────────────────────────
Route::middleware('auth:sanctum')->group(function () {
    Route::post('auth/logout', [AuthController::class, 'logout']);
    Route::get('auth/me',      [AuthController::class, 'me']);
    Route::get('user',         [UserApiController::class, 'show']);
    Route::patch('user',       [UserApiController::class, 'update']);
});

// ── Bearer token OR API Key+Secret ───────────────────────────────────────
Route::middleware('api.auth')->group(function () {

    // Images
    Route::get('images',             [ImageApiController::class, 'index']);
    Route::post('images',            [ImageApiController::class, 'store']);
    Route::get('images/{image}',     [ImageApiController::class, 'show']);
    Route::patch('images/{image}',   [ImageApiController::class, 'update']);
    Route::delete('images/{image}',  [ImageApiController::class, 'destroy']);

    // Shared links
    Route::get('shared-links',                 [SharedLinkApiController::class, 'index']);
    Route::post('shared-links',                [SharedLinkApiController::class, 'store']);
    Route::get('shared-links/{sharedLink}',    [SharedLinkApiController::class, 'show']);
    Route::delete('shared-links/{sharedLink}', [SharedLinkApiController::class, 'destroy']);
});

// ── Public ───────────────────────────────────────────────────────────────
Route::get('share/{token}', [SharedLinkApiController::class, 'resolve']);