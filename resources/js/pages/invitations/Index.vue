<script setup lang="ts">
import { Head, Link, router } from '@inertiajs/vue3';
import { Plus, Trash2 } from 'lucide-vue-next';
import { ref } from 'vue';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import {
    Dialog,
    DialogContent,
    DialogDescription,
    DialogFooter,
    DialogHeader,
    DialogTitle,
} from '@/components/ui/dialog';
import AppLayout from '@/layouts/AppLayout.vue';
import type { BreadcrumbItem } from '@/types';

const props = defineProps<{
    invitations: {
        data: Array<{
            id: number;
            email: string;
            status: 'pending' | 'accepted' | 'expired';
            expiresAt: string | null;
            invitedBy: { name: string } | null;
        }>;
        links: Array<{ url: string | null; label: string; active: boolean }>;
        meta: { current_page: number; last_page: number; total: number };
    };
}>();

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Dashboard', href: '/dashboard' },
    { title: 'Invitations', href: '/invitations' },
];

const statusVariant = (status: string) => {
    if (status === 'accepted') return 'default';
    if (status === 'expired') return 'destructive';
    return 'secondary';
};

const confirmDelete = ref<{ id: number; email: string } | null>(null);
const deleting = ref(false);

function openDelete(inv: { id: number; email: string }) {
    confirmDelete.value = inv;
}

function cancelDelete() {
    confirmDelete.value = null;
}

function deleteInvitation() {
    if (!confirmDelete.value) return;
    deleting.value = true;
    router.delete(`/invitations/${confirmDelete.value.id}`, {
        onFinish: () => {
            deleting.value = false;
            confirmDelete.value = null;
        },
    });
}
</script>

<template>
    <AppLayout :breadcrumbs="breadcrumbs">
        <Head title="Invitations" />

        <div class="px-4 py-6 md:px-8">
            <!-- Header -->
            <div class="flex items-center justify-between mb-6">
                <div>
                    <h1 class="text-2xl font-bold tracking-tight">Invitations</h1>
                    <p class="text-sm text-muted-foreground mt-1">
                        {{ invitations.meta.total }} invitation{{ invitations.meta.total !== 1 ? 's' : '' }} total
                    </p>
                </div>
                <Link href="/invitations/create">
                    <Button class="gap-2 bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF] text-white hover:opacity-90">
                        <Plus class="h-4 w-4" />
                        Send Invitation
                    </Button>
                </Link>
            </div>

            <!-- Empty state -->
            <div
                v-if="invitations.data.length === 0"
                class="flex flex-col items-center justify-center rounded-xl border border-dashed border-border py-24 text-center"
            >
                <h3 class="text-lg font-semibold mb-1">No invitations yet</h3>
                <p class="text-sm text-muted-foreground mb-6 max-w-xs">
                    Invite someone to join your workspace.
                </p>
                <Link href="/invitations/create">
                    <Button class="gap-2 bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF] text-white hover:opacity-90">
                        <Plus class="h-4 w-4" />
                        Send Invitation
                    </Button>
                </Link>
            </div>

            <!-- Table -->
            <div v-else class="rounded-xl border border-border overflow-hidden">
                <table class="min-w-full divide-y divide-border">
                    <thead class="bg-muted">
                        <tr>
                            <th class="px-4 py-3 text-left text-xs font-medium text-muted-foreground uppercase tracking-wider">Email</th>
                            <th class="px-4 py-3 text-left text-xs font-medium text-muted-foreground uppercase tracking-wider">Status</th>
                            <th class="px-4 py-3 text-left text-xs font-medium text-muted-foreground uppercase tracking-wider">Expires</th>
                            <th class="px-4 py-3 text-left text-xs font-medium text-muted-foreground uppercase tracking-wider">Invited By</th>
                            <th class="px-4 py-3"></th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-border">
                        <tr v-for="inv in invitations.data" :key="inv.id" class="hover:bg-muted/50 transition-colors">
                            <td class="px-4 py-3 text-sm">{{ inv.email }}</td>
                            <td class="px-4 py-3 text-sm">
                                <Badge :variant="statusVariant(inv.status)" class="capitalize">
                                    {{ inv.status }}
                                </Badge>
                            </td>
                            <td class="px-4 py-3 text-sm text-muted-foreground">
                                {{ inv.expiresAt ? new Date(inv.expiresAt).toLocaleString() : '-' }}
                            </td>
                            <td class="px-4 py-3 text-sm text-muted-foreground">
                                {{ inv.invitedBy?.name ?? '-' }}
                            </td>
                            <td class="px-4 py-3 text-right">
                                <button
                                    @click="openDelete(inv)"
                                    class="flex size-7 items-center justify-center rounded-full bg-red-500/10 hover:bg-red-500 text-red-500 hover:text-white transition-colors"
                                >
                                    <Trash2 class="h-3.5 w-3.5" />
                                </button>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <div v-if="invitations.meta.last_page > 1" class="flex justify-center gap-2 mt-8">
                <template v-for="link in invitations.links" :key="link.label">
                    <Link v-if="link.url" :href="link.url">
                        <Button
                            variant="outline"
                            size="sm"
                            :class="link.active ? 'bg-primary text-primary-foreground' : ''"
                            v-html="link.label"
                        />
                    </Link>
                    <Button v-else variant="ghost" size="sm" disabled v-html="link.label" />
                </template>
            </div>
        </div>

        <!-- Delete Confirmation Dialog -->
        <Dialog :open="!!confirmDelete" @update:open="cancelDelete">
            <DialogContent>
                <DialogHeader>
                    <DialogTitle>Delete invitation</DialogTitle>
                    <DialogDescription>
                        Are you sure you want to delete the invitation for
                        <strong>{{ confirmDelete?.email }}</strong>?
                        This action cannot be undone.
                    </DialogDescription>
                </DialogHeader>
                <DialogFooter>
                    <Button variant="outline" @click="cancelDelete">Cancel</Button>
                    <Button variant="destructive" :disabled="deleting" @click="deleteInvitation">
                        {{ deleting ? 'Deleting...' : 'Delete' }}
                    </Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>
    </AppLayout>
</template>