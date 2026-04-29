<script setup lang="ts">
import { Head, Link } from '@inertiajs/vue3';
import { Plus, FolderOpen, Lock, Globe, Image as ImageIcon } from 'lucide-vue-next';
import { Button } from '@/components/ui/button';
import AppLayout from '@/layouts/AppLayout.vue';
import type { BreadcrumbItem } from '@/types';

const props = defineProps<{
    albums: {
        id: number;
        name: string;
        slug: string;
        description: string | null;
        is_public: boolean;
        has_password: boolean;
        public_url: string;
        cover_image: { thumbnail_url: string } | null;
        images_count: number;
        created_at: string;
    }[];
}>();

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Dashboard', href: '/dashboard' },
    { title: 'Albums',    href: '/albums'    },
];

// Deterministic tilt per album based on id
function getTilt(id: number): string {
    const tilts = [-3, -1.5, 0, 1.5, 3, -2, 2];
    return `${tilts[id % tilts.length]}deg`;
}
function getTiltBack(id: number): string {
    const tilts = [2, -2, 1, -1, 3, -3, 1.5];
    return `${tilts[id % tilts.length]}deg`;
}
</script>

<template>
    <Head title="Albums" />
    <AppLayout :breadcrumbs="breadcrumbs">
        <div class="px-4 py-8 md:px-10">

            <!-- Header -->
            <div class="flex items-center justify-between mb-10">
                <div>
                    <h1 class="text-3xl font-bold tracking-tight">Albums</h1>
                    <p class="text-sm text-muted-foreground mt-1">
                        {{ albums.length }} album{{ albums.length !== 1 ? 's' : '' }}
                    </p>
                </div>
                <Link href="/albums/create">
                    <Button class="gap-2 bg-gradient-to-r from-violet-500 to-cyan-400 text-white hover:opacity-90 shadow-lg shadow-violet-500/20">
                        <Plus class="h-4 w-4" />
                        New Album
                    </Button>
                </Link>
            </div>

            <!-- Empty state -->
            <div v-if="albums.length === 0" class="flex flex-col items-center justify-center rounded-2xl border border-dashed border-border py-28 text-center">
                <div class="relative mb-6">
                    <div class="w-20 h-16 rounded-lg bg-muted/60 absolute -top-1 -right-2 rotate-6"></div>
                    <div class="w-20 h-16 rounded-lg bg-muted/80 absolute -top-0.5 -left-2 -rotate-4"></div>
                    <div class="w-20 h-16 rounded-lg bg-muted flex items-center justify-center relative">
                        <FolderOpen class="h-8 w-8 text-muted-foreground/50" />
                    </div>
                </div>
                <h3 class="text-lg font-semibold mb-1">No albums yet</h3>
                <p class="text-sm text-muted-foreground mb-6">Create your first album to organize your images.</p>
                <Link href="/albums/create">
                    <Button class="gap-2 bg-gradient-to-r from-violet-500 to-cyan-400 text-white hover:opacity-90">
                        <Plus class="h-4 w-4" />
                        Create album
                    </Button>
                </Link>
            </div>

            <!-- Albums grid -->
            <div v-else class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-x-6 gap-y-14">
                <Link
                    v-for="album in albums"
                    :key="album.id"
                    :href="`/albums/${album.id}`"
                    class="group relative flex flex-col items-center"
                >
                    <!-- Photo stack wrapper -->
                    <div class="relative w-full" style="padding-bottom: 80%;">

                        <!-- Back card -->
                        <div
                            class="absolute inset-0 rounded-xl bg-card border border-border shadow-md transition-transform duration-300 group-hover:scale-[1.03]"
                            :style="{ transform: `rotate(${getTiltBack(album.id)})` }"
                        >
                            <div class="absolute inset-x-0 top-0 h-5 rounded-t-xl opacity-30"
                                 style="background: linear-gradient(135deg, #a78bfa, #22d3ee)">
                            </div>
                        </div>

                        <!-- Middle card -->
                        <div
                            class="absolute inset-0 rounded-xl bg-card border border-border shadow-md transition-transform duration-300 group-hover:scale-[1.015]"
                            :style="{ transform: `rotate(${getTilt(album.id)})` }"
                        ></div>

                        <!-- Front card -->
                        <div
                            class="absolute inset-0 rounded-xl bg-card border border-border shadow-xl overflow-hidden transition-all duration-300 group-hover:scale-[1.05] group-hover:shadow-2xl group-hover:shadow-violet-500/15"
                        >
                            <!-- Cover image or placeholder -->
                            <div class="absolute inset-0">
                                <img
                                    v-if="album.cover_image"
                                    :src="album.cover_image.thumbnail_url"
                                    class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105"
                                />
                                <div v-else class="w-full h-full flex flex-col items-center justify-center gap-2 bg-muted/50">
                                    <div class="grid grid-cols-2 gap-1 opacity-20">
                                        <div class="w-8 h-8 rounded bg-muted-foreground"></div>
                                        <div class="w-8 h-8 rounded bg-muted-foreground"></div>
                                        <div class="w-8 h-8 rounded bg-muted-foreground"></div>
                                        <div class="w-8 h-8 rounded bg-muted-foreground"></div>
                                    </div>
                                </div>
                            </div>

                            <!-- Bottom gradient overlay -->
                            <div class="absolute inset-x-0 bottom-0 h-20 bg-gradient-to-t from-black/70 to-transparent pointer-events-none"></div>

                            <!-- Badges top right -->
                            <div class="absolute top-2.5 right-2.5 flex gap-1.5 z-10">
                                <span v-if="album.has_password"
                                      class="flex items-center justify-center w-6 h-6 rounded-full bg-black/50 backdrop-blur-sm ring-1 ring-white/10">
                                    <Lock class="h-3 w-3 text-amber-300" />
                                </span>
                                <span v-if="album.is_public"
                                      class="flex items-center justify-center w-6 h-6 rounded-full bg-black/50 backdrop-blur-sm ring-1 ring-white/10">
                                    <Globe class="h-3 w-3 text-emerald-300" />
                                </span>
                            </div>

                            <!-- Image count bottom left -->
                            <div class="absolute bottom-2.5 left-2.5 z-10">
                                <span class="flex items-center gap-1 text-[10px] font-semibold text-white/90 bg-black/40 backdrop-blur-sm rounded-full px-2 py-0.5 ring-1 ring-white/10">
                                    <ImageIcon class="h-2.5 w-2.5" />
                                    {{ album.images_count }} photo{{ album.images_count !== 1 ? 's' : '' }}
                                </span>
                            </div>
                        </div>
                    </div>

                    <!-- Label below -->
                    <div class="mt-4 text-center w-full px-1">
                        <p class="font-semibold text-sm text-foreground truncate leading-tight group-hover:text-violet-400 transition-colors duration-200">
                            {{ album.name }}
                        </p>
                        <p v-if="album.description" class="text-xs text-muted-foreground mt-0.5 line-clamp-1">
                            {{ album.description }}
                        </p>
                        <p class="text-[10px] text-muted-foreground/50 mt-1">{{ album.created_at }}</p>
                    </div>
                </Link>
            </div>

        </div>
    </AppLayout>
</template>