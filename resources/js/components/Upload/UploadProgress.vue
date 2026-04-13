<script setup lang="ts">
import { CheckCircle2, Loader2, XCircle } from 'lucide-vue-next';
import { computed } from 'vue';

export type UploadItem = {
    id: string;
    name: string;
    size: number;
    progress: number;
    status: 'pending' | 'uploading' | 'done' | 'error';
    error?: string;
};

const props = defineProps<{
    items: UploadItem[];
}>();

const overall = computed(() => {
    if (props.items.length === 0) {
        return 0;
    }

    const total = props.items.reduce((sum, i) => sum + i.progress, 0);

    return Math.round(total / props.items.length);
});

const doneCount = computed(() => props.items.filter(i => i.status === 'done').length);
const errorCount = computed(() => props.items.filter(i => i.status === 'error').length);

function formatSize(bytes: number): string {
    if (bytes >= 1048576) {
        return (bytes / 1048576).toFixed(1) + ' MB';
    }

    if (bytes >= 1024) {
        return (bytes / 1024).toFixed(0) + ' KB';
    }

    return bytes + ' B';
}
</script>

<template>
    <div class="rounded-xl border border-border bg-card p-4 space-y-3">
        <!-- Overall progress -->
        <div class="flex items-center justify-between text-sm mb-1">
            <span class="font-medium">
                Uploading {{ items.length }} file{{ items.length !== 1 ? 's' : '' }}
            </span>
            <span class="text-muted-foreground">
                {{ doneCount }}/{{ items.length }} done
                <span v-if="errorCount" class="text-destructive ml-1">· {{ errorCount }} failed</span>
            </span>
        </div>
        <div class="w-full h-2 rounded-full bg-muted overflow-hidden">
            <div
                class="h-full rounded-full bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF] transition-all duration-300"
                :style="{ width: overall + '%' }"
            />
        </div>

        <!-- Per file -->
        <div class="space-y-2 max-h-52 overflow-y-auto pr-1">
            <div
                v-for="item in items"
                :key="item.id"
                class="flex items-center gap-3 py-1.5"
            >
                <!-- Status icon -->
                <div class="shrink-0">
                    <CheckCircle2 v-if="item.status === 'done'"    class="h-4 w-4 text-green-500" />
                    <XCircle     v-else-if="item.status === 'error'" class="h-4 w-4 text-destructive" />
                    <Loader2     v-else                              class="h-4 w-4 text-[#7B2FFF] animate-spin" />
                </div>

                <!-- File info + progress -->
                <div class="flex-1 min-w-0">
                    <div class="flex items-center justify-between mb-1">
                        <p class="text-xs font-medium truncate">{{ item.name }}</p>
                        <p class="text-xs text-muted-foreground ml-2 shrink-0">{{ formatSize(item.size) }}</p>
                    </div>
                    <div v-if="item.status !== 'done'" class="w-full h-1 rounded-full bg-muted overflow-hidden">
                        <div
                            class="h-full rounded-full transition-all duration-200"
                            :class="item.status === 'error' ? 'bg-destructive' : 'bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF]'"
                            :style="{ width: item.progress + '%' }"
                        />
                    </div>
                    <p v-if="item.error" class="text-xs text-destructive mt-0.5">{{ item.error }}</p>
                </div>

                <!-- Percent -->
                <span class="text-xs text-muted-foreground shrink-0 w-8 text-right">
                    {{ item.status === 'done' ? '100%' : item.status === 'error' ? 'Error' : item.progress + '%' }}
                </span>
            </div>
        </div>
    </div>
</template>
