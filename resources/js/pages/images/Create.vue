<script setup lang="ts">
import { Head, router } from '@inertiajs/vue3';
import { CloudUpload, File, X, Zap } from 'lucide-vue-next';
import { reactive, ref } from 'vue';
import { Button } from '@/components/ui/button';
import { Label } from '@/components/ui/label';
import { Switch } from '@/components/ui/switch';
import AppLayout from '@/layouts/AppLayout.vue';
import CompressionOptions from '@/components/Upload/CompressionOptions.vue';
import { useCompression } from '@/composables/useCompression';
import type { CompressionOptions as COpts } from '@/composables/useCompression';
import type { BreadcrumbItem } from '@/types';

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Dashboard', href: '/dashboard' },
    { title: 'Images',    href: '/images'    },
    { title: 'Upload',    href: '/images/create' },
];

const { compressAll, compressing, formatSize } = useCompression();

// ─── Files ────────────────────────────────────────────────────────────────────
const files      = ref<File[]>([]);
const previews   = ref<string[]>([]);
const isDragging = ref(false);
const errors     = ref<string[]>([]);

const allowedTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp', 'image/svg+xml', 'image/tiff'];
const maxSize      = 100 * 1024 * 1024;

function onDragOver(e: DragEvent) { e.preventDefault(); isDragging.value = true; }
function onDragLeave()             { isDragging.value = false; }

function onDrop(e: DragEvent) {
    e.preventDefault();
    isDragging.value = false;
    if (e.dataTransfer?.files) addFiles(Array.from(e.dataTransfer.files));
}

function onFileInput(e: Event) {
    const input = e.target as HTMLInputElement;
    if (input.files) addFiles(Array.from(input.files));
}

function onPaste(e: ClipboardEvent) {
    const items = Array.from(e.clipboardData?.items ?? [])
        .filter(i => i.kind === 'file' && i.type.startsWith('image/'))
        .map(i => i.getAsFile())
        .filter(Boolean) as File[];
    addFiles(items);
}

function addFiles(newFiles: File[]) {
    errors.value = [];
    for (const file of newFiles) {
        if (!allowedTypes.includes(file.type)) {
            errors.value.push(`${file.name}: unsupported file type.`);
            continue;
        }
        if (file.size > maxSize) {
            errors.value.push(`${file.name}: exceeds 100MB limit.`);
            continue;
        }
        if (files.value.length >= 20) {
            errors.value.push('Maximum 20 images per upload.');
            break;
        }
        files.value.push(file);
        const reader = new FileReader();
        reader.onload = (e) => previews.value.push(e.target?.result as string);
        reader.readAsDataURL(file);
    }
}

function removeFile(index: number) {
    files.value.splice(index, 1);
    previews.value.splice(index, 1);
}

// ─── Settings ─────────────────────────────────────────────────────────────────
const isPrivate = ref(false);
const stripExif = ref(true);

const compressionOpts = reactive<COpts>({
    enabled:   true,
    quality:   0.8,
    maxWidth:  0,
    maxHeight: 0,
});

// ─── Upload ───────────────────────────────────────────────────────────────────
const uploading = ref(false);
const savings   = ref<{ saved: number; total: number } | null>(null);

async function upload() {
    if (!files.value.length || uploading.value) return;
    uploading.value = true;
    errors.value    = [];
    savings.value   = null;

    // Compress
    let totalOriginal   = 0;
    let totalCompressed = 0;

    const results = await compressAll(files.value, compressionOpts);
    results.forEach(r => {
        totalOriginal   += r.originalSize;
        totalCompressed += r.compressedSize;
    });

    if (totalOriginal - totalCompressed > 0) {
        savings.value = { saved: totalOriginal - totalCompressed, total: totalOriginal };
    }

    // Build form and post
    const formData = new FormData();
    results.forEach((r, i) => formData.append(`images[${i}]`, r.file));
    formData.append('is_private', isPrivate.value ? '1' : '0');
    formData.append('strip_exif',  stripExif.value  ? '1' : '0');

    router.post('/images', formData, {
        forceFormData: true,
        onError: (e) => {
            errors.value    = Object.values(e).flat() as string[];
            uploading.value = false;
        },
        onFinish: () => { uploading.value = false; },
    });
}
</script>

