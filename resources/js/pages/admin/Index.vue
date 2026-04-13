<script setup lang="ts">
import { Head, Link } from '@inertiajs/vue3';
import { HardDrive, Image as ImageIcon, Link as LinkIcon, Users } from 'lucide-vue-next';
import AppLayout from '@/layouts/AppLayout.vue';
import { Button } from '@/components/ui/button';
import type { BreadcrumbItem } from '@/types';

const props = defineProps<{
    stats: {
        total_users: number;
        admin_users: number;
        total_images: number;
        total_storage: number;
        active_links: number;
    };
    recentUsers: App.UserResource[];
}>();

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Dashboard', href: '/dashboard' },
    { title: 'Admin', href: '/admin' },
];

function formatBytes(bytes: number): string {
    if (bytes >= 1073741824) return (bytes / 1073741824).toFixed(2) + ' GB';
    if (bytes >= 1048576)    return (bytes / 1048576).toFixed(2) + ' MB';
    if (bytes >= 1024)       return (bytes / 1024).toFixed(2) + ' KB';
    return bytes + ' B';
}
</script>

<template>
    <AppLayout :breadcrumbs="breadcrumbs">
        <Head title="Admin" />

        <div class="px-4 py-6 md:px-8">
            <div class="mb-6">
                <h1 class="text-2xl font-bold tracking-tight">Admin</h1>
                <p class="text-sm text-muted-foreground mt-1">Overview of the Iris platform</p>
            </div>

            <!-- Stats cards -->
            <div class="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
                <div class="rounded-xl border border-border bg-card p-5">
                    <div class="flex items-center justify-between mb-3">
                        <p class="text-sm text-muted-foreground">Total users</p>
                        <div class="flex size-8 items-center justify-center rounded-lg bg-[#7B2FFF]/10">
                            <Users class="h-4 w-4 text-[#7B2FFF]" />
                        </div>
                    </div>
                    <p class="text-3xl font-bold">{{ stats.total_users }}</p>
                    <p class="text-xs text-muted-foreground mt-1">{{ stats.admin_users }} admin{{ stats.admin_users !== 1 ? 's' : '' }}</p>
                </div>

                <div class="rounded-xl border border-border bg-card p-5">
                    <div class="flex items-center justify-between mb-3">
                        <p class="text-sm text-muted-foreground">Total images</p>
                        <div class="flex size-8 items-center justify-center rounded-lg bg-[#00E5FF]/10">
                            <ImageIcon class="h-4 w-4 text-[#00E5FF]" />
                        </div>
                    </div>
                    <p class="text-3xl font-bold">{{ stats.total_images }}</p>
                    <p class="text-xs text-muted-foreground mt-1">Across all users</p>
                </div>

                <div class="rounded-xl border border-border bg-card p-5">
                    <div class="flex items-center justify-between mb-3">
                        <p class="text-sm text-muted-foreground">Storage used</p>
                        <div class="flex size-8 items-center justify-center rounded-lg bg-[#7B2FFF]/10">
                            <HardDrive class="h-4 w-4 text-[#7B2FFF]" />
                        </div>
                    </div>
                    <p class="text-3xl font-bold">{{ formatBytes(stats.total_storage) }}</p>
                    <p class="text-xs text-muted-foreground mt-1">Total platform usage</p>
                </div>

                <div class="rounded-xl border border-border bg-card p-5">
                    <div class="flex items-center justify-between mb-3">
                        <p class="text-sm text-muted-foreground">Active links</p>
                        <div class="flex size-8 items-center justify-center rounded-lg bg-[#00E5FF]/10">
                            <LinkIcon class="h-4 w-4 text-[#00E5FF]" />
                        </div>
                    </div>
                    <p class="text-3xl font-bold">{{ stats.active_links }}</p>
                    <p class="text-xs text-muted-foreground mt-1">Shared links not expired</p>
                </div>
            </div>

            <!-- Quick links -->
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 mb-8">
                <Link href="/admin/users">
                    <div class="rounded-xl border border-border bg-card p-5 hover:border-[#7B2FFF]/30 transition-colors cursor-pointer">
                        <div class="flex items-center gap-3 mb-2">
                            <Users class="h-5 w-5 text-[#7B2FFF]" />
                            <h3 class="font-semibold">Manage users</h3>
                        </div>
                        <p class="text-sm text-muted-foreground">View, search and manage all user accounts</p>
                    </div>
                </Link>
                <Link href="/plans">
                    <div class="rounded-xl border border-border bg-card p-5 hover:border-[#7B2FFF]/30 transition-colors cursor-pointer">
                        <div class="flex items-center gap-3 mb-2">
                            <HardDrive class="h-5 w-5 text-[#7B2FFF]" />
                            <h3 class="font-semibold">Manage plans</h3>
                        </div>
                        <p class="text-sm text-muted-foreground">Create, edit and manage subscription plans</p>
                    </div>
                </Link>
                <Link href="/invitations">
                    <div class="rounded-xl border border-border bg-card p-5 hover:border-[#7B2FFF]/30 transition-colors cursor-pointer">
                        <div class="flex items-center gap-3 mb-2">
                            <LinkIcon class="h-5 w-5 text-[#7B2FFF]" />
                            <h3 class="font-semibold">Invitations</h3>
                        </div>
                        <p class="text-sm text-muted-foreground">Send and manage user invitations</p>
                    </div>
                </Link>
            </div>

            <!-- Recent users -->
            <div>
                <div class="flex items-center justify-between mb-4">
                    <h2 class="font-semibold">Recent users</h2>
                    <Link href="/admin/users">
                        <Button variant="ghost" size="sm">View all</Button>
                    </Link>
                </div>
                <div class="rounded-xl border border-border overflow-hidden">
                    <table class="w-full text-sm">
                        <thead class="bg-muted/50 border-b border-border">
                            <tr>
                                <th class="text-left px-4 py-3 font-medium text-muted-foreground">User</th>
                                <th class="text-left px-4 py-3 font-medium text-muted-foreground">Plan</th>
                                <th class="text-left px-4 py-3 font-medium text-muted-foreground">Storage</th>
                                <th class="text-left px-4 py-3 font-medium text-muted-foreground">Joined</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-border">
                            <tr v-for="user in recentUsers" :key="user.id" class="hover:bg-muted/30 transition-colors">
                                <td class="px-4 py-3">
                                    <div class="flex items-center gap-3">
                                        <img :src="user.avatar" :alt="user.name" class="size-7 rounded-full" />
                                        <div>
                                            <p class="font-medium">{{ user.name }}</p>
                                            <p class="text-xs text-muted-foreground">{{ user.email }}</p>
                                        </div>
                                    </div>
                                </td>
                                <td class="px-4 py-3 text-muted-foreground">{{ user.plan?.name ?? 'Free' }}</td>
                                <td class="px-4 py-3 text-muted-foreground">{{ user.storage_used_human }}</td>
                                <td class="px-4 py-3 text-muted-foreground text-xs">{{ user.created_at }}</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </AppLayout>
</template>