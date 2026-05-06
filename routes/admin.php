<?php

use App\Http\Controllers\Admin\RoleController;
use App\Http\Controllers\Admin\UserController;
use Illuminate\Support\Facades\Route;

Route::middleware(['auth', 'verified', 'admin'])
    ->prefix('admin')
    ->name('admin.')
    ->group(function () {

        // Admin dashboard
        Route::inertia('/', 'admin/Index')->name('index');

        // ── User management ───────────────────────────────────────────────────
        Route::get('/users',                         [UserController::class, 'index'])->name('users.index');
        Route::get('/users/{user}',                  [UserController::class, 'show'])->name('users.show');
        Route::delete('/users/{user}',               [UserController::class, 'destroy'])->name('users.destroy');
        Route::patch('/users/{user}/toggle-admin',   [UserController::class, 'toggleAdmin'])->name('users.toggle-admin');

        // ── Role assignment on users (Group H) ───────────────────────────────
        Route::post('/users/{user}/roles',   [RoleController::class, 'assignToUser'])->name('users.roles.assign');
        Route::delete('/users/{user}/roles', [RoleController::class, 'revokeFromUser'])->name('users.roles.revoke');

        // ── Roles & Permissions CRUD (Group H) ───────────────────────────────
        Route::get('/roles',           [RoleController::class, 'index'])->name('roles.index');
        Route::post('/roles',          [RoleController::class, 'store'])->name('roles.store');
        Route::put('/roles/{role}',    [RoleController::class, 'update'])->name('roles.update');
        Route::delete('/roles/{role}', [RoleController::class, 'destroy'])->name('roles.destroy');

    });