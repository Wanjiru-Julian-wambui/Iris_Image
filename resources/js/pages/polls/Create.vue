<script setup lang="ts">
import { Head, Link, router } from '@inertiajs/vue3';
import { ArrowLeft, Plus, Image as ImageIcon, Check } from 'lucide-vue-next';
import { ref, computed } from 'vue';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import AppLayout from '@/layouts/AppLayout.vue';
import type { BreadcrumbItem } from '@/types';

const props = defineProps<{
    images: {
        data: App.ImageResource[];
    };
}>();

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Dashboard', href: '/dashboard' },
    { title: 'Polls',     href: '/polls'     },
    { title: 'Create',    href: '/polls/create' },
];

const question = ref('');
const imageAId = ref<number | null>(null);
const imageBId = ref<number | null>(null);
const creating = ref(false);

const canSubmit = computed(() => {
    return question.value.trim().length > 0 &&
           imageAId.value !== null &&
           imageBId.value !== null &&
           imageAId.value !== imageBId.value;
});

function createPoll() {
    if (!canSubmit.value) return;

    creating.value = true;
    router.post('/polls', {
        question: question.value.trim(),
        image_a_id: imageAId.value,
        image_b_id: imageBId.value,
    }, {
        onFinish: () => { creating.value = false; },
    });
}

function selectImage(id: number, slot: 'a' | 'b') {
    if (slot === 'a') {
        imageAId.value = imageAId.value === id ? null : id;
    } else {
        imageBId.value = imageBId.value === id ? null : id;
    }
}

function isSelected(id: number, slot: 'a' | 'b'): boolean {
    return slot === 'a' ? imageAId.value === id : imageBId.value === id;
}

function isDisabled(id: number, slot: 'a' | 'b'): boolean {
    const other = slot === 'a' ? imageBId.value : imageAId.value;
    return other === id;
}
</script>

<template>
    <AppLayout :breadcrumbs="breadcrumbs">
        <Head title="Create Poll" />

        <div class="max-w-3xl mx-auto px-4 py-8">
            <Link href="/polls">
                <Button variant="ghost" size="sm" class="gap-2 mb-6">
                    <ArrowLeft class="h-4 w-4" />
                    Back to polls
                </Button>
            </Link>

            <h1 class="text-2xl font-bold tracking-tight mb-1">Create a poll</h1>
            <p class="text-sm text-muted-foreground mb-8">Pick two images and ask a question. Anyone with the link can vote.</p>

            <div class="space-y-6">
                <!-- Question -->
                <div class="space-y-2">
                    <Label>Question</Label>
                    <Input
                        v-model="question"
                        placeholder="e.g. Which one looks better?"
                        maxlength="200"
                    />
                    <p class="text-xs text-muted-foreground">{{ question.length }}/200</p>
                </div>

                <!-- Image A -->
                <div class="space-y-2">
                    <Label>Image A {{ imageAId ? '✓' : '' }}</Label>
                    <div v-if="imageAId" class="flex items-center gap-3 rounded-lg border border-violet-500/30 bg-violet-500/5 p-3">
                        <img :src="props.images.data.find(i => i.id === imageAId)?.thumbnail_url" class="h-12 w-12 rounded object-cover" />
                        <span class="text-sm font-medium">{{ props.images.data.find(i => i.id === imageAId)?.name }}</span>
                        <Button variant="ghost" size="sm" class="ml-auto" @click="imageAId = null">Change</Button>
                    </div>
                    <div v-else class="grid grid-cols-3 sm:grid-cols-4 md:grid-cols-5 gap-2">
                        <button
                            v-for="img in props.images.data"
                            :key="img.id"
                            @click="selectImage(img.id, 'a')"
                            :disabled="isDisabled(img.id, 'a')"
                            class="relative rounded-lg overflow-hidden aspect-square border-2 transition-all"
                            :class="isSelected(img.id, 'a') ? 'border-violet-500' : 'border-border hover:border-violet-500/50'"
                        >
                            <img :src="img.thumbnail_url" class="w-full h-full object-cover" />
                            <div v-if="isSelected(img.id, 'a')" class="absolute inset-0 bg-violet-500/20 flex items-center justify-center">
                                <Check class="h-6 w-6 text-white" />
                            </div>
                        </button>
                    </div>
                </div>

                <!-- Image B -->
                <div class="space-y-2">
                    <Label>Image B {{ imageBId ? '✓' : '' }}</Label>
                    <div v-if="imageBId" class="flex items-center gap-3 rounded-lg border border-cyan-400/30 bg-cyan-400/5 p-3">
                        <img :src="props.images.data.find(i => i.id === imageBId)?.thumbnail_url" class="h-12 w-12 rounded object-cover" />
                        <span class="text-sm font-medium">{{ props.images.data.find(i => i.id === imageBId)?.name }}</span>
                        <Button variant="ghost" size="sm" class="ml-auto" @click="imageBId = null">Change</Button>
                    </div>
                    <div v-else class="grid grid-cols-3 sm:grid-cols-4 md:grid-cols-5 gap-2">
                        <button
                            v-for="img in props.images.data"
                            :key="img.id"
                            @click="selectImage(img.id, 'b')"
                            :disabled="isDisabled(img.id, 'b')"
                            class="relative rounded-lg overflow-hidden aspect-square border-2 transition-all"
                            :class="isSelected(img.id, 'b') ? 'border-cyan-400' : 'border-border hover:border-cyan-400/50'"
                        >
                            <img :src="img.thumbnail_url" class="w-full h-full object-cover" />
                            <div v-if="isSelected(img.id, 'b')" class="absolute inset-0 bg-cyan-400/20 flex items-center justify-center">
                                <Check class="h-6 w-6 text-white" />
                            </div>
                        </button>
                    </div>
                </div>

                <!-- Submit -->
                <Button
                    class="w-full gap-2 bg-gradient-to-r from-violet-500 to-cyan-400 text-white hover:opacity-90"
                    :disabled="!canSubmit || creating"
                    @click="createPoll"
                >
                    <Plus v-if="!creating" class="h-4 w-4" />
                    <span v-else class="h-4 w-4 animate-spin rounded-full border-2 border-white border-t-transparent" />
                    {{ creating ? 'Creating...' : 'Create poll' }}
                </Button>
            </div>
        </div>
    </AppLayout>
</template>