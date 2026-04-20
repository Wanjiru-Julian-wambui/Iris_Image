<script setup lang="ts">
import { Head, router } from '@inertiajs/vue3';
import { Check, Loader2, ShieldCheck } from 'lucide-vue-next';
import { onMounted, ref } from 'vue';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import type { Plan } from '@/types/plan';
import { featureLabels } from '@/types/plan';

const props = defineProps<{
    plans: { data: Plan[] };
}>();

const selecting    = ref<number | null>(null);
const errorMessage = ref('');
const sdkLoaded    = ref(false);

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

function mountAllButtons() {
    sdkLoaded.value = true;
    props.plans.data
        .filter(p => !p.is_free)
        .forEach(p => mountPayPalButton(p));
}

onMounted(() => {
    // SDK is loaded lazily here so the client ID is baked into the
    // compiled JS bundle (via import.meta.env) rather than printed
    // in plain HTML by the Blade layout.
    // @ts-ignore
    if (window.paypal) {
        mountAllButtons();
        return;
    }

    const clientId = import.meta.env.VITE_PAYPAL_CLIENT_ID as string;
    if (!clientId) {
        errorMessage.value = 'PayPal is not configured. Please contact support.';
        return;
    }

    const script    = document.createElement('script');
    script.src      = `https://www.paypal.com/sdk/js?client-id=${clientId}&currency=USD&disable-funding=venmo,paylater,card`;
    script.onload   = () => mountAllButtons();
    script.onerror  = () => { errorMessage.value = 'Could not load PayPal. Please check your connection and refresh.'; };
    document.head.appendChild(script);
});
</script>

<template>
    <Head title="Choose a Plan" />

    <div class="min-h-screen bg-background flex flex-col items-center justify-center px-4 py-16">

        <div class="text-center mb-12">
            <div class="inline-flex items-center justify-center size-16 rounded-2xl bg-gradient-to-br from-[#7B2FFF] to-[#00E5FF] mb-5 shadow-lg">
                <img src="/favicon.png" alt="Logo" class="size-9 object-contain" />
            </div>
            <h1 class="text-3xl font-bold tracking-tight">Choose your plan</h1>
            <p class="text-muted-foreground mt-2 max-w-sm mx-auto text-sm">
                Start for free or unlock more storage and features.<br>
                You can change your plan anytime.
            </p>
        </div>

        <div v-if="errorMessage" class="mb-8 w-full max-w-5xl rounded-xl bg-red-500/10 border border-red-500/20 px-5 py-3 text-sm text-red-600 text-center">
            {{ errorMessage }}
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 w-full max-w-5xl">
            <div
                v-for="plan in plans.data"
                :key="plan.id"
                class="relative rounded-2xl border p-8 flex flex-col transition-all hover:shadow-lg"
                :class="plan.slug === 'pro'
                    ? 'border-[#7B2FFF]/50 bg-gradient-to-br from-[#7B2FFF]/10 to-[#00E5FF]/5 shadow-md'
                    : 'border-border bg-card'"
            >
                <div v-if="plan.slug === 'pro'" class="absolute -top-3.5 left-1/2 -translate-x-1/2 z-10">
                    <Badge class="bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF] text-white border-0 px-3 shadow-sm">
                        Most popular
                    </Badge>
                </div>

                <div class="mb-6">
                    <p class="text-sm font-semibold text-muted-foreground uppercase tracking-wider mb-2">{{ plan.name }}</p>
                    <div class="flex items-end gap-1 mb-1">
                        <span class="text-4xl font-bold tracking-tight">{{ plan.is_free ? 'Free' : '$' + plan.price }}</span>
                        <span v-if="!plan.is_free" class="text-muted-foreground mb-1.5 text-sm">/mo</span>
                    </div>
                    <p class="text-sm text-muted-foreground">{{ plan.storage_limit_human }} storage</p>
                </div>

                <ul class="space-y-3 mb-8 flex-1">
                    <li v-for="feature in plan.features" :key="feature" class="flex items-center gap-2.5 text-sm">
                        <div class="flex size-5 shrink-0 items-center justify-center rounded-full bg-gradient-to-br from-[#7B2FFF] to-[#00E5FF]">
                            <Check class="h-3 w-3 text-white" />
                        </div>
                        {{ featureLabels[feature] ?? feature }}
                    </li>
                </ul>

                <!-- FREE plan -->
                <div v-if="plan.is_free">
                    <Button
                        variant="outline"
                        class="w-full"
                        :disabled="selecting !== null"
                        @click="selectFreePlan(plan)"
                    >
                        <Loader2 v-if="selecting === plan.id" class="h-4 w-4 animate-spin mr-2" />
                        {{ selecting === plan.id ? 'Setting up…' : 'Get started for free' }}
                    </Button>
                    <p class="text-xs text-center text-muted-foreground mt-2">No credit card required</p>
                </div>

                <!-- PAID plan -->
                <div v-else>
                    <div v-if="selecting === plan.id" class="flex items-center justify-center gap-2 py-3 text-sm text-muted-foreground">
                        <Loader2 class="h-4 w-4 animate-spin" /> Processing payment…
                    </div>
                    <div v-show="selecting !== plan.id" :id="`paypal-btn-${plan.id}`" class="min-h-[44px]" />
                    <p v-if="!sdkLoaded && selecting !== plan.id" class="text-xs text-center text-muted-foreground mt-1">
                        Loading PayPal…
                    </p>
                    <p v-else class="text-xs text-center text-muted-foreground mt-2 flex items-center justify-center gap-1">
                        <ShieldCheck class="h-3 w-3" /> Secured by PayPal
                    </p>
                </div>
            </div>
        </div>

        <p class="text-xs text-muted-foreground mt-10">
            You can upgrade, downgrade, or cancel your plan at any time from your account settings.
        </p>
    </div>
</template>