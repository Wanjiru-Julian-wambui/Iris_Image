<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class AlbumUpdateRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'name'        => ['sometimes', 'required', 'string', 'max:120'],
            'description' => ['nullable', 'string', 'max:2000'],
            'is_public'   => ['boolean'],
            'password'    => ['nullable', 'string', 'min:4', 'max:100'],
            'cover_image_id' => ['nullable', 'integer', 'exists:images,id'],
        ];
    }

    protected function prepareForValidation(): void
    {
        if ($this->has('is_public')) {
            $this->merge(['is_public' => $this->boolean('is_public')]);
        }
    }
}