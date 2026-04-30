<script setup lang="ts">
import { Head, Link, router } from '@inertiajs/vue3';
import { Download, Image as ImageIcon, Plus, Trash2, Upload, GripVertical, Search, Tag, X, Check, Droplets } from 'lucide-vue-next';
import { computed, ref, watch } from 'vue';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import {
    Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle,
} from '@/components/ui/dialog';
import {
    Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
} from '@/components/ui/select';
import AppLayout from '@/layouts/AppLayout.vue';
import { useDraggable } from '@/composables/useDraggable';
import type { BreadcrumbItem } from '@/types';

const props = defineProps<{
    images: {
        data: App.ImageResource[];
        meta: { current_page: number; last_page: number; total: number };
        links: { next: string | null; prev: string | null };
    };
    filters?: {
        search?: string;
    };
}>();

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Dashboard', href: '/dashboard' },
    { title: 'Images',    href: '/images'    },
];

const confirmDelete = ref<App.ImageResource | null>(null);
const deleting      = ref(false);

function openDelete(image: App.ImageResource) { confirmDelete.value = image; }
function cancelDelete()                       { confirmDelete.value = null;  }

function deleteImage() {
    if (!confirmDelete.value) return;
    deleting.value = true;
    router.delete(`/images/${confirmDelete.value.id}`, {
        onFinish: () => { deleting.value = false; confirmDelete.value = null; },
    });
}

const selected     = ref<Set<number>>(new Set());
const selectMode   = ref(false);
const bulkDeleting = ref(false);

const selectedCount = computed(() => selected.value.size);
const allSelected   = computed(() => props.images.data.length > 0 && selected.value.size === props.images.data.length);

function toggleSelectMode() {
    selectMode.value = !selectMode.value;
    if (!selectMode.value) {
        selected.value = new Set();
        showBatchTagPanel.value = false;
    }
}

function toggleSelect(id: number) {
    const next = new Set(selected.value);
    next.has(id) ? next.delete(id) : next.add(id);
    selected.value = next;
}

function toggleAll() {
    selected.value = allSelected.value ? new Set() : new Set(props.images.data.map(i => i.id));
}

// ─── Bulk Download + Watermark Modal ─────────────────────────────────────────
const showDownloadModal  = ref(false);
const downloading        = ref(false);
const useWatermark       = ref(false);
const wmTextType         = ref<'username' | 'site_name' | 'custom'>('site_name');
const wmCustomText       = ref('');
const wmPosition         = ref('bottom-right');
const wmOpacity          = ref<number>(60);

function closeDownloadModal() {
    showDownloadModal.value = false;
    useWatermark.value      = false;
    wmCustomText.value      = '';
    wmTextType.value        = 'site_name';
    wmPosition.value        = 'bottom-right';
    wmOpacity.value         = 60;
}

const positionOptions = [
    { label: 'Bottom right', value: 'bottom-right' },
    { label: 'Bottom left',  value: 'bottom-left'  },
    { label: 'Top right',    value: 'top-right'    },
    { label: 'Top left',     value: 'top-left'     },
    { label: 'Center',       value: 'center'       },
];

const textTypeOptions = [
    { label: 'Site name',     value: 'site_name' },
    { label: 'My username',   value: 'username'  },
    { label: 'Custom text',   value: 'custom'    },
];

function openDownloadModal() {
    if (!selectedCount.value) return;
    showDownloadModal.value = true;
}

