<script setup>
import { Head, useForm } from '@inertiajs/vue3';

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

  <div class="max-w-md mx-auto py-8">
    <h1 class="text-2xl font-bold mb-4">Accept Invitation</h1>

    <div class="mb-6 bg-white shadow rounded p-4">
      <p class="text-sm text-gray-700">
        You are accepting an invitation for:
        <strong>{{ invitation.email }}</strong>
      </p>
      <p class="text-sm text-gray-500 mt-2">
        Invited by:
        <strong>{{ invitation.invitedBy?.name ?? 'Unknown' }}</strong>
      </p>
      <p class="text-sm text-gray-500">
        Status: <strong>{{ invitation.status }}</strong>
      </p>
      <p class="text-sm text-gray-500" v-if="invitation.expiresAt">
        Expires at:
        <strong>{{ new Date(invitation.expiresAt).toLocaleString() }}</strong>
      </p>
    </div>

    <form
      @submit.prevent="form.post(route('invitations.accept', invitation.token))"
      class="space-y-4 bg-white shadow rounded p-4"
    >
      <div>
        <label class="block text-sm font-medium text-gray-700">Name</label>
        <input
          v-model="form.name"
          type="text"
          class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500"
        />
        <div v-if="form.errors.name" class="mt-1 text-sm text-red-600">
          {{ form.errors.name }}
        </div>
      </div>

      <div>
        <label class="block text-sm font-medium text-gray-700">Password</label>
        <input
          v-model="form.password"
          type="password"
          class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500"
        />
        <div v-if="form.errors.password" class="mt-1 text-sm text-red-600">
          {{ form.errors.password }}
        </div>
      </div>

      <div>
        <label class="block text-sm font-medium text-gray-700">Confirm Password</label>
        <input
          v-model="form.password_confirmation"
          type="password"
          class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500"
        />
        <div v-if="form.errors.password_confirmation" class="mt-1 text-sm text-red-600">
          {{ form.errors.password_confirmation }}
        </div>
      </div>

      <div class="flex justify-end">
        <button
          type="submit"
          class="px-4 py-2 bg-indigo-600 text-white rounded hover:bg-indigo-700"
          :disabled="form.processing"
        >
          <span v-if="form.processing">Creating account...</span>
          <span v-else>Accept Invitation</span>
        </button>
      </div>
    </form>
  </div>
</template>