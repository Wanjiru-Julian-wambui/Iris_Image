<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class SendInvitationRequest extends FormRequest
{
    public function authorize(): bool
    {
        // You can wire this into a policy if you prefer.
        return $this->user() !== null;
    }

    public function rules(): array
    {
        return [
            'email' => [
                'required',
                'email:rfc,dns',
                'max:255',
                // Optional: do not send if there is already a pending invite
                Rule::unique('invitations', 'email')
                    ->where(fn ($q) => $q->where('is_accepted', false)
                                          ->where('expires_at', '>', now())),
            ],
        ];
    }

    public function messages(): array
    {
        return [
            'email.unique' => 'There is already a pending invitation for this email.',
        ];
    }
}