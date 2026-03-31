<?php

namespace App\Http\Requests\Auth;

use Illuminate\Foundation\Http\FormRequest;

class InvitationRequest extends FormRequest
{
    public function authorize(): bool
    {
        return auth()->check() && auth()->user()->is_admin;
    }

    public function rules(): array
    {
        return [
            'email'      => [
                'required',
                'email',
                'max:255',
                'unique:users,email',
                'unique:invitations,email',
            ],
            'expires_in' => [
                'sometimes',
                'integer',
                'min:1',
                'max:' . config('iris.invitations.expiry_hours'),
            ],
        ];
    }

    public function messages(): array
    {
        return [
            'email.required'          => 'An email address is required to send an invitation.',
            'email.email'             => 'Please enter a valid email address.',
            'email.unique'            => 'This email address already has an account or a pending invitation.',
            'expires_in.min'          => 'Expiry must be at least 1 hour.',
            'expires_in.max'          => 'Expiry cannot exceed ' . config('iris.invitations.expiry_hours') . ' hours.',
        ];
    }
}