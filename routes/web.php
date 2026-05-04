<?php

use App\Http\Controllers\ApiCredentialController;
use App\Http\Controllers\ApiKeyController;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\GalleryController;
use App\Http\Controllers\ImageController;
use App\Http\Controllers\InvitationController;
use App\Http\Controllers\PlanController;
use App\Http\Controllers\SharedLinkController;
use App\Http\Controllers\AlbumController;
use App\Http\Controllers\PublicAlbumController;
use App\Http\Controllers\PublicImageController;
use App\Http\Controllers\ImageNoteController;
use App\Http\Controllers\TagController;
use App\Http\Controllers\ImagePollController;
use App\Http\Controllers\ImageReactionController;
use App\Http\Controllers\ImageVersionController;
use App\Http\Controllers\Profile\PublicProfileController;
use App\Http\Controllers\EmojiController;
use Illuminate\Support\Facades\Route;
use Laravel\Fortify\Features;

Route::inertia('/', 'Welcome', [
    'canRegister' => Features::enabled(Features::registration()),
])->name('home');

Route::get('/share/{token}',  [SharedLinkController::class, 'show'])->name('shared-links.show');
Route::post('/share/{token}', [SharedLinkController::class, 'verify'])->name('shared-links.verify');

// ─── Public routes (no auth required) ────────────────────────────────────────

Route::get('/i/{token}', [PublicImageController::class, 'show'])->name('public.image');

// Public reactions — guests can react to images via short URL
Route::post('/i/{image:public_token}/react', [ImageReactionController::class, 'store'])
    ->name('public.image.react');

// Public reactions — guests can react via short URL
Route::post('/i/{image:public_token}/react', [ImageReactionController::class, 'store'])
    ->name('public.image.react');

// Public tags — guests can add/remove tags
Route::post('/i/{image:public_token}/tags', [ImageController::class, 'publicBatchTag'])
    ->name('public.image.tags');

// Public notes — guests can add notes
Route::post('/i/{image:public_token}/notes', [ImageNoteController::class, 'storePublic'])
    ->name('public.image.notes');

// Public polls
Route::get('/poll/{token}',       [ImagePollController::class, 'show'])->name('polls.show');
Route::post('/poll/{token}/vote', [ImagePollController::class, 'vote'])->name('polls.vote');

// Public profile
Route::get('/@{username}', [PublicProfileController::class, 'show'])->name('profile.public');

// ── Emoji & Reactions (Public — guests can react) ─────────────────────────
Route::get('/emojis', [EmojiController::class, 'index']);


// Public profile
Route::get('/@{username}', [PublicProfileController::class, 'show'])->name('profile.public');

// ── Emoji & Reactions (Public — guests can react) ─────────────────────────
Route::get('/emojis', [EmojiController::class, 'index']);

// Authenticated reaction route (for dashboard/show page)
Route::post('/images/{image}/reactions', [ImageReactionController::class, 'store'])
    ->name('images.reactions.store');
Route::get('/reactions/giphy', [ImageReactionController::class, 'searchGiphy'])
    ->name('reactions.giphy');

// ─── Authenticated routes ─────────────────────────────────────────────────────

