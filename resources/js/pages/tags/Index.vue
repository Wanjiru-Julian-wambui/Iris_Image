<script setup lang="ts">
import { Head, Link, router } from '@inertiajs/vue3';
import { Tag, Trash2, Image, Plus, X } from 'lucide-vue-next';
import { ref, computed } from 'vue';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Badge } from '@/components/ui/badge';
import {
    Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle,
} from '@/components/ui/dialog';
import AppLayout from '@/layouts/AppLayout.vue';
import type { BreadcrumbItem } from '@/types';

interface TagItem {
    id: number;
    name: string;
    slug: string;
    images_count: number;
    created_at: string;
}

const props = defineProps<{
    tags: TagItem[];
}>();

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Dashboard', href: '/dashboard' },
    { title: 'Tags',      href: '/tags'      },
];

const newTagName = ref('');
const creating = ref(false);
const confirmDelete = ref<TagItem | null>(null);
const deleting = ref(false);

const sortedTags = computed(() => {
    return [...props.tags].sort((a, b) => a.name.localeCompare(b.name));
});

function createTag() {
    const name = newTagName.value.trim();
    if (!name) return;

    creating.value = true;
    router.post('/tags', { name }, {
        preserveScroll: true,
        onFinish: () => {
            creating.value = false;
            newTagName.value = '';
        },
    });
}

function deleteTag() {
    if (!confirmDelete.value) return;
    deleting.value = true;
    router.delete(`/tags/${confirmDelete.value.id}`, {
        preserveScroll: true,
        onFinish: () => {
            deleting.value = false;
            confirmDelete.value = null;
        },
    });
}

function searchByTag(tagName: string) {
    router.get('/gallery', { search: tagName }, {
        preserveState: true,
        preserveScroll: true,
    });
}
</script>

<template>
    <AppLayout :breadcrumbs="breadcrumbs">
        <Head title="Tags" />

        <div class="px-4 py-6 md:px-8 max-w-4xl mx-auto">
            <div class="flex items-center justify-between mb-6">
                <div>
                    <h1 class="text-2xl font-bold tracking-tight">Tags</h1>
                    <p class="text-sm text-muted-foreground mt-1">{{ tags.length }} tag{{ tags.length !== 1 ? 's' : '' }}</p>
                </div>
            </div>

            <!-- Create tag -->
            <div class="flex gap-2 mb-8">
                <Input
                    v-model="newTagName"
                    placeholder="Create a new tag..."
                    class="max-w-xs"
                    @keydown.enter.prevent="createTag"
                />
                <Button
                    class="gap-2 bg-gradient-to-r from-violet-500 to-cyan-400 text-white hover:opacity-90"
                    :disabled="creating || !newTagName.trim()"
                    @click="createTag"
                >
                    <Plus v-if="!creating" class="h-4 w-4" />
                    <span v-else class="h-4 w-4 animate-spin rounded-full border-2 border-white border-t-transparent" />
                    {{ creating ? 'Creating...' : 'Create' }}
                </Button>
            </div>

            <!-- Tags list -->
            <div v-if="tags.length === 0" class="text-center py-16">
                <div class="flex size-16 items-center justify-center rounded-full bg-muted mx-auto mb-4">
                    <Tag class="h-8 w-8 text-muted-foreground" />
                </div>
                <h3 class="text-lg font-semibold mb-1">No tags yet</h3>
                <p class="text-sm text-muted-foreground">Create tags to organize your images.</p>
            </div>

            <div v-else class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3">
                <div
                    v-for="tag in sortedTags"
                    :key="tag.id"
                    class="group flex items-center justify-between rounded-xl border border-border bg-card p-4 hover:border-violet-500/30 transition-colors"
                >
                    <div class="flex items-center gap-3 min-w-0">
                        <div class="flex size-8 items-center justify-center rounded-lg bg-violet-500/10">
                            <Tag class="h-4 w-4 text-violet-400" />
                        </div>
                        <div class="min-w-0">
                            <button
                                @click="searchByTag(tag.name)"
                                class="text-sm font-medium hover:text-violet-400 transition-colors truncate block text-left"
                            >
                                {{ tag.name }}
                            </button>
                            <div class="flex items-center gap-1.5 text-xs text-muted-foreground">
                                <Image class="h-3 w-3" />
                                <span>{{ tag.images_count }} image{{ tag.images_count !== 1 ? 's' : '' }}</span>
                            </div>
                        </div>
                    </div>

                    <button
                        @click="confirmDelete = tag"
                        class="opacity-0 group-hover:opacity-100 transition-opacity text-muted-foreground hover:text-rose-400 p-1"
                    >
                        <Trash2 class="h-4 w-4" />
                    </button>
                </div>
            </div>
        </div>

        <!-- Delete Dialog -->
        <Dialog :open="!!confirmDelete" @update:open="confirmDelete = null">
            <DialogContent>
                <DialogHeader>
                    <DialogTitle>Delete tag</DialogTitle>
                    <DialogDescription>
                        Are you sure you want to delete <strong>{{ confirmDelete?.name }}</strong>?
                        This will remove the tag from all images. The images themselves will not be deleted.
                    </DialogDescription>
                </DialogHeader>
                <DialogFooter>
                    <Button variant="outline" @click="confirmDelete = null">Cancel</Button>
                    <Button variant="destructive" :disabled="deleting" @click="deleteTag">
                        {{ deleting ? 'Deleting...' : 'Delete' }}
                    </Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>
    </AppLayout>
</template>