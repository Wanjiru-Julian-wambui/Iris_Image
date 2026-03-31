<script setup lang="ts">
import { Head, Link, useForm } from '@inertiajs/vue3';
import { ArrowLeft } from 'lucide-vue-next';
import AppLayout from '@/layouts/AppLayout.vue';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Switch } from '@/components/ui/switch';
import { Checkbox } from '@/components/ui/checkbox';
import InputError from '@/components/InputError.vue';
import type { BreadcrumbItem } from '@/types';

const props = defineProps<{
    
    plan: App.PlanResource; 
}>();

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Dashboard', href: '/dashboard' },
    { title: 'Plans', href: '/plans' },
    { title: `Edit ${props.plan.name}`, href: `/plans/${props.plan.id}/edit` },
];

const allFeatures = [
    { value: 'expiring_links',           label: 'Expiring links' },
    { value: 'exif_stripping',           label: 'EXIF stripping' },
    { value: 'basic_sharing',            label: 'Basic sharing' },
    { value: 'password_protected_links', label: 'Password-protected links' },
    { value: 'team_folders',             label: 'Team folders' },
    { value: 'view_history',             label: 'View history' },
    { value: 'admin_dashboard',          label: 'Admin dashboard' },
    { value: 'invite_only_registration', label: 'Invite-only registration' },
    { value: 'priority_support',         label: 'Priority support' },
];

const form = useForm({
    name:       props.plan.name,
    slug:       props.plan.slug,
    price:      props.plan.price,
    storage_gb: Math.round(props.plan.storage_limit / (1024 * 1024 * 1024)),
    features:   [...(props.plan.features ?? [])] as string[],
    is_active:  props.plan.is_active,
});

function submit() {
    form.transform(data => ({
        ...data,
        storage_limit: data.storage_gb * 1024 * 1024 * 1024,
    })).put(`/plans/${props.plan.id}`);
}
</script>

<template>
    <AppLayout :breadcrumbs="breadcrumbs">
        <Head :title="`Edit ${plan.name}`" />
        <div class="max-w-2xl mx-auto px-4 py-8">
            <div class="flex items-center gap-3 mb-6">
                <Link href="/plans">
                    <Button variant="ghost" size="icon" class="h-8 w-8">
                        <ArrowLeft class="h-4 w-4" />
                    </Button>
                </Link>
                <h1 class="text-2xl font-bold tracking-tight">Edit {{ plan.name }}</h1>
            </div>

            <form @submit.prevent="submit" class="space-y-6">
                <div class="rounded-xl border border-border p-6 space-y-4">
                    <h2 class="font-semibold text-sm text-muted-foreground uppercase tracking-wider">Basic info</h2>
                    <div class="grid grid-cols-2 gap-4">
                        <div class="space-y-1.5">
                            <Label for="name">Plan name</Label>
                            <Input id="name" v-model="form.name" required />
                            <InputError :message="form.errors.name" />
                        </div>
                        <div class="space-y-1.5">
                            <Label for="slug">Slug</Label>
                            <Input id="slug" v-model="form.slug" required />
                            <InputError :message="form.errors.slug" />
                        </div>
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div class="space-y-1.5">
                            <Label for="price">Price (USD/month)</Label>
                            <Input id="price" v-model.number="form.price" type="number" min="0" step="1" />
                            <InputError :message="form.errors.price" />
                        </div>
                        <div class="space-y-1.5">
                            <Label for="storage">Storage (GB)</Label>
                            <Input id="storage" v-model.number="form.storage_gb" type="number" min="1" step="1" />
                            <InputError :message="form.errors.storage_limit" />
                        </div>
                    </div>
                    <div class="flex items-center justify-between pt-2">
                        <Label class="font-medium">Active</Label>
                        <Switch :checked="form.is_active" @update:checked="form.is_active = $event" />
                    </div>
                </div>

                <div class="rounded-xl border border-border p-6 space-y-3">
                    <h2 class="font-semibold text-sm text-muted-foreground uppercase tracking-wider mb-2">Features</h2>
                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-3">
                        <label v-for="feature in allFeatures" :key="feature.value" 
                            class="flex items-center gap-3 rounded-lg border border-border px-3 py-2.5 cursor-pointer hover:bg-muted/50 transition-colors"
                            :class="form.features.includes(feature.value) ? 'border-[#7B2FFF]/40 bg-[#7B2FFF]/5' : ''">
                            <Checkbox :checked="form.features.includes(feature.value)"
                                @update:checked="(checked) => {
                                    if (checked) form.features.push(feature.value);
                                    else form.features = form.features.filter(f => f !== feature.value);
                                }" />
                            <span class="text-sm">{{ feature.label }}</span>
                        </label>
                    </div>
                    <InputError :message="form.errors.features" />
                </div>

                <div class="flex gap-3">
                    <Link href="/plans" class="flex-1">
                        <Button type="button" variant="outline" class="w-full">Cancel</Button>
                    </Link>
                    <Button type="submit" class="flex-1 bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF] text-white" :disabled="form.processing">
                        {{ form.processing ? 'Saving...' : 'Save changes' }}
                    </Button>
                </div>
            </form>
        </div>
    </AppLayout>
</template>