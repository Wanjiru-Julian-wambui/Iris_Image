<script setup lang="ts">
import { Head, useForm, usePage } from '@inertiajs/vue3';
import AppLayout from '@/layouts/AppLayout.vue';
import { ref, computed } from 'vue';
import type { BreadcrumbItem } from '@/types';

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Dashboard',  href: '/dashboard' },
    { title: 'API Keys',   href: '/settings/api-keys' },
];

const props = defineProps<{
    tokens: {
        id: number;
        name: string;
        abilities: string[];
        last_used_at: string | null;
        created_at: string;
        expires_at: string | null;
    }[];
}>();

const page     = usePage();
const newToken = computed(() => (page.props.flash as any)?.new_token ?? null);
const copied   = ref(false);

function copyToken() {
    if (!newToken.value) return;
    navigator.clipboard.writeText(newToken.value);
    copied.value = true;
    setTimeout(() => copied.value = false, 2000);
}

// ── Create form ───────────────────────────────────────────────
const showCreate = ref(false);
const form = useForm({
    name:       '',
    abilities:  ['read'] as string[],
    expires_in: '' as string | number,
});

function toggleAbility(a: string) {
    if (form.abilities.includes(a)) {
        form.abilities = form.abilities.filter(x => x !== a);
    } else {
        form.abilities.push(a);
    }
}

function submit() {
    form.post('/settings/api-keys', {
        preserveScroll: true,
        onSuccess: () => {
            form.reset();
            showCreate.value = false;
        },
    });
}

// ── Revoke ────────────────────────────────────────────────────
const revokeForm   = useForm({});
const revokeAllForm = useForm({});

function revoke(id: number) {
    if (!confirm('Revoke this key?')) return;
    revokeForm.delete(`/settings/api-keys/${id}`, { preserveScroll: true });
}

function revokeAll() {
    if (!confirm('Revoke ALL API keys? This cannot be undone.')) return;
    revokeAllForm.delete('/settings/api-keys', { preserveScroll: true });
}

const abilityMeta: Record<string, { label: string; color: string }> = {
    read:   { label: 'Read',   color: 'bg-sky-500/15 text-sky-400 ring-sky-500/20' },
    write:  { label: 'Write',  color: 'bg-violet-500/15 text-violet-400 ring-violet-500/20' },
    delete: { label: 'Delete', color: 'bg-rose-500/15 text-rose-400 ring-rose-500/20' },
};
</script>

