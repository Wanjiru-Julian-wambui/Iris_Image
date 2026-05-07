<script setup lang="ts">
import { Head, router, useForm, usePage } from '@inertiajs/vue3';
import {
    Activity, AlertCircle, CheckCircle2, ChevronDown, ChevronUp,
    Copy, Eye, EyeOff, Loader2, Plus, RefreshCw, Shield, Trash2,
    Webhook, X, Zap,
} from 'lucide-vue-next';
import { computed, ref } from 'vue';
import AppLayout from '@/layouts/AppLayout.vue';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Switch } from '@/components/ui/switch';
import {
    Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle,
} from '@/components/ui/dialog';
import type { BreadcrumbItem } from '@/types';

// ─── Types ───────────────────────────────────────────────────────────────────

interface Delivery {
    id:              number;
    event:           string;
    response_status: number | null;
    duration_ms:     number | null;
    attempt:         number;
    succeeded:       boolean;
    fired_at:        string;
}

interface WebhookItem {
    id:            number;
    name:          string;
    url:           string;
    events:        string[];
    active:        boolean;
    source:        string;
    last_fired_at: string | null;
    last_status:   string | null;
    failure_count: number;
    created_at:    string;
    deliveries:    Delivery[];
}

interface AvailableEvent {
    value: string;
    label: string;
}

// ─── Props ───────────────────────────────────────────────────────────────────

const props = defineProps<{
    webhooks:        WebhookItem[];
    availableEvents: AvailableEvent[];
}>();

// ─── Flash / page ────────────────────────────────────────────────────────────

const page          = usePage();
const flashSecret   = computed(() => (page.props.flash as any)?.webhook_secret ?? null);
const flashSuccess  = computed(() => (page.props.flash as any)?.success ?? null);

// ─── Breadcrumbs ─────────────────────────────────────────────────────────────

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Dashboard', href: '/dashboard'          },
    { title: 'Webhooks',  href: '/settings/webhooks'  },
];

// ─── Create / Edit form ───────────────────────────────────────────────────────

const showCreateDialog = ref(false);
const editingWebhook   = ref<WebhookItem | null>(null);

const form = useForm({
    name:   '',
    url:    '',
    events: [] as string[],
    active: true,
});

function openCreate() {
    form.reset();
    form.events = [];
    editingWebhook.value   = null;
    showCreateDialog.value = true;
}

function openEdit(wh: WebhookItem) {
    form.name   = wh.name;
    form.url    = wh.url;
    form.events = [...wh.events];
    form.active = wh.active;
    editingWebhook.value   = wh;
    showCreateDialog.value = true;
}

function closeDialog() {
    showCreateDialog.value = false;
    editingWebhook.value   = null;
    form.reset();
}

function toggleEvent(value: string) {
    const idx = form.events.indexOf(value);
    if (idx === -1) {
        // If selecting '*', clear others; if selecting specific, remove '*'
        if (value === '*') {
            form.events = ['*'];
        } else {
            form.events = form.events.filter(e => e !== '*');
            form.events.push(value);
        }
    } else {
        form.events.splice(idx, 1);
    }
}

function submitForm() {
    if (editingWebhook.value) {
        form.put(`/settings/webhooks/${editingWebhook.value.id}`, {
            onSuccess: () => closeDialog(),
        });
    } else {
        form.post('/settings/webhooks', {
            onSuccess: () => closeDialog(),
        });
    }
}

// ─── Delete ──────────────────────────────────────────────────────────────────

const confirmDelete   = ref<WebhookItem | null>(null);
const deleting        = ref(false);

function deleteWebhook() {
    if (! confirmDelete.value) return;
    deleting.value = true;
    router.delete(`/settings/webhooks/${confirmDelete.value.id}`, {
        onFinish: () => { deleting.value = false; confirmDelete.value = null; },
    });
}

// ─── Toggle active ───────────────────────────────────────────────────────────

function toggleActive(wh: WebhookItem) {
    router.post(`/settings/webhooks/${wh.id}/toggle`);
}

// ─── Regenerate secret ───────────────────────────────────────────────────────

const regenerating      = ref<number | null>(null);
const shownSecret       = ref<string | null>(null);
const shownSecretCopied = ref(false);

function regenerateSecret(wh: WebhookItem) {
    regenerating.value = wh.id;
    router.post(`/settings/webhooks/${wh.id}/regenerate-secret`, {}, {
        onFinish: () => { regenerating.value = null; },
    });
}

