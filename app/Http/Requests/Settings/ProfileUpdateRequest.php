<?php


namespace App\Http\Requests\Settings;

use App\Models\User;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class ProfileUpdateRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'name'             => ['required', 'string', 'max:255'],
            'email'            => ['required', 'email', 'max:255', Rule::unique(User::class)->ignore($this->user()->id)],
            'avatar'           => ['nullable', 'image', 'mimes:jpeg,png,gif,webp', 'max:2048'],
            'username'         => ['nullable', 'string', 'alpha_dash', 'min:3', 'max:30', Rule::unique(User::class)->ignore($this->user()->id)],
            'bio'              => ['nullable', 'string', 'max:500'],
            'website'          => ['nullable', 'url', 'max:255'],
            'profile_public'   => ['nullable', 'boolean'],
        ];
    }

    public function validated($key = null, $default = null)
    {
        $validated = parent::validated($key, $default);

        if (isset($validated['profile_public'])) {
            $validated['profile_public'] = (bool) $validated['profile_public'];
        }

        return $validated;
    }
}