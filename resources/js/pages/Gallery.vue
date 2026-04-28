<script setup lang="ts">
import { Head, Link, router } from '@inertiajs/vue3';
import { Image as ImageIcon, Search, X, ArrowUpDown } from 'lucide-vue-next';
import { ref, watch } from 'vue';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import {
    Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
} from '@/components/ui/select';
import AppLayout from '@/layouts/AppLayout.vue';
import type { BreadcrumbItem, ImageSortOption } from '@/types';

const props = defineProps<{
    images: {
        data: App.ImageResource[];
        meta: { current_page: number; last_page: number; total: number };
        links: { next: string | null; prev: string | null };
    };
    filters: {
        search?: string;
        sort?: ImageSortOption;
    };
}>();

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Dashboard', href: '/dashboard' },
    { title: 'Gallery',   href: '/gallery'   },
];

const searchQuery = ref(props.filters.search ?? '');
const sortBy = ref<ImageSortOption>(props.filters.sort ?? 'latest');
let searchTimeout: ReturnType<typeof setTimeout> | null = null;

function applyFilters() {
    router.get('/gallery', {
        search: searchQuery.value || undefined,
        sort: sortBy.value,
    }, {
        preserveState: true,
        preserveScroll: true,
        replace: true,
        only: ['images', 'filters'],
    });
}

watch(searchQuery, () => {
    if (searchTimeout) clearTimeout(searchTimeout);
    searchTimeout = setTimeout(applyFilters, 300);
});

watch(sortBy, applyFilters);

const sortOptions: { value: ImageSortOption; label: string }[] = [
    { value: 'latest',   label: 'Latest first'   },
    { value: 'oldest',   label: 'Oldest first'   },
    { value: 'largest',  label: 'Largest first'  },
    { value: 'smallest', label: 'Smallest first' },
    { value: 'name',     label: 'Name (A–Z)'     },
];
</script>

<template>
    <AppLayout :breadcrumbs="breadcrumbs">
        <Head title="Gallery" />

        <div class="px-4 py-6 md:px-8">
            <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-6">
                <div>
                    <h1 class="text-2xl font-bold tracking-tight">Gallery</h1>
                    <p class="text-sm text-muted-foreground mt-1">{{ images.meta.total }} image{{ images.meta.total !== 1 ? 's' : '' }}</p>
                </div>

                <div class="flex items-center gap-2">
                    <div class="relative">
                        <Search class="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                        <Input
                            v-model="searchQuery"
                            placeholder="Search images..."
                            class="pl-10 w-[200px] sm:w-[260px]"
                        />
                        <button
                            v-if="searchQuery"
                            @click="searchQuery = ''; applyFilters()"
                            class="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-foreground"
                        >
                            <X class="h-4 w-4" />
                        </button>
                    </div>

                    <Select v-model="sortBy">
                        <SelectTrigger class="w-[140px]">
                            <ArrowUpDown class="h-3.5 w-3.5 mr-1" />
                            <SelectValue />
                        </SelectTrigger>
                        <SelectContent>
                            <SelectItem v-for="opt in sortOptions" :key="opt.value" :value="opt.value">
                                {{ opt.label }}
                            </SelectItem>
                        </SelectContent>
                    </Select>
                </div>
            </div>

            <!-- Empty state -->
            <div v-if="images.data.length === 0" class="flex flex-col items-center justify-center rounded-xl border border-dashed border-border py-24 text-center">
                <div class="flex size-16 items-center justify-center rounded-full bg-muted mb-4">
                    <ImageIcon class="h-8 w-8 text-muted-foreground" />
                </div>
                <h3 class="text-lg font-semibold mb-1">
                    {{ searchQuery ? 'No images found' : 'No images yet' }}
                </h3>
                <p class="text-sm text-muted-foreground">
                    {{ searchQuery ? `No results for "${searchQuery}". Try a different term.` : 'Upload some images to see them here.' }}
                </p>
            </div>

            <!-- Grid -->
            <div v-else class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-4">
                <Link
                    v-for="image in images.data"
                    :key="image.id"
                    :href="`/images/${image.id}`"
                    class="group relative rounded-xl overflow-hidden border border-border bg-muted aspect-square block"
                >
                    <img :src="image.thumbnail_url" :alt="image.alt_text || image.name" class="w-full h-full object-cover transition-transform duration-300 group-hover:scale-105" />

                    <div v-if="image.tags?.length" class="absolute top-2 left-2 flex flex-wrap gap-1">
                        <Badge v-for="tag in image.tags.slice(0, 2)" :key="tag.id" variant="secondary" class="text-[10px] px-1.5 py-0 h-4 bg-black/60 text-white border-0">
                            {{ tag.name }}
                        </Badge>
                    </div>

                    <div class="absolute inset-0 bg-black/50 opacity-0 group-hover:opacity-100 transition-opacity duration-200 flex flex-col justify-end p-3">
                        <p class="text-white text-xs font-medium truncate">{{ image.name }}</p>
                        <p class="text-white/60 text-xs">{{ image.size_human }}</p>
                    </div>

                    <div v-if="image.is_private" class="absolute top-2 right-2">
                        <Badge variant="secondary" class="text-xs px-1.5 py-0">Private</Badge>
                    </div>
                </Link>
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
    </AppLayout>
</template>