<script setup lang="ts">
import { Head, router } from '@inertiajs/vue3';
import { nextTick, onMounted, ref, computed } from 'vue';
import { Crown, Zap } from 'lucide-vue-next';
import PlanCard from '@/components/Plans/PlanCard.vue';
import PlanBadge from '@/components/Plans/PlanBadge.vue';
import AppLayout from '@/layouts/AppLayout.vue';
import type { BreadcrumbItem } from '@/types';
import type { Plan } from '@/types/plan';

const props = defineProps<{
    plans: { data: Plan[] } | Plan[];
    currentPlan: Plan | null;
}>();

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Dashboard', href: '/dashboard' },
    { title: 'Plans',     href: '/plans' },
];

// Normalise: Inertia ResourceCollection wraps in { data: [...] }, but guard
// against plain arrays too so the page never goes blank.
const planList = computed<Plan[]>(() => {
    if (!props.plans) return [];
    if (Array.isArray(props.plans)) return props.plans;
    if (Array.isArray((props.plans as { data: Plan[] }).data)) return (props.plans as { data: Plan[] }).data;
    return [];
});

const errorMessage = ref('');
const successMsg   = ref('');

function csrfToken(): string {
    return (document.querySelector('meta[name="csrf-token"]') as HTMLMetaElement)?.content ?? '';
}

function switchToFree(plan: Plan) {
    if (!confirm('Switch to the Free plan? Your current paid features will end immediately.')) return;
    router.post('/plans/select', { plan_id: plan.id });
}

function mountPayPalButton(plan: Plan) {
    // @ts-ignore
    window.paypal.Buttons({
        style: { layout: 'vertical', color: 'blue', shape: 'pill', label: 'pay', height: 44 },

        createOrder: async () => {
            errorMessage.value = '';
            const res = await fetch(`/plans/${plan.id}/checkout`, {
                method:  'POST',
                headers: { 'Content-Type': 'application/json', 'X-CSRF-TOKEN': csrfToken(), 'Accept': 'application/json' },
            });
            const data = await res.json();
            if (!res.ok) throw new Error(data.error ?? 'Could not create PayPal order.');
            return data.id;
        },

        onApprove: async (data: { orderID: string }) => {
            const res = await fetch(`/plans/${plan.id}/capture`, {
                method:  'POST',
                headers: { 'Content-Type': 'application/json', 'X-CSRF-TOKEN': csrfToken(), 'Accept': 'application/json' },
                body:    JSON.stringify({ orderID: data.orderID }),
            });
            const result = await res.json();
            if (result.status === 'success') {
                router.visit('/plans?changed=1');
            } else {
                errorMessage.value = 'Payment captured but plan assignment failed. Please contact support.';
            }
        },

        onCancel: () => { errorMessage.value = 'Payment cancelled.'; },

        onError: (err: unknown) => {
            console.error('PayPal error', err);
            errorMessage.value = 'Something went wrong with PayPal. Please try again.';
        },
    }).render(`#paypal-btn-${plan.id}`);
}

async function mountAllButtons() {
    // Wait for Vue to finish rendering the plan cards before injecting PayPal buttons
    await nextTick();
    planList.value
        .filter(p => !p.is_free && p.id !== props.currentPlan?.id)
        .forEach(p => mountPayPalButton(p));
}

onMounted(async () => {
    const params = new URLSearchParams(window.location.search);
    if (params.get('changed')) successMsg.value = '🎉 Your plan has been updated!';

    // @ts-ignore
    if (window.paypal) {
        mountAllButtons();
        return;
    }

    const clientId = import.meta.env.VITE_PAYPAL_CLIENT_ID as string;
    if (!clientId) return;

    const script   = document.createElement('script');
    script.src     = `https://www.paypal.com/sdk/js?client-id=${clientId}&currency=USD&disable-funding=venmo,paylater`;
    script.onload  = () => mountAllButtons();
    script.onerror = () => { errorMessage.value = 'Could not load PayPal. Please refresh.'; };
    document.head.appendChild(script);
});
</script>

<template>
    <AppLayout :breadcrumbs="breadcrumbs">
        <Head title="Plans" />

        <div class="max-w-5xl mx-auto px-4 py-10">

            <!-- Page heading -->
            <div class="text-center mb-10">
                <h1 class="text-3xl font-bold tracking-tight mb-2">Plans &amp; Billing</h1>
                <p class="text-muted-foreground text-sm">
                    Upgrade or downgrade at any time. Changes take effect immediately.
                </p>
            </div>

            <!-- ── Current plan hero ──────────────────────────────── -->
            <div
                v-if="currentPlan"
                class="mb-10 rounded-2xl border p-6 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4"
                :class="currentPlan.is_free
                    ? 'border-border bg-muted/40'
                    : 'border-[#7B2FFF]/40 bg-gradient-to-r from-[#7B2FFF]/10 to-[#00E5FF]/5'"
            >
                <div class="flex items-center gap-4">
                    <div
                        class="flex size-12 shrink-0 items-center justify-center rounded-xl"
                        :class="currentPlan.is_free ? 'bg-muted' : 'bg-gradient-to-br from-[#7B2FFF] to-[#00E5FF]'"
                    >
                        <Crown class="h-5 w-5" :class="currentPlan.is_free ? 'text-muted-foreground' : 'text-white'" />
                    </div>
                    <div>
                        <p class="text-xs font-semibold text-muted-foreground uppercase tracking-wider mb-0.5">Current plan</p>
                        <div class="flex items-center gap-2">
                            <span class="text-xl font-bold tracking-tight">{{ currentPlan.name }}</span>
                            <PlanBadge :plan="currentPlan" size="sm" />
                        </div>
                        <p class="text-sm text-muted-foreground mt-0.5">
                            {{ currentPlan.storage_limit_human }} storage &mdash; {{ currentPlan.price_formatted }}
                            <span v-if="!currentPlan.is_free">/mo</span>
                        </p>
                    </div>
                </div>
                <div v-if="!currentPlan.is_free" class="flex items-center gap-1.5 rounded-full bg-green-500/10 border border-green-500/20 px-3 py-1.5 text-xs font-medium text-green-700 shrink-0">
                    <Zap class="h-3 w-3" /> Active subscription
                </div>
            </div>

            <!-- Alerts -->
            <div v-if="successMsg" class="mb-8 rounded-xl bg-green-500/10 border border-green-500/20 px-5 py-4 text-sm text-green-700 text-center font-medium">
                {{ successMsg }}
            </div>
            <div v-if="errorMessage" class="mb-8 rounded-xl bg-red-500/10 border border-red-500/20 px-5 py-4 text-sm text-red-600 text-center">
                {{ errorMessage }}
            </div>

            <!-- ── Heading for upgrade section ────────────────────── -->
            <h2 class="text-sm font-semibold text-muted-foreground uppercase tracking-wider mb-5">
                {{ currentPlan ? 'Available plans' : 'Choose a plan' }}
            </h2>

            <!-- Plan cards -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <PlanCard
                    v-for="plan in planList"
                    :key="plan.id"
                    :plan="plan"
                    :current-plan="currentPlan"
                    :is-popular="plan.slug === 'pro'"
                    @switch-free="switchToFree"
                />
            </div>

            <p class="text-center text-xs text-muted-foreground mt-8">
                Payments are securely processed by PayPal. You can change plans at any time.
            </p>
        </div>
    </AppLayout>
</template>