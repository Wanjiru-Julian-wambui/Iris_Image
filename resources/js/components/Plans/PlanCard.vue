<script setup lang="ts">
import { computed } from 'vue';
import { Check, ShieldCheck } from 'lucide-vue-next';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import type { Plan } from '@/types/plan';
import { featureLabels } from '@/types/plan';

const props = defineProps<{
    plan: Plan;
    currentPlan: Plan | null;
    isPopular?: boolean;
}>();

const emit = defineEmits<{
    (e: 'switch-free', plan: Plan): void;
}>();

// Must be computed() so it stays reactive if currentPlan changes after a plan switch
const isCurrentPlan = computed(() => props.currentPlan?.id === props.plan.id);
</script>

<template>
    <div
        class="relative rounded-2xl border p-8 flex flex-col transition-shadow hover:shadow-lg"
        :class="isCurrentPlan
            ? 'border-[#7B2FFF]/60 bg-gradient-to-br from-[#7B2FFF]/10 to-[#00E5FF]/5 shadow-md ring-2 ring-[#7B2FFF]/20'
            : isPopular
                ? 'border-[#7B2FFF]/50 bg-gradient-to-br from-[#7B2FFF]/10 to-[#00E5FF]/5 shadow-md'
                : 'border-border bg-card'"
    >
        <!-- Most Popular badge -->
        <div v-if="isPopular && !isCurrentPlan" class="absolute -top-3.5 left-1/2 -translate-x-1/2 z-10">
            <Badge class="bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF] text-white border-0 px-3 shadow-sm">
                Most popular
            </Badge>
        </div>

        <!-- Current plan badge -->
        <div v-if="isCurrentPlan" class="absolute -top-3.5 left-1/2 -translate-x-1/2 z-10">
            <Badge class="bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF] text-white border-0 px-3 shadow-sm">
                ✓ Your plan
            </Badge>
        </div>

        <!-- Header -->
        <div class="mb-6">
            <p class="text-sm font-semibold text-muted-foreground uppercase tracking-wider mb-2">
                {{ plan.name }}
            </p>
            <div class="flex items-end gap-1 mb-1">
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

        <!-- Already on this plan -->
        <Button v-if="isCurrentPlan" disabled variant="outline" class="w-full">
            ✓ Current plan
        </Button>

        <!-- Switch to Free (downgrade) -->
        <div v-else-if="plan.is_free">
            <Button variant="outline" class="w-full" @click="emit('switch-free', plan)">
                Switch to Free
            </Button>
            <p class="text-xs text-center text-muted-foreground mt-2">No payment required</p>
        </div>

        <!-- Paid — parent mounts PayPal SDK button into this div via onMounted + nextTick -->
        <div v-else>
            <div :id="`paypal-btn-${plan.id}`" class="min-h-[44px]" />
            <p class="text-xs text-center text-muted-foreground mt-2 flex items-center justify-center gap-1">
                <ShieldCheck class="h-3 w-3" /> Secured by PayPal
            </p>
        </div>
    </div>
</template>