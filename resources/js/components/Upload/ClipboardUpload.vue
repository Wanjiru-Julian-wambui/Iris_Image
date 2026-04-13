<script setup lang="ts">
import { ClipboardPaste } from 'lucide-vue-next';
import { onMounted, onUnmounted, ref } from 'vue';

const emit = defineEmits<{
    files: [files: File[]];
}>();

const flash = ref(false);

function onPaste(e: ClipboardEvent) {
    const items = e.clipboardData?.items;

    if (!items) {
        return;
    }

    const imageFiles = Array.from(items)
        .filter(i => i.kind === 'file' && i.type.startsWith('image/'))
        .map(i => i.getAsFile())
        .filter(Boolean) as File[];

    if (imageFiles.length > 0) {
        flash.value = true;
        setTimeout(() => {
            flash.value = false;
        }, 600);
        emit('files', imageFiles);
    }
}

onMounted(() => window.addEventListener('paste', onPaste));
onUnmounted(() => window.removeEventListener('paste', onPaste));
</script>

<template>
    <div
        class="flex items-center gap-3 rounded-xl border border-dashed px-4 py-3 transition-colors text-sm cursor-default select-none"
        :class="flash
            ? 'border-[#7B2FFF] bg-[#7B2FFF]/10 text-[#7B2FFF]'
            : 'border-border text-muted-foreground'"
    >
        <ClipboardPaste
            class="h-4 w-4 shrink-0 transition-colors"
            :class="flash ? 'text-[#7B2FFF]' : 'text-muted-foreground'"
        />
        <span v-if="flash" class="font-medium text-[#7B2FFF]">Image pasted!</span>
        <span v-else>
            Press <kbd class="px-1.5 py-0.5 rounded border border-border bg-muted text-xs mx-0.5">Ctrl+V</kbd> anywhere to paste an image from your clipboard
        </span>
    </div>
</template>
