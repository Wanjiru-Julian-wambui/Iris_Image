<script setup lang="ts">
import { Head, Link, router } from '@inertiajs/vue3';
import { Grid2X2, Grid3X3, LayoutList, Search, SlidersHorizontal, X } from 'lucide-vue-next';
import { computed, ref } from 'vue';
import AppLayout from '@/layouts/AppLayout.vue';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Badge } from '@/components/ui/badge';
import {
    Select,
    SelectContent,
    SelectItem,
    SelectTrigger,
    SelectValue,
} from '@/components/ui/select';
import type { BreadcrumbItem } from '@/types';

const props = defineProps<{
    images: {
        data: App.ImageResource[];
        meta: { current_page: number; last_page: number; total: number };
        links: { next: string | null; prev: string | null };
    };
    filters?: { search?: string; sort?: string };
}>();

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Dashboard', href: '/dashboard' },
    { title: 'Gallery', href: '/gallery' },
];

type GridSize = 'sm' | 'md' | 'lg';
const gridSize = ref<GridSize>('md');
const search = ref(props.filters?.search ?? '');
const sort = ref(props.filters?.sort ?? 'latest');
const lightboxImage = ref<App.ImageResource | null>(null);
const lightboxIndex = ref(0);

const gridClass = computed(() => ({
    sm: 'grid-cols-3 sm:grid-cols-4 md:grid-cols-6 lg:grid-cols-8',
    md: 'grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5',
    lg: 'grid-cols-1 sm:grid-cols-2 md:grid-cols-3',
}[gridSize.value]));

function applyFilters() {
    router.get('/gallery', {
        search: search.value || undefined,
        sort: sort.value,
    }, { preserveState: true, replace: true });
}

function clearSearch() {
    search.value = '';
    applyFilters();
}

function openLightbox(image: App.ImageResource, index: number) {
    lightboxImage.value = image;
    lightboxIndex.value = index;
}

function closeLightbox() {
    lightboxImage.value = null;
}

function prevImage() {
    if (lightboxIndex.value > 0) {
        lightboxIndex.value--;
        lightboxImage.value = props.images.data[lightboxIndex.value];
    }
}

function nextImage() {
    if (lightboxIndex.value < props.images.data.length - 1) {
        lightboxIndex.value++;
        lightboxImage.value = props.images.data[lightboxIndex.value];
    }
}

function onKeydown(e: KeyboardEvent) {
    if (!lightboxImage.value) return;
    if (e.key === 'Escape') closeLightbox();
    if (e.key === 'ArrowLeft') prevImage();
    if (e.key === 'ArrowRight') nextImage();
}
</script>

