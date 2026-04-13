<script setup lang="ts">
import { CloudUpload } from 'lucide-vue-next';
import { ref } from 'vue';

const emit = defineEmits<{
    files: [files: File[]];
}>();

const isDragging = ref(false);
const fileInputRef = ref<HTMLInputElement | null>(null);

const allowedTypes = [
    'image/jpeg', 'image/png', 'image/gif',
    'image/webp', 'image/svg+xml', 'image/tiff',
];
const maxSize = 100 * 1024 * 1024;
const maxFiles = 20;

function onDragOver(e: DragEvent) {
    e.preventDefault();
    isDragging.value = true;
}

function onDragLeave(e: DragEvent) {
    if (!(e.currentTarget as HTMLElement).contains(e.relatedTarget as Node)) {
        isDragging.value = false;
    }
}

function onDrop(e: DragEvent) {
    e.preventDefault();
    isDragging.value = false;

    if (e.dataTransfer?.files) {
        handleFiles(Array.from(e.dataTransfer.files));
    }
}

function onFileInput(e: Event) {
    const input = e.target as HTMLInputElement;

    if (input.files) {
        handleFiles(Array.from(input.files));
        input.value = '';
    }
}

function handleFiles(rawFiles: File[]) {
    const valid = rawFiles.filter(f =>
        allowedTypes.includes(f.type) && f.size <= maxSize
    ).slice(0, maxFiles);

    if (valid.length > 0) {
        emit('files', valid);
    }
}

function openBrowser() {
    fileInputRef.value?.click();
}
</script>

<template>
    <div
        role="button"
        tabindex="0"
        :aria-label="isDragging ? 'Drop files here' : 'Click or drag to upload images'"
        class="relative rounded-xl border-2 border-dashed transition-all duration-200 p-10 text-center cursor-pointer select-none outline-none"
        :class="isDragging
            ? 'border-[#7B2FFF] bg-[#7B2FFF]/5 scale-[1.01]'
            : 'border-border hover:border-[#7B2FFF]/50 hover:bg-muted/40'"
        @dragover="onDragOver"
        @dragleave="onDragLeave"
        @drop="onDrop"
        @click="openBrowser"
        @keydown.enter="openBrowser"
        @keydown.space.prevent="openBrowser"
    >
        <input
            ref="fileInputRef"
            type="file"
            multiple
            accept="image/*"
            class="hidden"
            @change="onFileInput"
        />

        <div class="flex flex-col items-center gap-3 pointer-events-none">
            <div
                class="flex size-16 items-center justify-center rounded-full transition-colors"
                :class="isDragging ? 'bg-[#7B2FFF]/15' : 'bg-muted'"
            >
                <CloudUpload
                    class="h-8 w-8 transition-colors"
                    :class="isDragging ? 'text-[#7B2FFF]' : 'text-muted-foreground'"
                />
            </div>

            <div>
                <p class="font-medium text-sm">
                    <span v-if="isDragging" class="text-[#7B2FFF]">Drop your images</span>
                    <span v-else>
                        Drop images here or
                        <span class="text-[#7B2FFF] underline underline-offset-2">browse</span>
                    </span>
                </p>
                <p class="text-xs text-muted-foreground mt-1">
                    JPG · PNG · GIF · WEBP · SVG · TIFF &nbsp;·&nbsp; Max 100 MB &nbsp;·&nbsp; Up to 20 files
                </p>
                <p class="text-xs text-muted-foreground mt-0.5">
                    You can also paste an image with <kbd class="px-1 py-0.5 rounded border border-border bg-muted text-xs">Ctrl+V</kbd>
                </p>
            </div>
        </div>

        <!-- Drag overlay ring -->
        <div
            v-if="isDragging"
            class="absolute inset-2 rounded-lg border-2 border-[#7B2FFF]/40 pointer-events-none"
        />
    </div>
</template>
