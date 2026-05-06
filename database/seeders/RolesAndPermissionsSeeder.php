<?php

namespace Database\Seeders;

use App\Models\Permission;
use App\Models\Role;
use Illuminate\Database\Seeder;

class RolesAndPermissionsSeeder extends Seeder
{
    public function run(): void
    {
        // ── Permissions ───────────────────────────────────────────────────
        $permissions = [
            // Images
            ['name' => 'images.view',    'label' => 'View images',    'group' => 'images'],
            ['name' => 'images.upload',  'label' => 'Upload images',  'group' => 'images'],
            ['name' => 'images.edit',    'label' => 'Edit images',    'group' => 'images'],
            ['name' => 'images.delete',  'label' => 'Delete images',  'group' => 'images'],
            // Shared links
            ['name' => 'links.view',     'label' => 'View links',     'group' => 'links'],
            ['name' => 'links.create',   'label' => 'Create links',   'group' => 'links'],
            ['name' => 'links.delete',   'label' => 'Delete links',   'group' => 'links'],
            // Albums
            ['name' => 'albums.view',    'label' => 'View albums',    'group' => 'albums'],
            ['name' => 'albums.create',  'label' => 'Create albums',  'group' => 'albums'],
            ['name' => 'albums.edit',    'label' => 'Edit albums',    'group' => 'albums'],
            ['name' => 'albums.delete',  'label' => 'Delete albums',  'group' => 'albums'],
            // Admin
            ['name' => 'admin.access',   'label' => 'Access admin area',      'group' => 'admin'],
            ['name' => 'admin.users',    'label' => 'Manage users',            'group' => 'admin'],
            ['name' => 'admin.roles',    'label' => 'Manage roles',            'group' => 'admin'],
        ];

        $permissionMap = [];

        foreach ($permissions as $p) {
            $permissionMap[$p['name']] = Permission::firstOrCreate(
                ['name' => $p['name']],
                ['label' => $p['label'], 'group' => $p['group']]
            );
        }

        // ── Built-in roles ─────────────────────────────────────────────────
        $roles = [
            [
                'name'        => 'admin',
                'label'       => 'Administrator',
                'description' => 'Full access to all features and admin area.',
                'permissions' => array_keys($permissionMap),
            ],
            [
                'name'        => 'moderator',
                'label'       => 'Moderator',
                'description' => 'Can view and delete content across the platform.',
                'permissions' => [
                    'images.view', 'images.edit', 'images.delete',
                    'links.view', 'links.delete',
                    'albums.view',
                    'admin.access', 'admin.users',
                ],
            ],
            [
                'name'        => 'uploader',
                'label'       => 'Uploader',
                'description' => 'Can upload and manage their own images.',
                'permissions' => [
                    'images.view', 'images.upload', 'images.edit', 'images.delete',
                    'links.view', 'links.create',
                    'albums.view', 'albums.create', 'albums.edit',
                ],
            ],
            [
                'name'        => 'viewer',
                'label'       => 'Viewer',
                'description' => 'Read-only access.',
                'permissions' => ['images.view', 'links.view', 'albums.view'],
            ],
        ];

        foreach ($roles as $r) {
            $role = Role::firstOrCreate(
                ['name' => $r['name']],
                ['label' => $r['label'], 'description' => $r['description']]
            );

            $ids = collect($r['permissions'])
                ->map(fn ($name) => $permissionMap[$name]->id)
                ->toArray();

            $role->permissions()->sync($ids);
        }
    }
}