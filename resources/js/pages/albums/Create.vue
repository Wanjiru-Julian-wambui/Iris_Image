<script setup lang="ts">
import { Head, useForm, Link } from '@inertiajs/vue3';
import { Plus, Check, Star, Image as ImageIcon } from 'lucide-vue-next';
import { ref, computed } from 'vue';
import AppLayout from '@/layouts/AppLayout.vue';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Switch } from '@/components/ui/switch';
import type { BreadcrumbItem } from '@/types';

const props = defineProps<{
    images: App.ImageResource[];
}>();

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Dashboard', href: '/dashboard' },
    { title: 'Albums',    href: '/albums'    },
    { title: 'Create',    href: '/albums/create' },
];

const form = useForm({
    name:           '',
    description:    '',
    is_public:      false,
    password:       '',
    image_ids:      [] as number[],
    cover_image_id: null as number | null,
});

const selectedImages = ref<Set<number>>(new Set());

function toggleImage(id: number) {
    const next = new Set(selectedImages.value);
    next.has(id) ? next.delete(id) : next.add(id);
    selectedImages.value = next;
    form.image_ids = Array.from(next);

    // If the cover was deselected, clear it
    if (!next.has(form.cover_image_id ?? -1)) {
        form.cover_image_id = null;
    }
}

function setCover(id: number) {
    form.cover_image_id = form.cover_image_id === id ? null : id;
}

// Images currently selected — shown in the cover picker
const selectedImageObjects = computed(() =>
    props.images.filter(img => selectedImages.value.has(img.id))
);

function submit() {
    form.post('/albums', {
        onSuccess: () => form.reset(),
    });
}
</script>

<template>
    <Head title="Create Album" />
    <AppLayout :breadcrumbs="breadcrumbs">
        <div class="max-w-3xl mx-auto px-4 py-8">
            <h1 class="text-2xl font-bold tracking-tight mb-6">Create Album</h1>

            <form @submit.prevent="submit" class="space-y-6">

                <!-- Name -->
                <div class="space-y-2">
                    <Label for="name">Album name</Label>
                    <Input id="name" v-model="form.name" placeholder="e.g. Summer Vacation" required />
                    <p v-if="form.errors.name" class="text-xs text-rose-400">{{ form.errors.name }}</p>
                </div>

                <!-- Description -->
                <div class="space-y-2">
                    <Label for="description">Description</Label>
                    <textarea
                        id="description"
                        v-model="form.description"
                        rows="3"
                        class="w-full rounded-xl border border-border bg-background px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-violet-500/50 resize-none"
                        placeholder="Optional description..."
                    />
                </div>

                <!-- Public toggle -->
                <div class="flex items-center justify-between rounded-xl border border-border p-4">
                    <div>
                        <Label class="font-medium">Public album</Label>
                        <p class="text-xs text-muted-foreground">Anyone with the link can view</p>
                    </div>
                    <Switch v-model:checked="form.is_public" />
                </div>

                <!-- Password -->
                <div v-if="form.is_public" class="space-y-2">
                    <Label for="password">Password protection (optional)</Label>
                    <Input
                        id="password"
                        v-model="form.password"
                        type="password"
                        placeholder="Leave blank for no password"
                    />
                    <p class="text-xs text-muted-foreground">Minimum 4 characters if set</p>
                </div>

                <!-- Step 1: Select images -->
                <div v-if="images.length > 0" class="space-y-3">
                    <div>
                        <Label class="font-medium">Select images</Label>
                        <p class="text-xs text-muted-foreground mt-0.5">Choose which images to include in this album.</p>
                    </div>

                    <div class="grid grid-cols-3 sm:grid-cols-4 md:grid-cols-5 gap-3">
                        <div
                            v-for="image in images"
                            :key="image.id"
                            @click="toggleImage(image.id)"
                            class="relative aspect-square rounded-xl overflow-hidden border-2 cursor-pointer transition-all"
                            :class="selectedImages.has(image.id)
                                ? 'border-violet-500 ring-2 ring-violet-500/20'
                                : 'border-border hover:border-violet-300'"
                        >
                            <img :src="image.thumbnail_url" class="w-full h-full object-cover" />
                            <div v-if="selectedImages.has(image.id)"
                                 class="absolute inset-0 bg-violet-500/20 flex items-center justify-center">
                                <Check class="h-6 w-6 text-violet-500" />
                            </div>
                        </div>
                    </div>

                    <p class="text-sm text-muted-foreground">{{ selectedImages.size }} selected</p>
                </div>

                <!-- Step 2: Pick cover (only shown once images are selected) -->
                <Transition
                    enter-active-class="transition-all duration-300"
                    enter-from-class="opacity-0 -translate-y-2"
                    leave-active-class="transition-all duration-200"
                    leave-to-class="opacity-0 -translate-y-2"
                >
                    <div v-if="selectedImageObjects.length > 0" class="space-y-3 rounded-xl border border-violet-500/20 bg-violet-500/5 p-4">
                        <div>
                            <Label class="font-medium text-violet-600 dark:text-violet-400">Cover image</Label>
                            <p class="text-xs text-muted-foreground mt-0.5">
                                Pick which image shows on the album card. Click to select, click again to remove.
                            </p>
                        </div>

                        <div class="grid grid-cols-3 sm:grid-cols-4 md:grid-cols-5 gap-3">
                            <div
                                v-for="image in selectedImageObjects"
                                :key="image.id"
                                @click="setCover(image.id)"
                                class="relative aspect-square rounded-xl overflow-hidden border-2 cursor-pointer transition-all"
                                :class="form.cover_image_id === image.id
                                    ? 'border-violet-500 ring-2 ring-violet-500/30 shadow-lg shadow-violet-500/20'
                                    : 'border-border hover:border-violet-300'"
                            >
                                <img :src="image.thumbnail_url" class="w-full h-full object-cover" />

                                <!-- Selected star overlay -->
                                <div v-if="form.cover_image_id === image.id"
                                     class="absolute inset-0 bg-violet-500/20 flex items-center justify-center">
                                    <div class="flex items-center justify-center w-8 h-8 rounded-full bg-violet-500 shadow-lg">
                                        <Star class="h-4 w-4 text-white fill-white" />
                                    </div>
                                </div>

                                <!-- Cover label -->
                                <div v-if="form.cover_image_id === image.id"
                                     class="absolute bottom-1.5 left-0 right-0 flex justify-center">
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
                            No cover selected — first image will be used as default.
                        </p>
                    </div>
                </Transition>

                <!-- Submit -->
                <div class="flex gap-3 pt-2">
                    <Button
                        type="submit"
                        :disabled="form.processing || !form.name.trim()"
                        class="bg-gradient-to-r from-violet-500 to-cyan-400 text-white hover:opacity-90"
                    >
                        {{ form.processing ? 'Creating...' : 'Create Album' }}
                    </Button>
                    <Link href="/albums">
                        <Button variant="outline">Cancel</Button>
                    </Link>
                </div>

            </form>
        </div>
    </AppLayout>
</template>