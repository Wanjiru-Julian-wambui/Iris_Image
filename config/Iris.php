<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Application Name
    |--------------------------------------------------------------------------
    */
    'name' => env('APP_NAME', 'Iris'),

    /*
    |--------------------------------------------------------------------------
    | Storage Limits (in bytes)
    |--------------------------------------------------------------------------
    */
    'storage' => [
        'free'  => env('IRIS_STORAGE_FREE',  1 * 1024 * 1024 * 1024),   // 1 GB
        'pro'   => env('IRIS_STORAGE_PRO',   50 * 1024 * 1024 * 1024),  // 50 GB
        'team'  => env('IRIS_STORAGE_TEAM',  200 * 1024 * 1024 * 1024), // 200 GB
    ],

    /*
    |--------------------------------------------------------------------------
    | Allowed File Types
    |--------------------------------------------------------------------------
    */
    'allowed_mimes' => [
        'image/jpeg',
        'image/png',
        'image/gif',
        'image/webp',
        'image/svg+xml',
        'image/x-canon-cr2',
        'image/x-nikon-nef',
        'image/x-sony-arw',
        'image/x-adobe-dng',
        'image/tiff',
    ],

    'allowed_extensions' => [
        'jpg', 'jpeg', 'png', 'gif', 'webp', 'svg',
        'cr2', 'nef', 'arw', 'dng', 'tiff', 'tif',
    ],

    /*
    |--------------------------------------------------------------------------
    | Max File Size (in bytes)
    |--------------------------------------------------------------------------
    */
    'max_file_size' => env('IRIS_MAX_FILE_SIZE', 100 * 1024 * 1024), // 100 MB

    /*
    |--------------------------------------------------------------------------
    | Expiring Links
    |--------------------------------------------------------------------------
    */
    'expiring_links' => [
        'default_expiry_hours' => env('IRIS_LINK_EXPIRY_HOURS', 24),
        'max_expiry_hours'     => env('IRIS_LINK_MAX_EXPIRY_HOURS', 720), // 30 days
    ],

    /*
    |--------------------------------------------------------------------------
    | EXIF Stripping
    |--------------------------------------------------------------------------
    | Strip EXIF metadata (GPS, camera info) from images on upload
    */
    'strip_exif' => env('IRIS_STRIP_EXIF', true),

    /*
    |--------------------------------------------------------------------------
    | Plans
    |--------------------------------------------------------------------------
    */
    'plans' => [
        'free' => [
            'name'          => 'Free',
            'price'         => 0,
            'storage_limit' => 1 * 1024 * 1024 * 1024, // 1 GB
            'features'      => [
                'expiring_links',
                'exif_stripping',
                'basic_sharing',
            ],
        ],
        'pro' => [
            'name'          => 'Pro',
            'price'         => 9,
            'storage_limit' => 50 * 1024 * 1024 * 1024, // 50 GB
            'features'      => [
                'expiring_links',
                'exif_stripping',
                'password_protected_links',
                'team_folders',
                'view_history',
                'priority_support',
            ],
        ],
        'team' => [
            'name'          => 'Team',
            'price'         => 29,
            'storage_limit' => 200 * 1024 * 1024 * 1024, // 200 GB
            'features'      => [
                'expiring_links',
                'exif_stripping',
                'password_protected_links',
                'team_folders',
                'view_history',
                'admin_dashboard',
                'invite_only_registration',
                'priority_support',
            ],
        ],
    ],

    /*
    |--------------------------------------------------------------------------
    | Invitation
    |--------------------------------------------------------------------------
    */
    'invitations' => [
        'expiry_hours' => env('IRIS_INVITATION_EXPIRY_HOURS', 72), // 3 days
    ],

    /*
    |--------------------------------------------------------------------------
    | Admin
    |--------------------------------------------------------------------------
    */
    'admin' => [
        'email' => env('IRIS_ADMIN_EMAIL', 'admin@iris.app'),
    ],

];