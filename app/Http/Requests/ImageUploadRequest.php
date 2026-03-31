<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class ImageUploadRequest extends FormRequest
{
    public function authorize(): bool
    {
        return auth()->check();
    }

    public function rules(): array
    {
        $maxSize = config('iris.max_file_size') / 1024; // convert bytes to KB for Laravel validation

        return [
            'images'                => ['required', 'array', 'min:1', 'max:20'],
            'images.*'              => [
                'required',
                'file',
                'image',
                'mimes:jpg,jpeg,png,gif,webp,svg,tiff',
                'max:102400',
            ],
            'is_private'            => ['sometimes', 'boolean'],
            'strip_exif'            => ['sometimes', 'boolean'],
        ];
    }

    public function messages(): array
    {
        return [
            'images.required'       => 'Please select at least one image to upload.',
            'images.max'            => 'You can upload a maximum of 20 images at a time.',
            'images.*.image'        => 'Only image files are allowed.',
            'images.*.mimes'        => 'Allowed formats: JPG, PNG, GIF, WEBP, SVG, TIFF.',
            'images.*.max'          => 'Each image must be smaller than 100MB.',
        ];
    }
}