<template>
    <Head title="API Keys" />

    <AppLayout :breadcrumbs="breadcrumbs">
        <div class="mx-auto max-w-3xl px-4 py-10 space-y-8">

            <!-- ── Header ──────────────────────────────────────── -->
            <div class="flex items-start justify-between gap-4">
                <div>
                    <h1 class="text-2xl font-bold tracking-tight text-foreground">API Keys</h1>
                    <p class="mt-1 text-sm text-muted-foreground max-w-lg">
                        Use personal access tokens to authenticate API requests.
                        Send them as <code class="rounded bg-muted px-1 py-0.5 text-xs font-mono text-foreground">Authorization: Bearer &lt;token&gt;</code>.
                    </p>
                </div>
                <button
                    v-if="!showCreate"
                    @click="showCreate = true"
                    class="shrink-0 rounded-xl bg-gradient-to-r from-violet-500 to-cyan-400 px-4 py-2 text-sm font-semibold text-white hover:opacity-90 transition-opacity"
                >
                    + New key
                </button>
            </div>

            <!-- ── New token banner ────────────────────────────── -->
            <div
                v-if="newToken"
                class="rounded-2xl border border-emerald-500/30 bg-emerald-500/10 p-5 space-y-3"
            >
                <div class="flex items-center gap-2">
                    <span class="text-emerald-400 text-lg">✓</span>
                    <p class="text-sm font-semibold text-emerald-400">Token created — copy it now, it won't be shown again.</p>
                </div>
                <div class="flex items-center gap-3 rounded-xl bg-background/60 border border-border px-4 py-3">
                    <code class="flex-1 truncate text-xs font-mono text-foreground select-all">{{ newToken }}</code>
                    <button
                        @click="copyToken"
                        class="shrink-0 rounded-lg bg-emerald-500/20 px-3 py-1.5 text-xs font-semibold text-emerald-400 hover:bg-emerald-500/30 transition-colors"
                    >
                        {{ copied ? 'Copied!' : 'Copy' }}
                    </button>
                </div>
            </div>

            <!-- ── Create form ─────────────────────────────────── -->
            <div
                v-if="showCreate"
                class="rounded-2xl border border-white/8 bg-card p-6 space-y-5"
            >
                <h2 class="text-base font-semibold text-foreground">Create new API key</h2>

                <div class="space-y-1">
                    <label class="text-xs font-medium text-muted-foreground uppercase tracking-wider">Key name</label>
                    <input
                        v-model="form.name"
                        type="text"
                        placeholder="e.g. My App, CI/CD Pipeline…"
                        class="w-full rounded-xl border border-border bg-background px-4 py-2.5 text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-violet-500/50"
                    />
                    <p v-if="form.errors.name" class="text-xs text-rose-400">{{ form.errors.name }}</p>
                </div>

                <div class="space-y-2">
                    <label class="text-xs font-medium text-muted-foreground uppercase tracking-wider">Permissions</label>
                    <div class="flex flex-wrap gap-2">
                        <button
                            v-for="(meta, ability) in abilityMeta"
                            :key="ability"
                            type="button"
                            @click="toggleAbility(ability)"
                            :class="[
                                'rounded-lg px-3 py-1.5 text-xs font-semibold ring-1 transition-all',
                                form.abilities.includes(ability)
                                    ? meta.color
                                    : 'bg-muted text-muted-foreground ring-border hover:ring-border/80',
                            ]"
                        >
                            {{ meta.label }}
                        </button>
                    </div>
                </div>

                <div class="space-y-1">
                    <label class="text-xs font-medium text-muted-foreground uppercase tracking-wider">
                        Expiry (days) <span class="normal-case text-muted-foreground/60">— leave blank for no expiry</span>
                    </label>
                    <input
                        v-model="form.expires_in"
                        type="number"
                        min="1"
                        max="365"
                        placeholder="e.g. 30, 90, 365"
                        class="w-full rounded-xl border border-border bg-background px-4 py-2.5 text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-violet-500/50"
                    />
                </div>

                <div class="flex gap-3 pt-1">
                    <button
                        @click="submit"
                        :disabled="form.processing || !form.name.trim()"
                        class="rounded-xl bg-gradient-to-r from-violet-500 to-cyan-400 px-5 py-2 text-sm font-semibold text-white hover:opacity-90 transition-opacity disabled:opacity-50"
                    >
                        {{ form.processing ? 'Creating…' : 'Create key' }}
                    </button>
                    <button
                        @click="showCreate = false; form.reset()"
                        class="rounded-xl border border-border px-5 py-2 text-sm font-medium text-muted-foreground hover:text-foreground transition-colors"
                    >
                        Cancel
                    </button>
                </div>
            </div>

            <!-- ── Token list ───────────────────────────────────── -->
            <div class="rounded-2xl border border-white/8 bg-card overflow-hidden">
                <div class="flex items-center justify-between px-6 py-4 border-b border-border">
                    <h2 class="text-sm font-semibold text-foreground">
                        Active keys
                        <span class="ml-2 rounded-full bg-muted px-2 py-0.5 text-xs text-muted-foreground">{{ tokens.length }}</span>
                    </h2>
                    <button
                        v-if="tokens.length > 1"
                        @click="revokeAll"
                        :disabled="revokeAllForm.processing"
                        class="text-xs font-medium text-rose-400 hover:text-rose-300 transition-colors"
                    >
                        Revoke all
                    </button>
                </div>

                <!-- Empty -->
                <div v-if="tokens.length === 0" class="flex flex-col items-center justify-center py-16 text-center">
                    <div class="mb-3 flex h-12 w-12 items-center justify-center rounded-2xl bg-muted text-2xl">🔑</div>
                    <p class="text-sm font-medium text-foreground">No API keys yet</p>
                    <p class="text-xs text-muted-foreground mt-1">Create one above to start using the API.</p>
                </div>

                <!-- Rows -->
                <ul v-else class="divide-y divide-border">
                    <li
                        v-for="token in tokens"
                        :key="token.id"
                        class="flex items-center gap-4 px-6 py-4 hover:bg-muted/30 transition-colors"
                    >
                        <div class="flex h-9 w-9 shrink-0 items-center justify-center rounded-xl bg-violet-500/15 text-violet-400">
                            🔑
                        </div>
                        <div class="flex-1 min-w-0">
                            <p class="text-sm font-semibold text-foreground truncate">{{ token.name }}</p>
                            <div class="mt-1 flex flex-wrap items-center gap-1.5">
                                <span
                                    v-for="a in token.abilities"
                                    :key="a"
                                    :class="['rounded-md px-1.5 py-0.5 text-[10px] font-semibold ring-1', abilityMeta[a]?.color ?? 'bg-muted text-muted-foreground ring-border']"
                                >
                                    {{ abilityMeta[a]?.label ?? a }}
                                </span>
                                <span class="text-xs text-muted-foreground">
                                    Created {{ token.created_at }}
                                </span>
                                <span v-if="token.last_used_at" class="text-xs text-muted-foreground">
                                    · Last used {{ token.last_used_at }}
                                </span>
                                <span v-if="token.expires_at" class="text-xs text-amber-400">
                                    · Expires {{ token.expires_at }}
                                </span>
                            </div>
                        </div>
                        <button
                            @click="revoke(token.id)"
                            :disabled="revokeForm.processing"
                            class="shrink-0 rounded-lg border border-rose-500/20 bg-rose-500/10 px-3 py-1.5 text-xs font-semibold text-rose-400 hover:bg-rose-500/20 transition-colors"
                        >
                            Revoke
                        </button>
                    </li>
                </ul>
            </div>

            <!-- ── Docs hint ─────────────────────────────────────── -->
            <div class="rounded-2xl border border-white/8 bg-card p-6">
                <h3 class="text-sm font-semibold text-foreground mb-3">Quick reference</h3>
                <div class="space-y-2 text-xs font-mono text-muted-foreground">
                    <div class="rounded-lg bg-muted/60 px-4 py-2.5">
                        <span class="text-violet-400">GET</span>  /api/images
                    </div>
                    <div class="rounded-lg bg-muted/60 px-4 py-2.5">
                        <span class="text-emerald-400">POST</span> /api/images
                    </div>
                    <div class="rounded-lg bg-muted/60 px-4 py-2.5">
                        <span class="text-rose-400">DELETE</span> /api/images/{id}
                    </div>
                    <div class="rounded-lg bg-muted/60 px-4 py-2.5">
                        <span class="text-violet-400">GET</span>  /api/shared-links
                    </div>
                    <div class="rounded-lg bg-muted/60 px-4 py-2.5">
                        <span class="text-emerald-400">POST</span> /api/auth/login  <span class="text-muted-foreground/50"># returns token</span>
                    </div>
                </div>
                <p class="mt-3 text-xs text-muted-foreground">
                    Send your token as <code class="rounded bg-muted px-1 py-0.5 text-foreground">Authorization: Bearer &lt;token&gt;</code> on every request.
                </p>
            </div>

        </div>
    </AppLayout>
</template>