<script setup lang="ts">
import { Head, Link } from '@inertiajs/vue3';
import { Plus, FolderOpen, Lock, Globe, Image as ImageIcon, Images } from 'lucide-vue-next';
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

const TILT_A = [-3.5, -2, -1, 1.5, 3, -2.5, 2.5];
const TILT_B = [2, -1.5, 2.5, -2, 1, -3, 1.5];

function tiltA(id: number) { return `${TILT_A[id % TILT_A.length]}deg`; }
function tiltB(id: number) { return `${TILT_B[id % TILT_B.length]}deg`; }

// Soft pastel backgrounds for placeholder cards
const PLACEHOLDER_GRADIENTS = [
    'linear-gradient(135deg, #f3e8ff 0%, #e0f2fe 100%)',
    'linear-gradient(135deg, #fce7f3 0%, #ede9fe 100%)',
    'linear-gradient(135deg, #ecfdf5 0%, #cffafe 100%)',
    'linear-gradient(135deg, #fef3c7 0%, #fce7f3 100%)',
    'linear-gradient(135deg, #ede9fe 0%, #dbeafe 100%)',
];
function placeholderBg(id: number) {
    return PLACEHOLDER_GRADIENTS[id % PLACEHOLDER_GRADIENTS.length];
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
                <div class="relative mb-6 w-20 h-16">
                    <div class="w-20 h-16 rounded-xl absolute inset-0 rotate-6"
                         style="background: linear-gradient(135deg,#ede9fe,#dbeafe)"></div>
                    <div class="w-20 h-16 rounded-xl absolute inset-0 -rotate-3"
                         style="background: linear-gradient(135deg,#fce7f3,#ede9fe)"></div>
                    <div class="w-20 h-16 rounded-xl absolute inset-0 flex items-center justify-center"
                         style="background: linear-gradient(135deg,#f3e8ff,#e0f2fe)">
                        <Images class="h-7 w-7 text-violet-400/60" />
                    </div>
                </div>
                <h3 class="text-lg font-semibold mb-1">No albums yet</h3>
                <p class="text-sm text-muted-foreground mb-6">Create your first album to organise your images.</p>
                <Link href="/albums/create">
                    <Button class="gap-2 bg-gradient-to-r from-violet-500 to-cyan-400 text-white hover:opacity-90">
                        <Plus class="h-4 w-4" />
                        Create album
                    </Button>
                </Link>
            </div>

            <!-- Albums grid -->
            <div v-else class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-x-8 gap-y-16">
                <Link
                    v-for="album in albums"
                    :key="album.id"
                    :href="`/albums/${album.id}`"
                    class="group relative flex flex-col items-center"
                >
                    <!-- Stack container -->
                    <div class="relative w-full" style="padding-bottom: 75%;">

                        <!-- Card 3 — back -->
                        <div
                            class="absolute inset-0 rounded-2xl border border-border/60 shadow-sm transition-all duration-500 ease-out group-hover:scale-[1.04]"
                            :style="{
                                transform: `rotate(${tiltB(album.id)})`,
                                background: placeholderBg(album.id),
                                opacity: '0.7',
                            }"
                        ></div>

                        <!-- Card 2 — middle -->
                        <div
                            class="absolute inset-0 rounded-2xl border border-border/70 shadow-md transition-all duration-400 ease-out group-hover:scale-[1.02]"
                            :style="{
                                transform: `rotate(${tiltA(album.id)})`,
                                background: placeholderBg((album.id + 2) % 5),
                                opacity: '0.85',
                            }"
                        ></div>

                        <!-- Card 1 — front (main) -->
                        <div
                            class="absolute inset-0 rounded-2xl border border-border shadow-lg overflow-hidden transition-all duration-300 ease-out group-hover:scale-[1.05] group-hover:shadow-2xl group-hover:shadow-violet-500/15"
                        >
                            <!-- Cover photo -->
                            <img
                                v-if="album.cover_image"
                                :src="album.cover_image.thumbnail_url"
                                class="absolute inset-0 w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
                            />

                            <!-- Placeholder — colourful gradient with film-strip icon -->
                            <div
                                v-else
                                class="absolute inset-0 flex flex-col items-center justify-center gap-3"
                                :style="{ background: placeholderBg(album.id) }"
                            >
                                <div class="flex items-center justify-center w-14 h-14 rounded-2xl bg-white/50 backdrop-blur-sm shadow-inner ring-1 ring-white/60">
                                    <Images class="h-7 w-7 text-violet-400" />
                                </div>
                                <span class="text-xs font-medium text-violet-500/70">No cover yet</span>
                            </div>

                            <!-- Bottom scrim -->
                            <div class="absolute inset-x-0 bottom-0 h-24 bg-gradient-to-t from-black/65 to-transparent pointer-events-none"></div>

                            <!-- Badges — top right -->
                            <div class="absolute top-3 right-3 flex gap-1.5 z-10">
                                <span
                                    v-if="album.has_password"
                                    class="flex items-center justify-center w-6 h-6 rounded-full bg-black/50 backdrop-blur-sm ring-1 ring-white/10"
                                >
                                    <Lock class="h-3 w-3 text-amber-300" />
                                </span>
                                <span
                                    v-if="album.is_public"
                                    class="flex items-center justify-center w-6 h-6 rounded-full bg-black/50 backdrop-blur-sm ring-1 ring-white/10"
                                >
                                    <Globe class="h-3 w-3 text-emerald-300" />
                                </span>
                            </div>

                            <!-- Photo count — bottom left -->
                            <div class="absolute bottom-3 left-3 z-10">
                                <span class="flex items-center gap-1.5 text-[11px] font-semibold text-white/90 bg-black/40 backdrop-blur-sm rounded-full px-2.5 py-1 ring-1 ring-white/10">
                                    <ImageIcon class="h-3 w-3" />
                                    {{ album.images_count }} photo{{ album.images_count !== 1 ? 's' : '' }}
                                </span>
                            </div>
                        </div>
                    </div>

                    <!-- Label -->
                    <div class="mt-5 text-center w-full px-2">
                        <p class="font-semibold text-sm text-foreground truncate transition-colors duration-200 group-hover:text-violet-500">
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