<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Permission;
use App\Models\Role;
use App\Models\User;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class RoleController extends Controller
{
    // ── Roles ─────────────────────────────────────────────────────────────────

    public function index(): Response
    {
        return Inertia::render('admin/Roles/Index', [
            'roles'       => Role::with('permissions')->withCount('users')->get(),
            'permissions' => Permission::orderBy('group')->orderBy('label')->get(),
        ]);
    }

    public function store(Request $request): RedirectResponse
    {
        $data = $request->validate([
            'name'        => ['required', 'string', 'max:64', 'unique:roles,name', 'alpha_dash'],
            'label'       => ['required', 'string', 'max:128'],
            'description' => ['nullable', 'string', 'max:255'],
            'permissions' => ['nullable', 'array'],
            'permissions.*' => ['integer', 'exists:permissions,id'],
        ]);

        $role = Role::create([
            'name'        => $data['name'],
            'label'       => $data['label'],
            'description' => $data['description'] ?? null,
        ]);

        if (! empty($data['permissions'])) {
            $role->permissions()->sync($data['permissions']);
        }

        return back()->with('success', "Role \"{$role->label}\" created.");
    }

    public function update(Request $request, Role $role): RedirectResponse
    {
        $data = $request->validate([
            'label'       => ['required', 'string', 'max:128'],
            'description' => ['nullable', 'string', 'max:255'],
            'permissions' => ['nullable', 'array'],
            'permissions.*' => ['integer', 'exists:permissions,id'],
        ]);

        $role->update([
            'label'       => $data['label'],
            'description' => $data['description'] ?? null,
        ]);

        $role->permissions()->sync($data['permissions'] ?? []);

        return back()->with('success', "Role \"{$role->label}\" updated.");
    }

    public function destroy(Role $role): RedirectResponse
    {
        // Prevent deletion of built-in roles
        if (in_array($role->name, ['admin', 'moderator', 'uploader', 'viewer'])) {
            return back()->with('error', 'Built-in roles cannot be deleted.');
        }

        $role->delete();

        return back()->with('success', "Role deleted.");
    }

    // ── Assign / revoke roles on users ────────────────────────────────────────

    public function assignToUser(Request $request, User $user): RedirectResponse
    {
        $data = $request->validate([
            'role' => ['required', 'string', 'exists:roles,name'],
        ]);

        $user->assignRole($data['role']);

        return back()->with('success', "Role assigned.");
    }

    public function revokeFromUser(Request $request, User $user): RedirectResponse
    {
        $data = $request->validate([
            'role' => ['required', 'string', 'exists:roles,name'],
        ]);

        $user->removeRole($data['role']);

        return back()->with('success', "Role revoked.");
    }
}