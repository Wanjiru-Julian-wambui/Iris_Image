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
const newKey    = computed(() => (page.props.flash as any)?.new_key    ?? null);
const newSecret = computed(() => (page.props.flash as any)?.new_secret ?? null);

// ── Show/hide logic ──────────────────────────────────────────────
const showSecret    = ref(false); // For the new credential reveal
const showKeyInList = ref<Record<number, boolean>>({});

function toggleKey(id: number) {
    showKeyInList.value[id] = !showKeyInList.value[id];
}

function masked(text: string): string {
    if (!text) return '••••••••••••••••••••';
    return text.slice(0, 8) + '••••••••••••••••••••';
}

// ── Copy helpers ──────────────────────────────────────────────────
const copiedId = ref<string | null>(null);

function copy(text: string, id: string) {
    navigator.clipboard.writeText(text);
    copiedId.value = id;
    setTimeout(() => { copiedId.value = null; }, 2000);
}

function copyPair() {
    if (!newKey.value || !newSecret.value) return;
    copy('API_KEY=' + newKey.value + '\nAPI_SECRET=' + newSecret.value, 'pair');
}

function copyEnv() {
    if (!newKey.value || !newSecret.value) return;
    copy(
        'IRIS_API_KEY=' + newKey.value + '\nIRIS_API_SECRET=' + newSecret.value + '\nIRIS_API_URL=' + props.appUrl,
        'env'
    );
}

function copyCurl() {
    const curl = `curl ${props.appUrl}/api/images \\\n  -H "X-API-Key: ik_your_key_here" \\\n  -H "X-API-Secret: is_your_secret_here"`;
    copy(curl, 'curl');
}

// ── Create form ───────────────────────────────────────────────────
const showCreate = ref(false);
const form = useForm({ label: '' });

function submit() {
    form.post('/settings/api-credentials', {
        preserveScroll: true,
        onSuccess: () => { form.reset(); showCreate.value = false; },
    });
}

// ── Delete ────────────────────────────────────────────────────────
const deleteForm = useForm({});
function remove(id: number) {
    if (!confirm('Delete this credential? Any apps using it will stop working.')) return;
    deleteForm.delete('/settings/api-credentials/' + id, { preserveScroll: true });
}
</script>