async function bulkDownload() {
    if (!selectedCount.value) return;
    downloading.value = true;

    try {
        const token = decodeURIComponent(document.cookie.match(/XSRF-TOKEN=([^;]+)/)?.[1] ?? '');

        const payload: Record<string, any> = {
            ids: Array.from(selected.value),
        };

        if (useWatermark.value) {
            payload.watermark           = true;
            payload.watermark_text_type = wmTextType.value;
            payload.watermark_position  = wmPosition.value;
            payload.watermark_opacity   = parseInt(String(wmOpacity.value), 10);
            if (wmTextType.value === 'custom') {
                payload.watermark_text = wmCustomText.value;
            }
        }

        const res = await fetch('/images/bulk-download', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json', 'X-XSRF-TOKEN': token },
            body: JSON.stringify(payload),
        });

        if (!res.ok) throw new Error('Download failed');

        const blob        = await res.blob();
        const url         = URL.createObjectURL(blob);
        const a           = document.createElement('a');
        const contentDisp = res.headers.get('content-disposition');
        const filename    = contentDisp?.match(/filename="?([^"]+)"?/)?.[1] ?? 'iris-images.zip';
        a.href     = url;
        a.download = filename;
        a.click();
        URL.revokeObjectURL(url);

        selected.value = new Set();
        closeDownloadModal();
    } catch {
        alert('Failed to download images.');
    } finally {
        downloading.value = false;
    }
}

function bulkDelete() {
    if (!selectedCount.value) return;
    if (!confirm(`Delete ${selectedCount.value} image(s)? This cannot be undone.`)) return;
    bulkDeleting.value = true;
    router.delete('/images/bulk', {
        data: { ids: Array.from(selected.value) },
        preserveScroll: true,
        onFinish: () => { bulkDeleting.value = false; selected.value = new Set(); },
    });
}

// ─── Search ──────────────────────────────────────────────────────────────────
const searchQuery = ref(props.filters?.search ?? '');
const searchInput = ref<HTMLInputElement | null>(null);
let searchTimeout: ReturnType<typeof setTimeout> | null = null;

watch(searchQuery, (val) => {
    if (searchTimeout) clearTimeout(searchTimeout);
    searchTimeout = setTimeout(() => {
        router.get('/images', { search: val || undefined }, {
            preserveState: true,
            preserveScroll: true,
            replace: true,
            only: ['images', 'filters'],
        });
    }, 300);
});

// ─── Batch Tagging ───────────────────────────────────────────────────────────
const showBatchTagPanel = ref(false);
const batchTagInput     = ref('');
const batchTagAction    = ref<'add' | 'remove'>('add');
const batchTagging      = ref(false);

function openBatchTag() {
    showBatchTagPanel.value = true;
}

function closeBatchTag() {
    showBatchTagPanel.value = false;
    batchTagInput.value = '';
}

function applyBatchTags() {
    const tags = batchTagInput.value
        .split(',')
        .map(t => t.trim())
        .filter(t => t.length > 0);

    if (!tags.length || !selectedCount.value) return;

    batchTagging.value = true;
    router.post('/images/batch-tag', {
        ids: Array.from(selected.value),
        tags,
        action: batchTagAction.value,
    }, {
        preserveScroll: true,
        onFinish: () => {
            batchTagging.value = false;
            batchTagInput.value = '';
            selected.value = new Set();
            selectMode.value = false;
            showBatchTagPanel.value = false;
        },
    });
}

const gridRef    = ref<HTMLElement | null>(null);
const imagesList = ref([...props.images.data]);

const { draggedIndex, dragOverIndex, handleDragStart, handleDragOver, handleDrop, handleDragEnd } = useDraggable(
    gridRef,
    imagesList,
    {
        onReorder: (orderedIds) => {
            router.post('/images/reorder', { ordered_ids: orderedIds }, {
                preserveScroll: true,
                preserveState: true,
            });
        }
    }
);
</script>