<template>
    <AppLayout :breadcrumbs="breadcrumbs">
        <Head title="Upload Images" />

        <div class="max-w-3xl mx-auto px-4 py-8" @paste="onPaste">
            <h1 class="text-2xl font-bold tracking-tight mb-1">Upload images</h1>
            <p class="text-sm text-muted-foreground mb-6">
                Drag & drop, paste from clipboard, or click to browse. Up to 20 images, 100MB each.
            </p>

            <!-- Dropzone -->
            <div
                class="relative rounded-xl border-2 border-dashed transition-colors duration-200 p-10 text-center cursor-pointer mb-6"
                :class="isDragging
                    ? 'border-[#7B2FFF] bg-[#7B2FFF]/5'
                    : 'border-border hover:border-[#7B2FFF]/50 hover:bg-muted/50'"
                @dragover="onDragOver"
                @dragleave="onDragLeave"
                @drop="onDrop"
                @click="($refs.fileInput as HTMLInputElement).click()"
            >
                <input
                    ref="fileInput"
                    type="file"
                    multiple
                    accept="image/*"
                    class="hidden"
                    @change="onFileInput"
                />
                <div class="flex flex-col items-center gap-3">
                    <div class="flex size-14 items-center justify-center rounded-full bg-muted">
                        <CloudUpload class="h-7 w-7 text-muted-foreground" />
                    </div>
                    <div>
                        <p class="font-medium text-sm">
                            Drop images here or <span class="text-[#7B2FFF]">browse</span>
                        </p>
                        <p class="text-xs text-muted-foreground mt-1">
                            JPG, PNG, GIF, WEBP, SVG, TIFF · Max 100MB · Up to 20 files
                        </p>
                        <p class="text-xs text-muted-foreground mt-0.5">
                            You can also paste an image with Ctrl+V
                        </p>
                    </div>
                </div>
            </div>

            <!-- Errors -->
            <div v-if="errors.length" class="mb-4 rounded-lg border border-destructive/50 bg-destructive/10 p-3">
                <p v-for="error in errors" :key="error" class="text-sm text-destructive">{{ error }}</p>
            </div>

            <!-- Previews -->
            <div v-if="files.length" class="grid grid-cols-3 sm:grid-cols-4 gap-3 mb-6">
                <div
                    v-for="(preview, index) in previews"
                    :key="index"
                    class="group relative rounded-lg overflow-hidden border border-border aspect-square bg-muted"
                >
                    <img :src="preview" class="w-full h-full object-cover" />
                    <div class="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center">
                        <button
                            @click.stop="removeFile(index)"
                            class="flex size-8 items-center justify-center rounded-full bg-red-500 text-white hover:bg-red-600"
                        >
                            <X class="h-4 w-4" />
                        </button>
                    </div>
                    <div class="absolute bottom-1 left-1 right-1">
                        <p class="text-white text-xs truncate bg-black/40 rounded px-1">
                            {{ files[index].name }}
                        </p>
                    </div>
                </div>
            </div>

            <!-- Compression savings banner -->
            <div
                v-if="savings"
                class="mb-4 flex items-center gap-2 rounded-lg border border-green-500/20 bg-green-500/10 px-4 py-2.5 text-sm"
            >
                <Zap class="h-4 w-4 text-green-500 shrink-0" />
                <span class="text-green-600 font-medium">
                    Saved {{ formatSize(savings.saved) }}
                    ({{ Math.round(savings.saved / savings.total * 100) }}%) via compression
                </span>
            </div>

            <!-- Options -->
            <div class="space-y-4 mb-6">
                <!-- Compression -->
                <CompressionOptions
                    :options="compressionOpts"
                    @update:options="Object.assign(compressionOpts, $event)"
                />

                <!-- Upload options -->
                <div class="rounded-xl border border-border p-4 space-y-4">
                    <h3 class="text-sm font-semibold">Upload options</h3>
                    <div class="flex items-center justify-between">
                        <div>
                            <Label class="font-medium">Strip EXIF data</Label>
                            <p class="text-xs text-muted-foreground">Remove GPS, camera info from images</p>
                        </div>
                        <Switch v-model:checked="stripExif" />
                    </div>
                    <div class="flex items-center justify-between">
                        <div>
                            <Label class="font-medium">Private</Label>
                            <p class="text-xs text-muted-foreground">Only you can see these images</p>
                        </div>
                        <Switch v-model:checked="isPrivate" />
                    </div>
                </div>
            </div>

            <!-- Submit -->
            <Button
                class="w-full gap-2 bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF] text-white hover:opacity-90"
                :disabled="files.length === 0 || uploading || compressing"
                @click="upload"
            >
                <Zap v-if="compressing" class="h-4 w-4 animate-pulse" />
                <File v-else class="h-4 w-4" />
                {{
                    compressing ? 'Compressing...'
                    : uploading  ? 'Uploading...'
                    : files.length > 0
                        ? `Upload ${files.length} image${files.length > 1 ? 's' : ''}`
                        : 'Upload'
                }}
            </Button>
        </div>
    </AppLayout>
</template>