<script setup lang="ts">
import { Head, router } from '@inertiajs/vue3';
import { Check, Loader2, ShieldCheck, Sparkles } from 'lucide-vue-next';
import { nextTick, onMounted, ref, computed } from 'vue';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import type { Plan } from '@/types/plan';
import { featureLabels } from '@/types/plan';

const props = defineProps<{
    plans: { data: Plan[] } | Plan[];
}>();

const planList = computed<Plan[]>(() => {
    if (!props.plans) return [];
    if (Array.isArray(props.plans)) return props.plans;
    if (Array.isArray((props.plans as { data: Plan[] }).data)) return (props.plans as { data: Plan[] }).data;
    return [];
});

const selecting    = ref<number | null>(null);
const errorMessage = ref('');
const sdkLoaded    = ref(false);
const visible      = ref(false);

function csrfToken(): string {
    return (document.querySelector('meta[name="csrf-token"]') as HTMLMetaElement)?.content ?? '';
}

function selectFreePlan(plan: Plan) {
    if (selecting.value !== null) return;
    selecting.value = plan.id;
    router.post('/plans/select', { plan_id: plan.id }, {
        onFinish: () => { selecting.value = null; },
    });
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
            selecting.value = plan.id;
            try {
                const res = await fetch(`/plans/${plan.id}/capture`, {
                    method:  'POST',
                    headers: { 'Content-Type': 'application/json', 'X-CSRF-TOKEN': csrfToken(), 'Accept': 'application/json' },
                    body:    JSON.stringify({ orderID: data.orderID }),
                });
                const result = await res.json();
                if (result.status === 'success') {
                    router.visit('/dashboard');
                } else {
                    errorMessage.value = 'Payment captured but plan assignment failed. Please contact support.';
                    selecting.value = null;
                }
            } catch {
                errorMessage.value = 'Network error during capture. Please contact support.';
                selecting.value = null;
            }
        },
        onCancel: () => {
            errorMessage.value = "Payment cancelled. You can try again whenever you're ready.";
        },
        onError: (err: unknown) => {
            console.error('PayPal error', err);
            errorMessage.value = 'Something went wrong with PayPal. Please try again.';
            selecting.value = null;
        },
    }).render(`#paypal-btn-${plan.id}`);
}

async function mountAllButtons() {
    sdkLoaded.value = true;
    await nextTick();
    planList.value.filter(p => !p.is_free).forEach(p => mountPayPalButton(p));
}

onMounted(() => {
    requestAnimationFrame(() => { visible.value = true; });

    // @ts-ignore
    if (window.paypal) { mountAllButtons(); return; }

    const clientId = import.meta.env.VITE_PAYPAL_CLIENT_ID as string;
    if (!clientId) {
        errorMessage.value = 'PayPal is not configured. Please contact support.';
        return;
    }

    const script    = document.createElement('script');
    script.src      = `https://www.paypal.com/sdk/js?client-id=${clientId}&currency=USD&disable-funding=venmo,paylater`;
    script.onload   = () => mountAllButtons();
    script.onerror  = () => { errorMessage.value = 'Could not load PayPal. Please check your connection and refresh.'; };
    document.head.appendChild(script);
});
</script>

