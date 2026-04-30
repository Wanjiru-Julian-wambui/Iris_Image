<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class AlbumStoreRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'name'           => ['required', 'string', 'max:120'],
            'description'    => ['nullable', 'string', 'max:2000'],
            'is_public'      => ['boolean'],
            'password'       => ['nullable', 'string', 'min:4', 'max:100'],
            'image_ids'      => ['nullable', 'array'],
            'image_ids.*'    => ['integer', 'exists:images,id'],
            'cover_image_id' => ['nullable', 'integer', 'exists:images,id'],
        ];
    }

    protected function prepareForValidation(): void
    {
        $this->merge([
            'is_public' => $this->boolean('is_public', false),
        ]);
    }
}