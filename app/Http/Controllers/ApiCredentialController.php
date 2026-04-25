<?php

namespace App\Http\Controllers;

use App\Models\ApiCredential;
use Illuminate\Http\Request;
use Inertia\Inertia;
use Inertia\Response;

class ApiCredentialController extends Controller
{
    public function index(Request $request): Response
    {
        $credentials = $request->user()
            ->apiCredentials()
            ->latest()
            ->get()
            ->map(fn($c) => [
                'id'           => $c->id,
                'label'        => $c->label,
                'api_key'      => $c->api_key,
                'last_used_at' => $c->last_used_at?->diffForHumans(),
                'created_at'   => $c->created_at->toDateString(),
            ]);

        return Inertia::render('settings/ApiCredentials', [
            'credentials' => $credentials,
            'appUrl'      => config('app.url'),
        ]);
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'label' => ['required', 'string', 'max:60'],
        ]);

        abort_if(
            $request->user()->apiCredentials()->count() >= 5,
            422,
            'Maximum of 5 API credentials allowed.'
        );

        $pair = ApiCredential::generate($request->user()->id, $data['label']);

        return back()->with([
            'new_key'    => $pair['key'],
            'new_secret' => $pair['secret'],
        ]);
    }

    public function destroy(Request $request, int $id)
    {
        $request->user()->apiCredentials()->where('id', $id)->delete();

        return back()->with('success', 'Credential deleted.');
    }
}