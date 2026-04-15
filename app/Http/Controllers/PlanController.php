<?php

namespace App\Http\Controllers;

use App\Http\Resources\PlanResource;
use App\Models\Plan;
use App\Services\PayPalService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Inertia\Inertia;

class PlanController extends Controller
{
    /*
    |--------------------------------------------------------------------------
    | Post-signup plan chooser
    | Route: GET /plans/choose  — excluded from plan.selected middleware
    |--------------------------------------------------------------------------
    */

    public function choose()
    {
        // Already has a plan → go straight to dashboard
        if (Auth::user()->plan_id) {
            return redirect()->route('dashboard');
        }

        return Inertia::render('plans/Choose', [
            'plans' => PlanResource::collection(Plan::active()->orderBy('price')->get()),
        ]);
    }

    /*
    |--------------------------------------------------------------------------
    | Select free plan immediately (no payment)
    |--------------------------------------------------------------------------
    */

    public function select(Request $request)
    {
        $request->validate(['plan_id' => 'required|exists:plans,id']);

        $plan = Plan::findOrFail($request->plan_id);

        if (! $plan->is_free) {
            return back()->withErrors(['error' => 'Paid plans require PayPal payment.']);
        }

        $request->user()->update(['plan_id' => $plan->id]);

        return redirect()->route('dashboard');
    }

    /*
    |--------------------------------------------------------------------------
    | PayPal: create order
    |--------------------------------------------------------------------------
    */

    public function checkout(Plan $plan, PayPalService $paypal)
    {
        if ($plan->is_free) {
            return response()->json(['error' => 'Free plans do not require payment.'], 422);
        }

        $order = $paypal->createOrder($plan->price);

        return response()->json($order);
    }

    /*
    |--------------------------------------------------------------------------
    | PayPal: capture order → assign plan
    |--------------------------------------------------------------------------
    */

    public function capture(Request $request, Plan $plan, PayPalService $paypal)
    {
        $request->validate(['orderID' => 'required|string']);

        $result = $paypal->captureOrder($request->orderID);

        if (isset($result['status']) && $result['status'] === 'COMPLETED') {
            Auth::user()->update(['plan_id' => $plan->id]);

            return response()->json(['status' => 'success']);
        }

        return response()->json(['status' => 'error', 'details' => $result], 422);
    }

    /*
    |--------------------------------------------------------------------------
    | In-app plan management (change plan)
    |--------------------------------------------------------------------------
    */

    public function index()
    {
        $plans = Plan::active()->orderBy('price')->get();

        return Inertia::render('plans/Index', [
            'plans'       => PlanResource::collection($plans),
            'currentPlan' => Auth::user()->plan
                ? new PlanResource(Auth::user()->plan)
                : null,
        ]);
    }

    /*
    |--------------------------------------------------------------------------
    | Admin CRUD
    |--------------------------------------------------------------------------
    */

    public function create()
    {
        return Inertia::render('plans/Create');
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'name'          => 'required|string|max:100',
            'slug'          => 'required|string|max:100|unique:plans,slug',
            'price'         => 'required|integer|min:0',
            'storage_limit' => 'required|integer|min:1',
            'features'      => 'nullable|array',
            'features.*'    => 'string',
            'is_active'     => 'boolean',
        ]);

        Plan::create($data);

        return redirect()->route('plans.index')->with('success', 'Plan created.');
    }

    public function edit(Plan $plan)
    {
        return Inertia::render('plans/Edit', [
            'plan' => new PlanResource($plan),
        ]);
    }

    public function update(Request $request, Plan $plan)
    {
        $data = $request->validate([
            'name'          => 'required|string|max:100',
            'slug'          => 'required|string|max:100|unique:plans,slug,' . $plan->id,
            'price'         => 'required|integer|min:0',
            'storage_limit' => 'required|integer|min:1',
            'features'      => 'nullable|array',
            'features.*'    => 'string',
            'is_active'     => 'boolean',
        ]);

        $plan->update($data);

        return redirect()->route('plans.index')->with('success', 'Plan updated.');
    }

    public function destroy(Plan $plan)
    {
        if ($plan->users()->exists()) {
            return back()->withErrors(['error' => 'Cannot delete a plan that has active subscribers.']);
        }

        $plan->delete();

        return redirect()->route('plans.index')->with('success', 'Plan deleted.');
    }
}