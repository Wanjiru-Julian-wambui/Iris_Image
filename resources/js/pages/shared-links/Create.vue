<script setup lang="ts">
import { Head, router, useForm } from '@inertiajs/vue3';
import { ArrowLeft, Copy } from 'lucide-vue-next';
import { Link } from '@inertiajs/vue3';
import { ref } from 'vue';
import AppLayout from '@/layouts/AppLayout.vue';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Switch } from '@/components/ui/switch';
import {
    Select,
    SelectContent,
    SelectItem,
    SelectTrigger,
    SelectValue,
} from '@/components/ui/select';
import InputError from '@/components/InputError.vue';
import type { BreadcrumbItem } from '@/types';

const props = defineProps<{
    images: App.ImageResource[];
}>();

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Dashboard', href: '/dashboard' },
    { title: 'Shared Links', href: '/shared-links' },
    { title: 'New link', href: '/shared-links/create' },
];

const form = useForm({
    image_id:   '',
    expires_in: '24',
    password:   '',
});

const usePassword = ref(false);
const shareUrl = ref('');
const copied = ref(false);

function submit() {
    form.transform(data => ({
        ...data,
        image_id:  parseInt(data.image_id),
        expires_in: parseInt(data.expires_in),
        password:  usePassword.value ? data.password : null,
    })).post('/shared-links', {
        onSuccess: (page: any) => {
            shareUrl.value = page.props.flash?.share_url ?? '';
        },
    });
}

function copyUrl() {
    navigator.clipboard.writeText(shareUrl.value);
    copied.value = true;
    setTimeout(() => { copied.value = false; }, 2000);
}
</script>

<template>
    <AppLayout :breadcrumbs="breadcrumbs">
        <Head title="New Shared Link" />

        <div class="max-w-xl mx-auto px-4 py-8">
            <div class="flex items-center gap-3 mb-6">
                <Link href="/shared-links">
                    <Button variant="ghost" size="icon" class="h-8 w-8">
                        <ArrowLeft class="h-4 w-4" />
                    </Button>
                </Link>
                <h1 class="text-2xl font-bold tracking-tight">New shared link</h1>
            </div>

            <!-- Generated URL -->
            <div v-if="shareUrl" class="rounded-xl border border-[#7B2FFF]/30 bg-[#7B2FFF]/5 p-6 mb-6 space-y-3">
                <p class="text-sm font-medium">Your link is ready</p>
                <div class="flex gap-2">
                    <Input :value="shareUrl" readonly class="font-mono text-xs" />
                    <Button variant="outline" size="icon" @click="copyUrl">
                        <Copy class="h-4 w-4" :class="copied ? 'text-green-500' : ''" />
                    </Button>
                </div>
                <p v-if="copied" class="text-xs text-green-600">Copied to clipboard!</p>
                <Link href="/shared-links">
                    <Button variant="outline" size="sm" class="mt-2">View all links</Button>
                </Link>
            </div>

            <form v-else @submit.prevent="submit" class="space-y-6">
                <!-- Select image -->
                <div class="rounded-xl border border-border p-6 space-y-4">
                    <h2 class="font-semibold text-sm text-muted-foreground uppercase tracking-wider">Select image</h2>

                    <div class="space-y-1.5">
                        <Label>Image</Label>
                        <Select v-model="form.image_id" required>
                            <SelectTrigger>
                                <SelectValue placeholder="Choose an image..." />
                            </SelectTrigger>
                            <SelectContent>
                                <SelectItem
                                    v-for="image in images"
                                    :key="image.id"
                                    :value="String(image.id)"
                                >
                                    {{ image.name }} — {{ image.size_human }}
                                </SelectItem>
                            </SelectContent>
                        </Select>
                        <InputError :message="form.errors.image_id" />
                    </div>

                    <!-- Preview selected image -->
                    <div
                        v-if="form.image_id"
                        class="rounded-lg overflow-hidden border border-border bg-muted h-40 flex items-center justify-center"
                    >
                        <img
                            :src="images.find(i => String(i.id) === form.image_id)?.thumbnail_url"
                            class="max-h-full max-w-full object-contain"
                        />
                    </div>
                </div>

                <!-- Link settings -->
                <div class="rounded-xl border border-border p-6 space-y-4">
                    <h2 class="font-semibold text-sm text-muted-foreground uppercase tracking-wider">Link settings</h2>

                    <div class="space-y-1.5">
                        <Label>Expires in</Label>
                        <Select v-model="form.expires_in">
                            <SelectTrigger>
                                <SelectValue />
                            </SelectTrigger>
                            <SelectContent>
                                <SelectItem value="1">1 hour</SelectItem>
                                <SelectItem value="6">6 hours</SelectItem>
                                <SelectItem value="24">24 hours</SelectItem>
                                <SelectItem value="72">3 days</SelectItem>
                                <SelectItem value="168">7 days</SelectItem>
                                <SelectItem value="720">30 days</SelectItem>
                            </SelectContent>
                        </Select>
                        <InputError :message="form.errors.expires_in" />
                    </div>

                    <div class="flex items-center justify-between">
                        <div>
                            <Label class="font-medium">Password protect</Label>
                            <p class="text-xs text-muted-foreground">Require a password to view this link</p>
                        </div>
                        <Switch v-model:checked="usePassword" />
                    </div>

                    <div v-if="usePassword" class="space-y-1.5">
                        <Label>Password</Label>
                        <Input
                            v-model="form.password"
                            type="password"
                            placeholder="Min. 4 characters"
                        />
                        <InputError :message="form.errors.password" />
                    </div>
                </div>

                <Button
                    type="submit"
                    class="w-full bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF] text-white hover:opacity-90"
                    :disabled="form.processing || !form.image_id"
                >
                    {{ form.processing ? 'Creating...' : 'Create shared link' }}
                </Button>
            </form>
        </div>
    </AppLayout>
</template>