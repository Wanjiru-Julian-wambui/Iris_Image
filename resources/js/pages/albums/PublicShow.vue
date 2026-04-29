<script setup lang="ts">
import { Head } from '@inertiajs/vue3';
import { FolderOpen, Image as ImageIcon, User } from 'lucide-vue-next';

const props = defineProps<{
    album: {
        id: number;
        name: string;
        description: string | null;
        user: { name: string };
        created_at: string;
    };
    images: App.ImageResource[];
}>();
</script>

<template>
    <Head :title="album.name" />

    <div class="min-h-screen bg-background">
        <div class="max-w-6xl mx-auto px-4 py-8">
            <div class="mb-8">
                <h1 class="text-3xl font-bold tracking-tight">{{ album.name }}</h1>
                <p v-if="album.description" class="text-muted-foreground mt-2">{{ album.description }}</p>
                <div class="flex items-center gap-2 mt-4 text-sm text-muted-foreground">
                    <User class="h-4 w-4" />
                    {{ album.user.name }}
                    <span>·</span>
                    <ImageIcon class="h-4 w-4" />
                    {{ images.length }} images
                </div>
            </div>

            <div v-if="images.length === 0" class="text-center py-16">
                <FolderOpen class="h-12 w-12 text-muted-foreground/30 mx-auto mb-4" />
                <p class="text-muted-foreground">This album is empty.</p>
            </div>

            <div v-else class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
                <div
                    v-for="image in images"
                    :key="image.id"
                    class="group aspect-square rounded-xl overflow-hidden border border-border bg-muted"
                >
                    <img
                        :src="image.thumbnail_url"
                        :alt="image.alt_text || image.name"
                        class="w-full h-full object-cover transition-transform duration-300 group-hover:scale-105"
                    />
                </div>
            </div>
        </div>
    </div>
</template>