<script setup lang="ts">
import { Head, useForm, Link } from '@inertiajs/vue3';
import { Plus, Check, X, Save, Star } from 'lucide-vue-next';
import { ref, computed } from 'vue';
import AppLayout from '@/layouts/AppLayout.vue';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Switch } from '@/components/ui/switch';
import type { BreadcrumbItem } from '@/types';

const props = defineProps<{
    album: {
        id: number;
        name: string;
        description: string | null;
        is_public: boolean;
        has_password: boolean;
        cover_image: { id: number; thumbnail_url: string } | null;
        images: App.ImageResource[];
    };
    userImages: App.ImageResource[];
}>();

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Dashboard', href: '/dashboard' },
    { title: 'Albums',    href: '/albums'    },
    { title: props.album.name, href: `/albums/${props.album.id}` },
    { title: 'Edit',      href: `/albums/${props.album.id}/edit` },
];

const form = useForm({
    name:           props.album.name,
    description:    props.album.description ?? '',
    is_public:      props.album.is_public,
    password:       '',
    cover_image_id: props.album.cover_image?.id ?? null as number | null,
});

const existingImageIds = new Set(props.album.images.map(i => i.id));
const selectedNewImages = ref<Set<number>>(new Set());

function toggleNewImage(id: number) {
    const next = new Set(selectedNewImages.value);
    next.has(id) ? next.delete(id) : next.add(id);
    selectedNewImages.value = next;
}

function setCover(id: number) {
    form.cover_image_id = form.cover_image_id === id ? null : id;
}

function submit() {
    form.put(`/albums/${props.album.id}`);
}

function addImages() {
    if (selectedNewImages.value.size === 0) return;
    form.transform((data) => ({
        ...data,
        image_ids: Array.from(selectedNewImages.value),
    })).post(`/albums/${props.album.id}/images`, {
        preserveScroll: true,
        onSuccess: () => selectedNewImages.value = new Set(),
    });
}

const availableImages = computed(() =>
    props.userImages.filter(img => !existingImageIds.has(img.id))
);

// All images in the album — used for cover picker
const albumImages = computed(() => props.album.images);
</script>