<template>
    <AppLayout :breadcrumbs="breadcrumbs">
        <Head title="Images" />
        <div class="px-4 py-6 md:px-8">
            <!-- Header -->
            <div class="flex items-center justify-between mb-6">
                <div>
                    <h1 class="text-2xl font-bold tracking-tight">Images</h1>
                    <p class="text-sm text-muted-foreground mt-1">{{ images.meta.total }} image{{ images.meta.total !== 1 ? 's' : '' }} total</p>
                </div>
                <div class="flex items-center gap-2">
                    <Button v-if="images.data.length > 0" variant="outline" size="sm"
                            :class="selectMode ? 'border-violet-500 text-violet-500' : ''"
                            @click="toggleSelectMode">
                        {{ selectMode ? 'Cancel' : 'Select' }}
                    </Button>

                    <template v-if="selectMode">
                        <Button variant="outline" size="sm" @click="toggleAll">
                            {{ allSelected ? 'Deselect all' : 'Select all' }}
                        </Button>
                        <Button v-if="selectedCount > 0" variant="outline" size="sm" class="gap-2 text-amber-400 border-amber-400/30 hover:bg-amber-500/10"
                                @click="openBatchTag">
                            <Tag class="h-4 w-4" />
                            Tag {{ selectedCount }}
                        </Button>
                        <Button v-if="selectedCount > 0" variant="outline" size="sm" class="gap-2 text-rose-400 border-rose-400/30 hover:bg-rose-500/10"
                                :disabled="bulkDeleting" @click="bulkDelete">
                            <Trash2 class="h-4 w-4" />
                            {{ bulkDeleting ? 'Deleting...' : `Delete ${selectedCount}` }}
                        </Button>
                        <Button v-if="selectedCount > 0" size="sm" class="gap-2 bg-gradient-to-r from-violet-500 to-cyan-400 text-white hover:opacity-90"
                                @click="openDownloadModal">
                            <Download class="h-4 w-4" />
                            Download {{ selectedCount }}
                        </Button>
                    </template>

                    <Link href="/images/create">
                        <Button class="gap-2 bg-gradient-to-r from-violet-500 to-cyan-400 text-white hover:opacity-90">
                            <Plus class="h-4 w-4" />
                            Upload
                        </Button>
                    </Link>
                </div>
            </div>

            <!-- Search bar -->
            <div class="relative mb-6">
                <Search class="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                <Input
                    ref="searchInput"
                    v-model="searchQuery"
                    placeholder="Search by name, caption, alt text, or tag..."
                    class="pl-10 w-full max-w-md"
                />
                <button
                    v-if="searchQuery"
                    @click="searchQuery = ''"
                    class="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-foreground"
                >
                    <X class="h-4 w-4" />
                </button>
            </div>

            <!-- Empty state -->
            <div v-if="images.data.length === 0" class="flex flex-col items-center justify-center rounded-xl border border-dashed border-border py-24 text-center">
                <div class="flex size-16 items-center justify-center rounded-full bg-muted mb-4">
                    <ImageIcon class="h-8 w-8 text-muted-foreground" />
                </div>
                <h3 class="text-lg font-semibold mb-1">
                    {{ searchQuery ? 'No images found' : 'No images yet' }}
                </h3>
                <p class="text-sm text-muted-foreground mb-6">
                    {{ searchQuery ? 'Try a different search term.' : 'Upload your first image to get started.' }}
                </p>
                <Link v-if="!searchQuery" href="/images/create">
                    <Button class="gap-2 bg-gradient-to-r from-violet-500 to-cyan-400 text-white hover:opacity-90">
                        <Upload class="h-4 w-4" />
                        Upload images
                    </Button>
                </Link>
            </div>

            <!-- Image grid -->
            <div v-else ref="gridRef" class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-4">
                <div
                    v-for="(image, index) in imagesList"
                    :key="image.id"
                    :draggable="!selectMode"
                    @dragstart="!selectMode && handleDragStart($event, index)"
                    @dragover.prevent="!selectMode && handleDragOver($event, index)"
                    @drop="!selectMode && handleDrop($event, index)"
                    @dragend="!selectMode && handleDragEnd"
                    class="group relative rounded-xl overflow-hidden border border-border bg-muted aspect-square"
                    :class="{
                        'cursor-move': !selectMode,
                        'cursor-pointer': selectMode,
                        'ring-2 ring-violet-500 opacity-50': draggedIndex === index,
                        'ring-2 ring-cyan-400': dragOverIndex === index && dragOverIndex !== draggedIndex,
                        'ring-2 ring-[#7B2FFF] border-[#7B2FFF]': selectMode && selected.has(image.id),
                    }"
                    @click="selectMode ? toggleSelect(image.id) : null"
                >
                    <Link v-if="!selectMode" :href="`/images/${image.id}`" class="block w-full h-full">
                        <img :src="image.thumbnail_url" :alt="image.name" class="w-full h-full object-cover transition-transform duration-300 group-hover:scale-105" />
                    </Link>
                    <img v-else :src="image.thumbnail_url" :alt="image.name" class="w-full h-full object-cover" />

                    <!-- Tags overlay -->
                    <div v-if="!selectMode && image.tags?.length" class="absolute top-2 left-2 right-2 flex flex-wrap gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
                        <Badge v-for="tag in image.tags.slice(0, 3)" :key="tag.id" variant="secondary" class="text-[10px] px-1.5 py-0 h-4 bg-black/60 text-white border-0">
                            {{ tag.name }}
                        </Badge>
                        <Badge v-if="image.tags.length > 3" variant="secondary" class="text-[10px] px-1.5 py-0 h-4 bg-black/60 text-white border-0">
                            +{{ image.tags.length - 3 }}
                        </Badge>
                    </div>

                    <!-- Selection checkbox -->
                    <div v-if="selectMode" class="absolute top-2 left-2 flex size-5 items-center justify-center rounded-full border-2 transition-colors"
                         :class="selected.has(image.id) ? 'border-[#7B2FFF] bg-[#7B2FFF]' : 'border-white/80 bg-black/30'">
                        <svg v-if="selected.has(image.id)" class="h-3 w-3 text-white" viewBox="0 0 12 12" fill="none">
                            <path d="M2 6l3 3 5-5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                        </svg>
                    </div>

                    <div v-if="selectMode && selected.has(image.id)" class="absolute inset-0 bg-[#7B2FFF]/15 pointer-events-none" />

                    <!-- Hover actions -->
                    <div v-if="!selectMode" class="absolute inset-0 bg-black/50 opacity-0 group-hover:opacity-100 transition-opacity duration-200 flex flex-col justify-between p-3">
                        <div class="flex justify-end">
                            <button @click.prevent.stop="openDelete(image)" class="flex size-7 items-center justify-center rounded-full bg-red-500/90 hover:bg-red-500 text-white transition-colors">
                                <Trash2 class="h-3.5 w-3.5" />
                            </button>
                        </div>
                        <div>
                            <p class="text-white text-xs font-medium truncate">{{ image.name }}</p>
                            <p class="text-white/60 text-xs">{{ image.size_human }}</p>
                        </div>
                    </div>

                    <div v-if="image.is_private && !selectMode" class="absolute top-2 right-2">
                        <Badge variant="secondary" class="text-xs px-1.5 py-0">Private</Badge>
                    </div>

                    <div v-if="!selectMode" class="absolute bottom-2 left-2 opacity-0 group-hover:opacity-100 transition-opacity">
                        <GripVertical class="h-4 w-4 text-white/60" />
                    </div>
                </div>
            </div>

            <!-- Pagination -->
            <div v-if="images.meta.last_page > 1" class="flex justify-center gap-2 mt-8">
                <Link v-if="images.links.prev" :href="images.links.prev">
                    <Button variant="outline" size="sm">Previous</Button>
                </Link>
                <span class="flex items-center text-sm text-muted-foreground px-3">Page {{ images.meta.current_page }} of {{ images.meta.last_page }}</span>
                <Link v-if="images.links.next" :href="images.links.next">
                    <Button variant="outline" size="sm">Next</Button>
                </Link>
            </div>
        </div>

        <!-- Delete Dialog -->
        <Dialog :open="!!confirmDelete" @update:open="cancelDelete">
            <DialogContent>
                <DialogHeader>
                    <DialogTitle>Delete image</DialogTitle>
                    <DialogDescription>Are you sure you want to delete <strong>{{ confirmDelete?.name }}</strong>? This action cannot be undone.</DialogDescription>
                </DialogHeader>
                <DialogFooter>
                    <Button variant="outline" @click="cancelDelete">Cancel</Button>
                    <Button variant="destructive" :disabled="deleting" @click="deleteImage">{{ deleting ? 'Deleting...' : 'Delete' }}</Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>

        <!-- Bulk Download + Watermark Modal -->
        <Dialog :open="showDownloadModal" @update:open="(val) => { if (!val) closeDownloadModal(); }">
            <DialogContent class="sm:max-w-md">
                <DialogHeader>
                    <DialogTitle>Download {{ selectedCount }} image{{ selectedCount !== 1 ? 's' : '' }}</DialogTitle>
                    <DialogDescription>
                        {{ selectedCount > 1 ? 'Images will be packaged into a ZIP file.' : 'Your image will be downloaded directly.' }}
                    </DialogDescription>
                </DialogHeader>

                <div class="space-y-4 py-2">
                    <!-- Watermark toggle -->
                    <div class="flex items-center justify-between">
                        <div>
                            <Label class="text-sm font-medium">Add watermark</Label>
                            <p class="text-xs text-muted-foreground">Embed text into downloaded images</p>
                        </div>
                        <button
                            type="button"
                            role="switch"
                            :aria-checked="useWatermark"
                            class="relative inline-flex h-6 w-11 shrink-0 cursor-pointer items-center rounded-full border-2 border-transparent transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 focus-visible:ring-offset-background"
                            :class="useWatermark ? 'bg-violet-500' : 'bg-input'"
                            @click.stop="useWatermark = !useWatermark"
                        >
                            <span
                                class="pointer-events-none block h-5 w-5 rounded-full bg-background shadow-lg ring-0 transition-transform"
                                :class="useWatermark ? 'translate-x-5' : 'translate-x-0'"
                            />
                        </button>
                    </div>

                    <!-- Watermark options — v-show keeps DOM stable, no focus-trap re-trigger -->
                    <div v-show="useWatermark" class="space-y-3 pt-3 border-t border-border">
                        <!-- Text type selector -->
                        <div class="space-y-1.5">
                            <Label class="text-xs text-muted-foreground">Watermark text</Label>
                            <div class="flex rounded-lg border border-border overflow-hidden">
                                <button
                                    v-for="opt in textTypeOptions"
                                    :key="opt.value"
                                    type="button"
                                    @click.stop="wmTextType = opt.value as any"
                                    class="flex-1 px-2 py-1.5 text-xs font-medium transition-colors"
                                    :class="wmTextType === opt.value ? 'bg-violet-500 text-white' : 'bg-muted hover:bg-muted/80 text-muted-foreground'"
                                >
                                    {{ opt.label }}
                                </button>
                            </div>
                        </div>

                        <!-- Custom text input -->
                        <div v-show="wmTextType === 'custom'" class="space-y-1">
                            <Input
                                v-model="wmCustomText"
                                placeholder="e.g. © Your Name 2026"
                                maxlength="60"
                                class="text-sm"
                            />
                        </div>

                        <!-- Position -->
                        <div class="space-y-1.5">
                            <Label class="text-xs text-muted-foreground">Position</Label>
                            <Select v-model="wmPosition">
                                <SelectTrigger class="h-8 text-sm"><SelectValue /></SelectTrigger>
                                <SelectContent>
                                    <SelectItem v-for="opt in positionOptions" :key="opt.value" :value="opt.value">
                                        {{ opt.label }}
                                    </SelectItem>
                                </SelectContent>
                            </Select>
                        </div>

                        <!-- Opacity -->
                        <div class="space-y-1.5">
                            <div class="flex justify-between">
                                <Label class="text-xs text-muted-foreground">Opacity</Label>
                                <span class="text-xs text-muted-foreground">{{ wmOpacity }}%</span>
                            </div>
                            <input v-model="wmOpacity" type="range" min="10" max="100" step="5" class="w-full accent-violet-500" />
                        </div>
                    </div>
                </div>

                <DialogFooter>
                    <Button variant="outline" @click="closeDownloadModal">Cancel</Button>
                    <Button
                        class="gap-2 bg-gradient-to-r from-violet-500 to-cyan-400 text-white hover:opacity-90"
                        :disabled="downloading || (useWatermark && wmTextType === 'custom' && !wmCustomText.trim())"
                        @click="bulkDownload"
                    >
                        <Droplets v-if="useWatermark" class="h-4 w-4" />
                        <Download v-else class="h-4 w-4" />
                        {{ downloading ? 'Preparing...' : useWatermark ? 'Download with watermark' : 'Download' }}
                    </Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>

        <!-- Batch Tag Slide-up Panel -->
        <Transition
            enter-active-class="transition-transform duration-300 ease-out"
            enter-from-class="translate-y-full"
            enter-to-class="translate-y-0"
            leave-active-class="transition-transform duration-200 ease-in"
            leave-from-class="translate-y-0"
            leave-to-class="translate-y-full"
        >
            <div v-if="showBatchTagPanel" class="fixed bottom-0 left-0 right-0 z-50 bg-card border-t border-border shadow-2xl p-4 md:p-6">
                <div class="max-w-3xl mx-auto space-y-4">
                    <div class="flex items-center justify-between">
                        <div class="flex items-center gap-2">
                            <Tag class="h-5 w-5 text-violet-400" />
                            <h3 class="text-sm font-semibold">Batch tag {{ selectedCount }} image(s)</h3>
                        </div>
                        <button @click="closeBatchTag" class="text-muted-foreground hover:text-foreground">
                            <X class="h-5 w-5" />
                        </button>
                    </div>

                    <div class="flex flex-col sm:flex-row gap-3">
                        <div class="flex-1 space-y-1">
                            <label class="text-xs text-muted-foreground">Tags (comma-separated)</label>
                            <Input
                                v-model="batchTagInput"
                                placeholder="e.g. nature, vacation, 2026"
                                class="w-full"
                                @keydown.enter.prevent="applyBatchTags"
                            />
                        </div>
                        <div class="flex items-end gap-2">
                            <div class="flex rounded-lg border border-border overflow-hidden">
                                <button
                                    @click="batchTagAction = 'add'"
                                    class="px-3 py-2 text-xs font-medium transition-colors"
                                    :class="batchTagAction === 'add' ? 'bg-violet-500 text-white' : 'bg-muted hover:bg-muted/80'"
                                >
                                    Add
                                </button>
                                <button
                                    @click="batchTagAction = 'remove'"
                                    class="px-3 py-2 text-xs font-medium transition-colors"
                                    :class="batchTagAction === 'remove' ? 'bg-rose-500 text-white' : 'bg-muted hover:bg-muted/80'"
                                >
                                    Remove
                                </button>
                            </div>
                            <Button
                                class="bg-gradient-to-r from-violet-500 to-cyan-400 text-white hover:opacity-90"
                                :disabled="batchTagging || !batchTagInput.trim()"
                                @click="applyBatchTags"
                            >
                                <Check v-if="batchTagging" class="h-4 w-4 animate-spin" />
                                <Tag v-else class="h-4 w-4" />
                                {{ batchTagging ? 'Applying...' : 'Apply' }}
                            </Button>
                        </div>
                    </div>
                    <p class="text-xs text-muted-foreground">
                        Tags will be created automatically if they don't exist. Use "Remove" to detach tags from selected images.
                    </p>
                </div>
            </div>
        </Transition>
    </AppLayout>
</template>