<script setup lang="ts">
import { Head, Link, router } from '@inertiajs/vue3';
import { Download, Image as ImageIcon, Plus, Trash2, Upload } from 'lucide-vue-next';
import { computed, ref } from 'vue';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import {
    Dialog,
    DialogContent,
    DialogDescription,
    DialogFooter,
    DialogHeader,
    DialogTitle,
} from '@/components/ui/dialog';
import AppLayout from '@/layouts/AppLayout.vue';
import type { BreadcrumbItem } from '@/types';

const props = defineProps<{
    images: {
        data: App.ImageResource[];
        meta: { current_page: number; last_page: number; total: number };
        links: { next: string | null; prev: string | null };
    };
}>();

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Dashboard', href: '/dashboard' },
    { title: 'Images',    href: '/images'    },
];

// ─── Delete ───────────────────────────────────────────────────────────────────
const confirmDelete = ref<App.ImageResource | null>(null);
const deleting      = ref(false);

function openDelete(image: App.ImageResource) { confirmDelete.value = image; }
function cancelDelete()                       { confirmDelete.value = null;  }

function deleteImage() {
    if (!confirmDelete.value) return;
    deleting.value = true;
    router.delete(`/images/${confirmDelete.value.id}`, {
        onFinish: () => {
            deleting.value      = false;
            confirmDelete.value = null;
        },
    });
}

// ─── Bulk select + ZIP download ───────────────────────────────────────────────
const selected    = ref<Set<number>>(new Set());
const selectMode  = ref(false);
const downloading = ref(false);

const selectedCount = computed(() => selected.value.size);
const allSelected   = computed(() =>
    props.images.data.length > 0 &&
    selected.value.size === props.images.data.length
);

function toggleSelectMode() {
    selectMode.value = !selectMode.value;
    if (!selectMode.value) selected.value = new Set();
}

function toggleSelect(id: number) {
    const next = new Set(selected.value);
    next.has(id) ? next.delete(id) : next.add(id);
    selected.value = next;
}

function toggleAll() {
    selected.value = allSelected.value
        ? new Set()
        : new Set(props.images.data.map(i => i.id));
}

async function bulkDownload() {
    if (!selectedCount.value) return;
    downloading.value = true;

    try {
        const token = decodeURIComponent(
            document.cookie.match(/XSRF-TOKEN=([^;]+)/)?.[1] ?? ''
        );
        const res = await fetch('/images/bulk-download', {
            method: 'POST',
            headers: {
                'Content-Type':  'application/json',
                'X-XSRF-TOKEN':  token,
            },
            body: JSON.stringify({ ids: Array.from(selected.value) }),
        });

        if (!res.ok) throw new Error('Download failed');

        const blob = await res.blob();
        const url  = URL.createObjectURL(blob);
        const a    = document.createElement('a');
        a.href     = url;
        a.download = 'iris-images.zip';
        a.click();
        URL.revokeObjectURL(url);
        selected.value = new Set();
    } catch {
        alert('Failed to create ZIP. Please try again.');
    } finally {
        downloading.value = false;
    }
}
</script>

