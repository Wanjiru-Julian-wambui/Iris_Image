<script setup lang="ts">
import { Clock, Copy, ExternalLink, Lock, Trash2 } from 'lucide-vue-next';
import { ref } from 'vue';
import { router } from '@inertiajs/vue3';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import {
    Dialog,
    DialogContent,
    DialogDescription,
    DialogFooter,
    DialogHeader,
    DialogTitle,
} from '@/components/ui/dialog';

const props = defineProps<{
    links: App.SharedLinkResource[];
    showImage?: boolean;
}>();

const emit = defineEmits<{
    deleted: [id: number];
}>();

const confirmDelete = ref<App.SharedLinkResource | null>(null);
const deleting      = ref(false);
const copiedId      = ref<number | null>(null);

function copyUrl(link: App.SharedLinkResource) {
    navigator.clipboard.writeText(link.url);
    copiedId.value = link.id;
    setTimeout(() => { copiedId.value = null; }, 2000);
}

function deleteLink() {
    if (!confirmDelete.value) return;
    deleting.value = true;
    router.delete(`/shared-links/${confirmDelete.value.id}`, {
        preserveScroll: true,
        onSuccess: () => emit('deleted', confirmDelete.value!.id),
        onFinish: () => {
            deleting.value      = false;
            confirmDelete.value = null;
        },
    });
}
</script>

<template>
    <div>
        <!-- Empty state -->
        <div
            v-if="links.length === 0"
            class="rounded-xl border border-dashed border-border py-10 text-center"
        >
            <p class="text-sm text-muted-foreground">No shared links yet.</p>
        </div>

        <!-- Table -->
        <div v-else class="rounded-xl border border-border overflow-hidden">
            <table class="w-full text-sm">
                <thead class="bg-muted/50 border-b border-border">
                    <tr>
                        <th v-if="showImage" class="text-left px-4 py-3 font-medium text-muted-foreground">Image</th>
                        <th class="text-left px-4 py-3 font-medium text-muted-foreground">Link</th>
                        <th class="text-left px-4 py-3 font-medium text-muted-foreground">Expires</th>
                        <th class="text-left px-4 py-3 font-medium text-muted-foreground">Views</th>
                        <th class="text-left px-4 py-3 font-medium text-muted-foreground">Status</th>
                        <th class="px-4 py-3" />
                    </tr>
                </thead>
                <tbody class="divide-y divide-border">
                    <tr
                        v-for="link in links"
                        :key="link.id"
                        class="hover:bg-muted/30 transition-colors"
                    >
                        <!-- Image thumbnail (optional) -->
                        <td v-if="showImage" class="px-4 py-3">
                            <div class="flex items-center gap-3">
                                <div class="size-9 rounded-lg overflow-hidden bg-muted border border-border shrink-0">
                                    <img
                                        v-if="link.image?.thumbnail_url"
                                        :src="link.image.thumbnail_url"
                                        :alt="link.image.name"
                                        class="w-full h-full object-cover"
                                    />
                                </div>
                                <span class="text-xs font-medium truncate max-w-[120px] text-muted-foreground">
                                    {{ link.image?.name ?? '—' }}
                                </span>
                            </div>
                        </td>

                        <!-- Token / URL -->
                        <td class="px-4 py-3">
                            <div class="flex items-center gap-2">
                                <Lock
                                    v-if="link.is_password_protected"
                                    class="h-3.5 w-3.5 text-muted-foreground shrink-0"
                                />
                                <span class="font-mono text-xs text-muted-foreground truncate max-w-[160px]">
                                    /share/{{ link.token?.slice(0, 12) }}…
                                </span>
                            </div>
                        </td>

                        <!-- Expires -->
                        <td class="px-4 py-3">
                            <div class="flex items-center gap-1.5">
                                <Clock class="h-3.5 w-3.5 text-muted-foreground shrink-0" />
                                <span class="text-xs text-muted-foreground">
                                    {{ link.is_expired ? 'Expired' : link.expires_in_human }}
                                </span>
                            </div>
                        </td>

                        <!-- Views -->
                        <td class="px-4 py-3 text-muted-foreground text-xs">
                            {{ link.view_count }} view{{ link.view_count !== 1 ? 's' : '' }}
                        </td>

                        <!-- Status -->
                        <td class="px-4 py-3">
                            <Badge
                                class="text-xs"
                                :class="link.is_expired
                                    ? 'bg-muted text-muted-foreground border-border'
                                    : 'bg-green-500/10 text-green-600 border-green-500/20'"
                            >
                                {{ link.is_expired ? 'Expired' : 'Active' }}
                            </Badge>
                        </td>

                        <!-- Actions -->
                        <td class="px-4 py-3">
                            <div class="flex items-center justify-end gap-1">
                                <Button
                                    variant="ghost"
                                    size="icon"
                                    class="h-7 w-7"
                                    :disabled="link.is_expired"
                                    @click="copyUrl(link)"
                                >
                                    <Copy
                                        class="h-3.5 w-3.5"
                                        :class="copiedId === link.id ? 'text-green-500' : 'text-muted-foreground'"
                                    />
                                </Button>
                                <a :href="link.url" target="_blank" rel="noopener noreferrer">
                                    <Button
                                        variant="ghost"
                                        size="icon"
                                        class="h-7 w-7"
                                        :disabled="link.is_expired"
                                    >
                                        <ExternalLink class="h-3.5 w-3.5 text-muted-foreground" />
                                    </Button>
                                </a>
                                <Button
                                    variant="ghost"
                                    size="icon"
                                    class="h-7 w-7"
                                    @click="confirmDelete = link"
                                >
                                    <Trash2 class="h-3.5 w-3.5 text-destructive" />
                                </Button>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- Delete dialog -->
        <Dialog :open="!!confirmDelete" @update:open="confirmDelete = null">
            <DialogContent>
                <DialogHeader>
                    <DialogTitle>Delete shared link</DialogTitle>
                    <DialogDescription>
                        This link will be permanently deleted and will stop working immediately.
                    </DialogDescription>
                </DialogHeader>
                <DialogFooter>
                    <Button variant="outline" @click="confirmDelete = null">Cancel</Button>
                    <Button variant="destructive" :disabled="deleting" @click="deleteLink">
                        {{ deleting ? 'Deleting...' : 'Delete' }}
                    </Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>
    </div>
</template>
