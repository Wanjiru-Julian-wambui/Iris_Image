<script setup>
import { Head, Link } from '@inertiajs/vue3';

const props = defineProps({
  invitations: Object, // pagination resource
});
</script>

<template>
  <Head title="Invitations" />

  <div class="max-w-4xl mx-auto py-8">
    <div class="flex justify-between items-center mb-6">
      <h1 class="text-2xl font-bold">Invitations</h1>
      <Link
        :href="route('invitations.create')"
        class="px-4 py-2 bg-indigo-600 text-white rounded hover:bg-indigo-700"
      >
        Send Invitation
      </Link>
    </div>

    <div class="bg-white shadow rounded overflow-hidden">
      <table class="min-w-full">
        <thead class="bg-gray-50">
          <tr>
            <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Email</th>
            <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Status</th>
            <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Expires</th>
            <th class="px-4 py-2 text-left text-xs font-medium text-gray-500 uppercase">Invited By</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-200">
          <tr v-for="inv in invitations.data" :key="inv.id">
            <td class="px-4 py-2 text-sm text-gray-900">
              {{ inv.email }}
            </td>
            <td class="px-4 py-2 text-sm">
              <span
                class="inline-flex px-2 py-1 text-xs font-semibold rounded-full"
                :class="{
                  'bg-yellow-100 text-yellow-800': inv.status === 'pending',
                  'bg-green-100 text-green-800': inv.status === 'accepted',
                  'bg-red-100 text-red-800': inv.status === 'expired',
                }"
              >
                {{ inv.status }}
              </span>
            </td>
            <td class="px-4 py-2 text-sm text-gray-500">
              {{ inv.expiresAt ? new Date(inv.expiresAt).toLocaleString() : '-' }}
            </td>
            <td class="px-4 py-2 text-sm text-gray-500">
              {{ inv.invitedBy?.name ?? '-' }}
            </td>
          </tr>
          <tr v-if="!invitations.data.length">
            <td colspan="4" class="px-4 py-4 text-center text-sm text-gray-500">
              No invitations found.
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Simple pagination example -->
    <div class="mt-4 flex justify-between" v-if="invitations.links?.length">
      <div v-for="link in invitations.links" :key="link.url" class="mr-2">
        <Link
          v-if="link.url"
          :href="link.url"
          class="px-3 py-1 text-sm rounded"
          :class="link.active ? 'bg-indigo-600 text-white' : 'bg-gray-100 text-gray-700'"
          v-html="link.label"
        />
        <span v-else class="px-3 py-1 text-sm text-gray-400" v-html="link.label" />
      </div>
    </div>
  </div>
</template>