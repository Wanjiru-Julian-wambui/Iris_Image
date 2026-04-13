<script setup lang="ts">
import { Head, Link, router } from '@inertiajs/vue3';
import { Clock, Copy, ExternalLink, Lock, Plus, Trash2 } from 'lucide-vue-next';
import { ref } from 'vue';
import AppLayout from '@/layouts/AppLayout.vue';
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
import type { BreadcrumbItem } from '@/types';

const props = defineProps<{
    links: {
        data: App.SharedLinkResource[];
        meta: { current_page: number; last_page: number; total: number };
        links: { next: string | null; prev: string | null };
    };
}>();

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Dashboard', href: '/dashboard' },
    { title: 'Shared Links', href: '/shared-links' },
];

const confirmDelete = ref<App.SharedLinkResource | null>(null);
const deleting = ref(false);
const copiedId = ref<number | null>(null);

function copyUrl(link: App.SharedLinkResource) {
    navigator.clipboard.writeText(link.url);
    copiedId.value = link.id;
    setTimeout(() => { copiedId.value = null; }, 2000);
}

function deleteLink() {
    if (!confirmDelete.value) return;
    deleting.value = true;
    router.delete(`/shared-links/${confirmDelete.value.id}`, {
        onFinish: () => {
            deleting.value = false;
            confirmDelete.value = null;
        },
    });
}
</script>

<template>
    <AppLayout :breadcrumbs="breadcrumbs">
        <Head title="Shared Links" />

        <div class="px-4 py-6 md:px-8">
            <!-- Header -->
            <div class="flex items-center justify-between mb-6">
                <div>
                    <h1 class="text-2xl font-bold tracking-tight">Shared Links</h1>
                    <p class="text-sm text-muted-foreground mt-1">
                        {{ links.meta.total }} link{{ links.meta.total !== 1 ? 's' : '' }} total
                    </p>
                </div>
                <Link href="/shared-links/create">
                    <Button class="gap-2 bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF] text-white hover:opacity-90">
                        <Plus class="h-4 w-4" />
                        New link
                    </Button>
                </Link>
            </div>

            <!-- Empty state -->
            <div
                v-if="links.data.length === 0"
                class="flex flex-col items-center justify-center rounded-xl border border-dashed border-border py-24 text-center"
            >
                <div class="flex size-14 items-center justify-center rounded-full bg-muted mb-4">
                    <ExternalLink class="h-7 w-7 text-muted-foreground" />
                </div>
                <h3 class="text-lg font-semibold mb-1">No shared links yet</h3>
                <p class="text-sm text-muted-foreground mb-6">Create an expiring link to share an image.</p>
                <Link href="/shared-links/create">
                    <Button class="gap-2 bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF] text-white hover:opacity-90">
                        <Plus class="h-4 w-4" />
                        Create link
                    </Button>
                </Link>
            </div>

            <!-- Links table -->
            <div v-else class="rounded-xl border border-border overflow-hidden">
                <table class="w-full text-sm">
                    <thead class="bg-muted/50 border-b border-border">
                        <tr>
                            <th class="text-left px-4 py-3 font-medium text-muted-foreground">Image</th>
                            <th class="text-left px-4 py-3 font-medium text-muted-foreground">Link</th>
                            <th class="text-left px-4 py-3 font-medium text-muted-foreground">Expires</th>
                            <th class="text-left px-4 py-3 font-medium text-muted-foreground">Views</th>
                            <th class="text-left px-4 py-3 font-medium text-muted-foreground">Status</th>
                            <th class="px-4 py-3" />
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-border">
                        <tr
                            v-for="link in links.data"
                            :key="link.id"
                            class="hover:bg-muted/30 transition-colors"
                        >
                            <!-- Image thumbnail -->
                            <td class="px-4 py-3">
                                <div class="flex items-center gap-3">
                                    <div class="size-10 rounded-lg overflow-hidden bg-muted border border-border shrink-0">
                                        <img
                                            v-if="link.image?.thumbnail_url"
                                            :src="link.image.thumbnail_url"
                                            :alt="link.image.name"
                                            class="w-full h-full object-cover"
                                        />
                                    </div>
                                    <span class="font-medium truncate max-w-[140px]">
                                        {{ link.image?.name ?? '—' }}
                                    </span>
                                </div>
                            </td>

                            <!-- URL -->
                            <td class="px-4 py-3">
                                <div class="flex items-center gap-2">
                                    <Lock v-if="link.is_password_protected" class="h-3.5 w-3.5 text-muted-foreground shrink-0" />
                                    <span class="font-mono text-xs text-muted-foreground truncate max-w-[160px]">
                                        {{ link.url }}
                                    </span>
                                </div>
                            </td>

                            <!-- Expires -->
                            <td class="px-4 py-3">
                                <div class="flex items-center gap-1.5 text-muted-foreground">
                                    <Clock class="h-3.5 w-3.5 shrink-0" />
                                    <span class="text-xs">
                                        {{ link.is_expired ? 'Expired' : link.expires_in_human }}
                                    </span>
                                </div>
                            </td>

                            <!-- View count -->
                            <td class="px-4 py-3 text-muted-foreground">
                                {{ link.view_count }}
                            </td>

                            <!-- Status -->
                            <td class="px-4 py-3">
                                <Badge
                                    :class="link.is_expired
                                        ? 'bg-muted text-muted-foreground'
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
                                        class="h-8 w-8"
                                        :disabled="link.is_expired"
                                        @click="copyUrl(link)"
                                    >
                                        <Copy class="h-4 w-4" :class="copiedId === link.id ? 'text-green-500' : ''" />
                                    </Button>
                                    <a :href="link.url" target="_blank" rel="noopener noreferrer">
                                        <Button variant="ghost" size="icon" class="h-8 w-8" :disabled="link.is_expired">
                                            <ExternalLink class="h-4 w-4" />
                                        </Button>
                                    </a>
                                    <Button
                                        variant="ghost"
                                        size="icon"
                                        class="h-8 w-8 text-destructive hover:text-destructive"
                                        @click="confirmDelete = link"
                                    >
                                        <Trash2 class="h-4 w-4" />
                                    </Button>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <div v-if="links.meta.last_page > 1" class="flex justify-center gap-2 mt-8">
                <Link v-if="links.links.prev" :href="links.links.prev">
                    <Button variant="outline" size="sm">Previous</Button>
                </Link>
                <span class="flex items-center text-sm text-muted-foreground px-3">
                    Page {{ links.meta.current_page }} of {{ links.meta.last_page }}
                </span>
                <Link v-if="links.links.next" :href="links.links.next">
                    <Button variant="outline" size="sm">Next</Button>
                </Link>
            </div>
        </div>

        <!-- Delete dialog -->
        <Dialog :open="!!confirmDelete" @update:open="confirmDelete = null">
            <DialogContent>
                <DialogHeader>
                    <DialogTitle>Delete shared link</DialogTitle>
                    <DialogDescription>
                        This link will be permanently deleted and will no longer work for anyone who has it.
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
    </AppLayout>
</template>