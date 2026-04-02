<script setup>
import { Head, useForm } from '@inertiajs/vue3';
import { Input } from '@/components/ui/input';
import { Button } from '@/components/ui/button';
import { Label } from '@/components/ui/label';

const props = defineProps({
  invitation: Object,
});

const form = useForm({
  name: '',
  password: '',
  password_confirmation: '',
});
</script>

<template>
  <Head title="Accept Invitation" />

  <div class="min-h-screen bg-background flex items-center justify-center px-4">
    <div class="w-full max-w-md">

      <!-- Logo / Brand -->
      <div class="text-center mb-8">
        <div class="inline-flex items-center justify-center size-14 rounded-2xl bg-gradient-to-br from-[#7B2FFF] to-[#00E5FF] mb-4 shadow-lg">
          <img src="/favicon.png" alt="Iris" class="size-8 object-contain" />
        </div>
        <h1 class="text-2xl font-bold tracking-tight">You're invited to Iris</h1>
        <p class="text-sm text-muted-foreground mt-1">
          Create your account to get started
        </p>
      </div>

      <!-- Invitation Info Card -->
      <div class="rounded-xl border border-border bg-muted/40 px-5 py-4 mb-6 space-y-1.5">
        <div class="flex items-center gap-2 text-sm">
          <span class="text-muted-foreground">Email:</span>
          <span class="font-medium">{{ invitation.data?.email ?? invitation.email }}</span>
        </div>
        <div class="flex items-center gap-2 text-sm">
          <span class="text-muted-foreground">Invited by:</span>
          <span class="font-medium">{{ invitation.data?.invitedBy?.name ?? invitation.invitedBy?.name ?? 'Unknown' }}</span>
        </div>
        <div class="flex items-center gap-2 text-sm" v-if="invitation.data?.expiresAt ?? invitation.expiresAt">
          <span class="text-muted-foreground">Expires:</span>
          <span class="font-medium">
            {{ new Date(invitation.data?.expiresAt ?? invitation.expiresAt).toLocaleDateString(undefined, { dateStyle: 'medium' }) }}
          </span>
        </div>
      </div>

      <!-- Form -->
      <div class="rounded-xl border border-border bg-card p-6 shadow-sm">
        <form
          @submit.prevent="form.post(`/invitations/${invitation.data?.token ?? invitation.token}/accept`)"
          class="space-y-5"
        >
          <div class="space-y-1.5">
            <Label for="name">Full Name</Label>
            <Input
              id="name"
              v-model="form.name"
              type="text"
              placeholder="Jane Doe"
              :class="{ 'border-destructive': form.errors.name }"
              autofocus
              required
            />
            <p v-if="form.errors.name" class="text-sm text-destructive">
              {{ form.errors.name }}
            </p>
          </div>

          <div class="space-y-1.5">
            <Label for="password">Password</Label>
            <Input
              id="password"
              v-model="form.password"
              type="password"
              placeholder="••••••••"
              :class="{ 'border-destructive': form.errors.password }"
              required
            />
            <p v-if="form.errors.password" class="text-sm text-destructive">
              {{ form.errors.password }}
            </p>
          </div>

          <div class="space-y-1.5">
            <Label for="password_confirmation">Confirm Password</Label>
            <Input
              id="password_confirmation"
              v-model="form.password_confirmation"
              type="password"
              placeholder="••••••••"
              :class="{ 'border-destructive': form.errors.password_confirmation }"
              required
            />
            <p v-if="form.errors.password_confirmation" class="text-sm text-destructive">
              {{ form.errors.password_confirmation }}
            </p>
          </div>

          <Button
            type="submit"
            :disabled="form.processing"
            class="w-full bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF] text-white hover:opacity-90"
          >
            {{ form.processing ? 'Creating account...' : 'Accept Invitation' }}
          </Button>
        </form>
      </div>

      <p class="text-center text-xs text-muted-foreground mt-6">
        Already have an account?
        <a href="/login" class="text-primary hover:underline">Sign in</a>
      </p>

    </div>
  </div>
</template>