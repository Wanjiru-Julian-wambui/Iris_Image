<script setup lang="ts">
import { AlertTriangle, ArrowRight, X } from 'lucide-vue-next';
import { Link } from '@inertiajs/vue3';

export type DuplicateItem = {
    fileName:     string;
    existingId:   number;
    existingName: string;
    existingUrl:  string;
};

defineProps<{ duplicates: DuplicateItem[] }>();
const emit = defineEmits<{ dismiss: []; keepAll: [] }>();
</script>

<template>
    <div class="rounded-xl border border-amber-500/30 bg-amber-500/5 p-4 space-y-3">
        <!-- Header -->
        <div class="flex items-start justify-between gap-3">
            <div class="flex items-start gap-2">
                <AlertTriangle class="h-4 w-4 text-amber-500 shrink-0 mt-0.5" />
                <div>
                    <p class="text-sm font-medium text-amber-600">
                        {{ duplicates.length }} duplicate{{ duplicates.length !== 1 ? 's' : '' }} detected
                    </p>
                    <p class="text-xs text-amber-600/70 mt-0.5">
                        These files already exist in your library and will be skipped.
                    </p>
                </div>
            </div>
            <button @click="emit('dismiss')" class="text-amber-500/60 hover:text-amber-500 transition-colors shrink-0">
                <X class="h-4 w-4" />
            </button>
        </div>

        <!-- List -->
        <div class="space-y-2 max-h-44 overflow-y-auto pr-1">
            <div
                v-for="dup in duplicates"
                :key="dup.existingId"
                class="flex items-center gap-3 rounded-lg bg-amber-500/10 px-3 py-2"
            >
                <div class="size-8 rounded-md overflow-hidden bg-muted shrink-0">
                    <img :src="dup.existingUrl" :alt="dup.existingName" class="w-full h-full object-cover" />
                </div>
                <div class="flex-1 min-w-0">
                    <p class="text-xs font-medium truncate text-amber-700 dark:text-amber-400">{{ dup.fileName }}</p>
                    <p class="text-xs text-amber-600/60 truncate">Already uploaded as "{{ dup.existingName }}"</p>
                </div>
                <Link :href="`/images/${dup.existingId}`" class="shrink-0 text-amber-500 hover:text-amber-600 transition-colors">
                    <ArrowRight class="h-3.5 w-3.5" />
                </Link>
            </div>
        </div>

        <!-- Actions -->
        <div class="flex items-center gap-2 pt-1">
            <button
                @click="emit('dismiss')"
                class="text-xs px-3 py-1.5 rounded-lg bg-amber-500/15 text-amber-600 hover:bg-amber-500/25 transition-colors font-medium"
            >
                Skip duplicates (recommended)
            </button>
            <button
                @click="emit('keepAll')"
                class="text-xs px-3 py-1.5 rounded-lg border border-amber-500/20 text-amber-600/60 hover:text-amber-600 hover:border-amber-500/40 transition-colors"
            >
                Upload anyway
            </button>
        </div>
    </div>
</template>