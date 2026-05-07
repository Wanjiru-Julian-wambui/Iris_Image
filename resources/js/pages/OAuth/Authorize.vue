<script setup lang="ts">
import { router } from '@inertiajs/vue3';
import AppLayout from '@/layouts/AppLayout.vue';

type Scope = {
    id: string;
    description: string;
};

type OAuthClient = {
    id: string;
    name: string;
};

type OAuthRequest = {
    state: string;
    client_id: string;
};

const props = defineProps<{
    client: OAuthClient;
    scopes: Scope[];
    request: OAuthRequest;
    authToken: string;
}>();

const approve = () => {
    router.post('/oauth/authorize', {
        state: props.request.state,
        client_id: props.request.client_id,
        auth_token: props.authToken,
    });
};

const deny = () => {
    router.delete('/oauth/authorize', {
        data: {
            state: props.request.state,
            client_id: props.request.client_id,
            auth_token: props.authToken,
        },
    });
};
</script>

<template>
    <AppLayout :breadcrumbs="[{ title: 'Authorize', href: '/oauth/authorize' }]">
        <div class="flex items-center justify-center p-8">
            <div class="bg-white shadow rounded-lg p-8 max-w-md w-full">
                <h1 class="text-xl font-semibold text-gray-800 mb-2">
                    Authorize {{ client.name }}
                </h1>
                <p class="text-gray-500 text-sm mb-6">
                    This application is requesting access to your account.
                </p>

                <div v-if="scopes.length" class="mb-6">
                    <p class="text-sm font-medium text-gray-700 mb-2">Requested permissions:</p>
                    <ul class="space-y-1">
                        <li
                            v-for="scope in scopes"
                            :key="scope.id"
                            class="text-sm text-gray-600 flex items-center gap-2"
                        >
                            <span class="text-green-500">✓</span>
                            {{ scope.description }}
                        </li>
                    </ul>
                </div>

                <div class="flex gap-3">
                    <button
                        @click="approve"
                        class="flex-1 bg-blue-600 text-white text-sm font-medium py-2 px-4 rounded hover:bg-blue-700 transition"
                    >
                        Approve
                    </button>
                    <button
                        @click="deny"
                        class="flex-1 bg-gray-100 text-gray-700 text-sm font-medium py-2 px-4 rounded hover:bg-gray-200 transition"
                    >
                        Deny
                    </button>
                </div>
            </div>
        </div>
    </AppLayout>
</template>