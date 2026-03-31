<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class PlanSeeder extends Seeder
{
    public function run(): void
    {
        $plans = [
            [
                'name'          => 'Free',
                'slug'          => 'free',
                'price'         => 0,
                'storage_limit' => 1 * 1024 * 1024 * 1024, // 1 GB
                'features'      => json_encode([
                    'expiring_links',
                    'exif_stripping',
                    'basic_sharing',
                ]),
                'is_active'     => true,
                'created_at'    => now(),
                'updated_at'    => now(),
            ],
            [
                'name'          => 'Pro',
                'slug'          => 'pro',
                'price'         => 9,
                'storage_limit' => 50 * 1024 * 1024 * 1024, // 50 GB
                'features'      => json_encode([
                    'expiring_links',
                    'exif_stripping',
                    'password_protected_links',
                    'team_folders',
                    'view_history',
                    'priority_support',
                ]),
                'is_active'     => true,
                'created_at'    => now(),
                'updated_at'    => now(),
            ],
            [
                'name'          => 'Team',
                'slug'          => 'team',
                'price'         => 29,
                'storage_limit' => 200 * 1024 * 1024 * 1024, // 200 GB
                'features'      => json_encode([
                    'expiring_links',
                    'exif_stripping',
                    'password_protected_links',
                    'team_folders',
                    'view_history',
                    'admin_dashboard',
                    'invite_only_registration',
                    'priority_support',
                ]),
                'is_active'     => true,
                'created_at'    => now(),
                'updated_at'    => now(),
            ],
        ];

        DB::table('plans')->insertOrIgnore($plans);
    }
}