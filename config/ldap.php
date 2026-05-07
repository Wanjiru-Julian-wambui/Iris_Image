<?php

return [

    /*
    |--------------------------------------------------------------------------
    | LDAP / Active Directory Connection
    |--------------------------------------------------------------------------
    | Configure via .env — leave LDAP_HOSTS empty to disable LDAP entirely.
    | Uses the directorytree/ldaprecord-laravel package.
    |--------------------------------------------------------------------------
    */

    'default' => env('LDAP_CONNECTION', 'default'),

    'connections' => [

        'default' => [
            'hosts'            => [env('LDAP_HOST', '127.0.0.1')],
            'username'         => env('LDAP_USERNAME', ''),       // service account DN
            'password'         => env('LDAP_PASSWORD', ''),
            'port'             => (int) env('LDAP_PORT', 389),
            'base_dn'          => env('LDAP_BASE_DN', ''),
            'timeout'          => 5,
            'use_ssl'          => env('LDAP_SSL', false),         // port 636
            'use_tls'          => env('LDAP_TLS', false),
            'use_sasl'         => false,
            'options'          => [
                LDAP_OPT_X_TLS_REQUIRE_CERT => LDAP_OPT_X_TLS_NEVER,
            ],
        ],

    ],

    /*
    |--------------------------------------------------------------------------
    | .env additions (copy these to your .env file)
    |--------------------------------------------------------------------------
    |
    | LDAP_CONNECTION=default
    | LDAP_HOST=your-dc.example.com
    | LDAP_USERNAME="cn=svc-iris,ou=service-accounts,dc=example,dc=com"
    | LDAP_PASSWORD=your-service-account-password
    | LDAP_PORT=389
    | LDAP_BASE_DN="dc=example,dc=com"
    | LDAP_SSL=false
    | LDAP_TLS=false
    |
    */

];