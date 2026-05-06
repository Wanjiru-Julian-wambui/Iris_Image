<script setup lang="ts">
import { Head, useForm, router } from '@inertiajs/vue3';
import { ref, computed } from 'vue';
import AppLayout from '@/layouts/AppLayout.vue';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import {
    Dialog, DialogContent, DialogDescription,
    DialogFooter, DialogHeader, DialogTitle,
} from '@/components/ui/dialog';
import type { BreadcrumbItem } from '@/types';

type Permission = {
    id: number;
    name: string;
    label: string;
    group: string;
};

type Role = {
    id: number;
    name: string;
    label: string;
    description: string | null;
    users_count: number;
    permissions: Permission[];
};

const props = defineProps<{
    roles: Role[];
    permissions: Permission[];
}>();

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Dashboard', href: '/dashboard' },
    { title: 'Admin', href: '/admin' },
    { title: 'Roles & Permissions', href: '/admin/roles' },
];

// ── Group permissions by category ────────────────────────────────────────────
const groupedPermissions = computed(() => {
    const groups: Record<string, Permission[]> = {};
    for (const p of props.permissions) {
        if (!groups[p.group]) groups[p.group] = [];
        groups[p.group].push(p);
    }
    return groups;
});

const BUILT_IN = ['admin', 'moderator', 'uploader', 'viewer'];

// ── Create form ───────────────────────────────────────────────────────────────
const showCreate = ref(false);
const createForm = useForm({
    name:        '',
    label:       '',
    description: '',
    permissions: [] as number[],
});

function toggleCreatePermission(id: number) {
    const idx = createForm.permissions.indexOf(id);
    if (idx >= 0) createForm.permissions.splice(idx, 1);
    else createForm.permissions.push(id);
}

function submitCreate() {
    createForm.post('/admin/roles', {
        preserveScroll: true,
        onSuccess: () => { createForm.reset(); showCreate.value = false; },
    });
}

// ── Edit form ─────────────────────────────────────────────────────────────────
const editingRole = ref<Role | null>(null);
const editForm = useForm({
    label:       '',
    description: '',
    permissions: [] as number[],
});

function openEdit(role: Role) {
    editingRole.value = role;
    editForm.label       = role.label;
    editForm.description = role.description ?? '';
    editForm.permissions = role.permissions.map(p => p.id);
}

function toggleEditPermission(id: number) {
    const idx = editForm.permissions.indexOf(id);
    if (idx >= 0) editForm.permissions.splice(idx, 1);
    else editForm.permissions.push(id);
}

function submitEdit() {
    if (!editingRole.value) return;
    editForm.put(`/admin/roles/${editingRole.value.id}`, {
        preserveScroll: true,
        onSuccess: () => { editingRole.value = null; },
    });
}

// ── Delete ────────────────────────────────────────────────────────────────────
const deletingRole = ref<Role | null>(null);

function deleteRole() {
    if (!deletingRole.value) return;
    router.delete(`/admin/roles/${deletingRole.value.id}`, {
        preserveScroll: true,
        onSuccess: () => { deletingRole.value = null; },
    });
}

// ── Color per group ───────────────────────────────────────────────────────────
const groupColor: Record<string, string> = {
    images: 'bg-violet-500/15 text-violet-400',
    links:  'bg-sky-500/15 text-sky-400',
    albums: 'bg-emerald-500/15 text-emerald-400',
    admin:  'bg-rose-500/15 text-rose-400',
    general:'bg-muted text-muted-foreground',
};
</script>

