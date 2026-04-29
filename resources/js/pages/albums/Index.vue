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
</script>

<template>
    <Head title="Albums" />
    <AppLayout :breadcrumbs="breadcrumbs">
        <div class="px-4 py-6 md:px-8">
            <div class="flex items-center justify-between mb-6">
                <div>
                    <h1 class="text-2xl font-bold tracking-tight">Albums</h1>
                    <p class="text-sm text-muted-foreground mt-1">
                        {{ albums.length }} album{{ albums.length !== 1 ? 's' : '' }}
                    </p>
                </div>
                <Link href="/albums/create">
                    <Button class="gap-2 bg-gradient-to-r from-violet-500 to-cyan-400 text-white hover:opacity-90">
                        <Plus class="h-4 w-4" />
                        New Album
                    </Button>
                </Link>
            </div>

            <div v-if="albums.length === 0" class="flex flex-col items-center justify-center rounded-xl border border-dashed border-border py-24 text-center">
                <div class="flex size-16 items-center justify-center rounded-full bg-muted mb-4">
                    <FolderOpen class="h-8 w-8 text-muted-foreground" />
                </div>
                <h3 class="text-lg font-semibold mb-1">No albums yet</h3>
                <p class="text-sm text-muted-foreground mb-6">Create your first album to organize images.</p>
                <Link href="/albums/create">
                    <Button class="gap-2 bg-gradient-to-r from-violet-500 to-cyan-400 text-white hover:opacity-90">
                        <Plus class="h-4 w-4" />
                        Create album
                    </Button>
                </Link>
            </div>

            <div v-else class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
                <Link
                    v-for="album in albums"
                    :key="album.id"
                    :href="`/albums/${album.id}`"
                    class="group rounded-2xl border border-border bg-card overflow-hidden hover:border-violet-500/50 transition-all hover:shadow-lg hover:shadow-violet-500/10"
                >
                    <div class="aspect-[4/3] bg-muted relative overflow-hidden">
                        <img
                            v-if="album.cover_image"
                            :src="album.cover_image.thumbnail_url"
                            class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-105"
                        />
                        <div v-else class="w-full h-full flex items-center justify-center">
                            <ImageIcon class="h-12 w-12 text-muted-foreground/30" />
                        </div>
                        <div class="absolute top-2 right-2 flex gap-1">
                            <span v-if="album.has_password" class="rounded-full bg-black/50 p-1.5">
                                <Lock class="h-3 w-3 text-white" />
                            </span>
                            <span v-if="album.is_public" class="rounded-full bg-black/50 p-1.5">
                                <Globe class="h-3 w-3 text-white" />
                            </span>
                        </div>
                    </div>
                    <div class="p-4">
                        <h3 class="font-semibold text-foreground truncate">{{ album.name }}</h3>
                        <p v-if="album.description" class="text-sm text-muted-foreground mt-1 line-clamp-2">{{ album.description }}</p>
                        <div class="flex items-center gap-2 mt-3 text-xs text-muted-foreground">
                            <ImageIcon class="h-3 w-3" />
                            {{ album.images_count }} image{{ album.images_count !== 1 ? 's' : '' }}
                            <span>·</span>
                            {{ album.created_at }}
                        </div>
                    </div>
                </Link>
            </div>
        </div>
    </AppLayout>
</template>