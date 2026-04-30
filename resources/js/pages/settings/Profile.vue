<script setup lang="ts">
import { Form, Head, Link, usePage } from '@inertiajs/vue3';
import { computed, ref } from 'vue';
import ProfileController from '@/actions/App/Http/Controllers/Settings/ProfileController';
import DeleteUser from '@/components/DeleteUser.vue';
import Heading from '@/components/Heading.vue';
import InputError from '@/components/InputError.vue';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Switch } from '@/components/ui/switch';
import AppLayout from '@/layouts/AppLayout.vue';
import SettingsLayout from '@/layouts/settings/Layout.vue';
import { edit } from '@/routes/profile';
import { send } from '@/routes/verification';
import type { BreadcrumbItem } from '@/types';

type Props = {
    mustVerifyEmail: boolean;
    status?: string;
};

defineProps<Props>();

const breadcrumbItems: BreadcrumbItem[] = [
    { title: 'Profile settings', href: edit() },
];

const page = usePage();
const user = computed(() => page.props.auth.user);

const avatarPreview = ref<string | null>(null);

function onAvatarChange(event: Event) {
    const file = (event.target as HTMLInputElement).files?.[0];
    if (file) {
        avatarPreview.value = URL.createObjectURL(file);
    }
}
</script>

<template>
    <AppLayout :breadcrumbs="breadcrumbItems">
        <Head title="Profile settings" />
        <h1 class="sr-only">Profile settings</h1>

        <SettingsLayout>
            <div class="flex flex-col space-y-6">
                <Heading
                    variant="small"
                    title="Profile information"
                    description="Update your name, email address, avatar, and public profile"
                />

                <Form
                    v-bind="ProfileController.update.form()"
                    enctype="multipart/form-data"
                    class="space-y-6"
                    v-slot="{ errors, processing, recentlySuccessful }"
                >
                    <!-- Avatar -->
                    <div class="grid gap-2">
                        <Label>Avatar</Label>
                        <div class="flex items-center gap-4">
                            <img
                                :src="avatarPreview ?? user.avatar_url"
                                :alt="user.name"
                                class="h-16 w-16 rounded-full object-cover ring-2 ring-border"
                            />

                            <div class="flex flex-col gap-1">
                                <label
                                    for="avatar"
                                    class="cursor-pointer inline-flex items-center gap-2 rounded-md border border-input bg-background px-3 py-2 text-sm font-medium shadow-sm hover:bg-accent hover:text-accent-foreground transition-colors"
                                >
                                    <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
                                        <polyline points="17 8 12 3 7 8"/>
                                        <line x1="12" y1="3" x2="12" y2="15"/>
                                    </svg>
                                    Choose image
                                </label>
                                <span class="text-xs text-muted-foreground">
                                    JPG, PNG, GIF or WebP · max 2 MB
                                </span>
                                <input
                                    id="avatar"
                                    name="avatar"
                                    type="file"
                                    accept="image/jpeg,image/png,image/gif,image/webp"
                                    class="sr-only"
                                    @change="onAvatarChange"
                                />
                            </div>
                        </div>
                        <InputError class="mt-1" :message="errors.avatar" />
                    </div>

                    <!-- Name -->
                    <div class="grid gap-2">
                        <Label for="name">Name</Label>
                        <Input
                            id="name"
                            class="mt-1 block w-full"
                            name="name"
                            :default-value="user.name"
                            required
                            autocomplete="name"
                            placeholder="Full name"
                        />
                        <InputError class="mt-2" :message="errors.name" />
                    </div>

                    <!-- Username -->
                    <div class="grid gap-2">
                        <Label for="username">Username</Label>
                        <div class="relative">
                            <span class="absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground text-sm">@</span>
                            <Input
                                id="username"
                                name="username"
                                class="mt-1 block w-full pl-7"
                                :default-value="user.username"
                                autocomplete="username"
                                placeholder="username"
                            />
                        </div>
                        <p class="text-xs text-muted-foreground">
                            Your public profile will be available at /@username
                        </p>
                        <InputError class="mt-2" :message="errors.username" />
                    </div>

                    <!-- Email -->
                    <div class="grid gap-2">
                        <Label for="email">Email address</Label>
                        <Input
                            id="email"
                            type="email"
                            class="mt-1 block w-full"
                            name="email"
                            :default-value="user.email"
                            required
                            autocomplete="username"
                            placeholder="Email address"
                        />
                        <InputError class="mt-2" :message="errors.email" />
                    </div>

                    <!-- Bio -->
                    <div class="grid gap-2">
                        <Label for="bio">Bio</Label>
                        <textarea
                            id="bio"
                            name="bio"
                            rows="3"
                            class="mt-1 block w-full rounded-xl border border-border bg-background px-4 py-2.5 text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-violet-500/50 resize-none"
                            :default-value="user.bio"
                            placeholder="Tell visitors a little about yourself..."
                        ></textarea>
                        <InputError class="mt-2" :message="errors.bio" />
                    </div>

                    <!-- Website -->
                    <div class="grid gap-2">
                        <Label for="website">Website</Label>
                        <Input
                            id="website"
                            type="url"
                            name="website"
                            class="mt-1 block w-full"
                            :default-value="user.website"
                            placeholder="https://your-website.com"
                        />
                        <InputError class="mt-2" :message="errors.website" />
                    </div>

                    <!-- Public Profile Toggle -->
                    <div class="flex items-center justify-between rounded-xl border border-border bg-muted/30 p-4">
                        <div class="space-y-0.5">
                            <Label for="profile_public" class="text-sm font-medium">Public profile</Label>
                            <p class="text-xs text-muted-foreground">
                                Allow anyone to view your profile and published images
                            </p>
                        </div>
                        <Switch
                            id="profile_public"
                            name="profile_public"
                            :default-checked="user.profile_public"
                            value="1"
                        />
                    </div>

                    <!-- Email verification notice -->
                    <div v-if="mustVerifyEmail && !user.email_verified_at">
                        <p class="-mt-4 text-sm text-muted-foreground">
                            Your email address is unverified.
                            <Link
                                :href="send()"
                                as="button"
                                class="text-foreground underline decoration-neutral-300 underline-offset-4 transition-colors duration-300 ease-out hover:decoration-current! dark:decoration-neutral-500"
                            >
                                Click here to resend the verification email.
                            </Link>
                        </p>
                        <div
                            v-if="status === 'verification-link-sent'"
                            class="mt-2 text-sm font-medium text-green-600"
                        >
                            A new verification link has been sent to your email address.
                        </div>
                    </div>

                    <!-- Submit -->
                    <div class="flex items-center gap-4">
                        <Button :disabled="processing" data-test="update-profile-button">
                            Save
                        </Button>
                        <Transition
                            enter-active-class="transition ease-in-out"
                            enter-from-class="opacity-0"
                            leave-active-class="transition ease-in-out"
                            leave-to-class="opacity-0"
                        >
                            <p v-show="recentlySuccessful" class="text-sm text-neutral-600">
                                Saved.
                            </p>
                        </Transition>
                    </div>
                </Form>
            </div>

            <DeleteUser />
        </SettingsLayout>
    </AppLayout>
</template>