<template>
    <AppLayout :breadcrumbs="breadcrumbs">
        <Head title="Roles & Permissions" />

        <div class="max-w-5xl mx-auto px-4 py-8 space-y-8">

            <!-- Header -->
            <div class="flex items-start justify-between gap-4">
                <div>
                    <h1 class="text-2xl font-bold tracking-tight">Roles &amp; Permissions</h1>
                    <p class="mt-1 text-sm text-muted-foreground">
                        Create custom roles and assign permission sets to control what each user group can do.
                    </p>
                </div>
                <Button @click="showCreate = true" v-if="!showCreate">
                    + New role
                </Button>
            </div>

            <!-- Create form -->
            <div v-if="showCreate" class="rounded-2xl border border-white/8 bg-card p-6 space-y-5">
                <h2 class="text-base font-semibold">Create new role</h2>

                <div class="grid grid-cols-2 gap-4">
                    <div class="space-y-1">
                        <label class="text-xs font-medium text-muted-foreground uppercase tracking-wider">Machine name</label>
                        <input
                            v-model="createForm.name"
                            type="text"
                            placeholder="e.g. content_editor"
                            class="w-full rounded-xl border border-border bg-background px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-violet-500/50"
                        />
                        <p v-if="createForm.errors.name" class="text-xs text-rose-400">{{ createForm.errors.name }}</p>
                    </div>
                    <div class="space-y-1">
                        <label class="text-xs font-medium text-muted-foreground uppercase tracking-wider">Display label</label>
                        <input
                            v-model="createForm.label"
                            type="text"
                            placeholder="e.g. Content Editor"
                            class="w-full rounded-xl border border-border bg-background px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-violet-500/50"
                        />
                        <p v-if="createForm.errors.label" class="text-xs text-rose-400">{{ createForm.errors.label }}</p>
                    </div>
                </div>

                <div class="space-y-1">
                    <label class="text-xs font-medium text-muted-foreground uppercase tracking-wider">Description (optional)</label>
                    <input
                        v-model="createForm.description"
                        type="text"
                        placeholder="Short description of what this role can do"
                        class="w-full rounded-xl border border-border bg-background px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-violet-500/50"
                    />
                </div>

                <!-- Permission matrix -->
                <div class="space-y-3">
                    <label class="text-xs font-medium text-muted-foreground uppercase tracking-wider">Permissions</label>
                    <div v-for="(perms, group) in groupedPermissions" :key="group" class="space-y-1.5">
                        <p class="text-xs font-semibold capitalize text-muted-foreground">{{ group }}</p>
                        <div class="flex flex-wrap gap-2">
                            <button
                                v-for="p in perms"
                                :key="p.id"
                                type="button"
                                @click="toggleCreatePermission(p.id)"
                                :class="[
                                    'rounded-lg px-3 py-1.5 text-xs font-semibold ring-1 transition-all',
                                    createForm.permissions.includes(p.id)
                                        ? (groupColor[group] ?? groupColor.general) + ' ring-current/20'
                                        : 'bg-muted text-muted-foreground ring-border',
                                ]"
                            >
                                {{ p.label }}
                            </button>
                        </div>
                    </div>
                </div>

                <div class="flex gap-3 pt-1">
                    <Button @click="submitCreate" :disabled="createForm.processing || !createForm.name || !createForm.label">
                        {{ createForm.processing ? 'Creating…' : 'Create role' }}
                    </Button>
                    <Button variant="outline" @click="showCreate = false; createForm.reset()">Cancel</Button>
                </div>
            </div>

            <!-- Roles list -->
            <div class="space-y-3">
                <div
                    v-for="role in roles"
                    :key="role.id"
                    class="rounded-2xl border border-white/8 bg-card p-6 space-y-4"
                >
                    <div class="flex items-start justify-between gap-4">
                        <div>
                            <div class="flex items-center gap-2">
                                <h2 class="text-base font-bold">{{ role.label }}</h2>
                                <code class="rounded bg-muted px-1.5 py-0.5 text-xs text-muted-foreground">{{ role.name }}</code>
                                <Badge v-if="BUILT_IN.includes(role.name)" variant="outline" class="text-[10px]">Built-in</Badge>
                            </div>
                            <p v-if="role.description" class="text-sm text-muted-foreground mt-0.5">{{ role.description }}</p>
                            <p class="text-xs text-muted-foreground mt-1">
                                {{ role.users_count }} user{{ role.users_count !== 1 ? 's' : '' }} assigned
                            </p>
                        </div>
                        <div class="flex gap-2 shrink-0">
                            <Button variant="outline" size="sm" @click="openEdit(role)">Edit</Button>
                            <Button
                                variant="ghost"
                                size="sm"
                                class="text-destructive hover:text-destructive"
                                :disabled="BUILT_IN.includes(role.name)"
                                @click="deletingRole = role"
                            >
                                Delete
                            </Button>
                        </div>
                    </div>

                    <!-- Permissions chips -->
                    <div class="flex flex-wrap gap-1.5">
                        <span
                            v-for="p in role.permissions"
                            :key="p.id"
                            :class="['rounded-md px-2 py-0.5 text-[11px] font-semibold ring-1 ring-current/20', groupColor[p.group] ?? groupColor.general]"
                        >
                            {{ p.label }}
                        </span>
                        <span v-if="role.permissions.length === 0" class="text-xs text-muted-foreground italic">
                            No permissions assigned
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Edit Dialog -->
        <Dialog :open="!!editingRole" @update:open="editingRole = null">
            <DialogContent class="max-w-2xl max-h-[90vh] overflow-y-auto">
                <DialogHeader>
                    <DialogTitle>Edit role: {{ editingRole?.label }}</DialogTitle>
                    <DialogDescription>Update label, description, and permission assignments.</DialogDescription>
                </DialogHeader>

                <div class="space-y-5 py-2">
                    <div class="grid grid-cols-2 gap-4">
                        <div class="space-y-1">
                            <label class="text-xs font-medium text-muted-foreground uppercase tracking-wider">Display label</label>
                            <input
                                v-model="editForm.label"
                                type="text"
                                class="w-full rounded-xl border border-border bg-background px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-violet-500/50"
                            />
                        </div>
                        <div class="space-y-1">
                            <label class="text-xs font-medium text-muted-foreground uppercase tracking-wider">Description</label>
                            <input
                                v-model="editForm.description"
                                type="text"
                                class="w-full rounded-xl border border-border bg-background px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-violet-500/50"
                            />
                        </div>
                    </div>

                    <div class="space-y-3">
                        <label class="text-xs font-medium text-muted-foreground uppercase tracking-wider">Permissions</label>
                        <div v-for="(perms, group) in groupedPermissions" :key="group" class="space-y-1.5">
                            <p class="text-xs font-semibold capitalize text-muted-foreground">{{ group }}</p>
                            <div class="flex flex-wrap gap-2">
                                <button
                                    v-for="p in perms"
                                    :key="p.id"
                                    type="button"
                                    @click="toggleEditPermission(p.id)"
                                    :class="[
                                        'rounded-lg px-3 py-1.5 text-xs font-semibold ring-1 transition-all',
                                        editForm.permissions.includes(p.id)
                                            ? (groupColor[group] ?? groupColor.general) + ' ring-current/20'
                                            : 'bg-muted text-muted-foreground ring-border',
                                    ]"
                                >
                                    {{ p.label }}
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <DialogFooter>
                    <Button variant="outline" @click="editingRole = null">Cancel</Button>
                    <Button @click="submitEdit" :disabled="editForm.processing">
                        {{ editForm.processing ? 'Saving…' : 'Save changes' }}
                    </Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>

        <!-- Delete confirm -->
        <Dialog :open="!!deletingRole" @update:open="deletingRole = null">
            <DialogContent>
                <DialogHeader>
                    <DialogTitle>Delete role</DialogTitle>
                    <DialogDescription>
                        Are you sure you want to delete the <strong>{{ deletingRole?.label }}</strong> role?
                        Users assigned this role will lose its permissions immediately.
                    </DialogDescription>
                </DialogHeader>
                <DialogFooter>
                    <Button variant="outline" @click="deletingRole = null">Cancel</Button>
                    <Button variant="destructive" @click="deleteRole">Delete</Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>

    </AppLayout>
</template>