function copySecret(secret: string) {
    navigator.clipboard.writeText(secret);
    shownSecretCopied.value = true;
    setTimeout(() => { shownSecretCopied.value = false; }, 2000);
}

// ─── Delivery history expansion ───────────────────────────────────────────────

const expandedDeliveries = ref<Set<number>>(new Set());

function toggleDeliveries(id: number) {
    const next = new Set(expandedDeliveries.value);
    next.has(id) ? next.delete(id) : next.add(id);
    expandedDeliveries.value = next;
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

function eventLabel(value: string): string {
    return props.availableEvents.find(e => e.value === value)?.label ?? value;
}

function statusColor(status: string | null): string {
    if (status === 'success') return 'text-green-600';
    if (status === 'failed')  return 'text-red-500';
    return 'text-muted-foreground';
}

function httpStatusColor(status: number | null): string {
    if (! status)          return 'text-muted-foreground';
    if (status < 300)      return 'text-green-600';
    if (status < 500)      return 'text-yellow-600';
    return 'text-red-500';
}
</script>

<template>
    <AppLayout :breadcrumbs="breadcrumbs">
        <Head title="Webhooks" />

        <div class="max-w-4xl mx-auto px-4 py-8 space-y-6">

            <!-- Header -->
            <div class="flex items-center justify-between">
                <div>
                    <h1 class="text-2xl font-semibold flex items-center gap-2">
                        <Webhook class="h-6 w-6" /> Webhooks
                    </h1>
                    <p class="text-sm text-muted-foreground mt-1">
                        Receive HTTP POST notifications when events happen in your account.
                    </p>
                </div>
                <Button @click="openCreate">
                    <Plus class="h-4 w-4 mr-1" /> Add Webhook
                </Button>
            </div>

            <!-- Flash success -->
            <div
                v-if="flashSuccess && !flashSecret"
                class="flex items-center gap-2 rounded-md border border-green-200 bg-green-50 px-4 py-3 text-sm text-green-800 dark:border-green-800 dark:bg-green-950 dark:text-green-300"
            >
                <CheckCircle2 class="h-4 w-4 shrink-0" />
                {{ flashSuccess }}
            </div>

            <!-- New webhook secret banner -->
            <div
                v-if="flashSecret"
                class="rounded-md border border-yellow-200 bg-yellow-50 px-4 py-4 dark:border-yellow-800 dark:bg-yellow-950"
            >
                <div class="flex items-start gap-3">
                    <Shield class="h-5 w-5 text-yellow-600 dark:text-yellow-400 shrink-0 mt-0.5" />
                    <div class="flex-1 min-w-0">
                        <p class="text-sm font-semibold text-yellow-800 dark:text-yellow-300">
                            Save your webhook secret — it won't be shown again
                        </p>
                        <p class="text-xs text-yellow-700 dark:text-yellow-400 mt-1">
                            Use this to verify that requests come from Iris (HMAC-SHA256 in the
                            <code class="font-mono">X-Iris-Signature</code> header).
                        </p>
                        <div class="flex items-center gap-2 mt-3">
                            <code class="flex-1 rounded bg-yellow-100 dark:bg-yellow-900 px-3 py-2 text-xs font-mono text-yellow-900 dark:text-yellow-200 break-all">
                                {{ flashSecret }}
                            </code>
                            <Button size="sm" variant="outline" @click="copySecret(flashSecret!)">
                                <Copy class="h-3.5 w-3.5 mr-1" />
                                {{ shownSecretCopied ? 'Copied!' : 'Copy' }}
                            </Button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Empty state -->
            <div
                v-if="webhooks.length === 0"
                class="flex flex-col items-center justify-center rounded-xl border-2 border-dashed py-16 text-center"
            >
                <Zap class="h-10 w-10 text-muted-foreground mb-3" />
                <p class="font-medium">No webhooks yet</p>
                <p class="text-sm text-muted-foreground mt-1">
                    Add a webhook URL to receive real-time event notifications.
                </p>
                <Button class="mt-4" @click="openCreate">
                    <Plus class="h-4 w-4 mr-1" /> Add Webhook
                </Button>
            </div>

            <!-- Webhook cards -->
            <div v-else class="space-y-4">
                <div
                    v-for="wh in webhooks"
                    :key="wh.id"
                    class="rounded-xl border bg-card shadow-sm overflow-hidden"
                >
                    <!-- Card header -->
                    <div class="flex items-start gap-4 px-5 py-4">
                        <!-- Active toggle -->
                        <div class="pt-0.5">
                            <Switch
                                :model-value="wh.active"
                                @update:model-value="toggleActive(wh)"
                            />
                        </div>

                        <!-- Info -->
                        <div class="flex-1 min-w-0">
                            <div class="flex items-center gap-2 flex-wrap">
                                <span class="font-medium truncate">{{ wh.name }}</span>
                                <Badge v-if="wh.source !== 'custom'" variant="secondary" class="text-xs capitalize">
                                    {{ wh.source }}
                                </Badge>
                                <Badge
                                    :variant="wh.active ? 'default' : 'secondary'"
                                    class="text-xs"
                                >
                                    {{ wh.active ? 'Active' : 'Inactive' }}
                                </Badge>
                                <Badge
                                    v-if="wh.last_status"
                                    :class="wh.last_status === 'success'
                                        ? 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-300'
                                        : 'bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-300'"
                                    class="text-xs"
                                >
                                    {{ wh.last_status }}
                                </Badge>
                            </div>

                            <p class="text-xs text-muted-foreground font-mono mt-1 truncate">{{ wh.url }}</p>

                            <div class="flex flex-wrap gap-1.5 mt-2">
                                <Badge
                                    v-for="event in wh.events"
                                    :key="event"
                                    variant="outline"
                                    class="text-xs font-mono"
                                >
                                    {{ event }}
                                </Badge>
                            </div>

                            <div class="flex items-center gap-4 mt-2 text-xs text-muted-foreground">
                                <span v-if="wh.last_fired_at">
                                    <Activity class="h-3 w-3 inline mr-0.5" />
                                    Last fired {{ wh.last_fired_at }}
                                </span>
                                <span v-if="wh.failure_count > 0" class="text-red-500">
                                    <AlertCircle class="h-3 w-3 inline mr-0.5" />
                                    {{ wh.failure_count }} failure{{ wh.failure_count !== 1 ? 's' : '' }}
                                </span>
                                <span>Added {{ wh.created_at }}</span>
                            </div>
                        </div>

                        <!-- Actions -->
                        <div class="flex items-center gap-1 shrink-0">
                            <Button
                                size="sm"
                                variant="ghost"
                                title="Regenerate secret"
                                :disabled="regenerating === wh.id"
                                @click="regenerateSecret(wh)"
                            >
                                <Loader2 v-if="regenerating === wh.id" class="h-4 w-4 animate-spin" />
                                <RefreshCw v-else class="h-4 w-4" />
                            </Button>
                            <Button size="sm" variant="ghost" @click="openEdit(wh)">
                                <Webhook class="h-4 w-4" />
                            </Button>
                            <Button
                                size="sm"
                                variant="ghost"
                                class="text-destructive hover:text-destructive"
                                @click="confirmDelete = wh"
                            >
                                <Trash2 class="h-4 w-4" />
                            </Button>
                        </div>
                    </div>

                    <!-- Delivery history toggle -->
                    <div
                        v-if="wh.deliveries && wh.deliveries.length > 0"
                        class="border-t"
                    >
                        <button
                            class="w-full flex items-center justify-between px-5 py-2.5 text-xs text-muted-foreground hover:bg-muted/50 transition-colors"
                            @click="toggleDeliveries(wh.id)"
                        >
                            <span class="flex items-center gap-1.5">
                                <Activity class="h-3.5 w-3.5" />
                                Recent deliveries ({{ wh.deliveries.length }})
                            </span>
                            <ChevronDown v-if="!expandedDeliveries.has(wh.id)" class="h-3.5 w-3.5" />
                            <ChevronUp   v-else                                class="h-3.5 w-3.5" />
                        </button>

                        <div v-if="expandedDeliveries.has(wh.id)" class="divide-y bg-muted/30">
                            <div
                                v-for="delivery in wh.deliveries"
                                :key="delivery.id"
                                class="flex items-center gap-4 px-5 py-2.5 text-xs"
                            >
                                <CheckCircle2
                                    v-if="delivery.succeeded"
                                    class="h-3.5 w-3.5 text-green-500 shrink-0"
                                />
                                <AlertCircle
                                    v-else
                                    class="h-3.5 w-3.5 text-red-500 shrink-0"
                                />
                                <span class="font-mono text-muted-foreground w-28 shrink-0">{{ delivery.event }}</span>
                                <span :class="httpStatusColor(delivery.response_status)" class="w-12 shrink-0 font-mono">
                                    {{ delivery.response_status ?? '—' }}
                                </span>
                                <span class="text-muted-foreground w-16 shrink-0">
                                    {{ delivery.duration_ms != null ? delivery.duration_ms + 'ms' : '—' }}
                                </span>
                                <span v-if="delivery.attempt > 1" class="text-yellow-600">
                                    attempt {{ delivery.attempt }}
                                </span>
                                <span class="ml-auto text-muted-foreground">{{ delivery.fired_at }}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Docs callout -->
            <div class="rounded-xl border bg-muted/40 px-5 py-4 text-sm">
                <p class="font-medium mb-1">Verifying webhook signatures</p>
                <p class="text-muted-foreground text-xs leading-relaxed">
                    Every request includes an <code class="font-mono">X-Iris-Signature</code> header with an
                    HMAC-SHA256 hash of the raw body signed with your secret.
                    Compute <code class="font-mono">sha256=HMAC(secret, rawBody)</code> and compare — reject requests that don't match.
                </p>
            </div>
        </div>

        <!-- ── Create / Edit dialog ─────────────────────────────────────────── -->
        <Dialog :open="showCreateDialog" @update:open="closeDialog">
            <DialogContent class="sm:max-w-lg">
                <DialogHeader>
                    <DialogTitle>{{ editingWebhook ? 'Edit Webhook' : 'Add Webhook' }}</DialogTitle>
                    <DialogDescription>
                        Iris will POST a signed JSON payload to this URL when the chosen events fire.
                    </DialogDescription>
                </DialogHeader>

                <div class="space-y-4 py-2">
                    <!-- Name -->
                    <div class="space-y-1.5">
                        <Label for="wh-name">Name</Label>
                        <Input
                            id="wh-name"
                            v-model="form.name"
                            placeholder="My deployment hook"
                        />
                        <p v-if="form.errors.name" class="text-xs text-destructive">{{ form.errors.name }}</p>
                    </div>

                    <!-- URL -->
                    <div class="space-y-1.5">
                        <Label for="wh-url">Endpoint URL</Label>
                        <Input
                            id="wh-url"
                            v-model="form.url"
                            type="url"
                            placeholder="https://example.com/webhook"
                        />
                        <p v-if="form.errors.url" class="text-xs text-destructive">{{ form.errors.url }}</p>
                    </div>

                    <!-- Events -->
                    <div class="space-y-2">
                        <Label>Events</Label>
                        <div class="grid grid-cols-2 gap-2">
                            <label
                                v-for="event in availableEvents"
                                :key="event.value"
                                class="flex items-center gap-2.5 rounded-lg border px-3 py-2.5 cursor-pointer hover:bg-muted/50 transition-colors"
                                :class="form.events.includes(event.value) ? 'border-primary bg-primary/5' : ''"
                            >
                                <input
                                    type="checkbox"
                                    class="accent-primary"
                                    :checked="form.events.includes(event.value)"
                                    @change="toggleEvent(event.value)"
                                />
                                <span class="text-sm">{{ event.label }}</span>
                            </label>
                        </div>
                        <p v-if="form.errors.events" class="text-xs text-destructive">{{ form.errors.events }}</p>
                    </div>

                    <!-- Active (edit only) -->
                    <div v-if="editingWebhook" class="flex items-center gap-3">
                        <Switch v-model="form.active" id="wh-active" />
                        <Label for="wh-active">Active</Label>
                    </div>
                </div>

                <DialogFooter>
                    <Button variant="outline" @click="closeDialog">Cancel</Button>
                    <Button
                        :disabled="form.processing || form.events.length === 0"
                        @click="submitForm"
                    >
                        <Loader2 v-if="form.processing" class="h-4 w-4 mr-1 animate-spin" />
                        {{ editingWebhook ? 'Save Changes' : 'Create Webhook' }}
                    </Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>

        <!-- ── Delete confirmation ──────────────────────────────────────────── -->
        <Dialog :open="!!confirmDelete" @update:open="confirmDelete = null">
            <DialogContent class="sm:max-w-sm">
                <DialogHeader>
                    <DialogTitle>Delete Webhook</DialogTitle>
                    <DialogDescription>
                        <strong>{{ confirmDelete?.name }}</strong> will stop receiving events immediately.
                        This cannot be undone.
                    </DialogDescription>
                </DialogHeader>
                <DialogFooter>
                    <Button variant="outline" @click="confirmDelete = null">Cancel</Button>
                    <Button
                        variant="destructive"
                        :disabled="deleting"
                        @click="deleteWebhook"
                    >
                        <Loader2 v-if="deleting" class="h-4 w-4 mr-1 animate-spin" />
                        Delete
                    </Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>
    </AppLayout>
</template>