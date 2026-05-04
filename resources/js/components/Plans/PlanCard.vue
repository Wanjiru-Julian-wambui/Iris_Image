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

const isCurrentPlan = computed(() => props.currentPlan?.id === props.plan.id);
</script>

<template>
    <div
        class="plan-card h-full flex flex-col"
        :class="{
            'is-current': isCurrentPlan,
            'is-popular': isPopular && !isCurrentPlan,
            'is-default': !isCurrentPlan && !isPopular,
        }"
    >
        <!-- Top badge -->
        <div v-if="isCurrentPlan" class="badge-wrap">
            <Badge class="top-badge current-badge">✓ Your plan</Badge>
        </div>
        <div v-else-if="isPopular" class="badge-wrap">
            <Badge class="top-badge popular-badge">✦ Most popular</Badge>
        </div>

        <div class="p-8 flex flex-col flex-1">

            <!-- Pricing header -->
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
                    class="feature-item flex items-center gap-3 text-sm"
                >
                    <div class="feature-check">
                        <Check class="h-2.5 w-2.5 text-white" />
                    </div>
                    <span class="text-foreground/80">{{ featureLabels[feature] ?? feature }}</span>
                </li>
            </ul>

            <!-- CTA -->
            <Button v-if="isCurrentPlan" disabled variant="outline" class="w-full h-11 font-semibold opacity-60">
                ✓ Current plan
            </Button>

            <div v-else-if="plan.is_free">
                <Button
                    variant="outline"
                    class="w-full h-11 font-semibold transition-all duration-200 hover:scale-[1.02] active:scale-[0.98]"
                    @click="emit('switch-free', plan)"
                >
                    Switch to Free
                </Button>
                <p class="text-xs text-center text-muted-foreground mt-2.5 opacity-70">No payment required</p>
            </div>

            <div v-else>
                <div :id="`paypal-btn-${plan.id}`" class="min-h-[44px]" />
                <p class="text-xs text-center text-muted-foreground mt-2.5 flex items-center justify-center gap-1 opacity-70">
                    <ShieldCheck class="h-3 w-3" /> Secured by PayPal
                </p>
            </div>
        </div>
    </div>
</template>

<style scoped>
/* Base card */
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

.plan-card.is-current {
    border: 1px solid #7B2FFF50;
    background: linear-gradient(160deg, #7B2FFF10 0%, #00E5FF09 100%);
    box-shadow: 0 4px 24px #7B2FFF14, 0 0 0 2px #7B2FFF20 inset;
}
.plan-card.is-current:hover {
    box-shadow: 0 10px 36px #7B2FFF1e, 0 0 0 2px #7B2FFF35 inset;
}

/* Badges */
.badge-wrap {
    position: absolute; top: -1px; left: 50%;
    transform: translateX(-50%); z-index: 10;
}
.top-badge {
    border: 0 !important; color: white !important;
    padding: 0.25rem 0.875rem !important;
    font-size: 0.7rem !important; font-weight: 700 !important;
    letter-spacing: 0.03em; white-space: nowrap;
}
.popular-badge {
    background: linear-gradient(135deg, #7B2FFF, #00E5FF) !important;
    box-shadow: 0 4px 12px #7B2FFF40;
}
.current-badge {
    background: linear-gradient(135deg, #16a34a, #22c55e) !important;
    box-shadow: 0 4px 12px #16a34a40;
}

/* Feature items */
.feature-check {
    display: flex; align-items: center; justify-content: center;
    width: 1.25rem; height: 1.25rem; border-radius: 9999px; flex-shrink: 0;
    background: linear-gradient(135deg, #7B2FFF, #00E5FF);
    box-shadow: 0 2px 6px #7B2FFF28;
    transition: transform 0.2s cubic-bezier(0.34, 1.56, 0.64, 1);
}
.feature-item:hover .feature-check { transform: scale(1.2) rotate(5deg); }
</style>