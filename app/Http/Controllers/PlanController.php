<?php

namespace App\Http\Controllers;

use App\Http\Resources\PlanResource;
use App\Models\Plan;
use Illuminate\Http\RedirectResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Inertia\Inertia;
use Inertia\Response;

class PlanController extends Controller
{
    public function index(): Response
    {
        $plans = Plan::active()
            ->orderBy('price')
            ->get();

        $user = Auth::user();
        $user->load('plan');

        return Inertia::render('plans/Index', [
            'plans'       => PlanResource::collection($plans),
            'currentPlan' => $user->plan ? new PlanResource($user->plan) : null,
        ]);
    }

    public function create(): Response
    {
        return Inertia::render('plans/Create');
    }

    public function store(Request $request): RedirectResponse
    {
        $validated = $request->validate([
            'name'          => 'required|string|max:255',
            'slug'          => 'required|string|unique:plans,slug|max:255',
            'price'         => 'required|integer|min:0',
            'storage_limit' => 'required|integer|min:1',
            'features'      => 'nullable|array',
            'is_active'     => 'boolean',
            'stripe_price_id' => 'nullable|string',
        ]);

        Plan::create($validated);

        return redirect('/plans')->with('success', 'Plan created successfully.');
    }

    public function edit(Plan $plan): Response
    {
        return Inertia::render('plans/Edit', [
            'plan' => new PlanResource($plan),
        ]);
    }

    public function update(Request $request, Plan $plan): RedirectResponse
    {
        $validated = $request->validate([
            'name'          => 'required|string|max:255',
            'slug'          => 'required|string|unique:plans,slug,' . $plan->id . '|max:255',
            'price'         => 'required|integer|min:0',
            'storage_limit' => 'required|integer|min:1',
            'features'      => 'nullable|array',
            'is_active'     => 'boolean',
            'stripe_price_id' => 'nullable|string',
        ]);

        $plan->update($validated);

        return redirect('/plans')->with('success', 'Plan updated successfully.');
    }

    public function destroy(Plan $plan): RedirectResponse
    {
        if ($plan->is_free) {
            return back()->withErrors(['error' => 'Cannot delete the free plan.']);
        }

        // Move users on this plan to the free plan
        $freePlan = Plan::where('slug', 'free')->first();
        $plan->users()->update(['plan_id' => $freePlan?->id]);

        $plan->delete();

        return redirect('/plans')->with('success', 'Plan deleted.');
    }

    /*
    |--------------------------------------------------------------------------
    | Stripe Checkout
    |--------------------------------------------------------------------------
    */

    public function checkout(Plan $plan): RedirectResponse
    {
        if ($plan->is_free || ! $plan->stripe_price_id) {
            return back()->withErrors(['error' => 'This plan cannot be purchased.']);
        }

        $user = Auth::user();

        // If user already has an active subscription, swap to the new plan
        if ($user->subscribed('default')) {
            $user->subscription('default')->swap($plan->stripe_price_id);

            // Update plan_id on the user
            $user->update(['plan_id' => $plan->id]);

            return redirect('/plans?subscribed=1');
        }

        // New subscription — redirect to Stripe Checkout
        $checkout = $user->newSubscription('default', $plan->stripe_price_id)
            ->checkout([
                'success_url' => url('/plans?subscribed=1'),
                'cancel_url'  => url('/plans'),
            ]);

        return redirect($checkout->url);
    }

    public function portal(): RedirectResponse
    {
        $user = Auth::user();

        return redirect(
            $user->billingPortalUrl(url('/plans'))
        );
    }
}