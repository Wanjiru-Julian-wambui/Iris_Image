<script setup lang="ts">
import { Head, Link } from '@inertiajs/vue3';
import AppLayout from '@/layouts/AppLayout.vue';
import { dashboard } from '@/routes';
import type { BreadcrumbItem } from '@/types';

// 1. Define the props coming from DashboardController
defineProps<{
    user: any;
    recentImages: { data: any[] }; // This matches your ImageResource collection
    stats: {
        total_images: number;
        storage_used: string;
        storage_limit: string;
        storage_percent: number;
        shared_links: number;
    };
}>();

const breadcrumbs: BreadcrumbItem[] = [
    {
        title: 'Dashboard',
        href: dashboard(),
    },
];
</script>

<template>
    <Head title="Dashboard" />

    <AppLayout :breadcrumbs="breadcrumbs">
        <div class="flex h-full flex-1 flex-col gap-4 p-4">
            
            <div class="grid auto-rows-min gap-4 md:grid-cols-3">
                <div class="rounded-xl border border-sidebar-border/70 p-4 dark:border-sidebar-border">
                    <div class="text-sm text-muted-foreground text-gray-400">Total Images</div>
                    <div class="text-2xl font-bold">{{ stats.total_images }}</div>
                </div>
                <div class="rounded-xl border border-sidebar-border/70 p-4 dark:border-sidebar-border">
                    <div class="text-sm text-muted-foreground text-gray-400">Storage Used</div>
                    <div class="text-2xl font-bold">{{ stats.storage_percent }}%</div>
                </div>
                <div class="rounded-xl border border-sidebar-border/70 p-4 dark:border-sidebar-border">
                    <div class="text-sm text-muted-foreground text-gray-400">Active Links</div>
                    <div class="text-2xl font-bold">{{ stats.shared_links }}</div>
                </div>
            </div>

            <div class="relative min-h-[100vh] flex-1 rounded-xl border border-sidebar-border/70 p-6 md:min-h-min dark:border-sidebar-border">
                <div class="mb-6 flex items-center justify-between">
                    <h2 class="text-xl font-semibold">Recent Uploads</h2>
                    <Link href="/images" class="text-sm text-indigo-500 hover:text-indigo-400 font-medium">View Gallery →</Link>
                </div>

                <div v-if="recentImages.data.length > 0" class="grid grid-cols-2 gap-4 sm:grid-cols-3 lg:grid-cols-4">
                    <div 
                        v-for="image in recentImages.data" 
                        :key="image.id"
                        class="group relative aspect-square overflow-hidden rounded-lg bg-black/5 dark:bg-white/5 border border-sidebar-border/50"
                    >
                        <img 
                            :src="image.thumbnail_url" 
                            :alt="image.name"
                            class="h-full w-full object-cover transition-transform duration-300 group-hover:scale-110"
                        />
                        <div class="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent opacity-0 transition-opacity group-hover:opacity-100 flex items-end p-3">
                            <span class="text-xs text-white truncate">{{ image.name }}</span>
                        </div>
                    </div>
                </div>

                <div v-else class="flex flex-col items-center justify-center py-20 text-center">
                    <div class="mb-4 rounded-full bg-sidebar-border/20 p-4">
                        📸
                    </div>
                    <p class="text-sm text-muted-foreground">No images found. Start by uploading some files!</p>
                </div>
            </div>
        </div>
    </AppLayout>
</template>