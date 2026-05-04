<script setup lang="ts">
import { Head, router } from '@inertiajs/vue3';
import { nextTick, onMounted, ref, computed } from 'vue';
import { Crown, Zap, Sparkles } from 'lucide-vue-next';
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

const planList = computed<Plan[]>(() => {
    if (!props.plans) return [];
    if (Array.isArray(props.plans)) return props.plans;
    if (Array.isArray((props.plans as { data: Plan[] }).data)) return (props.plans as { data: Plan[] }).data;
    return [];
});

const errorMessage = ref('');
const successMsg   = ref('');
const visible      = ref(false);

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
    await nextTick();
    planList.value
        .filter(p => !p.is_free && p.id !== props.currentPlan?.id)
        .forEach(p => mountPayPalButton(p));
}

onMounted(async () => {
    const params = new URLSearchParams(window.location.search);
    if (params.get('changed')) successMsg.value = '🎉 Your plan has been updated!';

    requestAnimationFrame(() => { visible.value = true; });

    // @ts-ignore
    if (window.paypal) { mountAllButtons(); return; }

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

        <div class="plans-page min-h-screen px-4 py-12 relative overflow-hidden">

            <!-- Ambient background orbs -->
            <div class="orb orb-1" />
            <div class="orb orb-2" />
            <div class="orb orb-3" />

            <div class="relative z-10 max-w-5xl mx-auto">

                <!-- Header -->
                <div class="text-center mb-12" :class="visible ? 'anim-fade-up' : 'opacity-0'">
                    <div class="inline-flex items-center gap-2 rounded-full border border-violet-200 bg-violet-50 dark:bg-violet-950/40 dark:border-violet-800 px-4 py-1.5 mb-5">
                        <Sparkles class="h-3.5 w-3.5 text-violet-500" />
                        <span class="text-xs font-semibold text-violet-600 dark:text-violet-400 tracking-wide uppercase">Plans & Billing</span>
                    </div>
                    <h1 class="text-4xl font-black tracking-tight mb-3">
                        Choose your power level
                    </h1>
                    <p class="text-muted-foreground text-sm max-w-md mx-auto leading-relaxed">
                        Upgrade or downgrade at any time. Changes take effect immediately.
                    </p>
                </div>

                <!-- Current plan hero -->
                <div
                    v-if="currentPlan"
                    class="current-plan-card mb-12"
                    :class="visible ? 'anim-fade-up anim-delay-1' : 'opacity-0'"
                >
                    <div class="current-plan-inner" :class="currentPlan.is_free ? 'is-free' : 'is-paid'">
                        <div v-if="!currentPlan.is_free" class="shimmer-line" />
                        <div class="flex flex-col sm:flex-row items-start sm:items-center justify-between gap-5">
                            <div class="flex items-center gap-5">
                                <div class="plan-icon-wrap" :class="currentPlan.is_free ? 'free-icon' : 'paid-icon'">
                                    <Crown class="h-6 w-6" :class="currentPlan.is_free ? 'text-muted-foreground' : 'text-white'" />
                                </div>
                                <div>
                                    <p class="text-[10px] font-bold text-muted-foreground uppercase tracking-widest mb-1">Current plan</p>
                                    <div class="flex items-center gap-2.5 mb-1">
                                        <span class="text-2xl font-black tracking-tight">{{ currentPlan.name }}</span>
                                        <PlanBadge :plan="currentPlan" size="sm" />
                                    </div>
                                    <p class="text-sm text-muted-foreground">
                                        {{ currentPlan.storage_limit_human }} storage &mdash;
                                        <span class="font-semibold text-foreground">{{ currentPlan.price_formatted }}</span>
                                        <span v-if="!currentPlan.is_free" class="text-muted-foreground">/mo</span>
                                    </p>
                                </div>
                            </div>
                            <div v-if="!currentPlan.is_free" class="active-pill">
                                <Zap class="h-3.5 w-3.5" />
                                <span>Active subscription</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Alerts -->
                <div v-if="successMsg" class="alert-success mb-8" :class="visible ? 'anim-fade-up anim-delay-1' : 'opacity-0'">
                    {{ successMsg }}
                </div>
                <div v-if="errorMessage" class="alert-error mb-8">
                    {{ errorMessage }}
                </div>

                <!-- Section label -->
                <p
                    class="text-[11px] font-bold text-muted-foreground uppercase tracking-widest mb-6"
                    :class="visible ? 'anim-fade-up anim-delay-2' : 'opacity-0'"
                >
                    {{ currentPlan ? 'Available plans' : 'Choose a plan' }}
                </p>

                <!-- Plan cards grid -->
                <div class="grid grid-cols-1 md:grid-cols-3 gap-5">
                    <div
                        v-for="(plan, i) in planList"
                        :key="plan.id"
                        :style="{ animationDelay: `${0.15 + i * 0.1}s` }"
                        :class="visible ? 'anim-fade-up' : 'opacity-0'"
                    >
                        <PlanCard
                            :plan="plan"
                            :current-plan="currentPlan"
                            :is-popular="plan.slug === 'pro'"
                            @switch-free="switchToFree"
                        />
                    </div>
                </div>

                <p class="text-center text-xs text-muted-foreground mt-10 opacity-60">
                    Payments are securely processed by PayPal. Cancel or change plans at any time.
                </p>
            </div>
        </div>
    </AppLayout>
</template>

<style scoped>
.plans-page {
    background: radial-gradient(ellipse 80% 40% at 50% -5%, hsl(263 70% 50% / 0.07), transparent 60%);
}

/* Ambient orbs */
.orb {
    position: absolute;
    border-radius: 9999px;
    filter: blur(90px);
    pointer-events: none;
}
.orb-1 {
    width: 520px; height: 520px;
    background: radial-gradient(circle, #7B2FFF28, transparent 70%);
    top: -140px; left: -120px;
    animation: drift 14s ease-in-out infinite alternate;
}
.orb-2 {
    width: 420px; height: 420px;
    background: radial-gradient(circle, #00E5FF1a, transparent 70%);
    top: 160px; right: -100px;
    animation: drift 18s ease-in-out infinite alternate-reverse;
}
.orb-3 {
    width: 320px; height: 320px;
    background: radial-gradient(circle, #7B2FFF14, transparent 70%);
    bottom: 40px; left: 38%;
    animation: drift 11s ease-in-out infinite alternate;
}
@keyframes drift {
    from { transform: translate(0, 0) scale(1); }
    to   { transform: translate(28px, 18px) scale(1.06); }
}

/* Entrance animations */
@keyframes fadeUp {
    from { opacity: 0; transform: translateY(22px); }
    to   { opacity: 1; transform: translateY(0); }
}
.anim-fade-up { animation: fadeUp 0.55s cubic-bezier(0.22, 1, 0.36, 1) both; }
.anim-delay-1 { animation-delay: 0.1s; }
.anim-delay-2 { animation-delay: 0.22s; }

/* Current plan card */
.current-plan-inner {
    position: relative;
    border-radius: 1.25rem;
    padding: 1.5rem 1.75rem;
    overflow: hidden;
    transition: box-shadow 0.35s ease, transform 0.35s ease;
}
.current-plan-inner:hover { transform: translateY(-2px); }
.current-plan-inner.is-free {
    border: 1px solid hsl(var(--border));
    background: hsl(var(--muted) / 0.45);
}
.current-plan-inner.is-paid {
    border: 1px solid #7B2FFF35;
    background: linear-gradient(135deg, #7B2FFF0d 0%, #00E5FF08 100%);
    box-shadow: 0 0 0 1px #7B2FFF14 inset, 0 8px 32px #7B2FFF0e;
}
.current-plan-inner.is-paid:hover {
    box-shadow: 0 0 0 1px #7B2FFF2a inset, 0 14px 44px #7B2FFF18;
}

/* Shimmer */
.shimmer-line {
    position: absolute;
    top: 0; left: -100%;
    width: 55%; height: 1.5px;
    background: linear-gradient(90deg, transparent, #7B2FFF70, #00E5FFaa, transparent);
    animation: shimmer 3.5s ease-in-out infinite;
}
@keyframes shimmer {
    0%   { left: -55%; }
    100% { left: 160%; }
}

/* Plan icon */
.plan-icon-wrap {
    display: flex; align-items: center; justify-content: center;
    width: 3.25rem; height: 3.25rem;
    border-radius: 0.875rem; flex-shrink: 0;
    transition: transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
}
.current-plan-inner:hover .plan-icon-wrap { transform: scale(1.1) rotate(-5deg); }
.free-icon { background: hsl(var(--muted)); }
.paid-icon {
    background: linear-gradient(135deg, #7B2FFF, #00E5FF);
    box-shadow: 0 4px 18px #7B2FFF35;
}

/* Active pill */
.active-pill {
    display: inline-flex; align-items: center; gap: 0.375rem;
    border-radius: 9999px; padding: 0.375rem 0.875rem;
    font-size: 0.75rem; font-weight: 600; color: #16a34a;
    background: #16a34a10; border: 1px solid #16a34a22;
    white-space: nowrap;
    animation: pulse-pill 3s ease-in-out infinite;
}
@keyframes pulse-pill {
    0%, 100% { box-shadow: 0 0 0 0 #16a34a20; }
    50%       { box-shadow: 0 0 0 5px transparent; }
}

/* Alerts */
.alert-success {
    border-radius: 0.875rem; background: #16a34a0e;
    border: 1px solid #16a34a1e; padding: 1rem 1.25rem;
    font-size: 0.875rem; color: #16a34a;
    text-align: center; font-weight: 500;
    animation: fadeUp 0.4s ease both;
}
.alert-error {
    border-radius: 0.875rem; background: #ef44440e;
    border: 1px solid #ef44441e; padding: 1rem 1.25rem;
    font-size: 0.875rem; color: #dc2626;
    text-align: center;
    animation: fadeUp 0.4s ease both;
}
</style>