<?php

namespace App\Http\Controllers;

use App\Http\Resources\PlanResource;
use App\Models\Plan;
use Illuminate\Support\Facades\Auth;
use Inertia\Inertia;
use Inertia\Response;

class PlanController extends Controller
{
    public function index(): Response
    {
        // Fetch all active plans for the grid
        $plans = Plan::active()
            ->orderBy('price')
            ->get();

        $user = Auth::user();
        
        // Ensure the plan relationship is loaded
        $user->load('plan');

        return Inertia::render('Plans', [
            'plans'       => PlanResource::collection($plans),
            // Fix: If user->plan is null, return null instead of a Resource crash
            'currentPlan' => $user->plan ? new PlanResource($user->plan) : null,
        ]);
    }
}