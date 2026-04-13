<script setup lang="ts">
import { Clock, MailCheck, MailX, RefreshCw, Trash2 } from 'lucide-vue-next';
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
    invitations: App.InvitationResource[];
}>();

const confirmDelete = ref<App.InvitationResource | null>(null);
const deleting      = ref(false);
const resending     = ref<number | null>(null);

const statusConfig: Record<string, { label: string; class: string }> = {
    pending:  { label: 'Pending',  class: 'bg-amber-500/10 text-amber-600 border-amber-500/20' },
    accepted: { label: 'Accepted', class: 'bg-green-500/10 text-green-600 border-green-500/20' },
    expired:  { label: 'Expired',  class: 'bg-muted text-muted-foreground' },
};

function resend(invitation: App.InvitationResource) {
    resending.value = invitation.id;
    router.post(`/invitations/${invitation.id}/resend`, {}, {
        preserveScroll: true,
        onFinish: () => { resending.value = null; },
    });
}

function deleteInvitation() {
    if (!confirmDelete.value) return;
    deleting.value = true;
    router.delete(`/invitations/${confirmDelete.value.id}`, {
        preserveScroll: true,
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
            v-if="invitations.length === 0"
            class="rounded-xl border border-dashed border-border py-14 text-center"
        >
            <div class="flex size-12 items-center justify-center rounded-full bg-muted mx-auto mb-3">
                <MailX class="h-6 w-6 text-muted-foreground" />
            </div>
            <p class="text-sm font-medium">No invitations sent yet</p>
            <p class="text-xs text-muted-foreground mt-1">Send an invite to add someone to Iris.</p>
        </div>

        <!-- Table -->
        <div v-else class="rounded-xl border border-border overflow-hidden">
            <table class="w-full text-sm">
                <thead class="bg-muted/50 border-b border-border">
                    <tr>
                        <th class="text-left px-4 py-3 font-medium text-muted-foreground">Email</th>
                        <th class="text-left px-4 py-3 font-medium text-muted-foreground">Invited by</th>
                        <th class="text-left px-4 py-3 font-medium text-muted-foreground">Expires</th>
                        <th class="text-left px-4 py-3 font-medium text-muted-foreground">Status</th>
                        <th class="px-4 py-3" />
                    </tr>
                </thead>
                <tbody class="divide-y divide-border">
                    <tr
                        v-for="invitation in invitations"
                        :key="invitation.id"
                        class="hover:bg-muted/30 transition-colors"
                    >
                        <!-- Email -->
                        <td class="px-4 py-3">
                            <div class="flex items-center gap-2">
                                <MailCheck v-if="invitation.is_accepted" class="h-4 w-4 text-green-500 shrink-0" />
                                <MailX     v-else-if="invitation.is_expired" class="h-4 w-4 text-muted-foreground shrink-0" />
                                <Clock     v-else class="h-4 w-4 text-amber-500 shrink-0" />
                                <span class="font-medium">{{ invitation.email }}</span>
                            </div>
                        </td>

                        <!-- Invited by -->
                        <td class="px-4 py-3 text-muted-foreground">
                            {{ invitation.invited_by?.name ?? '—' }}
                        </td>

                        <!-- Expires -->
                        <td class="px-4 py-3 text-xs text-muted-foreground">
                            <span v-if="invitation.is_accepted">—</span>
                            <span v-else>{{ invitation.expires_at }}</span>
                        </td>

                        <!-- Status -->
                        <td class="px-4 py-3">
                            <Badge :class="statusConfig[invitation.status]?.class">
                                {{ statusConfig[invitation.status]?.label ?? invitation.status }}
                            </Badge>
                        </td>

                        <!-- Actions -->
                        <td class="px-4 py-3">
                            <div class="flex items-center justify-end gap-1">
                                <!-- Resend (only for expired/pending) -->
                                <Button
                                    v-if="!invitation.is_accepted"
                                    variant="ghost"
                                    size="icon"
                                    class="h-8 w-8"
                                    :disabled="resending === invitation.id"
                                    @click="resend(invitation)"
                                >
                                    <RefreshCw
                                        class="h-4 w-4 text-muted-foreground"
                                        :class="resending === invitation.id ? 'animate-spin' : ''"
                                    />
                                </Button>

                                <!-- Delete -->
                                <Button
                                    variant="ghost"
                                    size="icon"
                                    class="h-8 w-8 text-destructive hover:text-destructive"
                                    @click="confirmDelete = invitation"
                                >
                                    <Trash2 class="h-4 w-4" />
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
                    <DialogTitle>Revoke invitation</DialogTitle>
                    <DialogDescription>
                        Revoke the invitation sent to
                        <strong>{{ confirmDelete?.email }}</strong>?
                        The invite link will no longer work.
                    </DialogDescription>
                </DialogHeader>
                <DialogFooter>
                    <Button variant="outline" @click="confirmDelete = null">Cancel</Button>
                    <Button variant="destructive" :disabled="deleting" @click="deleteInvitation">
                        {{ deleting ? 'Revoking...' : 'Revoke' }}
                    </Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>
    </div>
</template>
