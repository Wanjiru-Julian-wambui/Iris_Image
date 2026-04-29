<script setup lang="ts">
import { Head, Link, router } from '@inertiajs/vue3';
import { BarChart3, Plus, Trash2, Link2 } from 'lucide-vue-next';
import { ref } from 'vue';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import {
    Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle,
} from '@/components/ui/dialog';
import AppLayout from '@/layouts/AppLayout.vue';
import type { BreadcrumbItem } from '@/types';

const props = defineProps<{
    polls: {
        data: App.ImagePoll[];
        meta: { current_page: number; last_page: number; total: number };
        links: { next: string | null; prev: string | null };
    };
}>();

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Dashboard', href: '/dashboard' },
    { title: 'Polls',     href: '/polls'     },
];

const confirmDelete = ref<App.ImagePoll | null>(null);
const deleting = ref(false);

function deletePoll() {
    if (!confirmDelete.value) return;
    deleting.value = true;
    router.delete(`/polls/${confirmDelete.value.id}`, {
        onFinish: () => {
            deleting.value = false;
            confirmDelete.value = null;
        },
    });
}

function copyUrl(url: string) {
    navigator.clipboard.writeText(url);
}

// For multi polls, get the top N images by vote count
function topImages(poll: App.ImagePoll, n = 4) {
    if (!poll.images) return [];
    const items: any[] = poll.results?.items ?? [];
    return [...poll.images]
        .sort((a, b) => {
            const ca = items.find((r: any) => r.image_id === a.id)?.count ?? 0;
            const cb = items.find((r: any) => r.image_id === b.id)?.count ?? 0;
            return cb - ca;
        })
        .slice(0, n);
}

function multiPercent(poll: App.ImagePoll, imageId: number) {
    const item = (poll.results?.items ?? []).find((r: any) => r.image_id === imageId);
    return item?.percent ?? 0;
}

function multiCount(poll: App.ImagePoll, imageId: number) {
    const item = (poll.results?.items ?? []).find((r: any) => r.image_id === imageId);
    return item?.count ?? 0;
}
</script>

