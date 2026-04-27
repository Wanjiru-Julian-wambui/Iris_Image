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

// ── Show/hide secret ──────────────────────────────────────────────
const showSecret    = ref(false);
const showKeyInList = ref<Record<number, boolean>>({});

function toggleKey(id: number) {
    showKeyInList.value[id] = !showKeyInList.value[id];
}

function maskedKey(key: string): string {
    return key.slice(0, 8) + '••••••••••••••••••••';
}

// ── Copy helper ───────────────────────────────────────────────────
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
    const line1 = 'curl ' + props.appUrl + '/api/images \\';
    const line2 = '  -H "X-API-Key: ik_your_key_here" \\';
    const line3 = '  -H "X-API-Secret: is_your_secret_here"';
    copy(line1 + '\n' + line2 + '\n' + line3, 'curl');
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

            <!-- Header -->
            <div class="flex items-start justify-between gap-4">
                <div>
                    <h1 class="text-2xl font-bold tracking-tight">API Credentials</h1>
                    <p class="mt-1 text-sm text-muted-foreground max-w-lg">
                        Generate an API key &amp; secret to use Iris from your own apps or websites.
                        Authenticate requests with
                        <code class="rounded bg-muted px-1 text-xs text-foreground">X-API-Key</code>
                        and
                        <code class="rounded bg-muted px-1 text-xs text-foreground">X-API-Secret</code>
                        headers.
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

            <!-- New credential reveal -->
            <div v-if="newKey && newSecret" class="rounded-2xl border border-emerald-500/30 bg-emerald-500/10 p-6 space-y-5">
                <div class="flex items-center justify-between">
                    <p class="text-sm font-semibold text-emerald-400">
                        ✓ Credentials generated — save them now. The secret will never be shown again.
                    </p>
                    <button
                        @click="copyPair"
                        class="rounded-lg px-3 py-1.5 text-xs font-semibold transition-colors"
                        :class="copiedId === 'pair' ? 'bg-emerald-500/20 text-emerald-400' : 'bg-muted text-muted-foreground hover:text-foreground'"
                    >{{ copiedId === 'pair' ? '✓ Copied both' : 'Copy both' }}</button>
                </div>

                <!-- API Key -->
                <div class="space-y-1.5">
                    <label class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">API Key</label>
                    <div class="flex items-center gap-3 rounded-xl border border-border bg-background px-4 py-3">
                        <code class="flex-1 text-sm font-mono text-foreground select-all break-all">{{ newKey }}</code>
                        <button
                            @click="copy(newKey, 'key')"
                            class="shrink-0 rounded-lg px-3 py-1.5 text-xs font-semibold transition-colors"
                            :class="copiedId === 'key' ? 'bg-emerald-500/20 text-emerald-400' : 'bg-muted text-muted-foreground hover:text-foreground'"
                        >{{ copiedId === 'key' ? '✓ Copied' : 'Copy' }}</button>
                    </div>
                </div>

                <!-- API Secret -->
                <div class="space-y-1.5">
                    <div class="flex items-center justify-between">
                        <label class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">API Secret</label>
                        <button
                            @click="showSecret = !showSecret"
                            class="text-xs text-muted-foreground hover:text-foreground transition-colors"
                        >{{ showSecret ? '🙈 Hide' : '👁 Reveal' }}</button>
                    </div>
                    <div class="flex items-center gap-3 rounded-xl border border-amber-500/30 bg-amber-500/5 px-4 py-3">
                        <code class="flex-1 text-sm font-mono text-amber-300 select-all break-all">
                            {{ showSecret ? newSecret : newSecret.slice(0, 8) + '••••••••••••••••••••••••••••••' }}
                        </code>
                        <button
                            @click="copy(newSecret, 'secret')"
                            class="shrink-0 rounded-lg px-3 py-1.5 text-xs font-semibold transition-colors"
                            :class="copiedId === 'secret' ? 'bg-emerald-500/20 text-emerald-400' : 'bg-amber-500/10 text-amber-400 hover:bg-amber-500/20'"
                        >{{ copiedId === 'secret' ? '✓ Copied' : 'Copy' }}</button>
                    </div>
                    <p class="text-xs text-amber-400">⚠ Store this secret securely. It cannot be recovered — only regenerated.</p>
                </div>

                <!-- .env snippet -->
                <div class="space-y-1.5">
                    <label class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">.env snippet</label>
                    <div class="relative rounded-xl border border-border bg-muted/60 p-4">
                        <pre class="text-xs font-mono text-foreground whitespace-pre-wrap break-all">IRIS_API_KEY={{ newKey }}
