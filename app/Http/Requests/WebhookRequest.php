<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class WebhookRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'name'     => ['required', 'string', 'max:100'],
            'url'      => ['required', 'url', 'max:500'],
            'events'   => ['required', 'array', 'min:1'],
            'events.*' => ['required', 'string', 'in:image.uploaded,image.deleted,link.viewed,link.expired,*'],
            'active'   => ['sometimes', 'boolean'],
        ];
    }
}