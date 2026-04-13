<script setup lang="ts">
import { ArrowUpDown, Shield, ShieldOff, Trash2 } from 'lucide-vue-next';
import { ref, computed } from 'vue';
import { Link, router } from '@inertiajs/vue3';
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
import PlanBadge from '@/components/Plans/PlanBadge.vue';

type SortKey = 'name' | 'email' | 'plan' | 'storage' | 'created_at';
type SortDir = 'asc' | 'desc';

const props = defineProps<{
    users:        App.UserResource[];
    loading?:     boolean;
    showActions?: boolean;
}>();

const emit = defineEmits<{
    deleted:      [id: number];
    toggleAdmin:  [user: App.UserResource];
}>();

const sortKey = ref<SortKey>('created_at');
const sortDir = ref<SortDir>('desc');
const confirmDelete = ref<App.UserResource | null>(null);
const deleting      = ref(false);

const sorted = computed(() => {
    return [...props.users].sort((a, b) => {
        let valA: string | number;
        let valB: string | number;

        switch (sortKey.value) {
            case 'name':       valA = a.name;              valB = b.name;             break;
            case 'email':      valA = a.email;             valB = b.email;            break;
            case 'plan':       valA = a.plan?.name ?? '';  valB = b.plan?.name ?? ''; break;
            case 'storage':    valA = a.storage_used ?? 0; valB = b.storage_used ?? 0; break;
            case 'created_at': valA = a.created_at;        valB = b.created_at;       break;
            default:           return 0;
        }

        const cmp = typeof valA === 'number' && typeof valB === 'number'
            ? valA - valB
            : String(valA).localeCompare(String(valB));

        return sortDir.value === 'asc' ? cmp : -cmp;
    });
});

function toggleSort(key: SortKey) {
    if (sortKey.value === key) {
        sortDir.value = sortDir.value === 'asc' ? 'desc' : 'asc';
    } else {
        sortKey.value = key;
        sortDir.value = 'asc';
    }
}

function sortIcon(key: SortKey) {
    return sortKey.value === key ? (sortDir.value === 'asc' ? '↑' : '↓') : '';
}

