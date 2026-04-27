<script setup lang="ts">
import { Head, useForm, usePage } from '@inertiajs/vue3';
import { ref, computed } from 'vue';
import AppLayout from '@/layouts/AppLayout.vue';
import type { BreadcrumbItem } from '@/types';

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Dashboard', href: '/dashboard' },
    { title: 'API Credentials', href: '/settings/api-credentials' },
];

const props = defineProps<{
    credentials: {
        id: number;
        label: string;
        api_key: string;
        last_used_at: string | null;
        created_at: string;
    }[];
    appUrl: string;
}>();

const page      = usePage();
// Accessing the flashed values from the session
const newKey    = computed(() => (page.props.flash as any)?.new_key    ?? null);
const newSecret = computed(() => (page.props.flash as any)?.new_secret ?? null);

const showSecret    = ref(false); 
const showKeyInList = ref<Record<number, boolean>>({});

const copiedId = ref<string | null>(null);

function copy(text: string, id: string) {
    navigator.clipboard.writeText(text);
    copiedId.value = id;
    setTimeout(() => { copiedId.value = null; }, 2000);
}

// ── Actions ───────────────────────────────────────────────────────
const showCreate = ref(false);
const form = useForm({ label: '' });

function submit() {
    form.post('/settings/api-credentials', {
        preserveScroll: true,
        onSuccess: () => { form.reset(); showCreate.value = false; },
    });
}

const deleteForm = useForm({});
function remove(id: number) {
    if (!confirm('Delete this credential?')) return;
    deleteForm.delete('/settings/api-credentials/' + id, { preserveScroll: true });
}
</script>

<template>
    <Head title="API Credentials" />

    <AppLayout :breadcrumbs="breadcrumbs">
        <div class="mx-auto max-w-3xl px-4 py-10 space-y-8">

            <div class="flex items-start justify-between">
                <div>
                    <h1 class="text-2xl font-bold tracking-tight">API Credentials</h1>
                    <p class="mt-1 text-sm text-muted-foreground">Authenticate using X-API-Key and X-API-Secret headers.</p>
                </div>
                <button v-if="!newKey" @click="showCreate = true" class="rounded-xl bg-gradient-to-r from-violet-500 to-cyan-400 px-4 py-2 text-sm font-semibold text-white">
                    + Generate
                </button>
            </div>

            <div v-if="newKey" class="rounded-2xl border border-emerald-500/30 bg-emerald-500/10 p-6 space-y-5">
                <div class="flex items-center justify-between">
                    <p class="text-sm font-semibold text-emerald-400">✓ New Credentials Generated</p>
                    <button @click="copy(`API_KEY=${newKey}\nAPI_SECRET=${newSecret}`, 'pair')" class="text-xs bg-muted px-2 py-1 rounded">
                        {{ copiedId === 'pair' ? '✓ Copied Both' : 'Copy Both' }}
                    </button>
                </div>

                <div class="space-y-4">
                    <div class="space-y-1">
                        <label class="text-[10px] font-bold uppercase text-muted-foreground">API Key</label>
                        <div class="flex items-center gap-3 bg-background p-3 rounded-xl border border-border">
                            <code class="flex-1 text-xs font-mono break-all">{{ newKey }}</code>
                            <button @click="copy(newKey, 'nk')" class="text-xs text-violet-400">{{ copiedId === 'nk' ? '✓' : 'Copy' }}</button>
                        </div>
                    </div>

                    <div class="space-y-1">
                        <div class="flex justify-between">
                            <label class="text-[10px] font-bold uppercase text-muted-foreground">API Secret</label>
                            <button @click="showSecret = !showSecret" class="text-[10px] underline text-muted-foreground">
                                {{ showSecret ? 'Hide' : 'Reveal' }}
                            </button>
                        </div>
                        <div class="flex items-center gap-3 bg-amber-500/5 p-3 rounded-xl border border-amber-500/20">
                            <code class="flex-1 text-xs font-mono text-amber-300">
                                {{ showSecret ? newSecret : '••••••••••••••••••••••••••••••••' }}
                            </code>
                            <button @click="copy(newSecret, 'ns')" class="text-xs text-amber-400">{{ copiedId === 'ns' ? '✓' : 'Copy' }}</button>
                        </div>
                        <p class="text-[10px] text-amber-500/80 italic">⚠ Save this now. For security, we cannot show this secret again.</p>
                    </div>
                </div>
            </div>

            <div v-if="showCreate" class="rounded-2xl border border-border bg-card p-6 space-y-4">
                <h2 class="text-sm font-semibold">Credential Label</h2>
                <input v-model="form.label" type="text" placeholder="e.g. My App" class="w-full bg-background border border-border rounded-xl px-4 py-2 text-sm" />
                <div class="flex gap-2">
                    <button @click="submit" :disabled="form.processing" class="bg-violet-500 text-white px-4 py-2 rounded-xl text-sm font-bold">Generate</button>
                    <button @click="showCreate = false" class="text-sm text-muted-foreground">Cancel</button>
                </div>
            </div>

            <div class="rounded-2xl border border-border bg-card overflow-hidden">
                <div class="px-6 py-4 border-b border-border bg-muted/20">
                    <h2 class="text-sm font-semibold">Your API Keys</h2>
                </div>
                <ul class="divide-y divide-border">
                    <li v-for="cred in credentials" :key="cred.id" class="p-6 flex items-start gap-4">
                        <div class="h-10 w-10 bg-violet-500/10 rounded-xl flex items-center justify-center text-xl">🔐</div>
                        <div class="flex-1 space-y-2">
                            <div>
                                <p class="text-sm font-bold">{{ cred.label }}</p>
                                <p class="text-[10px] text-muted-foreground uppercase">Created {{ cred.created_at }}</p>
                            </div>
                            <div class="space-y-1">
                                <div class="flex items-center gap-2">
                                    <code class="text-xs font-mono text-muted-foreground">
                                        Key: {{ showKeyInList[cred.id] ? cred.api_key : cred.api_key.slice(0,8) + '...' }}
                                    </code>
                                    <button @click="showKeyInList[cred.id] = !showKeyInList[cred.id]" class="text-[10px] underline">Toggle</button>
                                </div>
                                <div class="text-[10px] text-muted-foreground italic">Secret: Hashed (Protected)</div>
                            </div>
                        </div>
                        <button @click="remove(cred.id)" class="text-xs text-rose-400 font-bold">Delete</button>
                    </li>
                </ul>
            </div>
        </div>
    </AppLayout>
</template>