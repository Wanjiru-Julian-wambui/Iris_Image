<script setup lang="ts">
import { Head, router } from '@inertiajs/vue3';
import { nextTick, onMounted, ref, computed } from 'vue';
import { Crown, Zap, Check, ShieldCheck } from 'lucide-vue-next';
import PlanBadge from '@/components/Plans/PlanBadge.vue';
import AppLayout from '@/layouts/AppLayout.vue';
import type { BreadcrumbItem } from '@/types';
import type { Plan } from '@/types/plan';
import { featureLabels } from '@/types/plan';

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
        style: { layout: 'vertical', color: 'gold', shape: 'rect', label: 'pay', height: 42 },
        createOrder: async () => {
            errorMessage.value = '';
            const res = await fetch(`/plans/${plan.id}/checkout`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json', 'X-CSRF-TOKEN': csrfToken(), 'Accept': 'application/json' },
            });
            const data = await res.json();
            if (!res.ok) throw new Error(data.error ?? 'Could not create PayPal order.');
            return data.id;
        },
        onApprove: async (data: { orderID: string }) => {
            const res = await fetch(`/plans/${plan.id}/capture`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json', 'X-CSRF-TOKEN': csrfToken(), 'Accept': 'application/json' },
                body: JSON.stringify({ orderID: data.orderID }),
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
    setTimeout(() => { visible.value = true; }, 50);

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

function isCurrentPlan(plan: Plan) {
    return props.currentPlan?.id === plan.id;
}
</script>

<template>
    <AppLayout :breadcrumbs="breadcrumbs">
        <Head title="Plans" />

        <div class="plans-page min-h-screen px-4 py-10 relative overflow-hidden">

            <!-- Ambient blobs -->
            <div class="blob blob-1" />
            <div class="blob blob-2" />
            <div class="blob blob-3" />

            <div class="relative z-10 max-w-5xl mx-auto">

                <!-- Header -->
                <div class="text-center mb-12 fade-up" :class="{ 'is-visible': visible }" style="transition-delay:0ms">
                    <div class="pill-badge mb-4">
                        <Zap class="h-3 w-3" /> Plans &amp; Billing
                    </div>
                    <h1 class="text-4xl font-extrabold tracking-tight mb-3">
                        Simple, transparent pricing
                    </h1>
                    <p class="text-muted-foreground text-sm max-w-md mx-auto leading-relaxed">
                        Upgrade or downgrade at any time. No hidden fees, cancel whenever.
                    </p>
                </div>

                <!-- Alerts -->
                <div v-if="successMsg" class="alert alert-success mb-8 fade-up is-visible">{{ successMsg }}</div>
                <div v-if="errorMessage" class="alert alert-error mb-8 fade-up is-visible">{{ errorMessage }}</div>

                <!-- Current plan hero -->
                <div
                    v-if="currentPlan"
                    class="current-plan-hero fade-up"
                    :class="{ 'is-visible': visible, 'hero-paid': !currentPlan.is_free }"
                    style="transition-delay:80ms"
                >
                    <div class="flex items-center gap-4">
                        <div class="plan-icon" :class="currentPlan.is_free ? 'plan-icon--free' : 'plan-icon--paid'">
                            <Crown class="h-5 w-5" :class="currentPlan.is_free ? 'text-muted-foreground' : 'text-white'" />
                        </div>
                        <div>
                            <p class="eyebrow mb-1">Current plan</p>
                            <div class="flex items-center gap-2 mb-0.5">
                                <span class="text-xl font-bold">{{ currentPlan.name }}</span>
                                <PlanBadge :plan="currentPlan" size="sm" />
                            </div>
                            <p class="text-sm text-muted-foreground">
                                {{ currentPlan.storage_limit_human }} storage &mdash; {{ currentPlan.price_formatted }}<span v-if="!currentPlan.is_free">/mo</span>
                            </p>
                        </div>
                    </div>
                    <div v-if="!currentPlan.is_free" class="active-pill">
                        <span class="active-dot" /> Active subscription
                    </div>
                </div>

                <!-- Section label -->
                <p class="eyebrow mb-6 fade-up" :class="{ 'is-visible': visible }" style="transition-delay:120ms">
                    {{ currentPlan ? 'Available plans' : 'Choose a plan' }}
                </p>

                <!-- Plan cards -->
                <div class="grid grid-cols-1 md:grid-cols-3 gap-5">
                    <div
                        v-for="(plan, i) in planList"
                        :key="plan.id"
                        class="plan-card fade-up"
                        :class="{
                            'is-visible': visible,
                            'plan-card--current': isCurrentPlan(plan),
                            'plan-card--popular': plan.slug === 'pro' && !isCurrentPlan(plan),
                        }"
                        :style="{ transitionDelay: `${150 + i * 90}ms` }"
                    >
                        <!-- Top label -->
                        <div v-if="isCurrentPlan(plan)" class="card-badge card-badge--current">✓ Your plan</div>
                        <div v-else-if="plan.slug === 'pro'" class="card-badge card-badge--popular">⚡ Most popular</div>

                        <div class="plan-card-body">
                            <p class="eyebrow mb-3">{{ plan.name }}</p>

                            <div class="flex items-end gap-1 mb-1">
                                <span class="text-5xl font-black tracking-tighter leading-none">
                                    {{ plan.is_free ? 'Free' : '$' + plan.price }}
                                </span>
                                <span v-if="!plan.is_free" class="text-muted-foreground text-sm mb-1.5 font-medium">/mo</span>
                            </div>
                            <p class="text-sm text-muted-foreground mb-5">{{ plan.storage_limit_human }} storage</p>

                            <div class="card-divider mb-5" />

                            <ul class="space-y-2.5 mb-8 flex-1">
                                <li v-for="feature in plan.features" :key="feature" class="flex items-center gap-3 text-sm">
                                    <span class="feature-dot"><Check class="h-2.5 w-2.5 text-white" /></span>
                                    {{ featureLabels[feature] ?? feature }}
                                </li>
                            </ul>

                            <div class="mt-auto">
                                <div v-if="isCurrentPlan(plan)" class="cta-current">
                                    <Check class="h-4 w-4" /> Current plan
                                </div>
                                <div v-else-if="plan.is_free">
                                    <button class="cta-downgrade" @click="switchToFree(plan)">Switch to Free</button>
                                    <p class="text-xs text-center text-muted-foreground mt-2">No payment required</p>
                                </div>
                                <div v-else>
                                    <div :id="`paypal-btn-${plan.id}`" class="min-h-[44px]" />
                                    <p class="text-xs text-center text-muted-foreground mt-2 flex items-center justify-center gap-1">
                                        <ShieldCheck class="h-3 w-3" /> Secured by PayPal
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <p class="text-center text-xs text-muted-foreground mt-10 fade-up" :class="{ 'is-visible': visible }" style="transition-delay:500ms">
                    Payments processed securely by PayPal &mdash; cancel or change plans anytime.
                </p>
            </div>
        </div>
    </AppLayout>
</template>

<style scoped>
.plans-page { background: hsl(var(--background)); }

/* Blobs */
.blob { position:absolute; border-radius:50%; filter:blur(90px); opacity:0.2; pointer-events:none; }
.blob-1 { width:500px;height:500px;background:radial-gradient(circle,#7B2FFF 0%,transparent 70%);top:-200px;left:-100px;animation:drift 14s ease-in-out infinite alternate; }
.blob-2 { width:400px;height:400px;background:radial-gradient(circle,#00E5FF 0%,transparent 70%);top:50px;right:-150px;animation:drift 18s ease-in-out infinite alternate-reverse; }
.blob-3 { width:280px;height:280px;background:radial-gradient(circle,#a855f7 0%,transparent 70%);bottom:50px;left:40%;opacity:0.1;animation:drift 11s ease-in-out infinite alternate; }
@keyframes drift { from{transform:translate(0,0) scale(1)} to{transform:translate(25px,15px) scale(1.06)} }

/* Entrance */
.fade-up { opacity:0;transform:translateY(22px);transition:opacity 0.55s cubic-bezier(0.16,1,0.3,1),transform 0.55s cubic-bezier(0.16,1,0.3,1); }
.fade-up.is-visible { opacity:1;transform:translateY(0); }

/* Typography */
.eyebrow { font-size:10px;font-weight:700;text-transform:uppercase;letter-spacing:.14em;color:hsl(var(--muted-foreground)); }

/* Pill badge */
.pill-badge { display:inline-flex;align-items:center;gap:6px;padding:5px 14px;border-radius:999px;border:1px solid rgba(123,47,255,.25);background:rgba(123,47,255,.07);font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:.1em;color:#7B2FFF; }

/* Alerts */
.alert { padding:14px 20px;border-radius:14px;font-size:13px;text-align:center;font-weight:500; }
.alert-success { background:rgba(34,197,94,.08);border:1px solid rgba(34,197,94,.2);color:#16a34a; }
.alert-error   { background:rgba(239,68,68,.08);border:1px solid rgba(239,68,68,.2);color:#dc2626; }

/* Current plan hero */
.current-plan-hero { display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:1rem;padding:1.25rem 1.5rem;border-radius:18px;border:1px solid hsl(var(--border));background:hsl(var(--card));box-shadow:0 1px 3px rgba(0,0,0,.04),0 4px 16px rgba(0,0,0,.04);margin-bottom:2.5rem;transition:box-shadow .3s; }
.current-plan-hero:hover { box-shadow:0 4px 28px rgba(123,47,255,.1); }
.current-plan-hero.hero-paid { border-color:rgba(123,47,255,.25);background:linear-gradient(135deg,rgba(123,47,255,.05) 0%,rgba(0,229,255,.03) 100%); }

.plan-icon { display:flex;align-items:center;justify-content:center;width:48px;height:48px;border-radius:14px;flex-shrink:0; }
.plan-icon--free { background:hsl(var(--muted)); }
.plan-icon--paid { background:linear-gradient(135deg,#7B2FFF,#00E5FF);box-shadow:0 4px 14px rgba(123,47,255,.35); }

.active-pill { display:flex;align-items:center;gap:6px;font-size:11px;font-weight:600;color:#16a34a;background:rgba(34,197,94,.08);border:1px solid rgba(34,197,94,.2);padding:5px 12px;border-radius:999px;flex-shrink:0; }
.active-dot { width:6px;height:6px;background:#22c55e;border-radius:50%;animation:pulse-dot 2s ease-in-out infinite; }
@keyframes pulse-dot { 0%,100%{opacity:1;transform:scale(1)} 50%{opacity:.5;transform:scale(.75)} }

/* Plan cards */
.plan-card { position:relative;border-radius:20px;border:1px solid hsl(var(--border));background:hsl(var(--card));transition:transform .35s cubic-bezier(.34,1.56,.64,1),box-shadow .3s ease,border-color .3s;display:flex;flex-direction:column; }
.plan-card:hover { transform:translateY(-7px);box-shadow:0 20px 40px rgba(0,0,0,.09); }
.plan-card--popular { border-color:rgba(123,47,255,.35);background:linear-gradient(155deg,rgba(123,47,255,.07) 0%,rgba(0,229,255,.04) 100%);box-shadow:0 4px 24px rgba(123,47,255,.1); }
.plan-card--popular:hover { box-shadow:0 24px 50px rgba(123,47,255,.18); }
.plan-card--current { border-color:rgba(123,47,255,.4);background:linear-gradient(155deg,rgba(123,47,255,.08) 0%,rgba(0,229,255,.05) 100%);box-shadow:0 0 0 3px rgba(123,47,255,.1),0 4px 24px rgba(123,47,255,.08); }
.plan-card--current:hover { transform:translateY(-4px); }

.card-badge { position:absolute;top:-13px;left:50%;transform:translateX(-50%);font-size:11px;font-weight:700;padding:3px 13px;border-radius:999px;white-space:nowrap;z-index:10;letter-spacing:.03em; }
.card-badge--popular { background:linear-gradient(90deg,#7B2FFF,#00E5FF);color:#fff;box-shadow:0 4px 14px rgba(123,47,255,.4);animation:badge-glow 3s ease-in-out infinite; }
.card-badge--current { background:linear-gradient(90deg,#7B2FFF,#a855f7);color:#fff;box-shadow:0 4px 12px rgba(123,47,255,.3); }
@keyframes badge-glow { 0%,100%{box-shadow:0 4px 14px rgba(123,47,255,.4)} 50%{box-shadow:0 4px 22px rgba(0,229,255,.55)} }

.plan-card-body { padding:2rem;display:flex;flex-direction:column;flex:1; }
.card-divider { height:1px;background:linear-gradient(90deg,transparent,hsl(var(--border)) 20%,hsl(var(--border)) 80%,transparent); }
.feature-dot { display:flex;align-items:center;justify-content:center;width:18px;height:18px;border-radius:50%;background:linear-gradient(135deg,#7B2FFF,#00E5FF);flex-shrink:0; }

.cta-current { display:flex;align-items:center;justify-content:center;gap:6px;width:100%;padding:10px;border-radius:10px;border:1px solid hsl(var(--border));background:hsl(var(--muted));color:hsl(var(--muted-foreground));font-size:14px;font-weight:600; }
.cta-downgrade { width:100%;padding:10px;border-radius:10px;border:1px solid hsl(var(--border));background:transparent;color:hsl(var(--foreground));font-size:14px;font-weight:600;cursor:pointer;transition:background .2s,border-color .2s; }
.cta-downgrade:hover { background:hsl(var(--muted));border-color:rgba(123,47,255,.3); }
</style>