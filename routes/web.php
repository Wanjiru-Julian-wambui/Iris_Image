<?php

use App\Http\Controllers\ApiCredentialController;
use App\Http\Controllers\ApiKeyController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\GalleryController;
use App\Http\Controllers\ImageController;
use App\Http\Controllers\InvitationController;
use App\Http\Controllers\PlanController;
use App\Http\Controllers\SharedLinkController;
use Illuminate\Support\Facades\Route;
use Laravel\Fortify\Features;

Route::inertia('/', 'Welcome', [
    'canRegister' => Features::enabled(Features::registration()),
])->name('home');

Route::get('/share/{token}',  [SharedLinkController::class, 'show'])->name('shared-links.show');
Route::post('/share/{token}', [SharedLinkController::class, 'verify'])->name('shared-links.verify');

Route::middleware(['auth', 'verified'])->group(function () {

    Route::get('/plans/choose',           [PlanController::class, 'choose'])->name('plans.choose');
    Route::post('/plans/select',          [PlanController::class, 'select'])->name('plans.select');
    Route::post('/plans/{plan}/checkout', [PlanController::class, 'checkout'])->name('plans.checkout');
    Route::post('/plans/{plan}/capture',  [PlanController::class, 'capture'])->name('plans.capture');

    Route::middleware('plan.selected')->group(function () {

        Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard');

        Route::get('/images',                  [ImageController::class, 'index'])->name('images.index');
        Route::get('/images/create',           [ImageController::class, 'create'])->name('images.create');
        Route::get('/images/{image}',          [ImageController::class, 'show'])->name('images.show');
        Route::delete('/images/{image}',       [ImageController::class, 'destroy'])->name('images.destroy');
        Route::get('/images/{image}/download', [ImageController::class, 'download'])->name('images.download');

        Route::get('/gallery', [GalleryController::class, 'index'])->name('gallery');

        Route::get('/shared-links',                  [SharedLinkController::class, 'index'])->name('shared-links.index');
        Route::get('/shared-links/create',           [SharedLinkController::class, 'create'])->name('shared-links.create');
        Route::post('/shared-links',                 [SharedLinkController::class, 'store'])->name('shared-links.store');
        Route::delete('/shared-links/{sharedLink}',  [SharedLinkController::class, 'destroy'])->name('shared-links.destroy');

        Route::get('/invitations',                   [InvitationController::class, 'index'])->name('invitations.index');
        Route::get('/invitations/create',            [InvitationController::class, 'create'])->name('invitations.create');
        Route::post('/invitations',                  [InvitationController::class, 'store'])->name('invitations.store');
        Route::delete('/invitations/{invitation}',   [InvitationController::class, 'destroy'])->name('invitations.destroy');

        Route::get('/plans',             [PlanController::class, 'index'])->name('plans.index');
        Route::get('/plans/create',      [PlanController::class, 'create'])->name('plans.create');
        Route::post('/plans',            [PlanController::class, 'store'])->name('plans.store');
        Route::get('/plans/{plan}/edit', [PlanController::class, 'edit'])->name('plans.edit');
        Route::put('/plans/{plan}',      [PlanController::class, 'update'])->name('plans.update');
        Route::delete('/plans/{plan}',   [PlanController::class, 'destroy'])->name('plans.destroy');

        // Sanctum Bearer token keys
        Route::get('/settings/api-keys',          [ApiKeyController::class, 'index'])->name('api-keys.index');
        Route::post('/settings/api-keys',         [ApiKeyController::class, 'store'])->name('api-keys.store');
        Route::delete('/settings/api-keys/all',   [ApiKeyController::class, 'destroyAll'])->name('api-keys.destroyAll');
        Route::delete('/settings/api-keys/{id}',  [ApiKeyController::class, 'destroy'])->name('api-keys.destroy');

        // API Key + Secret credentials
        Route::get('/settings/api-credentials',          [ApiCredentialController::class, 'index'])->name('api-credentials.index');
        Route::post('/settings/api-credentials',         [ApiCredentialController::class, 'store'])->name('api-credentials.store');
        Route::delete('/settings/api-credentials/{id}',  [ApiCredentialController::class, 'destroy'])->name('api-credentials.destroy');
    });

    Route::middleware('storage.limit')->group(function () {
        Route::post('/images', [ImageController::class, 'store'])->name('images.store');
    });

    Route::post('/images/bulk-download', [ImageController::class, 'bulkDownload'])->name('images.bulk-download');
});

require __DIR__.'/settings.php';
require __DIR__.'/admin.php';

Route::get('/invitations/{token}',         [InvitationController::class, 'show'])->name('invitations.show');
Route::post('/invitations/{token}/accept', [InvitationController::class, 'accept'])->name('invitations.accept');

Route::get('/debug-api-creds', function () {
    try {
        $user = \App\Models\User::find(6);
        return [
            'has_relation'   => method_exists($user, 'apiCredentials'),
            'table_exists'   => \Illuminate\Support\Facades\Schema::hasTable('api_credentials'),
            'controller_exists' => class_exists(\App\Http\Controllers\ApiCredentialController::class),
            'model_exists'   => class_exists(\App\Models\ApiCredential::class),
        ];
    } catch (\Exception $e) {
        return ['error' => $e->getMessage()];
    }
})->middleware('auth');