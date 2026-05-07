<script setup lang="ts">
import { Head, router, useForm, usePage } from '@inertiajs/vue3';
import {
    CheckCircle2, ChevronDown, ChevronUp, Eye, Loader2,
    Mail, RefreshCw, RotateCcw, Save,
} from 'lucide-vue-next';
import { computed, ref } from 'vue';
import AppLayout from '@/layouts/AppLayout.vue';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import {
    Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle,
} from '@/components/ui/dialog';
import type { BreadcrumbItem } from '@/types';

// ─── Types ───────────────────────────────────────────────────────────────────

interface EmailTemplate {
    id:        number;
    key:       string;
    subject:   string;
    html_body: string;
    text_body: string;
    variables: string[];
}

// ─── Props / Flash ────────────────────────────────────────────────────────────

const props = defineProps<{
    templates: EmailTemplate[];
}>();

const page         = usePage();
const flashSuccess = computed(() => (page.props.flash as any)?.success ?? null);

// ─── Breadcrumbs ─────────────────────────────────────────────────────────────

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Dashboard',        href: '/dashboard'               },
    { title: 'Admin',            href: '/admin'                   },
    { title: 'Email Templates',  href: '/admin/email-templates'   },
];

// ─── Editing state ────────────────────────────────────────────────────────────

const activeKey      = ref<string | null>(null);
const expandedKeys   = ref<Set<string>>(new Set());

function toggleExpand(key: string) {
    activeKey.value = activeKey.value === key ? null : key;
}

function isOpen(key: string) {
    return activeKey.value === key;
}

// Per-template forms
const forms = Object.fromEntries(
    props.templates.map(t => [
        t.key,
        useForm({
            subject:   t.subject,
            html_body: t.html_body,
            text_body: t.text_body,
        }),
    ])
);

function saveTemplate(template: EmailTemplate) {
    forms[template.key].put(`/admin/email-templates/${template.id}`, {
        preserveScroll: true,
    });
}

// ─── Reset ────────────────────────────────────────────────────────────────────

const confirmReset     = ref<EmailTemplate | null>(null);
const resetting        = ref(false);

function doReset() {
    if (! confirmReset.value) return;
    resetting.value = true;
    router.post(`/admin/email-templates/${confirmReset.value.id}/reset`, {}, {
        preserveScroll: true,
        onFinish: () => { resetting.value = false; confirmReset.value = null; },
        onSuccess: () => {
            // Refresh the page data so fields update
            router.reload({ only: ['templates'] });
        },
    });
}

// ─── Preview ──────────────────────────────────────────────────────────────────

