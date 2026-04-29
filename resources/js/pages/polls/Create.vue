<script setup lang="ts">
import { Head, router } from '@inertiajs/vue3';
import { ref, computed } from 'vue';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Badge } from '@/components/ui/badge';
import { Check, X } from 'lucide-vue-next';
import AppLayout from '@/layouts/AppLayout.vue';

const props = defineProps<{
    images: App.Image[];
}>();

const pollType   = ref<'ab' | 'multi'>('ab');
const question   = ref('');
const imageAId   = ref<number | null>(null);
const imageBId   = ref<number | null>(null);
const selectedIds = ref<number[]>([]);
const maxChoices = ref<number | null>(null);
const submitting = ref(false);
const errors     = ref<Record<string, string>>({});

// A/B helpers
function selectA(id: number) { imageAId.value = id; }
function selectB(id: number) { imageBId.value = id; }

// Multi helpers
function toggleMulti(id: number) {
    const idx = selectedIds.value.indexOf(id);
    if (idx === -1) selectedIds.value.push(id);
    else selectedIds.value.splice(idx, 1);
}
function isSelected(id: number) {
    return selectedIds.value.includes(id);
}
function moveUp(id: number) {
    const idx = selectedIds.value.indexOf(id);
    if (idx > 0) {
        [selectedIds.value[idx - 1], selectedIds.value[idx]] =
        [selectedIds.value[idx], selectedIds.value[idx - 1]];
    }
}
function moveDown(id: number) {
    const idx = selectedIds.value.indexOf(id);
    if (idx < selectedIds.value.length - 1) {
        [selectedIds.value[idx + 1], selectedIds.value[idx]] =
        [selectedIds.value[idx], selectedIds.value[idx + 1]];
    }
}
function removeFromMulti(id: number) {
    selectedIds.value = selectedIds.value.filter(i => i !== id);
}

const selectedImages = computed(() =>
    selectedIds.value.map(id => props.images.find(img => img.id === id)!).filter(Boolean)
);

const canSubmit = computed(() => {
    if (!question.value.trim()) return false;
    if (pollType.value === 'ab') return imageAId.value && imageBId.value;
    return selectedIds.value.length >= 2;
});

function submit() {
    if (!canSubmit.value || submitting.value) return;
    submitting.value = true;
    errors.value = {};

    const payload: any = {
        type:     pollType.value,
        question: question.value,
    };

    if (pollType.value === 'ab') {
        payload.image_a_id = imageAId.value;
        payload.image_b_id = imageBId.value;
    } else {
        payload.image_ids   = selectedIds.value;
        payload.max_choices = maxChoices.value;
    }

    router.post('/polls', payload, {
        onError: (e) => { errors.value = e; },
        onFinish: () => { submitting.value = false; },
    });
}
</script>

