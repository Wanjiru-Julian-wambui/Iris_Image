<?php

use App\Http\Controllers\DashboardController;
use App\Http\Controllers\ImageController;
use App\Http\Controllers\InvitationController;
use App\Http\Controllers\PlanController;
use App\Http\Controllers\SharedLinkController;
use App\Http\Controllers\StripeWebhookController;
use Illuminate\Support\Facades\Route;
use Laravel\Fortify\Features;

// ======== PUBLIC ROUTES ========

// Landing page
Route::inertia('/', 'Welcome', [
    'canRegister' => Features::enabled(Features::registration()),
])->name('home');

// Shared link (public - no auth needed)
Route::get('/share/{token}', [SharedLinkController::class, 'show'])
    ->name('shared-links.show');
Route::post('/share/{token}', [SharedLinkController::class, 'verify'])
    ->name('shared-links.verify');

// Stripe webhook (must be outside auth + CSRF middleware)
Route::post('/stripe/webhook', [StripeWebhookController::class, 'handleWebhook'])
    ->name('cashier.webhook');


// ======== AUTHENTICATED ROUTES ========
Route::middleware(['auth', 'verified'])->group(function () {

    // Dashboard
    Route::get('/dashboard', [DashboardController::class, 'index'])
        ->name('dashboard');

    // Images
    Route::middleware('storage.limit')->group(function () {
        Route::post('/images', [ImageController::class, 'store'])
            ->name('images.store');
    });

    Route::get('/images', [ImageController::class, 'index'])
        ->name('images.index');
    Route::get('/images/create', [ImageController::class, 'create'])
        ->name('images.create');
    Route::get('/images/{image}', [ImageController::class, 'show'])
        ->name('images.show');
    Route::delete('/images/{image}', [ImageController::class, 'destroy'])
        ->name('images.destroy');

    // Gallery
    Route::inertia('/gallery', 'Gallery')->name('gallery');

    // Shared links
    Route::get('/shared-links', [SharedLinkController::class, 'index'])
        ->name('shared-links.index');
    Route::post('/shared-links', [SharedLinkController::class, 'store'])
        ->name('shared-links.store');
    Route::delete('/shared-links/{sharedLink}', [SharedLinkController::class, 'destroy'])
        ->name('shared-links.destroy');

    // Invitations
    Route::get('/invitations', [InvitationController::class, 'index'])
        ->name('invitations.index');
    Route::get('/invitations/create', [InvitationController::class, 'create'])
        ->name('invitations.create');
    Route::post('/invitations', [InvitationController::class, 'store'])
        ->name('invitations.store');
    Route::delete('/invitations/{invitation}', [InvitationController::class, 'destroy'])
        ->name('invitations.destroy');

    // Plans
    Route::get('/plans', [PlanController::class, 'index'])
        ->name('plans.index');
    Route::get('/plans/create', [PlanController::class, 'create'])
        ->name('plans.create');
    Route::post('/plans', [PlanController::class, 'store'])
        ->name('plans.store');
    Route::get('/plans/{plan}/edit', [PlanController::class, 'edit'])
        ->name('plans.edit');
    Route::put('/plans/{plan}', [PlanController::class, 'update'])
        ->name('plans.update');
    Route::delete('/plans/{plan}', [PlanController::class, 'destroy'])
        ->name('plans.destroy');

    // Stripe checkout & billing portal
    Route::post('/plans/{plan}/checkout', [PlanController::class, 'checkout'])
        ->name('plans.checkout');
    Route::post('/plans/portal', [PlanController::class, 'portal'])
        ->name('plans.portal');

});

// Settings & Admin
require __DIR__.'/settings.php';
require __DIR__.'/admin.php';

// ======== PUBLIC INVITATION ROUTES ========
// Defined LAST so wildcard {token} never conflicts with /invitations/create above
Route::get('/invitations/{token}', [InvitationController::class, 'show'])
    ->name('invitations.show');
Route::post('/invitations/{token}/accept', [InvitationController::class, 'accept'])
    ->name('invitations.accept');