<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class SharedLinkRequest extends FormRequest
{
    public function authorize(): bool
    {
        return auth()->check();
    }

    public function rules(): array
    {
        $maxExpiry = config('iris.expiring_links.max_expiry_hours');

        return [
            'image_id'    => ['required', 'integer', 'exists:images,id'],
            'expires_in'  => ['required', 'integer', 'min:1', "max:{$maxExpiry}"],
            'password'    => ['sometimes', 'nullable', 'string', 'min:4', 'max:64'],
        ];
    }

    public function messages(): array
    {
        $maxExpiry = config('iris.expiring_links.max_expiry_hours');

        return [
            'image_id.required'   => 'Please select an image to share.',
            'image_id.exists'     => 'The selected image does not exist.',
            'expires_in.required' => 'Please set an expiry time for the link.',
            'expires_in.min'      => 'Expiry time must be at least 1 hour.',
            'expires_in.max'      => "Expiry time cannot exceed {$maxExpiry} hours.",
            'password.min'        => 'Password must be at least 4 characters.',
        ];
    }
}