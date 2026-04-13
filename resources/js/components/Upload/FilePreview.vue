<script setup lang="ts">
import { Eye, Lock, Shield, X } from 'lucide-vue-next';

export type PreviewFile = {
    id: string;
    file: File;
    preview: string;
    isPrivate?: boolean;
    stripExif?: boolean;
};

defineProps<{
    files: PreviewFile[];
}>();

const emit = defineEmits<{
    remove: [id: string];
    togglePrivate: [id: string];
}>();

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
    <div class="grid grid-cols-3 sm:grid-cols-4 md:grid-cols-5 gap-3">
        <div
            v-for="item in files"
            :key="item.id"
            class="group relative rounded-xl overflow-hidden border border-border bg-muted aspect-square"
        >
            <!-- Preview image -->
            <img
                :src="item.preview"
                :alt="item.file.name"
                class="w-full h-full object-cover"
            />

            <!-- Hover overlay -->
            <div class="absolute inset-0 bg-black/50 opacity-0 group-hover:opacity-100 transition-opacity duration-200 flex flex-col justify-between p-2">
                <!-- Top actions -->
                <div class="flex items-start justify-between">
                    <div class="flex gap-1">
                        <!-- Private toggle -->
                        <button
                            class="flex size-6 items-center justify-center rounded-full transition-colors"
                            :class="item.isPrivate
                                ? 'bg-[#7B2FFF] text-white'
                                : 'bg-black/40 text-white/70 hover:bg-black/60'"
                            :title="item.isPrivate ? 'Private' : 'Set private'"
                            @click.stop="emit('togglePrivate', item.id)"
                        >
                            <Eye class="h-3 w-3" />
                        </button>

                        <!-- EXIF indicator -->
                        <div
                            v-if="item.stripExif"
                            class="flex size-6 items-center justify-center rounded-full bg-green-500/80"
                            title="EXIF will be stripped"
                        >
                            <Shield class="h-3 w-3 text-white" />
                        </div>
                    </div>

                    <!-- Remove -->
                    <button
                        class="flex size-6 items-center justify-center rounded-full bg-red-500/90 hover:bg-red-500 text-white transition-colors"
                        @click.stop="emit('remove', item.id)"
                    >
                        <X class="h-3 w-3" />
                    </button>
                </div>

                <!-- File info -->
                <div>
                    <p class="text-white text-xs font-medium truncate leading-tight">{{ item.file.name }}</p>
                    <p class="text-white/50 text-xs">{{ formatSize(item.file.size) }}</p>
                </div>
            </div>

            <!-- Private badge -->
            <div v-if="item.isPrivate" class="absolute top-1.5 left-1.5 pointer-events-none group-hover:hidden">
                <div class="flex size-5 items-center justify-center rounded-full bg-[#7B2FFF]/90">
                    <Lock class="h-2.5 w-2.5 text-white" />
                </div>
            </div>
        </div>
    </div>
</template>
