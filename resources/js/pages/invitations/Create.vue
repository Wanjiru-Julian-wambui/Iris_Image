<script setup lang="ts">
import { Head, Link, useForm } from '@inertiajs/vue3';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import AppLayout from '@/layouts/AppLayout.vue';
import type { BreadcrumbItem } from '@/types';

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Dashboard', href: '/dashboard' },
    { title: 'Invitations', href: '/invitations' },
    { title: 'Send Invitation', href: '/invitations/create' },
];

const form = useForm({
    email: '',
});

const submit = () => {
    form.post('/invitations');
};
</script>

<template>
    <AppLayout :breadcrumbs="breadcrumbs">
        <Head title="Send Invitation" />

        <div class="px-4 py-6 md:px-8 max-w-lg">
            <div class="mb-6">
                <h1 class="text-2xl font-bold tracking-tight">Send Invitation</h1>
                <p class="text-sm text-muted-foreground mt-1">
                    Invite someone to join your workspace by email.
                </p>
            </div>

            <div class="rounded-xl border border-border bg-card p-6">
                <form @submit.prevent="submit" class="space-y-5">
                    <div class="space-y-1.5">
                        <Label for="email">Email Address</Label>
                        <Input
                            id="email"
                            v-model="form.email"
                            type="email"
                            placeholder="invitee@example.com"
                            :class="{ 'border-destructive': form.errors.email }"
                            required
                            autofocus
                        />
                        <p v-if="form.errors.email" class="text-sm text-destructive">
                            {{ form.errors.email }}
                        </p>
                    </div>

                    <div class="flex items-center justify-end gap-3 pt-2">
                        <Link href="/invitations">
                            <Button type="button" variant="outline">Cancel</Button>
                        </Link>
                        <Button
                            type="submit"
                            :disabled="form.processing"
                            class="bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF] text-white hover:opacity-90"
                        >
                            {{ form.processing ? 'Sending...' : 'Send Invitation' }}
                        </Button>
                    </div>
                </form>
            </div>
        </div>
    </AppLayout>
</template>