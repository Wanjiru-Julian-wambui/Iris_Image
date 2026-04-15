<script setup lang="ts">
import { Head, useForm, Link } from '@inertiajs/vue3';
import { ArrowLeft } from 'lucide-vue-next';
import InputError from '@/components/InputError.vue';
import { Button } from '@/components/ui/button';
import { Checkbox } from '@/components/ui/checkbox';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Switch } from '@/components/ui/switch';
import AppLayout from '@/layouts/AppLayout.vue';
import type { BreadcrumbItem } from '@/types';
import { allFeatures } from '@/types/plan';

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Dashboard', href: '/dashboard' },
    { title: 'Plans',     href: '/plans' },
    { title: 'New plan',  href: '/plans/create' },
];

const form = useForm({
    name:       '',
    slug:       '',
    price:      0,
    storage_gb: 1,
    features:   [] as string[],
    is_active:  true,
});

function autoSlug() {
    form.slug = form.name.toLowerCase().replace(/\s+/g, '-').replace(/[^a-z0-9-]/g, '');
}

function submit() {
    form.transform(data => ({
        ...data,
        storage_limit: data.storage_gb * 1024 * 1024 * 1024,
    })).post('/plans');
}
</script>

<template>
    <AppLayout :breadcrumbs="breadcrumbs">
        <Head title="New Plan" />

        <div class="max-w-2xl mx-auto px-4 py-8">
            <div class="flex items-center gap-3 mb-6">
                <Link href="/plans">
                    <Button variant="ghost" size="icon" class="h-8 w-8">
                        <ArrowLeft class="h-4 w-4" />
                    </Button>
                </Link>
                <h1 class="text-2xl font-bold tracking-tight">New plan</h1>
            </div>

            <form @submit.prevent="submit" class="space-y-6">
                <div class="rounded-xl border border-border p-6 space-y-4">
                    <h2 class="font-semibold text-sm text-muted-foreground uppercase tracking-wider">Basic info</h2>
                    <div class="grid grid-cols-2 gap-4">
                        <div class="space-y-1.5">
                            <Label for="name">Plan name</Label>
                            <Input id="name" v-model="form.name" @input="autoSlug" placeholder="e.g. Pro" required />
                            <InputError :message="form.errors.name" />
                        </div>
                        <div class="space-y-1.5">
                            <Label for="slug">Slug</Label>
                            <Input id="slug" v-model="form.slug" placeholder="e.g. pro" required />
                            <InputError :message="form.errors.slug" />
                        </div>
                    </div>
                    <div class="grid grid-cols-2 gap-4">
                        <div class="space-y-1.5">
                            <Label for="price">Price (USD/month, 0 = Free)</Label>
                            <Input id="price" v-model.number="form.price" type="number" min="0" step="1" />
                            <InputError :message="form.errors.price" />
                        </div>
                        <div class="space-y-1.5">
                            <Label for="storage">Storage (GB)</Label>
                            <Input id="storage" v-model.number="form.storage_gb" type="number" min="1" step="1" />
                            <InputError :message="form.errors.storage_gb" />
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
                        <label
                            v-for="feature in allFeatures"
                            :key="feature.value"
                            class="flex items-center gap-3 rounded-lg border border-border px-3 py-2.5 cursor-pointer hover:bg-muted/50 transition-colors"
                            :class="form.features.includes(feature.value) ? 'border-[#7B2FFF]/40 bg-[#7B2FFF]/5' : ''"
                        >
                            <Checkbox
                                :checked="form.features.includes(feature.value)"
                                @update:checked="(checked: boolean) => {
                                    if (checked) form.features.push(feature.value);
                                    else form.features = form.features.filter(f => f !== feature.value);
                                }"
                            />
                            <span class="text-sm">{{ feature.label }}</span>
                        </label>
                    </div>
                    <InputError :message="form.errors.features" />
                </div>

                <Button
                    type="submit"
                    class="w-full bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF] text-white"
                    :disabled="form.processing"
                >
                    {{ form.processing ? 'Creating…' : 'Create plan' }}
                </Button>
            </form>
        </div>
    </AppLayout>
</template>