function openPreview(template: EmailTemplate) {
    window.open(`/admin/email-templates/${template.id}/preview`, '_blank');
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

const keyLabels: Record<string, string> = {
    invite:        'Invitation Email',
    digest:        'Weekly Link Digest',
    quota_warning: 'Storage Quota Warning',
};

const keyDescriptions: Record<string, string> = {
    invite:        'Sent when a user is invited to the platform.',
    digest:        'Sent every Monday with a summary of shared link activity.',
    quota_warning: 'Sent when a user\'s storage crosses 70% or 90%.',
};

function insertVariable(key: string, field: 'subject' | 'html_body' | 'text_body', variable: string) {
    const form = forms[key];
    form[field] = (form[field] ?? '') + variable;
}
</script>

<template>
    <AppLayout :breadcrumbs="breadcrumbs">
        <Head title="Email Templates" />

        <div class="max-w-4xl mx-auto px-4 py-8 space-y-6">

            <!-- Header -->
            <div>
                <h1 class="text-2xl font-semibold flex items-center gap-2">
                    <Mail class="h-6 w-6" /> Email Templates
                </h1>
                <p class="text-sm text-muted-foreground mt-1">
                    Customise the system emails sent from Iris. Use <code class="font-mono text-xs">&#123;&#123;variable&#125;&#125;</code> placeholders — they're replaced at send time.
                </p>
            </div>

            <!-- Flash success -->
            <div
                v-if="flashSuccess"
                class="flex items-center gap-2 rounded-md border border-green-200 bg-green-50 px-4 py-3 text-sm text-green-800 dark:border-green-800 dark:bg-green-950 dark:text-green-300"
            >
                <CheckCircle2 class="h-4 w-4 shrink-0" />
                {{ flashSuccess }}
            </div>

            <!-- Template accordion -->
            <div class="space-y-3">
                <div
                    v-for="template in templates"
                    :key="template.key"
                    class="rounded-xl border bg-card shadow-sm overflow-hidden"
                >
                    <!-- Accordion header -->
                    <button
                        class="w-full flex items-center justify-between px-5 py-4 text-left hover:bg-muted/40 transition-colors"
                        @click="toggleExpand(template.key)"
                    >
                        <div>
                            <div class="flex items-center gap-2">
                                <span class="font-medium">{{ keyLabels[template.key] ?? template.key }}</span>
                                <Badge variant="outline" class="text-xs font-mono">{{ template.key }}</Badge>
                            </div>
                            <p class="text-xs text-muted-foreground mt-0.5">
                                {{ keyDescriptions[template.key] ?? '' }}
                            </p>
                        </div>
                        <ChevronDown v-if="!isOpen(template.key)" class="h-4 w-4 text-muted-foreground shrink-0" />
                        <ChevronUp   v-else                       class="h-4 w-4 text-muted-foreground shrink-0" />
                    </button>

                    <!-- Accordion body -->
                    <div v-if="isOpen(template.key)" class="border-t px-5 py-5 space-y-5">

                        <!-- Available variables -->
                        <div>
                            <p class="text-xs font-medium text-muted-foreground mb-2">Available variables — click to insert</p>
                            <div class="flex flex-wrap gap-1.5">
                                <button
                                    v-for="variable in template.variables"
                                    :key="variable"
                                    class="rounded bg-muted hover:bg-primary/10 border px-2 py-0.5 text-xs font-mono transition-colors"
                                    @click="insertVariable(template.key, 'html_body', variable)"
                                >
                                    {{ variable }}
                                </button>
                            </div>
                        </div>

                        <!-- Subject -->
                        <div class="space-y-1.5">
                            <Label :for="`${template.key}-subject`">Subject line</Label>
                            <Input
                                :id="`${template.key}-subject`"
                                v-model="forms[template.key].subject"
                                placeholder="Email subject"
                            />
                            <p v-if="forms[template.key].errors.subject" class="text-xs text-destructive">
                                {{ forms[template.key].errors.subject }}
                            </p>
                        </div>

                        <!-- HTML body -->
                        <div class="space-y-1.5">
                            <div class="flex items-center justify-between">
                                <Label :for="`${template.key}-html`">HTML body</Label>
                                <Button
                                    size="sm"
                                    variant="ghost"
                                    class="h-6 text-xs gap-1"
                                    @click="openPreview(template)"
                                >
                                    <Eye class="h-3 w-3" /> Preview
                                </Button>
                            </div>
                            <textarea
                                :id="`${template.key}-html`"
                                v-model="forms[template.key].html_body"
                                rows="10"
                                class="w-full rounded-md border bg-background px-3 py-2 text-sm font-mono shadow-sm focus:outline-none focus:ring-2 focus:ring-ring resize-y"
                                placeholder="<p>Hi {{user_name}},</p>"
                            />
                            <p v-if="forms[template.key].errors.html_body" class="text-xs text-destructive">
                                {{ forms[template.key].errors.html_body }}
                            </p>
                        </div>

                        <!-- Plain text body -->
                        <div class="space-y-1.5">
                            <Label :for="`${template.key}-text`">Plain text body</Label>
                            <textarea
                                :id="`${template.key}-text`"
                                v-model="forms[template.key].text_body"
                                rows="6"
                                class="w-full rounded-md border bg-background px-3 py-2 text-sm font-mono shadow-sm focus:outline-none focus:ring-2 focus:ring-ring resize-y"
                                placeholder="Hi {{user_name}}, ..."
                            />
                            <p v-if="forms[template.key].errors.text_body" class="text-xs text-destructive">
                                {{ forms[template.key].errors.text_body }}
                            </p>
                        </div>

                        <!-- Footer actions -->
                        <div class="flex items-center justify-between pt-1">
                            <Button
                                variant="ghost"
                                size="sm"
                                class="text-muted-foreground gap-1.5"
                                @click="confirmReset = template"
                            >
                                <RotateCcw class="h-3.5 w-3.5" />
                                Reset to default
                            </Button>

                            <Button
                                :disabled="forms[template.key].processing"
                                @click="saveTemplate(template)"
                            >
                                <Loader2
                                    v-if="forms[template.key].processing"
                                    class="h-4 w-4 mr-1.5 animate-spin"
                                />
                                <Save v-else class="h-4 w-4 mr-1.5" />
                                Save Template
                            </Button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Helper note -->
            <div class="rounded-xl border bg-muted/40 px-5 py-4 text-sm">
                <p class="font-medium mb-1">How variables work</p>
                <p class="text-xs text-muted-foreground leading-relaxed">
                    Variables like <code class="font-mono">&#123;&#123;user_name&#125;&#125;</code> are replaced with real values at send time.
                    They work in the subject line, HTML body, and plain text body. Unrecognised placeholders are left as-is.
                </p>
            </div>
        </div>

        <!-- ── Reset confirmation dialog ────────────────────────────────────── -->
        <Dialog :open="!!confirmReset" @update:open="confirmReset = null">
            <DialogContent class="sm:max-w-sm">
                <DialogHeader>
                    <DialogTitle>Reset to Default?</DialogTitle>
                    <DialogDescription>
                        The <strong>{{ keyLabels[confirmReset?.key ?? ''] ?? confirmReset?.key }}</strong> template
                        will be restored to the system default. Your edits will be lost.
                    </DialogDescription>
                </DialogHeader>
                <DialogFooter>
                    <Button variant="outline" @click="confirmReset = null">Cancel</Button>
                    <Button
                        variant="destructive"
                        :disabled="resetting"
                        @click="doReset"
                    >
                        <Loader2 v-if="resetting" class="h-4 w-4 mr-1 animate-spin" />
                        Reset
                    </Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>
    </AppLayout>
</template>