<template>
    <AppLayout :breadcrumbs="breadcrumbs">
        <Head title="Gallery" />

        <div class="px-4 py-6 md:px-8" @keydown.window="onKeydown">

            <!-- Header -->
            <div class="flex items-center justify-between mb-6">
                <div>
                    <h1 class="text-2xl font-bold tracking-tight">Gallery</h1>
                    <p class="text-sm text-muted-foreground mt-1">
                        {{ images.meta.total }} image{{ images.meta.total !== 1 ? 's' : '' }}
                    </p>
                </div>
                <Link href="/images/create">
                    <Button class="bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF] text-white hover:opacity-90">
                        Upload
                    </Button>
                </Link>
            </div>

            <!-- Filters bar -->
            <div class="flex flex-col sm:flex-row gap-3 mb-6">
                <div class="relative flex-1">
                    <Search class="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                    <Input
                        v-model="search"
                        placeholder="Search images..."
                        class="pl-9 pr-9"
                        @keydown.enter="applyFilters"
                    />
                    <button
                        v-if="search"
                        @click="clearSearch"
                        class="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-foreground"
                    >
                        <X class="h-4 w-4" />
                    </button>
                </div>

                <Select v-model="sort" @update:modelValue="applyFilters">
                    <SelectTrigger class="w-full sm:w-40">
                        <SlidersHorizontal class="h-4 w-4 mr-2" />
                        <SelectValue />
                    </SelectTrigger>
                    <SelectContent>
                        <SelectItem value="latest">Latest</SelectItem>
                        <SelectItem value="oldest">Oldest</SelectItem>
                        <SelectItem value="largest">Largest</SelectItem>
                        <SelectItem value="smallest">Smallest</SelectItem>
                        <SelectItem value="name">Name</SelectItem>
                    </SelectContent>
                </Select>

                <!-- Grid size toggle -->
                <div class="flex items-center gap-1 border border-border rounded-lg p-1">
                    <button
                        @click="gridSize = 'sm'"
                        class="p-1.5 rounded-md transition-colors"
                        :class="gridSize === 'sm' ? 'bg-accent text-accent-foreground' : 'text-muted-foreground hover:text-foreground'"
                    >
                        <Grid3X3 class="h-4 w-4" />
                    </button>
                    <button
                        @click="gridSize = 'md'"
                        class="p-1.5 rounded-md transition-colors"
                        :class="gridSize === 'md' ? 'bg-accent text-accent-foreground' : 'text-muted-foreground hover:text-foreground'"
                    >
                        <Grid2X2 class="h-4 w-4" />
                    </button>
                    <button
                        @click="gridSize = 'lg'"
                        class="p-1.5 rounded-md transition-colors"
                        :class="gridSize === 'lg' ? 'bg-accent text-accent-foreground' : 'text-muted-foreground hover:text-foreground'"
                    >
                        <LayoutList class="h-4 w-4" />
                    </button>
                </div>
            </div>

            <!-- Empty state -->
            <div
                v-if="images.data.length === 0"
                class="flex flex-col items-center justify-center rounded-xl border border-dashed border-border py-24 text-center"
            >
                <p class="text-lg font-semibold mb-1">No images found</p>
                <p class="text-sm text-muted-foreground">
                    {{ search ? 'Try a different search term.' : 'Upload some images to get started.' }}
                </p>
            </div>

            <!-- Grid -->
            <div v-else :class="['grid gap-3', gridClass]">
                <div
                    v-for="(image, index) in images.data"
                    :key="image.id"
                    class="group relative rounded-xl overflow-hidden border border-border bg-muted aspect-square cursor-pointer"
                    @click="openLightbox(image, index)"
                >
                    <img
                        :src="image.thumbnail_url"
                        :alt="image.name"
                        class="w-full h-full object-cover transition-transform duration-300 group-hover:scale-105"
                    />
                    <div class="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition-opacity duration-200 flex flex-col justify-end p-2">
                        <p class="text-white text-xs font-medium truncate">{{ image.name }}</p>
                        <p class="text-white/60 text-xs">{{ image.size_human }}</p>
                    </div>
                    <div v-if="image.is_private" class="absolute top-2 left-2">
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

        <!-- Lightbox -->
        <Teleport to="body">
            <div
                v-if="lightboxImage"
                class="fixed inset-0 z-50 bg-black/90 flex items-center justify-center"
                @click.self="closeLightbox"
            >
                <button @click="closeLightbox" class="absolute top-4 right-4 text-white/70 hover:text-white p-2 rounded-full hover:bg-white/10 transition-colors">
                    <X class="h-6 w-6" />
                </button>
                <button v-if="lightboxIndex > 0" @click="prevImage" class="absolute left-4 text-white/70 hover:text-white p-3 rounded-full hover:bg-white/10 transition-colors text-2xl">‹</button>
                <div class="max-w-5xl max-h-[85vh] px-16">
                    <img :src="lightboxImage.url" :alt="lightboxImage.name" class="max-w-full max-h-[80vh] object-contain rounded-lg shadow-2xl" />
                    <div class="flex items-center justify-between mt-3 px-1">
                        <p class="text-white/70 text-sm">{{ lightboxImage.name }}</p>
                        <p class="text-white/50 text-sm">{{ lightboxIndex + 1 }} / {{ images.data.length }}</p>
                    </div>
                </div>
                <button v-if="lightboxIndex < images.data.length - 1" @click="nextImage" class="absolute right-4 text-white/70 hover:text-white p-3 rounded-full hover:bg-white/10 transition-colors text-2xl">›</button>
            </div>
        </Teleport>
    </AppLayout>
</template>