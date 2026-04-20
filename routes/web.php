<?php

use App\Http\Controllers\DashboardController;
use App\Http\Controllers\GalleryController;
use App\Http\Controllers\ImageController;
use App\Http\Controllers\InvitationController;
use App\Http\Controllers\PlanController;
use App\Http\Controllers\SharedLinkController;
use Illuminate\Support\Facades\Route;
use Laravel\Fortify\Features;

// ============================================================
// PUBLIC
// ============================================================

Route::inertia('/', 'Welcome', [
    'canRegister' => Features::enabled(Features::registration()),
])->name('home');

Route::get('/share/{token}',  [SharedLinkController::class, 'show'])->name('shared-links.show');
Route::post('/share/{token}', [SharedLinkController::class, 'verify'])->name('shared-links.verify');


// ============================================================
// AUTHENTICATED
// ============================================================
Route::middleware(['auth', 'verified'])->group(function () {

    // ----------------------------------------------------------
    // Plan chooser + PayPal endpoints
    // Outside plan.selected so brand-new users can reach them.
    // ----------------------------------------------------------
    Route::get('/plans/choose',           [PlanController::class, 'choose'])->name('plans.choose');
    Route::post('/plans/select',          [PlanController::class, 'select'])->name('plans.select');
    Route::post('/plans/{plan}/checkout', [PlanController::class, 'checkout'])->name('plans.checkout');
    Route::post('/plans/{plan}/capture',  [PlanController::class, 'capture'])->name('plans.capture');

    // ----------------------------------------------------------
    // Protected app routes — require a plan to be chosen first.
    // ----------------------------------------------------------
    Route::middleware('plan.selected')->group(function () {

        // Dashboard
        Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard');

        // Images — read/delete require plan
        Route::get('/images',            [ImageController::class, 'index'])->name('images.index');
        Route::get('/images/create',     [ImageController::class, 'create'])->name('images.create');
        Route::get('/images/{image}',    [ImageController::class, 'show'])->name('images.show');
        Route::delete('/images/{image}', [ImageController::class, 'destroy'])->name('images.destroy');

        // Gallery — needs a real controller to pass paginated images + filters
        Route::get('/gallery', [GalleryController::class, 'index'])->name('gallery');

        // Shared links
        Route::get('/shared-links',               [SharedLinkController::class, 'index'])->name('shared-links.index');
        Route::get('/shared-links/create',        [SharedLinkController::class, 'create'])->name('shared-links.create'); // ← add this
        Route::post('/shared-links',              [SharedLinkController::class, 'store'])->name('shared-links.store');
        Route::delete('/shared-links/{sharedLink}', [SharedLinkController::class, 'destroy'])->name('shared-links.destroy');

        // Invitations
        Route::get('/invitations',        [InvitationController::class, 'index'])->name('invitations.index');
        Route::get('/invitations/create', [InvitationController::class, 'create'])->name('invitations.create');
        Route::post('/invitations',       [InvitationController::class, 'store'])->name('invitations.store');
        Route::delete('/invitations/{invitation}', [InvitationController::class, 'destroy'])->name('invitations.destroy');

        // Plans — in-app view & change plan, plus admin CRUD
        Route::get('/plans',             [PlanController::class, 'index'])->name('plans.index');
        Route::get('/plans/create',      [PlanController::class, 'create'])->name('plans.create');
        Route::post('/plans',            [PlanController::class, 'store'])->name('plans.store');
        Route::get('/plans/{plan}/edit', [PlanController::class, 'edit'])->name('plans.edit');
        Route::put('/plans/{plan}',      [PlanController::class, 'update'])->name('plans.update');
        Route::delete('/plans/{plan}',   [PlanController::class, 'destroy'])->name('plans.destroy');
    });

    // Image UPLOAD — auth + storage limit only, never blocked by plan.selected
    Route::middleware('storage.limit')->group(function () {
        Route::post('/images', [ImageController::class, 'store'])->name('images.store');
    });

    Route::post('/images/bulk-download', [ImageController::class, 'bulkDownload'])->name('images.bulk-download');
});

// Settings & Admin
require __DIR__.'/settings.php';
require __DIR__.'/admin.php';

// ============================================================
// PUBLIC INVITATION ROUTES
// Defined LAST so {token} wildcard never matches /invitations/create
// ============================================================
Route::get('/invitations/{token}',         [InvitationController::class, 'show'])->name('invitations.show');
Route::post('/invitations/{token}/accept', [InvitationController::class, 'accept'])->name('invitations.accept');

Route::get('/setup-plans', function () {
    \Illuminate\Support\Facades\Artisan::call('db:seed', [
        '--class' => 'PlanSeeder',
        '--force' => true,
    ]);
    return response()->json([
        'message' => 'Done',
        'plans'   => \App\Models\Plan::all()->pluck('name', 'id'),
    ]);
});

Route::get('/debug-storage', function () {
    return [
        'default_disk'  => config('filesystems.default'),
        'app_url'       => config('app.url'),
        'first_image'   => \App\Models\Image::first()?->only(['path', 'disk']),
        'url_generated' => \App\Models\Image::first()?->url,
    ];
});