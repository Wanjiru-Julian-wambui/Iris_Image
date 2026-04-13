<script setup lang="ts">
import { Head, Link, router } from '@inertiajs/vue3';
import { ArrowLeft, Search, Shield, ShieldOff, Trash2, X } from 'lucide-vue-next';
import { ref } from 'vue';
import AppLayout from '@/layouts/AppLayout.vue';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Input } from '@/components/ui/input';
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
    users: {
        data: App.UserResource[];
        meta: { current_page: number; last_page: number; total: number };
        links: { next: string | null; prev: string | null };
    };
    search?: string;
    stats: {
        total_users: number;
        admin_users: number;
        total_storage: number;
    };
}>();

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Dashboard', href: '/dashboard' },
    { title: 'Admin', href: '/admin' },
    { title: 'Users', href: '/admin/users' },
];

const search = ref(props.search ?? '');
const confirmDelete = ref<App.UserResource | null>(null);
const deleting = ref(false);

function applySearch() {
    router.get('/admin/users', { search: search.value || undefined }, { preserveState: true, replace: true });
}

function clearSearch() {
    search.value = '';
    applySearch();
}

function toggleAdmin(user: App.UserResource) {
    router.patch(`/admin/users/${user.id}/toggle-admin`);
}

function deleteUser() {
    if (!confirmDelete.value) return;
    deleting.value = true;
    router.delete(`/admin/users/${confirmDelete.value.id}`, {
        onFinish: () => {
            deleting.value = false;
            confirmDelete.value = null;
        },
    });
}

function formatBytes(bytes: number): string {
    if (bytes >= 1073741824) return (bytes / 1073741824).toFixed(2) + ' GB';
    if (bytes >= 1048576)    return (bytes / 1048576).toFixed(2) + ' MB';
    if (bytes >= 1024)       return (bytes / 1024).toFixed(2) + ' KB';
    return bytes + ' B';
}
</script>

<template>
    <AppLayout :breadcrumbs="breadcrumbs">
        <Head title="Users" />

        <div class="px-4 py-6 md:px-8">
            <!-- Header -->
            <div class="flex items-center gap-4 mb-6">
                <Link href="/admin">
                    <Button variant="ghost" size="icon" class="h-8 w-8">
                        <ArrowLeft class="h-4 w-4" />
                    </Button>
                </Link>
                <div class="flex-1">
                    <h1 class="text-2xl font-bold tracking-tight">Users</h1>
                    <p class="text-sm text-muted-foreground mt-0.5">
                        {{ stats.total_users }} total · {{ stats.admin_users }} admin · {{ formatBytes(stats.total_storage) }} used
                    </p>
                </div>
            </div>

            <!-- Search -->
            <div class="relative mb-6 max-w-md">
                <Search class="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                <Input
                    v-model="search"
                    placeholder="Search by name or email..."
                    class="pl-9 pr-9"
                    @keydown.enter="applySearch"
                />
                <button v-if="search" @click="clearSearch" class="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-foreground">
                    <X class="h-4 w-4" />
                </button>
            </div>

            <!-- Users table -->
            <div class="rounded-xl border border-border overflow-hidden">
                <table class="w-full text-sm">
                    <thead class="bg-muted/50 border-b border-border">
                        <tr>
                            <th class="text-left px-4 py-3 font-medium text-muted-foreground">User</th>
                            <th class="text-left px-4 py-3 font-medium text-muted-foreground">Plan</th>
                            <th class="text-left px-4 py-3 font-medium text-muted-foreground">Storage</th>
                            <th class="text-left px-4 py-3 font-medium text-muted-foreground">Role</th>
                            <th class="text-left px-4 py-3 font-medium text-muted-foreground">Joined</th>
                            <th class="px-4 py-3" />
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-border">
                        <tr v-for="user in users.data" :key="user.id" class="hover:bg-muted/30 transition-colors">
                            <td class="px-4 py-3">
                                <Link :href="`/admin/users/${user.id}`">
                                    <div class="flex items-center gap-3 hover:opacity-80 transition-opacity">
                                        <img :src="user.avatar" :alt="user.name" class="size-8 rounded-full" />
                                        <div>
                                            <p class="font-medium">{{ user.name }}</p>
                                            <p class="text-xs text-muted-foreground">{{ user.email }}</p>
                                        </div>
                                    </div>
                                </Link>
                            </td>
                            <td class="px-4 py-3 text-muted-foreground">{{ user.plan?.name ?? 'Free' }}</td>
                            <td class="px-4 py-3">
                                <div>
                                    <p class="text-muted-foreground">{{ user.storage_used_human }}</p>
                                    <div class="w-24 h-1.5 rounded-full bg-muted mt-1 overflow-hidden">
                                        <div
                                            class="h-full rounded-full bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF]"
                                            :style="{ width: Math.min(user.storage_percent, 100) + '%' }"
                                        />
                                    </div>
                                </div>
                            </td>
                            <td class="px-4 py-3">
                                <Badge
                                    :class="user.is_admin
                                        ? 'bg-[#7B2FFF]/10 text-[#7B2FFF] border-[#7B2FFF]/20'
                                        : 'bg-muted text-muted-foreground'"
                                >
                                    {{ user.is_admin ? 'Admin' : 'User' }}
                                </Badge>
                            </td>
                            <td class="px-4 py-3 text-xs text-muted-foreground">{{ user.created_at }}</td>
                            <td class="px-4 py-3">
                                <div class="flex items-center justify-end gap-1">
                                    <Button
                                        variant="ghost"
                                        size="icon"
                                        class="h-8 w-8"
                                        @click="toggleAdmin(user)"
                                    >
                                        <Shield v-if="!user.is_admin" class="h-4 w-4 text-muted-foreground" />
                                        <ShieldOff v-else class="h-4 w-4 text-[#7B2FFF]" />
                                    </Button>
                                    <Button
                                        variant="ghost"
                                        size="icon"
                                        class="h-8 w-8 text-destructive hover:text-destructive"
                                        :disabled="user.is_admin"
                                        @click="confirmDelete = user"
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
            <div v-if="users.meta.last_page > 1" class="flex justify-center gap-2 mt-8">
                <Link v-if="users.links.prev" :href="users.links.prev">
                    <Button variant="outline" size="sm">Previous</Button>
                </Link>
                <span class="flex items-center text-sm text-muted-foreground px-3">
                    Page {{ users.meta.current_page }} of {{ users.meta.last_page }}
                </span>
                <Link v-if="users.links.next" :href="users.links.next">
                    <Button variant="outline" size="sm">Next</Button>
                </Link>
            </div>
        </div>

        <!-- Delete dialog -->
        <Dialog :open="!!confirmDelete" @update:open="confirmDelete = null">
            <DialogContent>
                <DialogHeader>
                    <DialogTitle>Delete user</DialogTitle>
                    <DialogDescription>
                        Are you sure you want to delete <strong>{{ confirmDelete?.name }}</strong>?
                        All their images and shared links will also be permanently deleted.
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
    </AppLayout>
</template>