<template>
    <AppLayout>
        <Head title="Create Poll" />

        <div class="max-w-4xl mx-auto px-4 py-8 space-y-8">
            <div>
                <h1 class="text-2xl font-bold">Create a Poll</h1>
                <p class="text-muted-foreground text-sm mt-1">Let your audience vote on your images.</p>
            </div>

            <!-- Poll type toggle -->
            <div class="flex gap-3">
                <button
                    @click="pollType = 'ab'"
                    class="px-4 py-2 rounded-lg text-sm font-medium border transition-all"
                    :class="pollType === 'ab' ? 'bg-violet-600 border-violet-600 text-white' : 'border-border text-muted-foreground hover:border-foreground'"
                >
                    A/B Poll
                </button>
                <button
                    @click="pollType = 'multi'"
                    class="px-4 py-2 rounded-lg text-sm font-medium border transition-all"
                    :class="pollType === 'multi' ? 'bg-violet-600 border-violet-600 text-white' : 'border-border text-muted-foreground hover:border-foreground'"
                >
                    Multi-Image Poll
                </button>
            </div>

            <!-- Question -->
            <div class="space-y-1">
                <Label>Question</Label>
                <Input v-model="question" placeholder="Which photo do you prefer?" maxlength="200" />
                <p v-if="errors.question" class="text-xs text-red-500">{{ errors.question }}</p>
            </div>

            <!-- ── A/B Mode ─────────────────────────────────────────────── -->
            <template v-if="pollType === 'ab'">
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
                    <!-- Image A -->
                    <div class="space-y-2">
                        <Label>Image A</Label>
                        <div v-if="imageAId" class="relative rounded-xl overflow-hidden border-2 border-violet-500 aspect-square">
                            <img :src="images.find(i => i.id === imageAId)?.thumbnail_url" class="w-full h-full object-cover" />
                            <button @click="imageAId = null" class="absolute top-2 right-2 bg-black/60 rounded-full p-1 hover:bg-black">
                                <X class="h-4 w-4 text-white" />
                            </button>
                            <Badge class="absolute bottom-2 left-2 bg-violet-600">A</Badge>
                        </div>
                        <p v-if="errors.image_a_id" class="text-xs text-red-500">{{ errors.image_a_id }}</p>
                    </div>

                    <!-- Image B -->
                    <div class="space-y-2">
                        <Label>Image B</Label>
                        <div v-if="imageBId" class="relative rounded-xl overflow-hidden border-2 border-cyan-400 aspect-square">
                            <img :src="images.find(i => i.id === imageBId)?.thumbnail_url" class="w-full h-full object-cover" />
                            <button @click="imageBId = null" class="absolute top-2 right-2 bg-black/60 rounded-full p-1 hover:bg-black">
                                <X class="h-4 w-4 text-white" />
                            </button>
                            <Badge class="absolute bottom-2 left-2 bg-cyan-500">B</Badge>
                        </div>
                        <p v-if="errors.image_b_id" class="text-xs text-red-500">{{ errors.image_b_id }}</p>
                    </div>
                </div>

                <!-- Image picker for A/B -->
                <div class="space-y-2">
                    <Label class="text-muted-foreground text-xs uppercase tracking-wider">
                        Click an image to assign it to A or B
                    </Label>
                    <div class="grid grid-cols-3 sm:grid-cols-4 md:grid-cols-6 gap-2">
                        <button
                            v-for="img in images"
                            :key="img.id"
                            @click="!imageAId ? selectA(img.id) : !imageBId ? selectB(img.id) : null"
                            class="relative aspect-square rounded-lg overflow-hidden border-2 transition-all"
                            :class="[
                                img.id === imageAId ? 'border-violet-500' :
                                img.id === imageBId ? 'border-cyan-400' :
                                'border-transparent hover:border-muted-foreground'
                            ]"
                        >
                            <img :src="img.thumbnail_url" class="w-full h-full object-cover" />
                            <Badge v-if="img.id === imageAId" class="absolute bottom-1 left-1 text-[10px] bg-violet-600 px-1">A</Badge>
                            <Badge v-if="img.id === imageBId" class="absolute bottom-1 left-1 text-[10px] bg-cyan-500 px-1">B</Badge>
                        </button>
                    </div>
                </div>
            </template>

            <!-- ── Multi Mode ────────────────────────────────────────────── -->
            <template v-else>
                <!-- Max choices -->
                <div class="space-y-1 max-w-xs">
                    <Label>Max choices per voter <span class="text-muted-foreground">(optional)</span></Label>
                    <Input
                        v-model.number="maxChoices"
                        type="number"
                        min="1"
                        placeholder="Leave blank to allow all"
                    />
                    <p class="text-xs text-muted-foreground">e.g. 3 means each voter picks their 3 favorites</p>
                </div>

                <!-- Selected images order preview -->
                <div v-if="selectedImages.length" class="space-y-2">
                    <Label>Selected ({{ selectedImages.length }} images — drag to reorder)</Label>
                    <div class="flex flex-wrap gap-2">
                        <div
                            v-for="(img, idx) in selectedImages"
                            :key="img.id"
                            class="relative group w-20 h-20 rounded-lg overflow-hidden border-2 border-violet-500"
                        >
                            <img :src="img.thumbnail_url" class="w-full h-full object-cover" />
                            <div class="absolute inset-0 bg-black/50 opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center gap-1">
                                <button @click="moveUp(img.id)" :disabled="idx === 0" class="text-white disabled:opacity-30 text-xs px-1">↑</button>
                                <button @click="removeFromMulti(img.id)" class="text-white text-xs px-1"><X class="h-3 w-3" /></button>
                                <button @click="moveDown(img.id)" :disabled="idx === selectedImages.length - 1" class="text-white disabled:opacity-30 text-xs px-1">↓</button>
                            </div>
                            <span class="absolute top-1 left-1 bg-black/70 text-white text-[10px] rounded px-1">{{ idx + 1 }}</span>
                        </div>
                    </div>
                </div>

                <p v-if="errors.image_ids" class="text-xs text-red-500">{{ errors.image_ids }}</p>

                <!-- Image picker for multi -->
                <div class="space-y-2">
                    <Label class="text-muted-foreground text-xs uppercase tracking-wider">
                        Click images to add/remove from poll
                    </Label>
                    <div class="grid grid-cols-3 sm:grid-cols-4 md:grid-cols-6 gap-2">
                        <button
                            v-for="img in images"
                            :key="img.id"
                            @click="toggleMulti(img.id)"
                            class="relative aspect-square rounded-lg overflow-hidden border-2 transition-all"
                            :class="isSelected(img.id) ? 'border-violet-500' : 'border-transparent hover:border-muted-foreground'"
                        >
                            <img :src="img.thumbnail_url" class="w-full h-full object-cover" />
                            <div v-if="isSelected(img.id)" class="absolute inset-0 bg-violet-500/20 flex items-center justify-center">
                                <Check class="h-6 w-6 text-white drop-shadow" />
                            </div>
                            <span class="absolute top-1 left-1 bg-black/70 text-white text-[10px] rounded px-1">
                                {{ isSelected(img.id) ? selectedIds.indexOf(img.id) + 1 : '' }}
                            </span>
                        </button>
                    </div>
                </div>
            </template>

            <!-- Submit -->
            <div class="flex items-center gap-4 pt-2">
                <Button
                    @click="submit"
                    :disabled="!canSubmit || submitting"
                    class="bg-violet-600 hover:bg-violet-700"
                >
                    {{ submitting ? 'Creating…' : 'Create Poll' }}
                </Button>
                <span v-if="pollType === 'multi' && selectedIds.length < 2" class="text-xs text-muted-foreground">
                    Select at least 2 images
                </span>
            </div>
        </div>
    </AppLayout>
</template>