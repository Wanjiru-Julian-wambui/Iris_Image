<script setup lang="ts">
import { HardDrive } from 'lucide-vue-next';
import { computed } from 'vue';
import { Link } from '@inertiajs/vue3';

const props = defineProps<{
    used: number;
    limit: number;
    usedHuman: string;
    limitHuman: string;
    percent: number;
    showUpgrade?: boolean;
    compact?: boolean;
}>();

const barColor = computed(() => {
    if (props.percent >= 90) return 'from-red-500 to-red-400';
    if (props.percent >= 70) return 'from-amber-500 to-amber-400';
    return 'from-[#7B2FFF] to-[#00E5FF]';
});

const textColor = computed(() => {
    if (props.percent >= 90) return 'text-red-500';
    if (props.percent >= 70) return 'text-amber-500';
    return 'text-muted-foreground';
});
</script>

<template>
    <!-- Compact version (for sidebar/navbar) -->
    <div v-if="compact" class="space-y-1.5">
        <div class="flex items-center justify-between text-xs">
            <span class="text-muted-foreground flex items-center gap-1.5">
                <HardDrive class="h-3 w-3" />
                Storage
            </span>
            <span :class="textColor">{{ percent }}%</span>
        </div>
        <div class="w-full h-1.5 rounded-full bg-muted overflow-hidden">
            <div
                class="h-full rounded-full bg-gradient-to-r transition-all duration-500"
                :class="barColor"
                :style="{ width: Math.min(percent, 100) + '%' }"
            />
        </div>
        <p class="text-xs text-muted-foreground">{{ usedHuman }} / {{ limitHuman }}</p>
    </div>

    <!-- Full version (for dashboard/profile) -->
    <div v-else class="rounded-xl border border-border bg-card p-5 space-y-3">
        <div class="flex items-center justify-between">
            <div class="flex items-center gap-2">
                <div class="flex size-8 items-center justify-center rounded-lg bg-[#7B2FFF]/10">
                    <HardDrive class="h-4 w-4 text-[#7B2FFF]" />
                </div>
                <p class="text-sm font-medium">Storage</p>
            </div>
            <span class="text-sm font-semibold" :class="textColor">{{ percent }}%</span>
        </div>

        <!-- Bar -->
        <div class="w-full h-2.5 rounded-full bg-muted overflow-hidden">
            <div
                class="h-full rounded-full bg-gradient-to-r transition-all duration-500"
                :class="barColor"
                :style="{ width: Math.min(percent, 100) + '%' }"
            />
        </div>

        <!-- Used / Limit -->
        <div class="flex items-center justify-between text-sm">
            <span class="text-muted-foreground">{{ usedHuman }} used</span>
            <span class="text-muted-foreground">{{ limitHuman }} total</span>
        </div>

        <!-- Warning messages -->
        <p v-if="percent >= 90" class="text-xs text-red-500 font-medium">
            Storage almost full. Upgrade to continue uploading.
        </p>
        <p v-else-if="percent >= 70" class="text-xs text-amber-500">
            You are using {{ percent }}% of your storage.
        </p>

        <!-- Upgrade CTA -->
        <Link v-if="showUpgrade && percent >= 70" href="/plans">
            <div class="mt-1 w-full rounded-lg bg-gradient-to-r from-[#7B2FFF]/10 to-[#00E5FF]/10 border border-[#7B2FFF]/20 px-3 py-2 text-center text-xs font-medium text-[#7B2FFF] hover:from-[#7B2FFF]/15 hover:to-[#00E5FF]/15 transition-colors cursor-pointer">
                Upgrade plan for more storage →
            </div>
        </Link>
    </div>
</template>
