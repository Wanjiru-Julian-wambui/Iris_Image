<script setup lang="ts">
import { Head } from '@inertiajs/vue3';
import { Check } from 'lucide-vue-next';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import AppLayout from '@/layouts/AppLayout.vue';
import type { BreadcrumbItem } from '@/types';

// Updated props to allow null for currentPlan
defineProps<{
    plans: { data: any[] };
    currentPlan: any | null; 
}>();

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Dashboard', href: '/dashboard' },
    { title: 'Plans', href: '/plans' },
];

const featureLabels: Record<string, string> = {
    expiring_links:           'Expiring links',
    exif_stripping:           'EXIF data stripping',
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

        <div class="max-w-5xl mx-auto px-4 py-10">
            <div class="text-center mb-10">
                <h1 class="text-3xl font-bold tracking-tight mb-2">Simple pricing</h1>
                <p class="text-muted-foreground">
                    You are currently on the
                    <span class="font-semibold text-foreground">
                        {{ currentPlan ? currentPlan.name : 'Trial/Free' }}
                    </span> plan.
                </p>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <div
                    v-for="plan in plans.data"
                    :key="plan.id"
                    class="relative rounded-2xl border p-8 flex flex-col"
                    :class="plan.slug === 'pro'
                        ? 'border-[#7B2FFF]/50 bg-gradient-to-br from-[#7B2FFF]/10 to-[#00E5FF]/5'
                        : 'border-border bg-card'"
                >
                    <div v-if="plan.slug === 'pro'" class="absolute -top-3 left-1/2 -translate-x-1/2">
                        <Badge class="bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF] text-white border-0 px-3">
                            Most popular
                        </Badge>
                    </div>

                    <div v-if="currentPlan?.id === plan.id" class="absolute top-4 right-4">
                        <Badge variant="secondary" class="text-xs">Current plan</Badge>
                    </div>

                    <div class="mb-6">
                        <p class="text-sm font-medium text-muted-foreground mb-1">{{ plan.name }}</p>
                        <div class="flex items-end gap-1 mb-1">
                            <span class="text-4xl font-bold">
                                {{ plan.is_free ? 'Free' : '$' + plan.price }}
                            </span>
                            <span v-if="!plan.is_free" class="text-muted-foreground mb-1">/mo</span>
                        </div>
                        <p class="text-sm text-muted-foreground">{{ plan.storage_limit_human }} storage</p>
                    </div>

                    <ul class="space-y-3 mb-8 flex-1">
                        <li v-for="feature in plan.features" :key="feature" class="flex items-center gap-2.5 text-sm">
                            <div class="flex size-5 shrink-0 items-center justify-center rounded-full bg-gradient-to-br from-[#7B2FFF] to-[#00E5FF]">
                                <Check class="h-3 w-3 text-white" />
                            </div>
                            {{ featureLabels[feature] ?? feature }}
                        </li>
                    </ul>

                    <Button v-if="currentPlan?.id === plan.id" disabled variant="outline" class="w-full">
                        Current plan
                    </Button>
                    <Button v-else-if="plan.is_free" variant="outline" class="w-full" disabled>
                        Free Plan
                    </Button>
                    <Button v-else class="w-full bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF] text-white hover:opacity-90">
                        Upgrade to {{ plan.name }}
                    </Button>
                </div>
            </div>
        </div>
    </AppLayout>
</template>