<template>
    <Head title="Edit Album" />
    <AppLayout :breadcrumbs="breadcrumbs">
        <div class="max-w-3xl mx-auto px-4 py-8 space-y-10">
            <h1 class="text-2xl font-bold tracking-tight">Edit Album</h1>

            <!-- ── Details form ── -->
            <form @submit.prevent="submit" class="space-y-6">
                <div class="space-y-2">
                    <Label for="name">Album name</Label>
                    <Input id="name" v-model="form.name" required />
                    <p v-if="form.errors.name" class="text-xs text-rose-400">{{ form.errors.name }}</p>
                </div>

                <div class="space-y-2">
                    <Label for="description">Description</Label>
                    <textarea
                        id="description"
                        v-model="form.description"
                        rows="3"
                        class="w-full rounded-xl border border-border bg-background px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-violet-500/50 resize-none"
                    />
                </div>

                <div class="flex items-center justify-between rounded-xl border border-border p-4">
                    <div>
                        <Label class="font-medium">Public album</Label>
                        <p class="text-xs text-muted-foreground">Anyone with the link can view</p>
                    </div>
                    <Switch v-model:checked="form.is_public" />
                </div>

                <div v-if="form.is_public" class="space-y-2">
                    <Label for="password">Password protection</Label>
                    <Input
                        id="password"
                        v-model="form.password"
                        type="password"
                        placeholder="Leave blank to keep existing or remove"
                    />
                    <p class="text-xs text-muted-foreground">
                        {{ album.has_password
                            ? 'Album currently has a password. Enter new to change, leave blank to remove.'
                            : 'Optional password protection' }}
                    </p>
                </div>

                <!-- ── Cover image picker ── -->
                <div v-if="albumImages.length > 0" class="space-y-3">
                    <div>
                        <Label class="font-medium">Cover image</Label>
                        <p class="text-xs text-muted-foreground mt-0.5">
                            Click an image to set it as the album cover. Click again to remove.
                        </p>
                    </div>

                    <div class="grid grid-cols-3 sm:grid-cols-4 md:grid-cols-5 gap-3">
                        <div
                            v-for="image in albumImages"
                            :key="image.id"
                            @click="setCover(image.id)"
                            class="relative aspect-square rounded-xl overflow-hidden border-2 cursor-pointer transition-all"
                            :class="form.cover_image_id === image.id
                                ? 'border-violet-500 ring-2 ring-violet-500/30 shadow-lg shadow-violet-500/20'
                                : 'border-border hover:border-violet-300'"
                        >
                            <img :src="image.thumbnail_url" class="w-full h-full object-cover" />

                            <!-- Selected overlay -->
                            <div
                                v-if="form.cover_image_id === image.id"
                                class="absolute inset-0 bg-violet-500/20 flex items-center justify-center"
                            >
                                <div class="flex items-center justify-center w-8 h-8 rounded-full bg-violet-500 shadow-lg">
                                    <Star class="h-4 w-4 text-white fill-white" />
                                </div>
                            </div>

                            <!-- Cover badge -->
                            <div
                                v-if="form.cover_image_id === image.id"
                                class="absolute bottom-1.5 left-0 right-0 flex justify-center"
                            >
                                <span class="text-[9px] font-bold uppercase tracking-widest text-white bg-violet-500 rounded-full px-2 py-0.5">
                                    Cover
                                </span>
                            </div>
                        </div>
                    </div>

                    <p v-if="form.cover_image_id" class="text-xs text-violet-500 font-medium">
                        ✓ Cover image selected
                    </p>
                    <p v-else class="text-xs text-muted-foreground">
                        No cover selected — the album will show a placeholder.
                    </p>
                </div>

                <div class="flex gap-3">
                    <Button
                        type="submit"
                        :disabled="form.processing"
                        class="gap-2 bg-gradient-to-r from-violet-500 to-cyan-400 text-white hover:opacity-90"
                    >
                        <Save class="h-4 w-4" />
                        {{ form.processing ? 'Saving...' : 'Save Changes' }}
                    </Button>
                    <Link :href="`/albums/${album.id}`">
                        <Button variant="outline">Cancel</Button>
                    </Link>
                </div>
            </form>

            <!-- ── Add images section ── -->
            <div v-if="availableImages.length > 0" class="space-y-4">
                <div class="border-t border-border pt-8">
                    <h2 class="text-lg font-semibold">Add Images to Album</h2>
                    <p class="text-sm text-muted-foreground mt-1">Select images from your library to add to this album.</p>
                </div>

                <div class="grid grid-cols-3 sm:grid-cols-4 md:grid-cols-5 gap-3">
                    <div
                        v-for="image in availableImages"
                        :key="image.id"
                        @click="toggleNewImage(image.id)"
                        class="relative aspect-square rounded-xl overflow-hidden border-2 cursor-pointer transition-all"
                        :class="selectedNewImages.has(image.id)
                            ? 'border-violet-500 ring-2 ring-violet-500/20'
                            : 'border-border hover:border-violet-300'"
                    >
                        <img :src="image.thumbnail_url" class="w-full h-full object-cover" />
                        <div v-if="selectedNewImages.has(image.id)" class="absolute inset-0 bg-violet-500/20 flex items-center justify-center">
                            <Check class="h-6 w-6 text-violet-500" />
                        </div>
                    </div>
                </div>

                <Button
                    v-if="selectedNewImages.size > 0"
                    @click="addImages"
                    :disabled="form.processing"
                    class="gap-2 bg-gradient-to-r from-violet-500 to-cyan-400 text-white hover:opacity-90"
                >
                    <Plus class="h-4 w-4" />
                    Add {{ selectedNewImages.size }} image{{ selectedNewImages.size !== 1 ? 's' : '' }}
                </Button>
            </div>

        </div>
    </AppLayout>
</template>