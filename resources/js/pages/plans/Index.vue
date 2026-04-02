<script setup lang="ts">
import { Head, router } from '@inertiajs/vue3';
import { ref } from 'vue';
import PlanCard from '@/components/Plans/PlanCard.vue';
import { Button } from '@/components/ui/button';
import AppLayout from '@/layouts/AppLayout.vue';
import type { BreadcrumbItem } from '@/types';
import type { Plan } from '@/types/plan';

defineProps<{
    plans: { data: Plan[] };
    currentPlan: Plan | null;
}>();

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Dashboard', href: '/dashboard' },
    { title: 'Plans', href: '/plans' },
];

const subscribing = ref(false);

function subscribeToPlan(plan: Plan) {
    subscribing.value = true;
    router.post(`/plans/${plan.id}/checkout`, {}, {
        onFinish: () => { subscribing.value = false; },
    });
}

function openPortal() {
    router.post('/plans/portal');
}
</script>

<template>
    <AppLayout :breadcrumbs="breadcrumbs">
        <Head title="Plans" />

        <div class="max-w-5xl mx-auto px-4 py-10">

            <!-- Header -->
            <div class="text-center mb-10">
                <h1 class="text-3xl font-bold tracking-tight mb-2">Simple pricing</h1>
                <p class="text-muted-foreground">
                    You are currently on the
                    <span class="font-semibold text-foreground">
                        {{ currentPlan ? currentPlan.name : 'Free' }}
                    </span> plan.
                </p>
            </div>

            <!-- Manage Subscription -->
            <div v-if="currentPlan && !currentPlan.is_free" class="flex justify-center mb-8">
                <Button variant="outline" @click="openPortal">
                    Manage subscription & billing
                </Button>
            </div>

            <!-- Success Banner -->
            <div
                v-if="$page.props.ziggy?.query?.subscribed"
                class="mb-8 rounded-xl bg-green-500/10 border border-green-500/20 px-5 py-4 text-sm text-green-600 text-center font-medium"
            >
                🎉 You're now subscribed! Your plan has been updated.
            </div>

            <!-- Plan Cards -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <PlanCard
                    v-for="plan in plans.data"
                    :key="plan.id"
                    :plan="plan"
                    :current-plan="currentPlan"
                    :is-popular="plan.slug === 'pro'"
                    @subscribe="subscribeToPlan"
                />
            </div>

            <!-- Fine print -->
            <p class="text-center text-xs text-muted-foreground mt-8">
                Payments are securely processed by Stripe. Cancel anytime.
            </p>
        </div>
    </AppLayout>
</template>