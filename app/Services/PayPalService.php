<?php

namespace App\Services;

use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

class PayPalService
{
    protected string $baseUrl;
    protected string $clientId;
    protected string $secret;

    public function __construct()
    {
        $mode = config('services.paypal.mode', 'sandbox');

        $this->baseUrl = $mode === 'live'
            ? 'https://api-m.paypal.com'
            : 'https://api-m.sandbox.paypal.com';

        $clientId = config('services.paypal.client_id');
        $secret   = config('services.paypal.secret');

        if (empty($clientId) || empty($secret)) {
            Log::error('PayPal credentials are not configured. Set PAYPAL_CLIENT_ID and PAYPAL_SECRET in your .env file.');
            throw new \RuntimeException('PayPal is not configured. Please contact support.');
        }

        $this->clientId = $clientId;
        $this->secret   = $secret;
    }

    public function getAccessToken(): string
    {
        $response = Http::asForm()
            ->withBasicAuth($this->clientId, $this->secret)
            ->post("{$this->baseUrl}/v1/oauth2/token", [
                'grant_type' => 'client_credentials',
            ]);

        if ($response->failed()) {
            Log::error('PayPal Auth Failed: ' . $response->body());
            throw new \Exception('PayPal authentication failed.');
        }

        return $response->json()['access_token'];
    }

    public function createOrder(int $amount): array
    {
        $accessToken = $this->getAccessToken();

        return Http::withToken($accessToken)
            ->post("{$this->baseUrl}/v2/checkout/orders", [
                'intent'         => 'CAPTURE',
                'purchase_units' => [[
                    'amount' => [
                        'currency_code' => 'USD',
                        'value'         => number_format($amount, 2, '.', ''),
                    ],
                ]],
            ])->json();
    }

    public function captureOrder(string $orderId): array
    {
        $accessToken = $this->getAccessToken();

        return Http::withToken($accessToken)
            ->withHeaders(['Content-Type' => 'application/json'])
            ->post("{$this->baseUrl}/v2/checkout/orders/{$orderId}/capture")
            ->json();
    }
}