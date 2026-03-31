<script setup lang="ts">
import { Head, Link, router } from '@inertiajs/vue3';
import { Pencil, Plus, Trash2, Check } from 'lucide-vue-next';
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

// FIXED: Added .data wrapper for Resource Collection
const props = defineProps<{
    plans: { data: App.PlanResource[] };
}>();

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Dashboard', href: '/dashboard' },
    { title: 'Plans', href: '/plans' },
];

const confirmDelete = ref<App.PlanResource | null>(null);
const deleting = ref(false);

function openDelete(plan: App.PlanResource) {
    confirmDelete.value = plan;
}

function deletePlan() {
    if (!confirmDelete.value) return;
    deleting.value = true;
    router.delete(`/plans/${confirmDelete.value.id}`, {
        onFinish: () => {
            deleting.value = false;
            confirmDelete.value = null;
        },
    });
}

const featureLabels: Record<string, string> = {
    expiring_links:           'Expiring links',
    exif_stripping:           'EXIF stripping',
    basic_sharing:            'Basic sharing',
    password_protected_links: 'Password-protected links',
    team_folders:             'Team folders',
    view_history:             'View history',
    admin_dashboard:          'Admin dashboard',
    invite_only_registration: 'Invite-only registration',
    priority_support:         'Priority support',
};
</script>

<template>
    <AppLayout :breadcrumbs="breadcrumbs">
        <Head title="Plans" />

        <div class="px-4 py-6 md:px-8">
            <div class="flex items-center justify-between mb-6">
                <div>
                    <h1 class="text-2xl font-bold tracking-tight">Plans</h1>
                    <p class="text-sm text-muted-foreground mt-1">Manage subscription plans</p>
                </div>
                <Link href="/plans/create">
                    <Button class="gap-2 bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF] text-white hover:opacity-90">
                        <Plus class="h-4 w-4" />
                        New plan
                    </Button>
                </Link>
            </div>

            <div class="rounded-xl border border-border overflow-hidden">
                <table class="w-full text-sm">
                    <thead class="bg-muted/50 border-b border-border">
                        <tr>
                            <th class="text-left px-4 py-3 font-medium text-muted-foreground">Plan</th>
                            <th class="text-left px-4 py-3 font-medium text-muted-foreground">Price</th>
                            <th class="text-left px-4 py-3 font-medium text-muted-foreground">Storage</th>
                            <th class="text-left px-4 py-3 font-medium text-muted-foreground">Features</th>
                            <th class="text-left px-4 py-3 font-medium text-muted-foreground">Status</th>
                            <th class="px-4 py-3" />
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-border">
                        <tr v-for="plan in plans.data" :key="plan.id" class="hover:bg-muted/30 transition-colors">
                            <td class="px-4 py-4">
                                <div class="font-semibold">{{ plan.name }}</div>
                                <div class="text-xs text-muted-foreground">{{ plan.slug }}</div>
                            </td>
                            <td class="px-4 py-4 font-medium">{{ plan.price_formatted }}</td>
                            <td class="px-4 py-4 text-muted-foreground">{{ plan.storage_limit_human }}</td>
                            <td class="px-4 py-4">
                                <div class="flex flex-wrap gap-1">
                                    <Badge
                                        v-for="feature in plan.features?.slice(0, 3)"
                                        :key="feature"
                                        variant="secondary"
                                        class="text-xs"
                                    >
                                        {{ featureLabels[feature] ?? feature }}
                                    </Badge>
                                    <Badge
                                        v-if="plan.features?.length > 3"
                                        variant="outline"
                                        class="text-xs"
                                    >
                                        +{{ plan.features.length - 3 }} more
                                    </Badge>
                                </div>
                            </td>
                            <td class="px-4 py-4">
                                <Badge
                                    :class="plan.is_active
                                        ? 'bg-green-500/10 text-green-600 border-green-500/20'
                                        : 'bg-muted text-muted-foreground'"
                                >
                                    {{ plan.is_active ? 'Active' : 'Inactive' }}
                                </Badge>
                            </td>
                            <td class="px-4 py-4">
                                <div class="flex items-center justify-end gap-2">
                                    <Link :href="`/plans/${plan.id}/edit`">
                                        <Button variant="ghost" size="icon" class="h-8 w-8">
                                            <Pencil class="h-4 w-4" />
                                        </Button>
                                    </Link>
                                    <Button
                                        variant="ghost"
                                        size="icon"
                                        class="h-8 w-8 text-destructive hover:text-destructive"
                                        :disabled="plan.is_free"
                                        @click="openDelete(plan)"
                                    >
                                        <Trash2 class="h-4 w-4" />
                                    </Button>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <Dialog :open="!!confirmDelete" @update:open="confirmDelete = null">
            <DialogContent>
                <DialogHeader>
                    <DialogTitle>Delete plan</DialogTitle>
                    <DialogDescription>
                        Are you sure you want to delete the <strong>{{ confirmDelete?.name }}</strong> plan?
                        Users on this plan will be moved to the Free plan.
                    </DialogDescription>
                </DialogHeader>
                <DialogFooter>
                    <Button variant="outline" @click="confirmDelete = null">Cancel</Button>
                    <Button variant="destructive" :disabled="deleting" @click="deletePlan">
                        {{ deleting ? 'Deleting...' : 'Delete' }}
                    </Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>
    </AppLayout>
</template>