function deleteUser() {
    if (!confirmDelete.value) return;
    deleting.value = true;
    router.delete(`/admin/users/${confirmDelete.value.id}`, {
        onSuccess: () => emit('deleted', confirmDelete.value!.id),
        onFinish:  () => {
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
            v-if="!loading && users.length === 0"
            class="rounded-xl border border-dashed border-border py-16 text-center"
        >
            <p class="text-sm text-muted-foreground">No users found.</p>
        </div>

        <!-- Table -->
        <div v-else class="rounded-xl border border-border overflow-hidden">
            <table class="w-full text-sm">
                <thead class="bg-muted/50 border-b border-border">
                    <tr>
                        <!-- User column -->
                        <th class="text-left px-4 py-3 font-medium text-muted-foreground">
                            <button
                                class="flex items-center gap-1 hover:text-foreground transition-colors"
                                @click="toggleSort('name')"
                            >
                                User
                                <span class="text-xs w-3">{{ sortIcon('name') }}</span>
                                <ArrowUpDown v-if="sortKey !== 'name'" class="h-3 w-3 opacity-40" />
                            </button>
                        </th>
                        <!-- Plan -->
                        <th class="text-left px-4 py-3 font-medium text-muted-foreground">
                            <button
                                class="flex items-center gap-1 hover:text-foreground transition-colors"
                                @click="toggleSort('plan')"
                            >
                                Plan
                                <span class="text-xs w-3">{{ sortIcon('plan') }}</span>
                                <ArrowUpDown v-if="sortKey !== 'plan'" class="h-3 w-3 opacity-40" />
                            </button>
                        </th>
                        <!-- Storage -->
                        <th class="text-left px-4 py-3 font-medium text-muted-foreground">
                            <button
                                class="flex items-center gap-1 hover:text-foreground transition-colors"
                                @click="toggleSort('storage')"
                            >
                                Storage
                                <span class="text-xs w-3">{{ sortIcon('storage') }}</span>
                                <ArrowUpDown v-if="sortKey !== 'storage'" class="h-3 w-3 opacity-40" />
                            </button>
                        </th>
                        <!-- Role -->
                        <th class="text-left px-4 py-3 font-medium text-muted-foreground">Role</th>
                        <!-- Joined -->
                        <th class="text-left px-4 py-3 font-medium text-muted-foreground">
                            <button
                                class="flex items-center gap-1 hover:text-foreground transition-colors"
                                @click="toggleSort('created_at')"
                            >
                                Joined
                                <span class="text-xs w-3">{{ sortIcon('created_at') }}</span>
                                <ArrowUpDown v-if="sortKey !== 'created_at'" class="h-3 w-3 opacity-40" />
                            </button>
                        </th>
                        <th v-if="showActions !== false" class="px-4 py-3" />
                    </tr>
                </thead>

                <!-- Skeleton rows -->
                <tbody v-if="loading" class="divide-y divide-border">
                    <tr v-for="i in 5" :key="i">
                        <td class="px-4 py-3">
                            <div class="flex items-center gap-3">
                                <div class="size-8 rounded-full bg-muted animate-pulse" />
                                <div class="space-y-1">
                                    <div class="h-3 w-28 rounded bg-muted animate-pulse" />
                                    <div class="h-2.5 w-36 rounded bg-muted animate-pulse" />
                                </div>
                            </div>
                        </td>
                        <td class="px-4 py-3"><div class="h-3 w-12 rounded bg-muted animate-pulse" /></td>
                        <td class="px-4 py-3"><div class="h-3 w-20 rounded bg-muted animate-pulse" /></td>
                        <td class="px-4 py-3"><div class="h-3 w-10 rounded bg-muted animate-pulse" /></td>
                        <td class="px-4 py-3"><div class="h-3 w-20 rounded bg-muted animate-pulse" /></td>
                        <td class="px-4 py-3" />
                    </tr>
                </tbody>

                <!-- Data rows -->
                <tbody v-else class="divide-y divide-border">
                    <tr
                        v-for="user in sorted"
                        :key="user.id"
                        class="hover:bg-muted/30 transition-colors"
                    >
                        <!-- User -->
                        <td class="px-4 py-3">
                            <Link :href="`/admin/users/${user.id}`">
                                <div class="flex items-center gap-3 hover:opacity-80 transition-opacity">
                                    <img
                                        :src="user.avatar"
                                        :alt="user.name"
                                        class="size-8 rounded-full shrink-0"
                                    />
                                    <div class="min-w-0">
                                        <p class="font-medium truncate">{{ user.name }}</p>
                                        <p class="text-xs text-muted-foreground truncate">{{ user.email }}</p>
                                    </div>
                                </div>
                            </Link>
                        </td>

                        <!-- Plan -->
                        <td class="px-4 py-3">
                            <PlanBadge :plan="user.plan" size="sm" />
                        </td>

                        <!-- Storage -->
                        <td class="px-4 py-3">
                            <div class="space-y-1">
                                <p class="text-xs text-muted-foreground">{{ user.storage_used_human }}</p>
                                <div class="w-20 h-1.5 rounded-full bg-muted overflow-hidden">
                                    <div
                                        class="h-full rounded-full transition-all"
                                        :class="(user.storage_percent ?? 0) >= 90
                                            ? 'bg-red-500'
                                            : (user.storage_percent ?? 0) >= 70
                                                ? 'bg-amber-500'
                                                : 'bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF]'"
                                        :style="{ width: Math.min(user.storage_percent ?? 0, 100) + '%' }"
                                    />
                                </div>
                            </div>
                        </td>

                        <!-- Role -->
                        <td class="px-4 py-3">
                            <Badge
                                class="text-xs"
                                :class="user.is_admin
                                    ? 'bg-[#7B2FFF]/10 text-[#7B2FFF] border-[#7B2FFF]/20'
                                    : 'bg-muted text-muted-foreground border-border'"
                            >
                                {{ user.is_admin ? 'Admin' : 'User' }}
                            </Badge>
                        </td>

                        <!-- Joined -->
                        <td class="px-4 py-3 text-xs text-muted-foreground">
                            {{ user.created_at }}
                        </td>

                        <!-- Actions -->
                        <td v-if="showActions !== false" class="px-4 py-3">
                            <div class="flex items-center justify-end gap-1">
                                <Button
                                    variant="ghost"
                                    size="icon"
                                    class="h-8 w-8"
                                    :title="user.is_admin ? 'Remove admin' : 'Make admin'"
                                    @click="emit('toggleAdmin', user)"
                                >
                                    <Shield v-if="!user.is_admin" class="h-4 w-4 text-muted-foreground" />
                                    <ShieldOff v-else class="h-4 w-4 text-[#7B2FFF]" />
                                </Button>
                                <Button
                                    variant="ghost"
                                    size="icon"
                                    class="h-8 w-8"
                                    :disabled="user.is_admin"
                                    @click="confirmDelete = user"
                                >
                                    <Trash2 class="h-4 w-4 text-destructive" />
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
                    <DialogTitle>Delete user</DialogTitle>
                    <DialogDescription>
                        Delete <strong>{{ confirmDelete?.name }}</strong>? All their images and shared links will also be permanently removed.
                    </DialogDescription>
                </DialogHeader>
                <DialogFooter>
                    <Button variant="outline" @click="confirmDelete = null">Cancel</Button>
                    <Button variant="destructive" :disabled="deleting" @click="deleteUser">
                        {{ deleting ? 'Deleting...' : 'Delete user' }}
                    </Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>
    </div>
</template>