<template>
    <AppLayout :breadcrumbs="breadcrumbs">
        <Head title="Polls" />

        <div class="px-4 py-6 md:px-8">
            <div class="flex items-center justify-between mb-6">
                <div>
                    <h1 class="text-2xl font-bold tracking-tight">Polls</h1>
                    <p class="text-sm text-muted-foreground mt-1">{{ polls.meta.total }} poll{{ polls.meta.total !== 1 ? 's' : '' }}</p>
                </div>
                <Link href="/polls/create">
                    <Button class="gap-2 bg-gradient-to-r from-violet-500 to-cyan-400 text-white hover:opacity-90">
                        <Plus class="h-4 w-4" />
                        Create poll
                    </Button>
                </Link>
            </div>

            <!-- Empty state -->
            <div v-if="polls.data.length === 0" class="flex flex-col items-center justify-center rounded-xl border border-dashed border-border py-24 text-center">
                <div class="flex size-16 items-center justify-center rounded-full bg-muted mb-4">
                    <BarChart3 class="h-8 w-8 text-muted-foreground" />
                </div>
                <h3 class="text-lg font-semibold mb-1">No polls yet</h3>
                <p class="text-sm text-muted-foreground mb-6">Create a poll to let people vote on your images.</p>
                <Link href="/polls/create">
                    <Button class="gap-2 bg-gradient-to-r from-violet-500 to-cyan-400 text-white hover:opacity-90">
                        <Plus class="h-4 w-4" />
                        Create your first poll
                    </Button>
                </Link>
            </div>

            <!-- Polls grid -->
            <div v-else class="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div v-for="poll in polls.data" :key="poll.id" class="rounded-xl border border-border bg-card overflow-hidden">
                    <div class="p-4 space-y-3">

                        <!-- Title row -->
                        <div class="flex items-start justify-between gap-2">
                            <div class="space-y-1">
                                <h3 class="text-sm font-semibold leading-tight">{{ poll.question }}</h3>
                                <Badge variant="secondary" class="text-[10px] capitalize">{{ poll.type === 'ab' ? 'A/B' : 'Multi' }}</Badge>
                            </div>
                            <div class="flex items-center gap-1 shrink-0">
                                <button @click="copyUrl(poll.public_url)" class="text-muted-foreground hover:text-violet-400 transition-colors p-1">
                                    <Link2 class="h-3.5 w-3.5" />
                                </button>
                                <button @click="confirmDelete = poll" class="text-muted-foreground hover:text-rose-400 transition-colors p-1">
                                    <Trash2 class="h-3.5 w-3.5" />
                                </button>
                            </div>
                        </div>

                        <!-- ── A/B preview ── -->
                        <template v-if="poll.type === 'ab'">
                            <div class="grid grid-cols-2 gap-2">
                                <div class="relative rounded-lg overflow-hidden aspect-square bg-muted">
                                    <img :src="poll.image_a?.thumbnail_url" class="w-full h-full object-cover" />
                                    <div class="absolute bottom-1 left-1 right-1">
                                        <div class="h-1.5 rounded-full bg-black/30 overflow-hidden">
                                            <div class="h-full bg-violet-400 rounded-full transition-all" :style="{ width: poll.results?.a_percent + '%' }" />
                                        </div>
                                    </div>
                                    <Badge class="absolute top-1 left-1 text-[10px] h-4 px-1 bg-black/60 text-white border-0">
                                        {{ poll.results?.a_count }} votes
                                    </Badge>
                                </div>
                                <div class="relative rounded-lg overflow-hidden aspect-square bg-muted">
                                    <img :src="poll.image_b?.thumbnail_url" class="w-full h-full object-cover" />
                                    <div class="absolute bottom-1 left-1 right-1">
                                        <div class="h-1.5 rounded-full bg-black/30 overflow-hidden">
                                            <div class="h-full bg-cyan-400 rounded-full transition-all" :style="{ width: poll.results?.b_percent + '%' }" />
                                        </div>
                                    </div>
                                    <Badge class="absolute top-1 left-1 text-[10px] h-4 px-1 bg-black/60 text-white border-0">
                                        {{ poll.results?.b_count }} votes
                                    </Badge>
                                </div>
                            </div>

                            <div class="space-y-1">
                                <div class="flex justify-between text-xs text-muted-foreground">
                                    <span>{{ poll.results?.a_percent }}%</span>
                                    <span>{{ poll.results?.total }} total votes</span>
                                    <span>{{ poll.results?.b_percent }}%</span>
                                </div>
                                <div class="h-2 rounded-full bg-muted overflow-hidden flex">
                                    <div class="bg-violet-500 transition-all" :style="{ width: poll.results?.a_percent + '%' }" />
                                    <div class="bg-cyan-400 transition-all" :style="{ width: poll.results?.b_percent + '%' }" />
                                </div>
                            </div>
                        </template>

                        <!-- ── Multi preview ── -->
                        <template v-else>
                            <!-- Show up to 4 images in a 2x2 grid -->
                            <div class="grid grid-cols-4 gap-1.5">
                                <div
                                    v-for="img in topImages(poll, 4)"
                                    :key="img.id"
                                    class="relative rounded-md overflow-hidden aspect-square bg-muted"
                                >
                                    <img :src="img.thumbnail_url" class="w-full h-full object-cover" />
                                    <div class="absolute bottom-0 left-0 right-0 bg-black/50 text-white text-[9px] text-center py-0.5">
                                        {{ multiPercent(poll, img.id) }}%
                                    </div>
                                </div>
                                <!-- Overflow indicator -->
                                <div
                                    v-if="(poll.images?.length ?? 0) > 4"
                                    class="relative rounded-md overflow-hidden aspect-square bg-muted flex items-center justify-center"
                                >
                                    <span class="text-xs text-muted-foreground font-medium">+{{ (poll.images?.length ?? 0) - 4 }}</span>
                                </div>
                            </div>

                            <div class="flex justify-between text-xs text-muted-foreground">
                                <span>{{ poll.images?.length ?? 0 }} images</span>
                                <span>{{ poll.results?.total_voters ?? 0 }} voter{{ poll.results?.total_voters !== 1 ? 's' : '' }}</span>
                                <span>{{ poll.results?.total_votes ?? 0 }} votes cast</span>
                            </div>
                        </template>

                        <!-- Footer row (shared) -->
                        <div class="flex items-center justify-between pt-1">
                            <span class="text-xs text-muted-foreground">{{ poll.created_at }}</span>
                            <Link :href="poll.public_url" target="_blank">
                                <Button variant="outline" size="sm" class="h-7 text-xs gap-1">
                                    <BarChart3 class="h-3 w-3" />
                                    View poll
                                </Button>
                            </Link>
                        </div>

                    </div>
                </div>
            </div>

            <!-- Pagination -->
            <div v-if="polls.meta.last_page > 1" class="flex justify-center gap-2 mt-8">
                <Link v-if="polls.links.prev" :href="polls.links.prev">
                    <Button variant="outline" size="sm">Previous</Button>
                </Link>
                <span class="flex items-center text-sm text-muted-foreground px-3">
                    Page {{ polls.meta.current_page }} of {{ polls.meta.last_page }}
                </span>
                <Link v-if="polls.links.next" :href="polls.links.next">
                    <Button variant="outline" size="sm">Next</Button>
                </Link>
            </div>
        </div>

        <!-- Delete Dialog -->
        <Dialog :open="!!confirmDelete" @update:open="confirmDelete = null">
            <DialogContent>
                <DialogHeader>
                    <DialogTitle>Delete poll</DialogTitle>
                    <DialogDescription>
                        Are you sure you want to delete this poll? All votes will be lost.
                    </DialogDescription>
                </DialogHeader>
                <DialogFooter>
                    <Button variant="outline" @click="confirmDelete = null">Cancel</Button>
                    <Button variant="destructive" :disabled="deleting" @click="deletePoll">
                        {{ deleting ? 'Deleting...' : 'Delete' }}
                    </Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>
    </AppLayout>
</template>