<template>
    <Head title="Choose a Plan" />

    <div class="choose-page min-h-screen flex flex-col items-center justify-center px-4 py-16 relative overflow-hidden">

        <!-- Ambient orbs -->
        <div class="orb orb-1" />
        <div class="orb orb-2" />
        <div class="orb orb-3" />

        <!-- Subtle grid pattern -->
        <div class="grid-pattern" />

        <div class="relative z-10 w-full max-w-5xl flex flex-col items-center">

            <!-- Hero header -->
            <div class="text-center mb-14" :class="visible ? 'anim-fade-up' : 'opacity-0'">
                <div class="logo-wrap mb-6">
                    <div class="logo-ring" />
                    <div class="logo-inner">
                        <img src="/favicon.png" alt="Logo" class="size-9 object-contain relative z-10" />
                    </div>
                </div>

                <div class="inline-flex items-center gap-2 rounded-full border border-violet-200 dark:border-violet-800 bg-violet-50 dark:bg-violet-950/40 px-4 py-1.5 mb-4">
                    <Sparkles class="h-3 w-3 text-violet-500" />
                    <span class="text-xs font-semibold text-violet-600 dark:text-violet-400 uppercase tracking-wide">Get started today</span>
                </div>

                <h1 class="text-4xl sm:text-5xl font-black tracking-tight mb-4 leading-[1.1]">
                    Choose your plan
                </h1>
                <p class="text-muted-foreground text-sm max-w-sm mx-auto leading-relaxed">
                    Start for free or unlock more storage and features.<br>
                    You can change your plan anytime.
                </p>
            </div>

            <!-- Error -->
            <div
                v-if="errorMessage"
                class="alert-error w-full max-w-5xl mb-8"
            >
                {{ errorMessage }}
            </div>

            <!-- Empty state -->
            <div v-if="planList.length === 0" class="text-muted-foreground text-sm">
                No plans available. Please contact support.
            </div>

            <!-- Plan cards -->
            <div v-else class="grid grid-cols-1 md:grid-cols-3 gap-5 w-full">
                <div
                    v-for="(plan, i) in planList"
                    :key="plan.id"
                    class="plan-card-wrap"
                    :style="{ animationDelay: `${0.1 + i * 0.12}s` }"
                    :class="visible ? 'anim-fade-up' : 'opacity-0'"
                >
                    <div
                        class="plan-card h-full flex flex-col"
                        :class="plan.slug === 'pro' ? 'is-popular' : 'is-default'"
                    >
                        <!-- Popular badge -->
                        <div v-if="plan.slug === 'pro'" class="popular-badge-wrap">
                            <Badge class="popular-badge">
                                ✦ Most popular
                            </Badge>
                        </div>

                        <!-- Card content -->
                        <div class="p-8 flex flex-col flex-1">

                            <!-- Pricing -->
                            <div class="mb-7">
                                <p class="text-[11px] font-bold text-muted-foreground uppercase tracking-widest mb-3">
                                    {{ plan.name }}
                                </p>
                                <div class="flex items-end gap-1.5 mb-1">
                                    <span class="text-5xl font-black tracking-tighter leading-none">
                                        {{ plan.is_free ? 'Free' : '$' + plan.price }}
                                    </span>
                                    <span v-if="!plan.is_free" class="text-muted-foreground mb-1.5 text-sm font-medium">/mo</span>
                                </div>
                                <p class="text-sm text-muted-foreground mt-1.5">{{ plan.storage_limit_human }} storage</p>
                            </div>

                            <!-- Divider -->
                            <div class="h-px bg-border mb-6 opacity-60" />

                            <!-- Features -->
                            <ul class="space-y-3 mb-8 flex-1">
                                <li
                                    v-for="feature in plan.features"
                                    :key="feature"
                                    class="flex items-center gap-3 text-sm"
                                >
                                    <div class="feature-check">
                                        <Check class="h-2.5 w-2.5 text-white" />
                                    </div>
                                    <span class="text-foreground/80">{{ featureLabels[feature] ?? feature }}</span>
                                </li>
                            </ul>

                            <!-- CTA -->
                            <div v-if="plan.is_free">
                                <Button
                                    variant="outline"
                                    class="w-full h-11 font-semibold transition-all duration-200 hover:scale-[1.02] active:scale-[0.98]"
                                    :disabled="selecting !== null"
                                    @click="selectFreePlan(plan)"
                                >
                                    <Loader2 v-if="selecting === plan.id" class="h-4 w-4 animate-spin mr-2" />
                                    {{ selecting === plan.id ? 'Setting up…' : 'Get started for free' }}
                                </Button>
                                <p class="text-xs text-center text-muted-foreground mt-2.5 opacity-70">No credit card required</p>
                            </div>

                            <div v-else>
                                <div v-if="selecting === plan.id" class="flex items-center justify-center gap-2 py-3 text-sm text-muted-foreground">
                                    <Loader2 class="h-4 w-4 animate-spin" /> Processing payment…
                                </div>
                                <div v-show="selecting !== plan.id" :id="`paypal-btn-${plan.id}`" class="min-h-[44px]" />
                                <p v-if="!sdkLoaded && selecting !== plan.id" class="text-xs text-center text-muted-foreground mt-2 opacity-60">
                                    Loading PayPal…
                                </p>
                                <p v-else class="text-xs text-center text-muted-foreground mt-2.5 flex items-center justify-center gap-1 opacity-70">
                                    <ShieldCheck class="h-3 w-3" /> Secured by PayPal
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Footer note -->
            <p class="text-xs text-muted-foreground mt-12 opacity-50 text-center" :class="visible ? 'anim-fade-up anim-delay-4' : 'opacity-0'">
                You can upgrade, downgrade, or cancel your plan at any time from your account settings.
            </p>
        </div>
    </div>
</template>

<style scoped>
/* Page */
.choose-page {
    background: radial-gradient(ellipse 90% 50% at 50% -8%, hsl(263 70% 50% / 0.08), transparent 55%);
}