Route::middleware(['auth', 'verified'])->group(function () {

    Route::get('/plans/choose',           [PlanController::class, 'choose'])->name('plans.choose');
    Route::post('/plans/select',          [PlanController::class, 'select'])->name('plans.select');
    Route::post('/plans/{plan}/checkout', [PlanController::class, 'checkout'])->name('plans.checkout');
    Route::post('/plans/{plan}/capture',  [PlanController::class, 'capture'])->name('plans.capture');

    Route::middleware('plan.selected')->group(function () {

        Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard');

        // ── Images ── static routes BEFORE wildcard ───────────────────────────
        Route::get('/images',            [ImageController::class, 'index'])->name('images.index');
        Route::get('/images/create',     [ImageController::class, 'create'])->name('images.create');
        Route::delete('/images/bulk',    [ImageController::class, 'bulkDestroy'])->name('images.bulk-destroy');
        Route::post('/images/reorder',   [ImageController::class, 'reorder'])->name('images.reorder');
        Route::post('/images/batch-tag', [ImageController::class, 'batchTag'])->name('images.batch-tag');

        // ── Images ── wildcard routes AFTER ──────────────────────────────────
        Route::get('/images/{image}',          [ImageController::class, 'show'])->name('images.show');
        Route::put('/images/{image}',          [ImageController::class, 'update'])->name('images.update');
        Route::delete('/images/{image}',       [ImageController::class, 'destroy'])->name('images.destroy');
        Route::get('/images/{image}/download', [ImageController::class, 'download'])->name('images.download');

        // Replace image / upload new version
        Route::post('/images/{image}/replace', [ImageVersionController::class, 'replace'])
            ->name('images.replace');

        // ── Versions ─────────────────────────────────────────────────────────
        Route::get('/images/{image}/versions',                    [ImageVersionController::class, 'index'])->name('images.versions.index');
        Route::post('/images/{image}/versions',                   [ImageVersionController::class, 'store'])->name('images.versions.store');
        Route::get('/images/{image}/versions/{version}/download', [ImageVersionController::class, 'download'])->name('images.versions.download');
        Route::post('/images/{image}/versions/{version}/restore', [ImageVersionController::class, 'restore'])->name('images.versions.restore');
        Route::put('/images/{image}/versions/{version}',          [ImageVersionController::class, 'updateLabel'])->name('images.versions.update');
        Route::delete('/images/{image}/versions/{version}',       [ImageVersionController::class, 'destroy'])->name('images.versions.destroy');

        // ── Image notes ───────────────────────────────────────────────────────
        Route::post('/images/{image}/notes',          [ImageNoteController::class, 'store'])->name('images.notes.store');
        Route::put('/images/{image}/notes/{note}',    [ImageNoteController::class, 'update'])->name('images.notes.update');
        Route::delete('/images/{image}/notes/{note}', [ImageNoteController::class, 'destroy'])->name('images.notes.destroy');

        // ── Tags ──────────────────────────────────────────────────────────────
        Route::get('/tags',          [TagController::class, 'index'])->name('tags.index');
        Route::post('/tags',         [TagController::class, 'store'])->name('tags.store');
        Route::delete('/tags/{tag}', [TagController::class, 'destroy'])->name('tags.destroy');

        // ── Polls ─────────────────────────────────────────────────────────────
        Route::get('/polls',           [ImagePollController::class, 'index'])->name('polls.index');
        Route::get('/polls/create',    [ImagePollController::class, 'create'])->name('polls.create');
        Route::post('/polls',          [ImagePollController::class, 'store'])->name('polls.store');
        Route::delete('/polls/{poll}', [ImagePollController::class, 'destroy'])->name('polls.destroy');

        // ── Gallery ───────────────────────────────────────────────────────────
        Route::get('/gallery', [GalleryController::class, 'index'])->name('gallery');

        // ── Shared links ──────────────────────────────────────────────────────
        Route::get('/shared-links',                 [SharedLinkController::class, 'index'])->name('shared-links.index');
        Route::get('/shared-links/create',          [SharedLinkController::class, 'create'])->name('shared-links.create');
        Route::post('/shared-links',                [SharedLinkController::class, 'store'])->name('shared-links.store');
        Route::delete('/shared-links/{sharedLink}', [SharedLinkController::class, 'destroy'])->name('shared-links.destroy');

        // ── Invitations ───────────────────────────────────────────────────────
        Route::get('/invitations',                 [InvitationController::class, 'index'])->name('invitations.index');
        Route::get('/invitations/create',          [InvitationController::class, 'create'])->name('invitations.create');
        Route::post('/invitations',                [InvitationController::class, 'store'])->name('invitations.store');
        Route::delete('/invitations/{invitation}', [InvitationController::class, 'destroy'])->name('invitations.destroy');

        // ── Plans ─────────────────────────────────────────────────────────────
        Route::get('/plans',             [PlanController::class, 'index'])->name('plans.index');
        Route::get('/plans/create',      [PlanController::class, 'create'])->name('plans.create');
        Route::post('/plans',            [PlanController::class, 'store'])->name('plans.store');
        Route::get('/plans/{plan}/edit', [PlanController::class, 'edit'])->name('plans.edit');
        Route::put('/plans/{plan}',      [PlanController::class, 'update'])->name('plans.update');
        Route::delete('/plans/{plan}',   [PlanController::class, 'destroy'])->name('plans.destroy');

        // ── API keys (Sanctum Bearer tokens) ─────────────────────────────────
        Route::get('/settings/api-keys',         [ApiKeyController::class, 'index'])->name('api-keys.index');
        Route::post('/settings/api-keys',        [ApiKeyController::class, 'store'])->name('api-keys.store');
        Route::delete('/settings/api-keys/{id}', [ApiKeyController::class, 'destroy'])->name('api-keys.destroy');
        Route::delete('/settings/api-keys',      [ApiKeyController::class, 'destroyAll'])->name('api-keys.destroy-all');

        // ── API credentials (key + secret) ────────────────────────────────────
        Route::get('/settings/api-credentials',         [ApiCredentialController::class, 'index'])->name('api-credentials.index');
        Route::post('/settings/api-credentials',        [ApiCredentialController::class, 'store'])->name('api-credentials.store');
        Route::delete('/settings/api-credentials/{id}', [ApiCredentialController::class, 'destroy'])->name('api-credentials.destroy');

        // ── Albums ────────────────────────────────────────────────────────────
        Route::get('/albums',                           [AlbumController::class, 'index'])->name('albums.index');
        Route::get('/albums/create',                    [AlbumController::class, 'create'])->name('albums.create');
        Route::post('/albums',                          [AlbumController::class, 'store'])->name('albums.store');
        Route::get('/albums/{album}',                   [AlbumController::class, 'show'])->name('albums.show');
        Route::get('/albums/{album}/edit',              [AlbumController::class, 'edit'])->name('albums.edit');
        Route::put('/albums/{album}',                   [AlbumController::class, 'update'])->name('albums.update');
        Route::delete('/albums/{album}',                [AlbumController::class, 'destroy'])->name('albums.destroy');
        Route::post('/albums/{album}/images',           [AlbumController::class, 'addImages'])->name('albums.images.add');
        Route::delete('/albums/{album}/images/{image}', [AlbumController::class, 'removeImage'])->name('albums.images.remove');
        Route::post('/albums/{album}/reorder',          [AlbumController::class, 'reorder'])->name('albums.reorder');

        // Public albums
        Route::get('/a/{token}',         [PublicAlbumController::class, 'show'])->name('albums.public.show');
        Route::post('/a/{token}/verify', [PublicAlbumController::class, 'verify'])->name('albums.public.verify');

    }); // end plan.selected

    Route::middleware('storage.limit')->group(function () {
        Route::post('/images', [ImageController::class, 'store'])->name('images.store');
    });

    Route::post('/images/bulk-download', [ImageController::class, 'bulkDownload'])->name('images.bulk-download');

}); // end auth + verified

require __DIR__ . '/settings.php';
require __DIR__ . '/admin.php';

Route::get('/invitations/{token}',         [InvitationController::class, 'show'])->name('invitations.show');
Route::post('/invitations/{token}/accept', [InvitationController::class, 'accept'])->name('invitations.accept');