IRIS_API_SECRET={{ showSecret ? newSecret : '••••••••••••••••••••' }}
IRIS_API_URL={{ appUrl }}</pre>
                        <button
                            @click="copyEnv"
                            class="absolute top-3 right-3 rounded-lg px-2.5 py-1 text-xs font-semibold transition-colors border border-border"
                            :class="copiedId === 'env' ? 'bg-emerald-500/15 text-emerald-400' : 'bg-background text-muted-foreground hover:text-foreground'"
                        >{{ copiedId === 'env' ? '✓ Copied' : 'Copy .env' }}</button>
                    </div>
                </div>
            </div>

            <!-- Create form -->
            <div v-if="showCreate" class="rounded-2xl border border-white/8 bg-card p-6 space-y-4">
                <h2 class="text-base font-semibold">Generate new credential</h2>
                <div class="space-y-1">
                    <label class="text-xs font-medium text-muted-foreground uppercase tracking-wider">Label</label>
                    <input
                        v-model="form.label"
                        type="text"
                        placeholder="e.g. My Portfolio, Client Site…"
                        class="w-full rounded-xl border border-border bg-background px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-violet-500/50"
                    />
                    <p v-if="form.errors.label" class="text-xs text-rose-400">{{ form.errors.label }}</p>
                </div>
                <div class="flex gap-3">
                    <button
                        @click="submit"
                        :disabled="form.processing || !form.label.trim()"
                        class="rounded-xl bg-gradient-to-r from-violet-500 to-cyan-400 px-5 py-2 text-sm font-semibold text-white hover:opacity-90 disabled:opacity-50"
                    >{{ form.processing ? 'Generating…' : 'Generate' }}</button>
                    <button
                        @click="showCreate = false; form.reset()"
                        class="rounded-xl border border-border px-5 py-2 text-sm font-medium text-muted-foreground hover:text-foreground"
                    >Cancel</button>
                </div>
            </div>

            <!-- Credentials list -->
            <div class="rounded-2xl border border-white/8 bg-card overflow-hidden">
                <div class="px-6 py-4 border-b border-border">
                    <h2 class="text-sm font-semibold">
                        Your credentials
                        <span class="ml-2 rounded-full bg-muted px-2 py-0.5 text-xs text-muted-foreground">{{ credentials.length }} / 5</span>
                    </h2>
                </div>

                <div v-if="credentials.length === 0" class="flex flex-col items-center justify-center py-16 text-center">
                    <div class="mb-3 text-3xl">🔐</div>
                    <p class="text-sm font-medium">No credentials yet</p>
                    <p class="text-xs text-muted-foreground mt-1">Generate one above to start integrating Iris.</p>
                </div>

                <ul v-else class="divide-y divide-border">
                    <li
                        v-for="cred in credentials"
                        :key="cred.id"
                        class="flex items-center gap-4 px-6 py-4 hover:bg-muted/20 transition-colors"
                    >
                        <div class="flex h-9 w-9 shrink-0 items-center justify-center rounded-xl bg-violet-500/15 text-lg">🔐</div>
                        <div class="flex-1 min-w-0">
                            <p class="text-sm font-semibold">{{ cred.label }}</p>
                            <div class="flex flex-wrap items-center gap-2 mt-0.5">
                                <code class="text-xs font-mono text-muted-foreground">
                                    {{ showKeyInList[cred.id] ? cred.api_key : maskedKey(cred.api_key) }}
                                </code>
                                <button
                                    @click="toggleKey(cred.id)"
                                    class="text-[10px] text-muted-foreground hover:text-foreground"
                                >{{ showKeyInList[cred.id] ? 'hide' : 'reveal' }}</button>
                                <button
                                    @click="copy(cred.api_key, 'list_' + cred.id)"
                                    class="text-[10px] text-violet-400 hover:text-violet-300"
                                >{{ copiedId === 'list_' + cred.id ? '✓ copied' : 'copy key' }}</button>
                            </div>
                            <p class="text-xs text-muted-foreground mt-0.5">
                                Created {{ cred.created_at }}
                                <span v-if="cred.last_used_at"> · Last used {{ cred.last_used_at }}</span>
                            </p>
                        </div>
                        <button
                            @click="remove(cred.id)"
                            class="shrink-0 rounded-lg border border-rose-500/20 bg-rose-500/10 px-3 py-1.5 text-xs font-semibold text-rose-400 hover:bg-rose-500/20"
                        >Delete</button>
                    </li>
                </ul>
            </div>

            <!-- Usage examples -->
            <div class="rounded-2xl border border-white/8 bg-card p-6 space-y-4">
                <h3 class="text-sm font-semibold">How to use</h3>
                <div class="space-y-3 text-xs">
                    <div>
                        <p class="text-muted-foreground mb-1.5 font-medium">cURL</p>
                        <div class="relative rounded-xl bg-muted/60 border border-border p-4">
                            <pre class="font-mono text-foreground whitespace-pre-wrap break-all">curl {{ appUrl }}/api/images \
  -H "X-API-Key: ik_your_key_here" \
  -H "X-API-Secret: is_your_secret_here"</pre>
                            <button
                                @click="copyCurl"
                                class="absolute top-3 right-3 rounded-lg px-2.5 py-1 text-xs font-semibold bg-background border border-border transition-colors"
                                :class="copiedId === 'curl' ? 'text-emerald-400' : 'text-muted-foreground hover:text-foreground'"
                            >{{ copiedId === 'curl' ? '✓' : 'Copy' }}</button>
                        </div>
                    </div>

                    <div>
                        <p class="text-muted-foreground mb-1.5 font-medium">JavaScript / fetch</p>
                        <div class="rounded-xl bg-muted/60 border border-border p-4">
                            <pre class="font-mono text-foreground whitespace-pre-wrap break-all">const res = await fetch('{{ appUrl }}/api/images', {
  headers: {
    'X-API-Key':    process.env.IRIS_API_KEY,
    'X-API-Secret': process.env.IRIS_API_SECRET,
  }
});
const { data } = await res.json();</pre>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </AppLayout>
</template>