<script setup lang="ts">
import { Head, Link, router } from '@inertiajs/vue3';
import { ArrowLeft, Shield, ShieldOff, Trash2 } from 'lucide-vue-next';
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
    user: App.UserResource;
    images: {
        data: App.ImageResource[];
        meta: { current_page: number; last_page: number; total: number };
    };
}>();

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Dashboard', href: '/dashboard' },
    { title: 'Admin', href: '/admin' },
    { title: 'Users', href: '/admin/users' },
    { title: props.user.name, href: `/admin/users/${props.user.id}` },
];

const showDeleteDialog = ref(false);
const deleting = ref(false);

function toggleAdmin() {
    router.patch(`/admin/users/${props.user.id}/toggle-admin`);
}

function deleteUser() {
    deleting.value = true;
    router.delete(`/admin/users/${props.user.id}`, {
        onFinish: () => { deleting.value = false; },
    });
}
</script>

<template>
    <AppLayout :breadcrumbs="breadcrumbs">
        <Head :title="user.name" />

        <div class="max-w-5xl mx-auto px-4 py-8">
            <!-- Back -->
            <div class="flex items-center gap-3 mb-6">
                <Link href="/admin/users">
                    <Button variant="ghost" size="icon" class="h-8 w-8">
                        <ArrowLeft class="h-4 w-4" />
                    </Button>
                </Link>
                <h1 class="text-2xl font-bold tracking-tight">User details</h1>
            </div>

            <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                <!-- User info -->
                <div class="space-y-4">
                    <div class="rounded-xl border border-border bg-card p-6 flex flex-col items-center text-center">
                        <img :src="user.avatar" :alt="user.name" class="size-20 rounded-full mb-4" />
                        <h2 class="text-lg font-bold">{{ user.name }}</h2>
                        <p class="text-sm text-muted-foreground">{{ user.email }}</p>
                        <div class="flex gap-2 mt-3">
                            <Badge
                                :class="user.is_admin
                                    ? 'bg-[#7B2FFF]/10 text-[#7B2FFF] border-[#7B2FFF]/20'
                                    : 'bg-muted text-muted-foreground'"
                            >
                                {{ user.is_admin ? 'Admin' : 'User' }}
                            </Badge>
                            <Badge variant="outline">{{ user.plan?.name ?? 'Free' }}</Badge>
                        </div>
                    </div>

                    <!-- Storage -->
                    <div class="rounded-xl border border-border bg-card p-5">
                        <h3 class="font-semibold text-sm mb-3">Storage</h3>
                        <div class="flex justify-between text-sm mb-2">
                            <span class="text-muted-foreground">Used</span>
                            <span class="font-medium">{{ user.storage_used_human }}</span>
                        </div>
                        <div class="w-full h-2 rounded-full bg-muted overflow-hidden mb-2">
                            <div
                                class="h-full rounded-full bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF] transition-all"
                                :style="{ width: Math.min(user.storage_percent, 100) + '%' }"
                            />
                        </div>
                        <p class="text-xs text-muted-foreground text-right">{{ user.storage_percent }}% used</p>
                    </div>

                    <!-- Meta -->
                    <div class="rounded-xl border border-border bg-card divide-y divide-border">
                        <div class="flex justify-between px-4 py-3 text-sm">
                            <span class="text-muted-foreground">Images</span>
                            <span class="font-medium">{{ images.meta.total }}</span>
                        </div>
                        <div class="flex justify-between px-4 py-3 text-sm">
                            <span class="text-muted-foreground">Joined</span>
                            <span class="font-medium text-xs">{{ user.created_at }}</span>
                        </div>
                        <div class="flex justify-between px-4 py-3 text-sm">
                            <span class="text-muted-foreground">Verified</span>
                            <span class="font-medium text-xs">{{ user.email_verified_at ?? 'No' }}</span>
                        </div>
                    </div>

                    <!-- Actions -->
                    <div class="space-y-2">
                        <Button
                            variant="outline"
                            class="w-full gap-2"
                            @click="toggleAdmin"
                        >
                            <Shield v-if="!user.is_admin" class="h-4 w-4" />
                            <ShieldOff v-else class="h-4 w-4" />
                            {{ user.is_admin ? 'Remove admin' : 'Make admin' }}
                        </Button>
                        <Button
                            variant="destructive"
                            class="w-full gap-2"
                            :disabled="user.is_admin"
                            @click="showDeleteDialog = true"
                        >
                            <Trash2 class="h-4 w-4" />
                            Delete user
                        </Button>
                    </div>
                </div>

                <!-- Images -->
                <div class="lg:col-span-2">
                    <h2 class="font-semibold mb-4">
                        Images
                        <span class="text-muted-foreground font-normal text-sm ml-1">({{ images.meta.total }})</span>
                    </h2>

                    <div v-if="images.data.length === 0" class="rounded-xl border border-dashed border-border py-16 text-center">
                        <p class="text-muted-foreground text-sm">No images uploaded yet</p>
                    </div>

                    <div v-else class="grid grid-cols-3 sm:grid-cols-4 gap-3">
                        <Link
                            v-for="image in images.data"
                            :key="image.id"
                            :href="`/images/${image.id}`"
                            class="group relative rounded-xl overflow-hidden border border-border bg-muted aspect-square"
                        >
                            <img
                                :src="image.thumbnail_url"
                                :alt="image.name"
                                class="w-full h-full object-cover transition-transform duration-300 group-hover:scale-105"
                            />
                            <div class="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition-opacity flex flex-col justify-end p-2">
                                <p class="text-white text-xs truncate">{{ image.name }}</p>
                                <p class="text-white/60 text-xs">{{ image.size_human }}</p>
                            </div>
                        </Link>
                    </div>

                    <div v-if="images.meta.last_page > 1" class="flex justify-center gap-2 mt-6">
                        <span class="text-sm text-muted-foreground">
                            Showing {{ images.data.length }} of {{ images.meta.total }}
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Delete dialog -->
        <Dialog :open="showDeleteDialog" @update:open="showDeleteDialog = false">
            <DialogContent>
                <DialogHeader>
                    <DialogTitle>Delete user</DialogTitle>
                    <DialogDescription>
                        Are you sure you want to permanently delete <strong>{{ user.name }}</strong>?
                        All their images and shared links will also be deleted. This cannot be undone.
                    </DialogDescription>
                </DialogHeader>
                <DialogFooter>
                    <Button variant="outline" @click="showDeleteDialog = false">Cancel</Button>
                    <Button variant="destructive" :disabled="deleting" @click="deleteUser">
                        {{ deleting ? 'Deleting...' : 'Delete user' }}
                    </Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>
    </AppLayout>
</template>