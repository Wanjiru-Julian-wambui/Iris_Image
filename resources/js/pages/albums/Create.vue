<script setup lang="ts">
import { Head, useForm, Link } from '@inertiajs/vue3';
import { Plus, Check, Image as ImageIcon } from 'lucide-vue-next';
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
    name: '',
    description: '',
    is_public: false,
    password: '',
    image_ids: [] as number[],
});

const selectedImages = ref<Set<number>>(new Set());

function toggleImage(id: number) {
    const next = new Set(selectedImages.value);
    next.has(id) ? next.delete(id) : next.add(id);
    selectedImages.value = next;
    form.image_ids = Array.from(next);
}

function submit() {
    form.post('/albums', {
        onSuccess: () => form.reset(),
    });
}

const hasPassword = computed(() => form.password.length > 0);
</script>

<template>
    <Head title="Create Album" />
    <AppLayout :breadcrumbs="breadcrumbs">
        <div class="max-w-3xl mx-auto px-4 py-8">
            <h1 class="text-2xl font-bold tracking-tight mb-6">Create Album</h1>

            <form @submit.prevent="submit" class="space-y-6">
                <div class="space-y-2">
                    <Label for="name">Album name</Label>
                    <Input id="name" v-model="form.name" placeholder="e.g. Summer Vacation" required />
                    <p v-if="form.errors.name" class="text-xs text-rose-400">{{ form.errors.name }}</p>
                </div>

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

                <div class="flex items-center justify-between rounded-xl border border-border p-4">
                    <div>
                        <Label class="font-medium">Public album</Label>
                        <p class="text-xs text-muted-foreground">Anyone with the link can view</p>
                    </div>
                    <Switch v-model:checked="form.is_public" />
                </div>

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

                <div v-if="images.length > 0" class="space-y-3">
                    <Label>Select images to add</Label>
                    <div class="grid grid-cols-3 sm:grid-cols-4 md:grid-cols-5 gap-3">
                        <div
                            v-for="image in images"
                            :key="image.id"
                            @click="toggleImage(image.id)"
                            class="relative aspect-square rounded-xl overflow-hidden border-2 cursor-pointer transition-all"
                            :class="selectedImages.has(image.id) ? 'border-violet-500 ring-2 ring-violet-500/20' : 'border-border hover:border-violet-300'"
                        >
                            <img :src="image.thumbnail_url" class="w-full h-full object-cover" />
                            <div v-if="selectedImages.has(image.id)" class="absolute inset-0 bg-violet-500/20 flex items-center justify-center">
                                <Check class="h-6 w-6 text-violet-500" />
                            </div>
                        </div>
                    </div>
                    <p class="text-sm text-muted-foreground">{{ selectedImages.size }} selected</p>
                </div>

                <div class="flex gap-3">
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