<script setup lang="ts">
import { TrendingDown, TrendingUp } from 'lucide-vue-next';
import { computed, type Component } from 'vue';

const props = defineProps<{
    title:      string;
    value:      string | number;
    subtitle?:  string;
    icon:       Component;
    trend?:     number;
    trendLabel?: string;
    color?:     'purple' | 'cyan' | 'green' | 'amber' | 'red';
    loading?:   boolean;
}>();

const colorConfig = computed(() => {
    const map = {
        purple: { icon: 'text-[#7B2FFF]', bg: 'bg-[#7B2FFF]/10' },
        cyan:   { icon: 'text-[#00a5bb]', bg: 'bg-[#00E5FF]/10' },
        green:  { icon: 'text-green-500',  bg: 'bg-green-500/10'  },
        amber:  { icon: 'text-amber-500',  bg: 'bg-amber-500/10'  },
        red:    { icon: 'text-red-500',    bg: 'bg-red-500/10'    },
    };
    return map[props.color ?? 'purple'];
});

const trendPositive = computed(() => (props.trend ?? 0) >= 0);
</script>

<template>
    <div class="rounded-xl border border-border bg-card p-5 flex flex-col gap-3">
        <!-- Header -->
        <div class="flex items-start justify-between">
            <p class="text-sm text-muted-foreground">{{ title }}</p>
            <div
                class="flex size-9 items-center justify-center rounded-lg shrink-0"
                :class="colorConfig.bg"
            >
                <component
                    :is="icon"
                    class="h-4.5 w-4.5"
                    :class="colorConfig.icon"
                />
            </div>
        </div>

        <!-- Skeleton -->
        <div v-if="loading" class="space-y-2">
            <div class="h-8 w-24 rounded-md bg-muted animate-pulse" />
            <div class="h-3 w-32 rounded-md bg-muted animate-pulse" />
        </div>

        <!-- Value -->
        <div v-else>
            <p class="text-3xl font-bold tracking-tight">{{ value }}</p>

            <!-- Subtitle or trend -->
            <div class="flex items-center gap-1.5 mt-1">
                <template v-if="trend !== undefined">
                    <TrendingUp
                        v-if="trendPositive"
                        class="h-3.5 w-3.5 text-green-500 shrink-0"
                    />
                    <TrendingDown
                        v-else
                        class="h-3.5 w-3.5 text-red-500 shrink-0"
                    />
                    <span
                        class="text-xs font-medium"
                        :class="trendPositive ? 'text-green-500' : 'text-red-500'"
                    >
                        {{ trendPositive ? '+' : '' }}{{ trend }}%
                    </span>
                    <span v-if="trendLabel" class="text-xs text-muted-foreground">
                        {{ trendLabel }}
                    </span>
                </template>
                <span v-else-if="subtitle" class="text-xs text-muted-foreground">
                    {{ subtitle }}
                </span>
            </div>
        </div>
    </div>
</template>