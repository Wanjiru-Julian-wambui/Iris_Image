<script setup lang="ts">
import { Head, Link } from '@inertiajs/vue3';
import { Globe, Calendar, Eye, Lock } from 'lucide-vue-next';
import AppLayout from '@/layouts/AppLayout.vue';

const props = defineProps<{
    user: {
        name: string;
        username: string;
        bio: string | null;
        website: string | null;
        avatar_url: string;
        joined_at: string;
    };
    images: {
        data: {
            id: number;
            uuid: string;
            filename: string;
            title: string | null;
            width: number;
            height: number;
        }[];
        current_page: number;
        last_page: number;
    };
}>();
</script>

<template>
    <Head :title="`${user.name} (@${user.username})`" />

    <div class="min-h-screen bg-background">
        <!-- Profile Header -->
        <div class="border-b border-border bg-card">
            <div class="mx-auto max-w-5xl px-4 py-12">
                <div class="flex flex-col items-center gap-6 sm:flex-row sm:items-start">
                    <img
                        :src="user.avatar_url"
                        :alt="user.name"
                        class="h-28 w-28 rounded-full object-cover ring-4 ring-border"
                    />
                    <div class="text-center sm:text-left flex-1">
                        <h1 class="text-2xl font-bold tracking-tight">{{ user.name }}</h1>
                        <p class="text-sm text-muted-foreground mt-1">@{{ user.username }}</p>

                        <p v-if="user.bio" class="mt-3 text-sm text-foreground max-w-lg">
                            {{ user.bio }}
                        </p>

                        <div class="mt-4 flex flex-wrap items-center justify-center gap-4 sm:justify-start text-xs text-muted-foreground">
                            <span class="inline-flex items-center gap-1">
                                <Calendar class="h-3.5 w-3.5" />
                                Joined {{ user.joined_at }}
                            </span>
                            <a
                                v-if="user.website"
                                :href="user.website"
                                target="_blank"
                                rel="noopener noreferrer"
                                class="inline-flex items-center gap-1 text-violet-400 hover:text-violet-300 transition-colors"
                            >
                                <Globe class="h-3.5 w-3.5" />
                                {{ user.website.replace(/^https?:\/\//, '') }}
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Image Grid -->
        <div class="mx-auto max-w-5xl px-4 py-8">
            <div class="flex items-center justify-between mb-6">
                <h2 class="text-sm font-semibold text-muted-foreground uppercase tracking-wider">
                    Published images
                </h2>
                <span class="text-xs text-muted-foreground">
                    {{ images.data.length }} shown
                </span>
            </div>

            <div v-if="images.data.length === 0" class="flex flex-col items-center justify-center py-20 text-center">
                <div class="mb-3 text-3xl">📷</div>
                <p class="text-sm font-medium">No published images yet</p>
            </div>

            <div v-else class="grid grid-cols-2 gap-4 sm:grid-cols-3 md:grid-cols-4">
                <div
                    v-for="image in images.data"
                    :key="image.id"
                    class="group relative aspect-square overflow-hidden rounded-xl border border-border bg-muted"
                >
                    <img
                        :src="`/storage/${image.filename}`"
                        :alt="image.title ?? 'Image'"
                        class="h-full w-full object-cover transition-transform duration-300 group-hover:scale-105"
                        loading="lazy"
                    />
                    <div class="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-transparent opacity-0 transition-opacity duration-200 group-hover:opacity-100">
                        <div class="absolute bottom-0 left-0 right-0 p-3">
                            <p v-if="image.title" class="text-xs font-medium text-white truncate">
                                {{ image.title }}
                            </p>
                            <div class="mt-1 flex items-center gap-2 text-[10px] text-white/70">
                                <span>{{ image.width }}×{{ image.height }}</span>
                                <span class="flex items-center gap-0.5">
                                    <Eye class="h-3 w-3" />
                                    View only
                                </span>
                            </div>
                        </div>
                    </div>
                    <!-- No download overlay indicator -->
                    <div class="absolute top-2 right-2 rounded-full bg-black/40 p-1.5 opacity-0 transition-opacity group-hover:opacity-100">
                        <Lock class="h-3 w-3 text-white" />
                    </div>
                </div>
            </div>

            <!-- Pagination -->
            <div v-if="images.last_page > 1" class="mt-8 flex justify-center">
                <div class="flex gap-2">
                    <Link
                        v-for="page in images.last_page"
                        :key="page"
                        :href="`?page=${page}`"
                        :class="[
                            'rounded-lg px-3 py-1.5 text-xs font-medium transition-colors',
                            page === images.current_page
                                ? 'bg-violet-500 text-white'
                                : 'bg-muted text-muted-foreground hover:text-foreground'
                        ]"
                    >
                        {{ page }}
                    </Link>
                </div>
            </div>
        </div>
    </div>
</template>