/* Grid pattern overlay */
.grid-pattern {
    position: absolute; inset: 0; pointer-events: none;
    background-image:
        linear-gradient(hsl(var(--foreground) / 0.025) 1px, transparent 1px),
        linear-gradient(90deg, hsl(var(--foreground) / 0.025) 1px, transparent 1px);
    background-size: 48px 48px;
    mask-image: radial-gradient(ellipse 80% 80% at 50% 50%, black 20%, transparent 80%);
}

/* Orbs */
.orb {
    position: absolute; border-radius: 9999px;
    filter: blur(90px); pointer-events: none;
}
.orb-1 {
    width: 600px; height: 600px;
    background: radial-gradient(circle, #7B2FFF22, transparent 70%);
    top: -180px; left: -150px;
    animation: drift 15s ease-in-out infinite alternate;
}
.orb-2 {
    width: 450px; height: 450px;
    background: radial-gradient(circle, #00E5FF18, transparent 70%);
    top: 300px; right: -120px;
    animation: drift 19s ease-in-out infinite alternate-reverse;
}
.orb-3 {
    width: 350px; height: 350px;
    background: radial-gradient(circle, #7B2FFF12, transparent 70%);
    bottom: -80px; left: 35%;
    animation: drift 12s ease-in-out infinite alternate;
}
@keyframes drift {
    from { transform: translate(0, 0) scale(1); }
    to   { transform: translate(30px, 20px) scale(1.07); }
}

/* Logo */
.logo-wrap {
    position: relative; display: inline-flex;
    align-items: center; justify-content: center;
    width: 5rem; height: 5rem;
}
.logo-ring {
    position: absolute; inset: 0; border-radius: 1.5rem;
    background: linear-gradient(135deg, #7B2FFF, #00E5FF);
    animation: spin-slow 8s linear infinite;
    opacity: 0.7;
}
.logo-inner {
    position: relative; z-index: 1;
    display: flex; align-items: center; justify-content: center;
    width: calc(100% - 4px); height: calc(100% - 4px);
    border-radius: calc(1.5rem - 2px);
    background: linear-gradient(135deg, #7B2FFF, #00E5FF);
}
@keyframes spin-slow {
    from { transform: rotate(0deg); }
    to   { transform: rotate(360deg); }
}

/* Entrance animations */
@keyframes fadeUp {
    from { opacity: 0; transform: translateY(24px); }
    to   { opacity: 1; transform: translateY(0); }
}
.anim-fade-up  { animation: fadeUp 0.6s cubic-bezier(0.22, 1, 0.36, 1) both; }
.anim-delay-4  { animation-delay: 0.45s; }

/* Plan cards */
.plan-card {
    border-radius: 1.5rem;
    position: relative;
    overflow: hidden;
    transition: transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1), box-shadow 0.3s ease;
}
.plan-card:hover { transform: translateY(-5px); }
.plan-card.is-default {
    border: 1px solid hsl(var(--border));
    background: hsl(var(--card));
    box-shadow: 0 2px 16px hsl(var(--foreground) / 0.04);
}
.plan-card.is-default:hover {
    box-shadow: 0 8px 32px hsl(var(--foreground) / 0.08);
}
.plan-card.is-popular {
    border: 1px solid #7B2FFF40;
    background: linear-gradient(160deg, #7B2FFF0e 0%, #00E5FF07 100%);
    box-shadow: 0 4px 24px #7B2FFF12, 0 0 0 1px #7B2FFF18 inset;
}
.plan-card.is-popular:hover {
    box-shadow: 0 12px 40px #7B2FFF22, 0 0 0 1px #7B2FFF30 inset;
}

/* Popular badge */
.popular-badge-wrap {
    position: absolute; top: -1px; left: 50%; transform: translateX(-50%);
    z-index: 10;
}
.popular-badge {
    background: linear-gradient(135deg, #7B2FFF, #00E5FF) !important;
    color: white !important; border: 0 !important;
    padding: 0.25rem 0.875rem !important;
    font-size: 0.7rem !important; font-weight: 700 !important;
    letter-spacing: 0.03em;
    box-shadow: 0 4px 12px #7B2FFF40;
}

/* Feature check */
.feature-check {
    display: flex; align-items: center; justify-content: center;
    width: 1.25rem; height: 1.25rem; border-radius: 9999px; flex-shrink: 0;
    background: linear-gradient(135deg, #7B2FFF, #00E5FF);
    box-shadow: 0 2px 6px #7B2FFF30;
    transition: transform 0.2s ease;
}
li:hover .feature-check { transform: scale(1.15); }

/* Alert */
.alert-error {
    border-radius: 0.875rem; background: #ef44440e;
    border: 1px solid #ef44441e; padding: 0.875rem 1.25rem;
    font-size: 0.875rem; color: #dc2626; text-align: center;
    animation: fadeUp 0.4s ease both;
}
</style>