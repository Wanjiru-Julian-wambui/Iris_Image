<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class SamlIdentityProvider extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'name',
        'idp_name',       // URL-safe slug used by laravel-saml2
        'entity_id',
        'sso_url',
        'slo_url',
        'x509_cert',
        'sp_entity_id',
        'sp_acs_url',
        'email_attribute',
        'name_attribute',
        'active',
    ];

    protected $casts = [
        'active' => 'boolean',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}