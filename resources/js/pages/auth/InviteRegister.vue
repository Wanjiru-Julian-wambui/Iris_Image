<script setup lang="ts">
import { Head, useForm } from '@inertiajs/vue3';
import { Eye, EyeOff } from 'lucide-vue-next';
import { ref } from 'vue';
import InputError from '@/components/InputError.vue';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import AuthLayout from '@/layouts/AuthLayout.vue';

const props = defineProps<{
    invitation: App.InvitationResource;
}>();

const showPassword = ref(false);
const showConfirm = ref(false);

const form = useForm({
    name:                  '',
    password:              '',
    password_confirmation: '',
});

function submit() {
    form.post(`/register/invite/${props.invitation.token}`, {
        onFinish: () => form.reset('password', 'password_confirmation'),
    });
}
</script>

<template>
    <AuthLayout>
        <Head title="Accept Invitation" />

        <div class="flex flex-col items-center mb-6 text-center">
            <img src="/favicon.png" alt="Iris" class="w-12 h-12 object-contain mb-3" />
            <h1 class="text-2xl font-bold tracking-tight">You're invited to Iris</h1>
            <p class="text-sm text-muted-foreground mt-1">
                Invited by <span class="font-medium text-foreground">{{ invitation.invited_by?.name }}</span>
            </p>
        </div>

        <div class="rounded-xl border border-border bg-muted/50 px-4 py-3 mb-6 text-sm text-center">
            <p class="text-muted-foreground">
                Creating account for
                <span class="font-semibold text-foreground">{{ invitation.email }}</span>
            </p>
            <p class="text-xs text-muted-foreground mt-1">
                Invitation expires {{ invitation.expires_at }}
            </p>
        </div>

        <form @submit.prevent="submit" class="space-y-4">
            <div class="space-y-1.5">
                <Label for="name">Full name</Label>
                <Input
                    id="name"
                    v-model="form.name"
                    type="text"
                    placeholder="John Doe"
                    autocomplete="name"
                    :disabled="form.processing"
                    required
                />
                <InputError :message="form.errors.name" />
            </div>

            <div class="space-y-1.5">
                <Label for="password">Password</Label>
                <div class="relative">
                    <Input
                        id="password"
                        v-model="form.password"
                        :type="showPassword ? 'text' : 'password'"
                        placeholder="Min. 8 characters"
                        autocomplete="new-password"
                        :disabled="form.processing"
                        required
                    />
                    <button type="button" @click="showPassword = !showPassword" class="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-foreground">
                        <Eye v-if="!showPassword" class="h-4 w-4" />
                        <EyeOff v-else class="h-4 w-4" />
                    </button>
                </div>
                <InputError :message="form.errors.password" />
            </div>

            <div class="space-y-1.5">
                <Label for="password_confirmation">Confirm password</Label>
                <div class="relative">
                    <Input
                        id="password_confirmation"
                        v-model="form.password_confirmation"
                        :type="showConfirm ? 'text' : 'password'"
                        placeholder="Repeat your password"
                        autocomplete="new-password"
                        :disabled="form.processing"
                        required
                    />
                    <button type="button" @click="showConfirm = !showConfirm" class="absolute right-3 top-1/2 -translate-y-1/2 text-muted-foreground hover:text-foreground">
                        <Eye v-if="!showConfirm" class="h-4 w-4" />
                        <EyeOff v-else class="h-4 w-4" />
                    </button>
                </div>
                <InputError :message="form.errors.password_confirmation" />
            </div>

            <Button
                type="submit"
                class="w-full bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF] text-white hover:opacity-90"
                :disabled="form.processing"
            >
                {{ form.processing ? 'Creating account...' : 'Create account' }}
            </Button>
        </form>
    </AuthLayout>
</template>