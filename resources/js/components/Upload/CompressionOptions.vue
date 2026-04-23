<script setup lang="ts">
import { Zap } from 'lucide-vue-next';
import { computed } from 'vue';
import { Switch } from '@/components/ui/switch';
import { Label } from '@/components/ui/label';
import {
    Select,
    SelectContent,
    SelectItem,
    SelectTrigger,
    SelectValue,
} from '@/components/ui/select';
import type { CompressionOptions } from '@/composables/useCompression';

const props = defineProps<{ options: CompressionOptions }>();
const emit  = defineEmits<{ 'update:options': [options: CompressionOptions] }>();

function update(patch: Partial<CompressionOptions>) {
    emit('update:options', { ...props.options, ...patch });
}

const qualityLabel = computed(() => {
    const q = props.options.quality;
    if (q >= 0.9) return 'Maximum';
    if (q >= 0.75) return 'High';
    if (q >= 0.55) return 'Medium';
    if (q >= 0.35) return 'Low';
    return 'Minimum';
});

const dimOptions = [
    { label: 'No resize',    value: '0'    },
    { label: '3840px (4K)',  value: '3840' },
    { label: '1920px (FHD)', value: '1920' },
    { label: '1280px (HD)',  value: '1280' },
    { label: '800px',        value: '800'  },
];
</script>

<template>
    <div class="rounded-xl border border-border bg-card p-5 space-y-4">
        <!-- Toggle -->
        <div class="flex items-center justify-between">
            <div class="flex items-center gap-2">
                <div class="flex size-8 items-center justify-center rounded-lg bg-[#7B2FFF]/10">
                    <Zap class="h-4 w-4 text-[#7B2FFF]" />
                </div>
                <div>
                    <p class="text-sm font-medium">Compress before upload</p>
                    <p class="text-xs text-muted-foreground">Reduce file size in-browser</p>
                </div>
            </div>
            <Switch :checked="options.enabled" @update:checked="update({ enabled: $event })" />
        </div>

        <!-- Options -->
        <Transition
            enter-active-class="transition-all duration-200"
            enter-from-class="opacity-0 -translate-y-1"
            leave-active-class="transition-all duration-150"
            leave-to-class="opacity-0 -translate-y-1"
        >
            <div v-if="options.enabled" class="space-y-4 pt-3 border-t border-border">
                <!-- Quality -->
                <div class="space-y-2">
                    <div class="flex items-center justify-between">
                        <Label class="text-sm">Quality</Label>
                        <span class="text-sm font-semibold text-[#7B2FFF]">
                            {{ qualityLabel }} ({{ Math.round(options.quality * 100) }}%)
                        </span>
                    </div>
                    <input
                        :value="options.quality"
                        type="range"
                        min="0.1"
                        max="1"
                        step="0.05"
                        class="w-full accent-[#7B2FFF]"
                        @input="update({ quality: parseFloat(($event.target as HTMLInputElement).value) })"
                    />
                    <div class="flex justify-between text-xs text-muted-foreground">
                        <span>Smaller</span>
                        <span>Better quality</span>
                    </div>
                </div>

                <!-- Max dimensions -->
                <div class="grid grid-cols-2 gap-3">
                    <div class="space-y-1.5">
                        <Label class="text-xs text-muted-foreground">Max width</Label>
                        <Select
                            :model-value="String(options.maxWidth)"
                            @update:model-value="update({ maxWidth: parseInt($event) })"
                        >
                            <SelectTrigger class="h-8">
                                <SelectValue />
                            </SelectTrigger>
                            <SelectContent>
                                <SelectItem v-for="o in dimOptions" :key="o.value" :value="o.value">
                                    {{ o.label }}
                                </SelectItem>
                            </SelectContent>
                        </Select>
                    </div>
                    <div class="space-y-1.5">
                        <Label class="text-xs text-muted-foreground">Max height</Label>
                        <Select
                            :model-value="String(options.maxHeight)"
                            @update:model-value="update({ maxHeight: parseInt($event) })"
                        >
                            <SelectTrigger class="h-8">
                                <SelectValue />
                            </SelectTrigger>
                            <SelectContent>
                                <SelectItem v-for="o in dimOptions" :key="o.value" :value="o.value">
                                    {{ o.label }}
                                </SelectItem>
                            </SelectContent>
                        </Select>
                    </div>
                </div>

                <p class="text-xs text-muted-foreground leading-relaxed">
                    Runs entirely in your browser. Only used if the result is smaller than the original.
                    PNG files are resized only (lossless).
                </p>
            </div>
        </Transition>
    </div>
</template>