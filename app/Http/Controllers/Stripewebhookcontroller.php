<?php

namespace App\Http\Controllers;

use App\Models\Plan;
use App\Models\User;
use Laravel\Cashier\Http\Controllers\WebhookController as CashierWebhookController;

class StripeWebhookController extends CashierWebhookController
{
    /**
     * Handle subscription updated — sync plan_id on the user.
     */
    public function handleCustomerSubscriptionUpdated(array $payload): \Symfony\Component\HttpFoundation\Response
    {
        $stripeSubscription = $payload['data']['object'];
        $stripePriceId      = $stripeSubscription['items']['data'][0]['price']['id'] ?? null;

        if ($stripePriceId) {
            $plan = Plan::where('stripe_price_id', $stripePriceId)->first();

            if ($plan) {
                $stripeCustomerId = $stripeSubscription['customer'];

                $user = User::where('stripe_id', $stripeCustomerId)->first();
                $user?->update(['plan_id' => $plan->id]);
            }
        }

        return parent::handleCustomerSubscriptionUpdated($payload);
    }

    /**
     * Handle subscription deleted — revert user to free plan.
     */
    public function handleCustomerSubscriptionDeleted(array $payload): \Symfony\Component\HttpFoundation\Response
    {
        $stripeSubscription = $payload['data']['object'];
        $stripeCustomerId   = $stripeSubscription['customer'];

        $freePlan = Plan::where('slug', 'free')->first();
        $user     = User::where('stripe_id', $stripeCustomerId)->first();
        $user?->update(['plan_id' => $freePlan?->id]);

        return parent::handleCustomerSubscriptionDeleted($payload);
    }
}