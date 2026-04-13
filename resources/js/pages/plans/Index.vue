<script setup lang="ts">
import { Head, router } from '@inertiajs/vue3';
import { onMounted, ref } from 'vue';
import PlanCard from '@/components/Plans/PlanCard.vue';
import AppLayout from '@/layouts/AppLayout.vue';
import type { BreadcrumbItem } from '@/types';
import type { Plan } from '@/types/plan';

const props = defineProps<{
    plans: { data: Plan[] };
    currentPlan: Plan | null;
}>();

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Dashboard', href: '/dashboard' },
    { title: 'Plans', href: '/plans' },
];

const paypalReady  = ref(false);
const errorMessage = ref('');

function mountPayPalButton(plan: Plan) {
    const containerId = `paypal-button-${plan.id}`;

    // @ts-ignore
    window.paypal.Buttons({
        style: {
            layout: 'vertical',
            color:  'blue',
            shape:  'pill',
            label:  'pay',
            height: 40,
        },

        createOrder: async () => {
            errorMessage.value = '';
            const res = await fetch(`/plans/${plan.id}/checkout`, {
                method:  'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-TOKEN': (document.querySelector('meta[name="csrf-token"]') as HTMLMetaElement)?.content ?? '',
                    'Accept':       'application/json',
                },
            });
            const data = await res.json();
            if (!res.ok) throw new Error(data.error ?? 'Could not create PayPal order.');
            return data.id;
        },

        onApprove: async (data: { orderID: string }) => {
            const res = await fetch(`/plans/${plan.id}/capture`, {
                method:  'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-TOKEN': (document.querySelector('meta[name="csrf-token"]') as HTMLMetaElement)?.content ?? '',
                    'Accept':       'application/json',
                },
                body: JSON.stringify({ orderID: data.orderID }),
            });
            const result = await res.json();
            if (result.status === 'success') {
                router.visit('/plans?upgraded=1');
            } else {
                errorMessage.value = 'Payment captured but plan assignment failed. Please contact support.';
            }
        },

        onError: (err: unknown) => {
            console.error('PayPal error', err);
            errorMessage.value = 'Something went wrong with PayPal. Please try again.';
        },
    }).render(`#${containerId}`);
}

onMounted(() => {
    const clientId = (document.querySelector('meta[name="paypal-client-id"]') as HTMLMetaElement)?.content;
    if (!clientId) return;

    const script  = document.createElement('script');
    script.src    = `https://www.paypal.com/sdk/js?client-id=${clientId}&currency=USD`;
    script.onload = () => {
        paypalReady.value = true;
        props.plans.data
            .filter(p => !p.is_free && props.currentPlan?.id !== p.id)
            .forEach(p => mountPayPalButton(p));
    };
    document.head.appendChild(script);
});
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

            <!-- Success banner -->
            <div
                v-if="($page.props as any).ziggy?.query?.upgraded"
                class="mb-8 rounded-xl bg-green-500/10 border border-green-500/20 px-5 py-4 text-sm text-green-600 text-center font-medium"
            >
                🎉 Plan upgraded successfully!
            </div>

            <!-- Error banner -->
            <div v-if="errorMessage" class="mb-8 rounded-xl bg-red-500/10 border border-red-500/20 px-5 py-4 text-sm text-red-600 text-center">
                {{ errorMessage }}
            </div>

            <!-- Plan Cards -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <PlanCard
                    v-for="plan in plans.data"
                    :key="plan.id"
                    :plan="plan"
                    :current-plan="currentPlan"
                    :is-popular="plan.slug === 'pro'"
                    :paypal-ready="paypalReady"
                />
            </div>

            <p class="text-center text-xs text-muted-foreground mt-8">
                Payments are securely processed by PayPal. Cancel anytime.
            </p>
        </div>
    </AppLayout>
</template>