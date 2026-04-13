<script setup lang="ts">
import { Head, router } from '@inertiajs/vue3';
import { Check, Loader2 } from 'lucide-vue-next';
import { onMounted, ref } from 'vue';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import type { Plan } from '@/types/plan';
import { featureLabels } from '@/types/plan';

const props = defineProps<{
    plans: { data: Plan[] };
}>();

const selecting    = ref<number | null>(null);
const paypalReady  = ref(false);
const errorMessage = ref('');

// -----------------------------------------------------------------------
// Free plan — direct POST
// -----------------------------------------------------------------------
function selectFreePlan(plan: Plan) {
    if (selecting.value) return;
    selecting.value = plan.id;
    router.post('/plans/select', { plan_id: plan.id }, {
        onFinish: () => { selecting.value = null; },
    });
}

// -----------------------------------------------------------------------
// PayPal — render a button per paid plan
// -----------------------------------------------------------------------
function mountPayPalButton(plan: Plan) {
    const containerId = `paypal-button-${plan.id}`;

    // @ts-ignore — PayPal SDK loaded via CDN script tag
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
                    'Content-Type':     'application/json',
                    'X-CSRF-TOKEN':     (document.querySelector('meta[name="csrf-token"]') as HTMLMetaElement)?.content ?? '',
                    'Accept':           'application/json',
                },
            });
            const data = await res.json();
            if (!res.ok) throw new Error(data.error ?? 'Could not create PayPal order.');
            return data.id; // PayPal order ID
        },

        onApprove: async (data: { orderID: string }) => {
            selecting.value = plan.id;
            const res = await fetch(`/plans/${plan.id}/capture`, {
                method:  'POST',
                headers: {
                    'Content-Type':     'application/json',
                    'X-CSRF-TOKEN':     (document.querySelector('meta[name="csrf-token"]') as HTMLMetaElement)?.content ?? '',
                    'Accept':           'application/json',
                },
                body: JSON.stringify({ orderID: data.orderID }),
            });
            const result = await res.json();
            if (result.status === 'success') {
                router.visit('/dashboard');
            } else {
                errorMessage.value = 'Payment was captured but plan assignment failed. Please contact support.';
                selecting.value = null;
            }
        },

        onError: (err: unknown) => {
            console.error('PayPal error', err);
            errorMessage.value = 'Something went wrong with PayPal. Please try again.';
            selecting.value = null;
        },
    }).render(`#${containerId}`);
}

onMounted(() => {
    // Load PayPal JS SDK script dynamically
    const clientId = (document.querySelector('meta[name="paypal-client-id"]') as HTMLMetaElement)?.content;
    if (!clientId) {
        console.warn('PayPal client-id meta tag not found. Add <meta name="paypal-client-id" content="..."> to your layout.');
        return;
    }

    const script    = document.createElement('script');
    script.src      = `https://www.paypal.com/sdk/js?client-id=${clientId}&currency=USD`;
    script.onload   = () => {
        paypalReady.value = true;
        props.plans.data
            .filter(p => !p.is_free)
            .forEach(p => mountPayPalButton(p));
    };
    document.head.appendChild(script);
});
</script>

<template>
    <Head title="Choose a Plan" />

    <div class="min-h-screen bg-background flex flex-col items-center justify-center px-4 py-12">

        <!-- Brand -->
        <div class="text-center mb-10">
            <div class="inline-flex items-center justify-center size-14 rounded-2xl bg-gradient-to-br from-[#7B2FFF] to-[#00E5FF] mb-4 shadow-lg">
                <img src="/favicon.png" alt="Logo" class="size-8 object-contain" />
            </div>
            <h1 class="text-3xl font-bold tracking-tight">Choose your plan</h1>
            <p class="text-muted-foreground mt-2 max-w-sm mx-auto">
                Start for free or unlock more storage and features with a paid plan.
            </p>
        </div>

        <!-- Error -->
        <div v-if="errorMessage" class="mb-6 w-full max-w-5xl rounded-xl bg-red-500/10 border border-red-500/20 px-5 py-3 text-sm text-red-600 text-center">
            {{ errorMessage }}
        </div>

        <!-- Plan Cards -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6 w-full max-w-5xl">
            <div
                v-for="plan in plans.data"
                :key="plan.id"
                class="relative rounded-2xl border p-8 flex flex-col transition-all hover:shadow-lg"
                :class="plan.slug === 'pro'
                    ? 'border-[#7B2FFF]/50 bg-gradient-to-br from-[#7B2FFF]/10 to-[#00E5FF]/5 shadow-md'
                    : 'border-border bg-card'"
            >
                <!-- Most Popular badge -->
                <div v-if="plan.slug === 'pro'" class="absolute -top-3 left-1/2 -translate-x-1/2">
                    <Badge class="bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF] text-white border-0 px-3 shadow">
                        Most popular
                    </Badge>
                </div>

                <!-- Header -->
                <div class="mb-6">
                    <p class="text-sm font-semibold text-muted-foreground uppercase tracking-wider mb-2">
                        {{ plan.name }}
                    </p>
                    <div class="flex items-end gap-1 mb-2">
                        <span class="text-4xl font-bold tracking-tight">
                            {{ plan.is_free ? 'Free' : '$' + plan.price }}
                        </span>
                        <span v-if="!plan.is_free" class="text-muted-foreground mb-1.5 text-sm">/mo</span>
                    </div>
                    <p class="text-sm text-muted-foreground">{{ plan.storage_limit_human }} storage</p>
                </div>

                <!-- Features -->
                <ul class="space-y-3 mb-8 flex-1">
                    <li
                        v-for="feature in plan.features"
                        :key="feature"
                        class="flex items-center gap-2.5 text-sm"
                    >
                        <div class="flex size-5 shrink-0 items-center justify-center rounded-full bg-gradient-to-br from-[#7B2FFF] to-[#00E5FF]">
                            <Check class="h-3 w-3 text-white" />
                        </div>
                        {{ featureLabels[feature] ?? feature }}
                    </li>
                </ul>

                <!-- CTA -->
                <div v-if="plan.is_free">
                    <Button
                        variant="outline"
                        class="w-full"
                        :disabled="selecting === plan.id"
                        @click="selectFreePlan(plan)"
                    >
                        <Loader2 v-if="selecting === plan.id" class="h-4 w-4 animate-spin mr-2" />
                        {{ selecting === plan.id ? 'Setting up...' : 'Get started for free' }}
                    </Button>
                </div>

                <!-- PayPal button container for paid plans -->
                <div v-else>
                    <div v-if="selecting === plan.id" class="flex items-center justify-center py-3 text-sm text-muted-foreground gap-2">
                        <Loader2 class="h-4 w-4 animate-spin" /> Processing payment…
                    </div>
                    <div v-show="!selecting" :id="`paypal-button-${plan.id}`" class="min-h-[44px]" />
                    <p v-if="!paypalReady && !selecting" class="text-xs text-center text-muted-foreground mt-2">
                        Loading PayPal…
                    </p>
                </div>
            </div>
        </div>

        <p class="text-xs text-muted-foreground mt-8">
            You can change your plan anytime from your account settings.
            Payments are securely processed by PayPal.
        </p>
    </div>
</template>