<template>
    <Head title="API Credentials" />

    <AppLayout :breadcrumbs="breadcrumbs">
        <div class="mx-auto max-w-3xl px-4 py-10 space-y-8">

            <div class="flex items-start justify-between gap-4">
                <div>
                    <h1 class="text-2xl font-bold tracking-tight text-foreground">API Credentials</h1>
                    <p class="mt-1 text-sm text-muted-foreground max-w-lg">
                        Authenticate requests with <code class="rounded bg-muted px-1 text-xs text-foreground">X-API-Key</code> and <code class="rounded bg-muted px-1 text-xs text-foreground">X-API-Secret</code>.
                    </p>
                </div>
                <button
                    v-if="!showCreate && !newKey"
                    @click="showCreate = true"
                    class="shrink-0 rounded-xl bg-gradient-to-r from-violet-500 to-cyan-400 px-4 py-2 text-sm font-semibold text-white hover:opacity-90 transition-opacity"
                >
                    + Generate
                </button>
            </div>

            <div v-if="newKey && newSecret" class="rounded-2xl border border-emerald-500/30 bg-emerald-500/10 p-6 space-y-5">
                <div class="flex items-center justify-between">
                    <p class="text-sm font-semibold text-emerald-400">
                        ✓ Credentials generated — save them now.
                    </p>
                    <button
                        @click="copyPair"
                        class="rounded-lg px-3 py-1.5 text-xs font-semibold transition-colors"
                        :class="copiedId === 'pair' ? 'bg-emerald-500/20 text-emerald-400' : 'bg-muted text-muted-foreground hover:text-foreground'"
                    >{{ copiedId === 'pair' ? '✓ Copied both' : 'Copy both' }}</button>
                </div>

                <div class="space-y-4">
                    <div class="space-y-1.5">
                        <label class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">API Key</label>
                        <div class="flex items-center gap-3 rounded-xl border border-border bg-background px-4 py-3">
                            <code class="flex-1 text-sm font-mono text-foreground select-all break-all">{{ newKey }}</code>
                            <button @click="copy(newKey, 'key')" class="text-xs text-violet-400">{{ copiedId === 'key' ? '✓' : 'Copy' }}</button>
                        </div>
                    </div>

                    <div class="space-y-1.5">
                        <div class="flex items-center justify-between">
                            <label class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">API Secret</label>
                            <button @click="showSecret = !showSecret" class="text-xs text-muted-foreground">{{ showSecret ? 'Hide' : 'Reveal' }}</button>
                        </div>
                        <div class="flex items-center gap-3 rounded-xl border border-amber-500/30 bg-amber-500/5 px-4 py-3">
                            <code class="flex-1 text-sm font-mono text-amber-300">
                                {{ showSecret ? newSecret : masked(newSecret) }}
                            </code>
                            <button @click="copy(newSecret, 'secret')" class="text-xs text-amber-400">{{ copiedId === 'secret' ? '✓' : 'Copy' }}</button>
                        </div>
                        <p class="text-[10px] text-amber-400 italic">⚠ This secret is hashed in our database and cannot be shown again after you leave this page.</p>
                    </div>
                </div>
            </div>

            <div v-if="showCreate" class="rounded-2xl border border-white/8 bg-card p-6 space-y-4">
                <h2 class="text-base font-semibold">Generate new credential</h2>
                <input v-model="form.label" type="text" placeholder="Label (e.g. Mobile App)" class="w-full rounded-xl border border-border bg-background px-4 py-2.5 text-sm focus:ring-2 focus:ring-violet-500 outline-none" />
                <div class="flex gap-3">
                    <button @click="submit" :disabled="form.processing" class="rounded-xl bg-violet-500 px-5 py-2 text-sm font-semibold text-white">Generate</button>
                    <button @click="showCreate = false" class="text-sm text-muted-foreground">Cancel</button>
                </div>
            </div>

            <div class="rounded-2xl border border-white/8 bg-card overflow-hidden">
                <div class="px-6 py-4 border-b border-border bg-muted/20">
                    <h2 class="text-sm font-semibold">Your credentials</h2>
                </div>

                <ul class="divide-y divide-border">
                    <li v-for="cred in credentials" :key="cred.id" class="p-6 flex items-start gap-4 hover:bg-muted/10 transition-colors">
                        <div class="h-10 w-10 flex items-center justify-center rounded-xl bg-violet-500/10 text-xl shrink-0">🔐</div>
                        <div class="flex-1 space-y-2 min-w-0">
                            <div>
                                <p class="text-sm font-bold">{{ cred.label }}</p>
                                <p class="text-[10px] text-muted-foreground uppercase">Created {{ cred.created_at }}</p>
                            </div>
                            
                            <div class="space-y-1">
                                <div class="flex items-center gap-2">
                                    <code class="text-xs font-mono text-muted-foreground bg-muted/50 px-2 py-0.5 rounded">
                                        Key: {{ showKeyInList[cred.id] ? cred.api_key : masked(cred.api_key) }}
                                    </code>
                                    <button @click="toggleKey(cred.id)" class="text-[10px] text-muted-foreground underline">{{ showKeyInList[cred.id] ? 'hide' : 'reveal' }}</button>
                                    <button @click="copy(cred.api_key, 'list'+cred.id)" class="text-[10px] text-violet-400">{{ copiedId === 'list'+cred.id ? '✓ copied' : 'copy' }}</button>
                                </div>
                                <div class="flex items-center gap-2 opacity-60">
                                    <code class="text-xs font-mono text-muted-foreground/50 bg-muted/20 px-2 py-0.5 rounded">
                                        Secret: ••••••••••••••••••••
                                    </code>
                                    <span class="text-[10px] text-muted-foreground italic">(Hashed/Hidden)</span>
                                </div>
                            </div>
                        </div>
                        <button @click="remove(cred.id)" class="text-xs text-rose-400 font-semibold border border-rose-500/20 px-3 py-1 rounded-lg hover:bg-rose-500/10">Delete</button>
                    </li>
                </ul>
            </div>

            <div class="rounded-2xl border border-white/8 bg-card p-6 space-y-4">
                <h3 class="text-sm font-semibold">How to use</h3>
                <div class="relative rounded-xl bg-muted/60 border border-border p-4">
                    <pre class="text-xs font-mono text-foreground whitespace-pre-wrap break-all">curl {{ appUrl }}/api/images \
  -H "X-API-Key: YOUR_KEY" \
  -H "X-API-Secret: YOUR_SECRET"</pre>
                    <button @click="copyCurl" class="absolute top-4 right-4 text-xs border border-border bg-background px-2 py-1 rounded-lg">Copy</button>
                </div>
            </div>

        </div>
    </AppLayout>
</template>