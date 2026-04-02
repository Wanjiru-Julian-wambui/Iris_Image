<script setup lang="ts">
import { Check, Loader2 } from 'lucide-vue-next';
import { ref } from 'vue';
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
    (e: 'subscribe', plan: Plan): void;
}>();

const loading = ref(false);
const isCurrentPlan = props.currentPlan?.id === props.plan.id;

function handleSubscribe() {
    if (isCurrentPlan || props.plan.is_free) return;
    loading.value = true;
    emit('subscribe', props.plan);
}
</script>

<template>
    <div
        class="relative rounded-2xl border p-8 flex flex-col transition-shadow hover:shadow-lg"
        :class="isPopular
            ? 'border-[#7B2FFF]/50 bg-gradient-to-br from-[#7B2FFF]/10 to-[#00E5FF]/5 shadow-md'
            : 'border-border bg-card'"
    >
        <!-- Most Popular Badge -->
        <div v-if="isPopular" class="absolute -top-3 left-1/2 -translate-x-1/2">
            <Badge class="bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF] text-white border-0 px-3 shadow">
                Most popular
            </Badge>
        </div>

        <!-- Current Plan Badge -->
        <div v-if="isCurrentPlan" class="absolute top-4 right-4">
            <Badge variant="secondary" class="text-xs">Current plan</Badge>
        </div>

        <!-- Plan Header -->
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
        <Button v-if="isCurrentPlan" disabled variant="outline" class="w-full">
            Current plan
        </Button>
        <Button v-else-if="plan.is_free" variant="outline" class="w-full" disabled>
            Free plan
        </Button>
        <Button
            v-else
            class="w-full text-white hover:opacity-90 bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF]"
            :disabled="loading"
            @click="handleSubscribe"
        >
            <Loader2 v-if="loading" class="h-4 w-4 animate-spin mr-2" />
            {{ loading ? 'Redirecting to Stripe...' : `Upgrade to ${plan.name}` }}
        </Button>
    </div>
</template>