<template>
    <AppLayout :breadcrumbs="breadcrumbs">
        <Head title="Images" />

        <div class="px-4 py-6 md:px-8">
            <!-- Header -->
            <div class="flex items-center justify-between mb-6">
                <div>
                    <h1 class="text-2xl font-bold tracking-tight">Images</h1>
                    <p class="text-sm text-muted-foreground mt-1">
                        {{ images.meta.total }} image{{ images.meta.total !== 1 ? 's' : '' }} total
                    </p>
                </div>
                <div class="flex items-center gap-2">
                    <!-- Select mode toggle -->
                    <Button
                        v-if="images.data.length > 0"
                        variant="outline"
                        size="sm"
                        :class="selectMode ? 'border-[#7B2FFF] text-[#7B2FFF]' : ''"
                        @click="toggleSelectMode"
                    >
                        {{ selectMode ? 'Cancel' : 'Select' }}
                    </Button>

                    <template v-if="selectMode">
                        <Button variant="outline" size="sm" @click="toggleAll">
                            {{ allSelected ? 'Deselect all' : 'Select all' }}
                        </Button>
                        <Button
                            v-if="selectedCount > 0"
                            size="sm"
                            class="gap-2 bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF] text-white hover:opacity-90"
                            :disabled="downloading"
                            @click="bulkDownload"
                        >
                            <Download class="h-4 w-4" />
                            {{ downloading ? 'Zipping…' : `Download ${selectedCount}` }}
                        </Button>
                    </template>

                    <Link href="/images/create">
                        <Button class="gap-2 bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF] text-white hover:opacity-90">
                            <Plus class="h-4 w-4" />
                            Upload
                        </Button>
                    </Link>
                </div>
            </div>

            <!-- Empty state -->
            <div
                v-if="images.data.length === 0"
                class="flex flex-col items-center justify-center rounded-xl border border-dashed border-border py-24 text-center"
            >
                <div class="flex size-16 items-center justify-center rounded-full bg-muted mb-4">
                    <ImageIcon class="h-8 w-8 text-muted-foreground" />
                </div>
                <h3 class="text-lg font-semibold mb-1">No images yet</h3>
                <p class="text-sm text-muted-foreground mb-6 max-w-xs">Upload your first image to get started.</p>
                <Link href="/images/create">
                    <Button class="gap-2 bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF] text-white hover:opacity-90">
                        <Upload class="h-4 w-4" />
                        Upload images
                    </Button>
                </Link>
            </div>

            <!-- Image Grid -->
            <div v-else class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-4">
                <div
                    v-for="image in images.data"
                    :key="image.id"
                    class="group relative rounded-xl overflow-hidden border border-border bg-muted aspect-square"
                    :class="selectMode && selected.has(image.id)
                        ? 'ring-2 ring-[#7B2FFF] border-[#7B2FFF]'
                        : ''"
                    @click="selectMode ? toggleSelect(image.id) : null"
                >
                    <!-- Navigate only when not selecting -->
                    <Link v-if="!selectMode" :href="`/images/${image.id}`">
                        <img
                            :src="image.thumbnail_url"
                            :alt="image.name"
                            class="w-full h-full object-cover transition-transform duration-300 group-hover:scale-105"
                        />
                    </Link>
                    <img
                        v-else
                        :src="image.thumbnail_url"
                        :alt="image.name"
                        class="w-full h-full object-cover"
                    />

                    <!-- Checkbox (select mode) -->
                    <div
                        v-if="selectMode"
                        class="absolute top-2 left-2 flex size-5 items-center justify-center rounded-full border-2 transition-colors"
                        :class="selected.has(image.id)
                            ? 'border-[#7B2FFF] bg-[#7B2FFF]'
                            : 'border-white/80 bg-black/30'"
                    >
                        <svg v-if="selected.has(image.id)" class="h-3 w-3 text-white" viewBox="0 0 12 12" fill="none">
                            <path d="M2 6l3 3 5-5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                        </svg>
                    </div>

                    <!-- Selected tint -->
                    <div v-if="selectMode && selected.has(image.id)" class="absolute inset-0 bg-[#7B2FFF]/15 pointer-events-none" />

                    <!-- Hover overlay (non-select mode) -->
                    <div
                        v-if="!selectMode"
                        class="absolute inset-0 bg-black/50 opacity-0 group-hover:opacity-100 transition-opacity duration-200 flex flex-col justify-between p-3"
                    >
                        <div class="flex justify-end">
                            <button
                                @click.prevent.stop="openDelete(image)"
                                class="flex size-7 items-center justify-center rounded-full bg-red-500/90 hover:bg-red-500 text-white transition-colors"
                            >
                                <Trash2 class="h-3.5 w-3.5" />
                            </button>
                        </div>
                        <div>
                            <p class="text-white text-xs font-medium truncate">{{ image.name }}</p>
                            <p class="text-white/60 text-xs">{{ image.size_human }}</p>
                        </div>
                    </div>

                    <!-- Private badge -->
                    <div v-if="image.is_private && !selectMode" class="absolute top-2 left-2">
                        <Badge variant="secondary" class="text-xs px-1.5 py-0">Private</Badge>
                    </div>
                </div>
            </div>

            <!-- Pagination -->
            <div v-if="images.meta.last_page > 1" class="flex justify-center gap-2 mt-8">
                <Link v-if="images.links.prev" :href="images.links.prev">
                    <Button variant="outline" size="sm">Previous</Button>
                </Link>
                <span class="flex items-center text-sm text-muted-foreground px-3">
                    Page {{ images.meta.current_page }} of {{ images.meta.last_page }}
                </span>
                <Link v-if="images.links.next" :href="images.links.next">
                    <Button variant="outline" size="sm">Next</Button>
                </Link>
            </div>
        </div>

        <!-- Delete Confirmation Dialog -->
        <Dialog :open="!!confirmDelete" @update:open="cancelDelete">
            <DialogContent>
                <DialogHeader>
                    <DialogTitle>Delete image</DialogTitle>
                    <DialogDescription>
                        Are you sure you want to delete <strong>{{ confirmDelete?.name }}</strong>?
                        This action cannot be undone and all shared links will also be removed.
                    </DialogDescription>
                </DialogHeader>
                <DialogFooter>
                    <Button variant="outline" @click="cancelDelete">Cancel</Button>
                    <Button variant="destructive" :disabled="deleting" @click="deleteImage">
                        {{ deleting ? 'Deleting...' : 'Delete' }}
                    </Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>
    </AppLayout>
</template>