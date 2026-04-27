<script setup lang="ts">
import { Head, Link, router } from '@inertiajs/vue3';
import { ArrowLeft, Pencil, Trash2, Lock, Globe, Link as LinkIcon, GripVertical, X, Plus } from 'lucide-vue-next';
import { ref } from 'vue';
import AppLayout from '@/layouts/AppLayout.vue';
import { Button } from '@/components/ui/button';
import {
    Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle,
} from '@/components/ui/dialog';
import { useDraggable } from '@/composables/useDraggable';
import type { BreadcrumbItem } from '@/types';

const props = defineProps<{
    album: {
        id: number;
        name: string;
        slug: string;
        description: string | null;
        is_public: boolean;
        has_password: boolean;
        public_url: string;
        public_token: string;
        cover_image: { thumbnail_url: string } | null;
        images_count: number;
    };
    images: { data: App.ImageResource[] };
}>();

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Dashboard', href: '/dashboard' },
    { title: 'Albums',    href: '/albums'    },
    { title: props.album.name, href: `/albums/${props.album.id}` },
];

const showDeleteDialog = ref(false);
const deleting = ref(false);
const copied = ref(false);

function deleteAlbum() {
    deleting.value = true;
    router.delete(`/albums/${props.album.id}`, {
        onFinish: () => { deleting.value = false; showDeleteDialog.value = false; },
    });
}

function copyPublicUrl() {
    navigator.clipboard.writeText(props.album.public_url);
    copied.value = true;
    setTimeout(() => copied.value = false, 2000);
}

function removeImage(imageId: number) {
    if (!confirm('Remove this image from the album?')) return;
    router.delete(`/albums/${props.album.id}/images/${imageId}`, { preserveScroll: true });
}

// Drag to reorder
const gridRef = ref<HTMLElement | null>(null);
const imagesList = ref([...props.images.data]);

const { draggedIndex, dragOverIndex, handleDragStart, handleDragOver, handleDrop, handleDragEnd } = useDraggable(
    gridRef,
    imagesList,
    {
        onReorder: (orderedIds) => {
            router.post(`/albums/${props.album.id}/reorder`, { ordered_ids: orderedIds }, {
                preserveScroll: true,
                preserveState: true,
            });
        }
    }
);
</script>

<template>
    <Head :title="album.name" />
    <AppLayout :breadcrumbs="breadcrumbs">
        <div class="px-4 py-6 md:px-8">
            <!-- Header -->
            <div class="flex items-start justify-between mb-6">
                <div class="flex items-center gap-4">
                    <Link href="/albums">
                        <Button variant="ghost" size="sm" class="gap-2">
                            <ArrowLeft class="h-4 w-4" />
                            Back
                        </Button>
                    </Link>
                    <div>
                        <div class="flex items-center gap-2">
                            <h1 class="text-2xl font-bold tracking-tight">{{ album.name }}</h1>
                            <Lock v-if="album.has_password" class="h-4 w-4 text-amber-400" />
                            <Globe v-if="album.is_public" class="h-4 w-4 text-emerald-400" />
                        </div>
                        <p v-if="album.description" class="text-sm text-muted-foreground mt-1">{{ album.description }}</p>
                    </div>
                </div>
                <div class="flex items-center gap-2">
                    <Button v-if="album.is_public" variant="outline" size="sm" class="gap-2" @click="copyPublicUrl">
                        <LinkIcon class="h-4 w-4" />
                        {{ copied ? 'Copied!' : 'Copy link' }}
                    </Button>
                    <Link :href="`/albums/${album.id}/edit`">
                        <Button variant="outline" size="sm" class="gap-2">
                            <Pencil class="h-4 w-4" />
                            Edit
                        </Button>
                    </Link>
                    <Button variant="destructive" size="sm" class="gap-2" @click="showDeleteDialog = true">
                        <Trash2 class="h-4 w-4" />
                        Delete
                    </Button>
                </div>
            </div>

            <!-- Images grid -->
            <div v-if="images.data.length === 0" class="text-center py-16">
                <p class="text-muted-foreground">No images in this album yet.</p>
                <Link :href="`/albums/${album.id}/edit`">
                    <Button variant="outline" class="mt-4 gap-2">
                        <Plus class="h-4 w-4" />
                        Add images
                    </Button>
                </Link>
            </div>

            <div v-else ref="gridRef" class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
                <div
                    v-for="(image, index) in imagesList"
                    :key="image.id"
                    draggable="true"
                    @dragstart="handleDragStart($event, index)"
                    @dragover.prevent="handleDragOver($event, index)"
                    @drop="handleDrop($event, index)"
                    @dragend="handleDragEnd"
                    class="group relative aspect-square rounded-xl overflow-hidden border border-border bg-muted cursor-move"
                    :class="{
                        'ring-2 ring-violet-500 opacity-50': draggedIndex === index,
                        'ring-2 ring-cyan-400': dragOverIndex === index && dragOverIndex !== draggedIndex,
                    }"
                >
                    <img :src="image.thumbnail_url" class="w-full h-full object-cover" />
                    
                    <!-- Drag handle -->
                    <div class="absolute top-2 left-2 opacity-0 group-hover:opacity-100 transition-opacity">
                        <GripVertical class="h-4 w-4 text-white drop-shadow-md" />
                    </div>

                    <!-- Remove button -->
                    <button
                        @click="removeImage(image.id)"
                        class="absolute top-2 right-2 opacity-0 group-hover:opacity-100 transition-opacity flex size-7 items-center justify-center rounded-full bg-red-500/90 hover:bg-red-500 text-white"
                    >
                        <X class="h-3.5 w-3.5" />
                    </button>

                    <!-- Hover overlay -->
                    <Link :href="`/images/${image.id}`" class="absolute inset-0 bg-black/50 opacity-0 group-hover:opacity-100 transition-opacity flex flex-col justify-end p-3">
                        <p class="text-white text-xs font-medium truncate">{{ image.name }}</p>
                    </Link>
                </div>
            </div>
        </div>

        <!-- Delete Dialog -->
        <Dialog :open="showDeleteDialog" @update:open="showDeleteDialog = false">
            <DialogContent>
                <DialogHeader>
                    <DialogTitle>Delete album</DialogTitle>
                    <DialogDescription>
                        Are you sure you want to delete <strong>{{ album.name }}</strong>?
                        The images themselves will not be deleted, only removed from this album.
                    </DialogDescription>
                </DialogHeader>
                <DialogFooter>
                    <Button variant="outline" @click="showDeleteDialog = false">Cancel</Button>
                    <Button variant="destructive" :disabled="deleting" @click="deleteAlbum">
                        {{ deleting ? 'Deleting...' : 'Delete' }}
                    </Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>
    </AppLayout>
</template>