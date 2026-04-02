<script setup lang="ts">
import { Badge } from '@/components/ui/badge';
import type { Plan } from '@/types/plan';

defineProps<{
    plan: Plan | null;
    size?: 'sm' | 'md';
}>();
</script>

<template>
    <Badge
        v-if="!plan || plan.is_free"
        variant="secondary"
        class="text-xs font-medium"
    >
        Free
    </Badge>
    <Badge
        v-else-if="plan.slug === 'pro'"
        class="text-xs font-medium border-0 text-white"
        :class="size === 'sm' ? 'px-2 py-0.5' : 'px-3 py-1'"
        style="background: linear-gradient(135deg, #7B2FFF 0%, #00E5FF 100%)"
    >
        {{ plan.name }}
    </Badge>
    <Badge
        v-else-if="plan.slug === 'team'"
        class="text-xs font-medium border-0 text-white"
        :class="size === 'sm' ? 'px-2 py-0.5' : 'px-3 py-1'"
        style="background: linear-gradient(135deg, #00E5FF 0%, #7B2FFF 100%)"
    >
        {{ plan.name }}
    </Badge>
    <Badge v-else variant="secondary" class="text-xs font-medium">
        {{ plan.name }}
    </Badge>
</template>