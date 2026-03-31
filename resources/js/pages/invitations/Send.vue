<script setup>
import { Head, useForm } from '@inertiajs/vue3';

const form = useForm({
  email: '',
});
</script>

<template>
  <Head title="Send Invitation" />

  <div class="max-w-md mx-auto py-8">
    <h1 class="text-2xl font-bold mb-6">Send Invitation</h1>

    <form @submit.prevent="form.post(route('invitations.store'))" class="space-y-4">
      <div>
        <label class="block text-sm font-medium text-gray-700">Email</label>
        <input
          v-model="form.email"
          type="email"
          class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500"
        />
        <div v-if="form.errors.email" class="mt-1 text-sm text-red-600">
          {{ form.errors.email }}
        </div>
      </div>

      <div class="flex justify-end">
        <button
          type="submit"
          class="px-4 py-2 bg-indigo-600 text-white rounded hover:bg-indigo-700"
          :disabled="form.processing"
        >
          <span v-if="form.processing">Sending...</span>
          <span v-else>Send Invitation</span>
        </button>
      </div>
    </form>
  </div>
</template>