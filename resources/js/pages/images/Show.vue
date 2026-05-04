<script setup lang="ts">
import { Head, Link, router, useForm } from '@inertiajs/vue3';
import { ArrowLeft, Check, Clock, Code, Copy, Download, Eye, Link2, Lock, Share2, Shield, Trash2, Pencil, MessageSquare, X, Send, Tag, Plus, ChevronDown, ChevronUp, Save, History, Upload, RotateCcw, Archive, FileImage } from 'lucide-vue-next';
import { ref, computed } from 'vue';
import AppLayout from '@/layouts/AppLayout.vue';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import {
    Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle,
} from '@/components/ui/dialog';
import {
    Select, SelectContent, SelectItem, SelectTrigger, SelectValue,
} from '@/components/ui/select';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Switch } from '@/components/ui/switch';
import { useExif } from '@/composables/useExif';
import type { BreadcrumbItem } from '@/types';

const props = defineProps<{
    image: App.ImageResource;
}>();

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Dashboard', href: '/dashboard' },
    { title: 'Images',    href: '/images' },
    { title: props.image.name, href: `/images/${props.image.id}` },
];

// ─── Tabs ───────────────────────────────────────────────────────────────────
type Tab = 'details' | 'versions';
const activeTab = ref<Tab>('details');

// URL / embed copy
type CopyTarget = 'url' | 'html' | 'markdown' | 'bbcode';
const copyStates = ref<Record<CopyTarget, boolean>>({
    url: false, html: false, markdown: false, bbcode: false,
});

const embedCodes = computed(() => ({
    url:      props.image.public_url,
    html:     `<img src="${props.image.public_url}" alt="${props.image.alt_text || props.image.name}" />`,
    markdown: `![${props.image.alt_text || props.image.name}](${props.image.public_url})`,
    bbcode:   `[img]${props.image.public_url}[/img]`,
}));

function copyEmbed(type: CopyTarget) {
    navigator.clipboard.writeText(embedCodes.value[type]);
    copyStates.value[type] = true;
    setTimeout(() => { copyStates.value[type] = false; }, 2000);
}

const embedTypes: { key: CopyTarget; label: string; desc: string }[] = [
    { key: 'url',      label: 'Direct URL',  desc: 'Raw image link'         },
    { key: 'html',     label: 'HTML',        desc: '<img> tag'              },
    { key: 'markdown', label: 'Markdown',    desc: '![alt](url)'            },
    { key: 'bbcode',   label: 'BBCode',      desc: '[img] for forums'       },
];

// Delete
const showDeleteDialog = ref(false);
const deleting         = ref(false);

function deleteImage() {
    deleting.value = true;
    router.delete(`/images/${props.image.id}`, {
        onFinish: () => { deleting.value = false; },
    });
}

// Share
const showShareDialog = ref(false);
const expiresIn       = ref('24');
const sharePassword   = ref('');
const usePassword     = ref(false);
const sharing         = ref(false);
const shareUrl        = ref('');
const shareCopied     = ref(false);

function createShareLink() {
    sharing.value = true;
    router.post('/shared-links', {
        image_id:   props.image.id,
        expires_in: parseInt(expiresIn.value),
        password:   usePassword.value ? sharePassword.value : null,
    }, {
        onSuccess: (page: any) => {
            shareUrl.value = page.props.flash?.share_url ?? '';
            sharing.value  = false;
        },
        onError: () => { sharing.value = false; },
    });
}

function copyShareUrl() {
    navigator.clipboard.writeText(shareUrl.value);
    shareCopied.value = true;
    setTimeout(() => { shareCopied.value = false; }, 2000);
}

// Caption/Alt edit
const editingCaption = ref(false);
const captionForm = useForm({
    caption: props.image.caption ?? '',
    alt_text: props.image.alt_text ?? '',
});

function saveCaption() {
    captionForm.put(`/images/${props.image.id}`, {
        preserveScroll: true,
        onSuccess: () => { editingCaption.value = false; },
    });
}

// ─── Notes (Full CRUD + Collapsible) ────────────────────────────────────────
const notesExpanded = ref(true);
const editingNoteId = ref<number | null>(null);
const editNoteForm = useForm({
    body: '',
});

const noteForm = useForm({
    body: '',
});

function addNote() {
    if (!noteForm.body.trim()) return;
    noteForm.post(`/images/${props.image.id}/notes`, {
        preserveScroll: true,
        onSuccess: () => { noteForm.reset(); },
    });
}

function startEditNote(note: App.ImageNote) {
    editingNoteId.value = note.id;
    editNoteForm.body = note.body;
}

function cancelEditNote() {
    editingNoteId.value = null;
    editNoteForm.reset();
}

function saveNote(noteId: number) {
    editNoteForm.put(`/images/${props.image.id}/notes/${noteId}`, {
        preserveScroll: true,
        onSuccess: () => { editingNoteId.value = null; },
    });
}

function deleteNote(noteId: number) {
    if (!confirm('Delete this note?')) return;
    router.delete(`/images/${props.image.id}/notes/${noteId}`, { preserveScroll: true });
}

// ─── Tags ───────────────────────────────────────────────────────────────────
const showTagInput = ref(false);
const tagInput = ref('');
const addingTag = ref(false);

function addTag() {
    const name = tagInput.value.trim();
    if (!name) return;

    addingTag.value = true;
    router.post('/images/batch-tag', {
        ids: [props.image.id],
        tags: [name],
        action: 'add',
    }, {
        preserveScroll: true,
        onFinish: () => {
            addingTag.value = false;
            tagInput.value = '';
            showTagInput.value = false;
        },
    });
}

function removeTag(tagId: number) {
    const tag = props.image.tags?.find(t => t.id === tagId);
    if (!tag) return;

    router.post('/images/batch-tag', {
        ids: [props.image.id],
        tags: [tag.name],
        action: 'remove',
    }, {
        preserveScroll: true,
    });
}

// ─── Reactions ───────────────────────────────────────────────────────────────
const reactingEmoji  = ref<string | null>(null);
const showPicker     = ref(false);
const pickerSearch   = ref('');
const activeCategory = ref(0);

// reactions prop is { emoji: count } from the server
const reactionEntries = computed<{ emoji: string; count: number }[]>(() => {
    const r = props.image.reactions as Record<string, number> | null | undefined;
    if (!r) return [];
    return Object.entries(r)
        .map(([emoji, count]) => ({ emoji, count }))
        .sort((a, b) => b.count - a.count);
});

function react(emoji: string) {
    if (reactingEmoji.value) return;
    reactingEmoji.value = emoji;
    showPicker.value = false;
    pickerSearch.value = '';
    router.post(`/images/${props.image.id}/reactions`, { emoji }, {
        preserveScroll: true,
        onFinish: () => { reactingEmoji.value = null; },
    });
}

// Full categorised emoji set
const EMOJI_CATEGORIES = [
    {
        label: '😀 Smileys',
        emojis: ['😀','😃','😄','😁','😆','😅','🤣','😂','🙂','🙃','😉','😊','😇','🥰','😍','🤩','😘','😗','😚','😙','🥲','😋','😛','😜','🤪','😝','🤑','🤗','🤭','🤫','🤔','🤐','🤨','😐','😑','😶','😏','😒','🙄','😬','🤥','😌','😔','😪','🤤','😴','😷','🤒','🤕','🤢','🤮','🤧','🥵','🥶','🥴','😵','💫','🤯','🤠','🥳','🥸','😎','🤓','🧐','😕','😟','🙁','☹️','😮','😯','😲','😳','🥺','😦','😧','😨','😰','😥','😢','😭','😱','😖','😣','😞','😓','😩','😫','🥱','😤','😡','😠','🤬','😈','👿','💀','☠️','💩','🤡','👹','👺','👻','👽','👾','🤖'],
    },
    {
        label: '👋 People',
        emojis: ['👋','🤚','🖐️','✋','🖖','👌','🤌','🤏','✌️','🤞','🤟','🤘','🤙','👈','👉','👆','🖕','👇','☝️','👍','👎','✊','👊','🤛','🤜','👏','🙌','👐','🤲','🤝','🙏','✍️','💅','🤳','💪','🦾','🦿','🦵','🦶','👂','🦻','👃','🫀','🫁','🧠','🦷','🦴','👀','👁️','👅','👄','💋','🩸'],
    },
    {
        label: '❤️ Hearts',
        emojis: ['❤️','🧡','💛','💚','💙','💜','🖤','🤍','🤎','💔','❤️‍🔥','❤️‍🩹','❣️','💕','💞','💓','💗','💖','💘','💝','💟','☮️','✝️','☪️','🕉️','✡️','🔯','🕎','☯️','☦️','🛐','⛎','♈','♉','♊','♋','♌','♍','♎','♏','♐','♑','♒','♓'],
    },
    {
        label: '🐶 Animals',
        emojis: ['🐶','🐱','🐭','🐹','🐰','🦊','🐻','🐼','🐻‍❄️','🐨','🐯','🦁','🐮','🐷','🐸','🐵','🙈','🙉','🙊','🐔','🐧','🐦','🐤','🦆','🦅','🦉','🦇','🐺','🐗','🐴','🦄','🐝','🐛','🦋','🐌','🐞','🐜','🦟','🦗','🕷️','🦂','🐢','🐍','🦎','🦖','🦕','🐙','🦑','🦐','🦞','🦀','🐡','🐠','🐟','🐬','🐳','🐋','🦈','🐊','🐅','🐆','🦓','🦍','🦧','🦣','🐘','🦛','🦏','🐪','🐫','🦒','🦘','🦬','🐃','🐂','🐄','🐎','🐖','🐏','🐑','🦙','🐐','🦌','🐕','🐩','🦮','🐕‍🦺','🐈','🐈‍⬛','🐓','🦃','🦤','🦚','🦜','🦢','🦩','🕊️','🐇','🦝','🦨','🦡','🦫','🦦','🦥','🐁','🐀','🐿️','🦔'],
    },
    {
        label: '🍕 Food',
        emojis: ['🍏','🍎','🍐','🍊','🍋','🍌','🍉','🍇','🍓','🫐','🍈','🍒','🍑','🥭','🍍','🥥','🥝','🍅','🍆','🥑','🥦','🥬','🥒','🌶️','🫑','🧄','🧅','🥔','🍠','🫘','🌰','🥜','🍞','🥐','🥖','🫓','🥨','🧀','🥚','🍳','🧈','🥞','🧇','🥓','🥩','🍗','🍖','🦴','🌭','🍔','🍟','🍕','🫔','🌮','🌯','🥙','🧆','🥚','🥗','🥘','🫕','🍝','🍜','🍲','🍛','🍣','🍱','🥟','🦪','🍤','🍙','🍘','🍥','🥮','🍢','🧁','🍰','🎂','🍮','🍭','🍬','🍫','🍿','🍩','🍪','🌰','🥜','🍯','🧃','🥤','🧋','☕','🫖','🍵','🧉','🍺','🍻','🥂','🍷','🥃','🍸','🍹','🧊','🥄','🍴','🍽️'],
    },
    {
        label: '🌍 Travel',
        emojis: ['🚗','🚕','🚙','🚌','🚎','🏎️','🚓','🚑','🚒','🚐','🛻','🚚','🚛','🚜','🏍️','🛵','🛺','🚲','🛴','🛹','🛼','🚏','🛣️','🛤️','⛽','🛞','🚨','🚥','🚦','🛑','🚧','⚓','🛟','⛵','🚤','🛥️','🛳️','⛴️','🚢','✈️','🛩️','🛫','🛬','🪂','💺','🚁','🚟','🚠','🚡','🛰️','🚀','🛸','🌍','🌎','🌏','🌐','🗺️','🗾','🧭','🏔️','⛰️','🌋','🗻','🏕️','🏖️','🏜️','🏝️','🏞️','🏟️','🏛️','🏗️','🧱','🪨','🪵','🛖','🏘️','🏚️','🏠','🏡','🏢','🏣','🏤','🏥','🏦','🏨','🏩','🏪','🏫','🏬','🏭','🏯','🏰','💒','🗼','🗽','⛪','🕌','🛕','🕍','⛩️','🕋'],
    },
    {
        label: '⚽ Activities',
        emojis: ['⚽','🏀','🏈','⚾','🥎','🎾','🏐','🏉','🥏','🎱','🏓','🏸','🏒','🏑','🥍','🏏','🪃','🥅','⛳','🪁','🏹','🎣','🤿','🥊','🥋','🎽','🛹','🛼','🛷','⛸️','🥌','🎿','⛷️','🏂','🪂','🏋️','🤼','🤸','⛹️','🤺','🏇','🧘','🏄','🏊','🤽','🚣','🧗','🚵','🚴','🏆','🥇','🥈','🥉','🏅','🎖️','🏵️','🎗️','🎫','🎟️','🎪','🤹','🎭','🩰','🎨','🎬','🎤','🎧','🎼','🎹','🥁','🪘','🎷','🎺','🎸','🪕','🎻','🪗','🎲','♟️','🎯','🎳','🎮','🎰','🧩'],
    },
    {
        label: '🔥 Symbols',
        emojis: ['🔥','✨','💥','💫','⭐','🌟','💢','💦','💨','🕳️','💬','💭','🗯️','💤','💮','♨️','💈','🛑','🚫','📵','🔞','⛔','❌','⭕','🔴','🟠','🟡','🟢','🔵','🟣','⚫','⚪','🟤','🔶','🔷','🔸','🔹','🔺','🔻','💠','🔘','🔲','🔳','▪️','▫️','◾','◽','◼️','◻️','🟥','🟧','🟨','🟩','🟦','🟪','⬛','⬜','🟫','🔈','🔉','🔊','📢','📣','🔔','🔕','🎵','🎶','💯','🔑','🗝️','🔐','🔏','🔒','🔓','🔨','🪓','⛏️','⚒️','🛠️','🗡️','⚔️','🛡️','🔧','🔩','⚙️','🗜️','⚖️','🦯','🔗','⛓️','🧲','🪜'],
    },
] as const;

const filteredCategories = computed(() => {
    const q = pickerSearch.value.trim().toLowerCase();
    if (!q) return EMOJI_CATEGORIES;
    // Simple filter: return a single pseudo-category with matching emojis
    const all = EMOJI_CATEGORIES.flatMap(c => c.emojis).filter(e => {
        // Basic: include if the emoji itself or its codepoint description could match
        // Since we don't have names, just do a text search over the category labels too
        return true; // fallback: show all when searching (user sees what they type)
    });
    // We can't do real name search without a lookup table, so just show all on search
    // and let users find by scrolling — the search box still helps by keeping focus.
    return EMOJI_CATEGORIES;
});

// ─── Versions ───────────────────────────────────────────────────────────────
const showReplaceDialog = ref(false);
const replaceFile = ref<File | null>(null);
const replacePreview = ref<string | null>(null);
const replaceLabel = ref('');
const replaceNote = ref('');
const replacing = ref(false);

function onReplaceFile(e: Event) {
    const input = e.target as HTMLInputElement;
    if (input.files?.[0]) {
        replaceFile.value = input.files[0];
        const reader = new FileReader();
        reader.onload = (e) => replacePreview.value = e.target?.result as string;
        reader.readAsDataURL(input.files[0]);
    }
}

function submitReplace() {
    if (!replaceFile.value) return;

    replacing.value = true;
    const formData = new FormData();
    formData.append('file', replaceFile.value);
    if (replaceLabel.value) formData.append('label', replaceLabel.value);
    if (replaceNote.value) formData.append('change_note', replaceNote.value);

    router.post(`/images/${props.image.id}/replace`, formData, {
        forceFormData: true,
        preserveScroll: true,
        onFinish: () => {
            replacing.value = false;
            showReplaceDialog.value = false;
            replaceFile.value = null;
            replacePreview.value = null;
            replaceLabel.value = '';
            replaceNote.value = '';
        },
    });
}

function restoreVersion(versionId: number) {
    if (!confirm('Restore this version? The current image will be saved as a new version.')) return;
    router.post(`/images/${props.image.id}/versions/${versionId}/restore`, {}, {
        preserveScroll: true,
    });
}

function downloadVersion(versionId: number) {
    window.open(`/images/${props.image.id}/versions/${versionId}/download`, '_blank');
}

function deleteVersion(versionId: number) {
    if (!confirm('Delete this version permanently?')) return;
    router.delete(`/images/${props.image.id}/versions/${versionId}`, {
        preserveScroll: true,
    });
}

const editingVersionId = ref<number | null>(null);
const editVersionLabel = ref('');
const editVersionNote = ref('');
const savingVersionLabel = ref(false);

function startEditVersion(version: App.ImageVersion) {
    editingVersionId.value = version.id;
    editVersionLabel.value = version.label ?? '';
    editVersionNote.value = version.change_note ?? '';
}

function saveVersionLabel(versionId: number) {
    savingVersionLabel.value = true;
    router.put(`/images/${props.image.id}/versions/${versionId}`, {
        label: editVersionLabel.value || null,
        change_note: editVersionNote.value || null,
    }, {
        preserveScroll: true,
        onFinish: () => {
            savingVersionLabel.value = false;
            editingVersionId.value = null;
        },
    });
}

// ─── Watermark download ─────────────────────────────────────────────────────
const useWatermark  = ref(false);
const wmText        = ref('Iris');
const wmPosition    = ref('bottom-right');
const wmOpacity     = ref('60');
const downloading   = ref(false);

const positionOptions = [
    { label: 'Bottom right', value: 'bottom-right' },
    { label: 'Bottom left',  value: 'bottom-left'  },
    { label: 'Top right',    value: 'top-right'    },
    { label: 'Top left',     value: 'top-left'     },
    { label: 'Center',       value: 'center'       },
];

async function download() {
    downloading.value = true;
    const params = new URLSearchParams();
    if (useWatermark.value) {
        params.set('watermark', '1');
        params.set('text',      wmText.value || 'Iris');
        params.set('position',  wmPosition.value);
        params.set('opacity',   wmOpacity.value);
    }
    const url = `/images/${props.image.id}/download${params.size ? '?' + params : ''}`;
    try {
        const token = decodeURIComponent(document.cookie.match(/XSRF-TOKEN=([^;]+)/)?.[1] ?? '');
        const res  = await fetch(url, { headers: { 'X-XSRF-TOKEN': token } });
        const blob = await res.blob();
        const a    = document.createElement('a');
        a.href     = URL.createObjectURL(blob);
        a.download = props.image.original_name ?? props.image.name;
        a.click();
        URL.revokeObjectURL(a.href);
    } finally {
        downloading.value = false;
    }
}

// ─── EXIF viewer ────────────────────────────────────────────────────────────
const showExif = ref(false);
const { exif, loading: exifLoading, readFromFile, fileHasExif } = useExif();

async function loadExif() {
    showExif.value = !showExif.value;
    if (showExif.value && !exif.value) {
        try {
            const res = await fetch(props.image.url);
            const blob = await res.blob();
            await readFromFile(new File([blob], props.image.name, { type: blob.type }));
        } catch {
            // Silent fail
        }
    }
}
</script>

<template>
    <AppLayout :breadcrumbs="breadcrumbs">
        <Head :title="image.name" />

        <div class="max-w-5xl mx-auto px-4 py-8">
            <!-- Back + Actions -->
            <div class="flex items-center justify-between mb-6">
                <Link href="/images">
                    <Button variant="ghost" size="sm" class="gap-2">
                        <ArrowLeft class="h-4 w-4" />
                        Back
                    </Button>
                </Link>
                <div class="flex items-center gap-2">
                    <Button variant="outline" size="sm" class="gap-2" @click="showReplaceDialog = true">
                        <Upload class="h-4 w-4" />
                        Replace
                    </Button>
                    <Button variant="outline" size="sm" class="gap-2" @click="showShareDialog = true">
                        <Share2 class="h-4 w-4" />
                        Share
                    </Button>
                    <Button variant="destructive" size="sm" class="gap-2" @click="showDeleteDialog = true">
                        <Trash2 class="h-4 w-4" />
                        Delete
                    </Button>
                </div>
            </div>

            <!-- Tabs -->
            <div class="flex items-center gap-1 border-b border-border mb-6">
                <button
                    @click="activeTab = 'details'"
                    class="px-4 py-2 text-sm font-medium border-b-2 transition-colors"
                    :class="activeTab === 'details' ? 'border-violet-500 text-violet-400' : 'border-transparent text-muted-foreground hover:text-foreground'"
                >
                    Details
                </button>
                <button
                    @click="activeTab = 'versions'"
                    class="px-4 py-2 text-sm font-medium border-b-2 transition-colors flex items-center gap-1.5"
                    :class="activeTab === 'versions' ? 'border-violet-500 text-violet-400' : 'border-transparent text-muted-foreground hover:text-foreground'"
                >
                    <History class="h-3.5 w-3.5" />
                    Versions
                    <Badge v-if="image.versions?.length" variant="secondary" class="text-[10px] h-4 px-1">
                        {{ image.versions.length }}
                    </Badge>
                </button>
            </div>

            <!-- Details Tab -->
            <div v-if="activeTab === 'details'" class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                <!-- Image preview -->
                <div class="lg:col-span-2 space-y-4">
                    <div class="rounded-xl overflow-hidden border border-border bg-muted flex items-center justify-center min-h-[300px]">
                        <img :src="image.url" :alt="image.alt_text || image.name" class="max-w-full max-h-[600px] object-contain" />
                    </div>

                    <!-- Caption / Alt editor -->
                    <div class="rounded-xl border border-border bg-card p-5 space-y-4">
                        <div class="flex items-center justify-between">
                            <h3 class="text-sm font-semibold text-foreground">Caption & Alt Text</h3>
                            <Button v-if="!editingCaption" variant="ghost" size="sm" class="gap-2" @click="editingCaption = true">
                                <Pencil class="h-3 w-3" />
                                Edit
                            </Button>
                        </div>
                        
                        <div v-if="!editingCaption">
                            <p v-if="image.caption" class="text-sm text-foreground">{{ image.caption }}</p>
                            <p v-else class="text-sm text-muted-foreground italic">No caption</p>
                            <p v-if="image.alt_text" class="text-xs text-muted-foreground mt-1">Alt: {{ image.alt_text }}</p>
                        </div>
                        
                        <form v-else @submit.prevent="saveCaption" class="space-y-3">
                            <div>
                                <Label class="text-xs">Caption</Label>
                                <textarea v-model="captionForm.caption" rows="2" class="w-full rounded-lg border border-border bg-background px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-violet-500/50 resize-none" placeholder="Describe this image..."></textarea>
                            </div>
                            <div>
                                <Label class="text-xs">Alt text</Label>
                                <Input v-model="captionForm.alt_text" placeholder="Accessibility description" />
                            </div>
                            <div class="flex gap-2">
                                <Button type="submit" size="sm" :disabled="captionForm.processing" class="bg-gradient-to-r from-violet-500 to-cyan-400 text-white hover:opacity-90">
                                    {{ captionForm.processing ? 'Saving...' : 'Save' }}
                                </Button>
                                <Button type="button" variant="outline" size="sm" @click="editingCaption = false">Cancel</Button>
                            </div>
                        </form>
                    </div>

                    <!-- URL / Embed card -->
                    <div class="rounded-xl border border-border bg-card p-5 space-y-4">
                        <div class="flex items-center gap-2">
                            <Link2 class="h-4 w-4 text-violet-400" />
                            <h3 class="text-sm font-semibold text-foreground">Direct URL &amp; Embed codes</h3>
                        </div>

                        <div class="space-y-2">
                            <div v-for="type in embedTypes" :key="type.key"
                                 class="flex items-center gap-3 rounded-lg border border-border bg-muted/40 px-3 py-2.5">
                                <div class="min-w-[80px]">
                                    <p class="text-xs font-semibold text-foreground">{{ type.label }}</p>
                                    <p class="text-[10px] text-muted-foreground">{{ type.desc }}</p>
                                </div>
                                <code class="flex-1 truncate text-xs font-mono text-muted-foreground">{{ embedCodes[type.key] }}</code>
                                <button @click="copyEmbed(type.key)"
                                        class="shrink-0 flex items-center gap-1.5 rounded-lg px-2.5 py-1.5 text-xs font-semibold transition-all"
                                        :class="copyStates[type.key] ? 'bg-emerald-500/15 text-emerald-400' : 'bg-violet-500/10 text-violet-400 hover:bg-violet-500/20'">
                                    <Check v-if="copyStates[type.key]" class="h-3 w-3" />
                                    <Copy v-else class="h-3 w-3" />
                                    {{ copyStates[type.key] ? 'Copied!' : 'Copy' }}
                                </button>
                            </div>
                        </div>

                        <p class="text-xs text-muted-foreground">
                            These are permanent direct links to your image. Paste them anywhere — websites, docs, forums, chat apps.
                        </p>
                    </div>
                </div>

                <!-- Sidebar info -->
                <div class="space-y-4">
                    <div>
                        <h1 class="text-xl font-bold tracking-tight break-all">{{ image.name }}</h1>
                        <p class="text-sm text-muted-foreground mt-1">{{ image.original_name }}</p>
                    </div>

                    <div class="flex flex-wrap gap-2">
                        <Badge variant="secondary">{{ image.extension.toUpperCase() }}</Badge>
                        <Badge v-if="image.is_private" variant="outline" class="gap-1"><Eye class="h-3 w-3" /> Private</Badge>
                        <Badge v-if="image.exif_stripped" variant="outline" class="gap-1"><Shield class="h-3 w-3" /> EXIF stripped</Badge>
                    </div>

                    <!-- ── Reactions ──────────────────────────────────────────── -->
                    <div class="rounded-xl border border-border bg-card p-4 space-y-3">
                        <h3 class="text-sm font-semibold">Reactions</h3>

                        <!-- Existing reaction counts -->
                        <div v-if="reactionEntries.length" class="flex flex-wrap gap-2">
                            <button
                                v-for="item in reactionEntries"
                                :key="item.emoji"
                                @click="react(item.emoji)"
                                :disabled="!!reactingEmoji"
                                class="flex items-center gap-1.5 rounded-full border border-border bg-muted/50 px-3 py-1 text-sm transition-colors hover:border-violet-500/50 hover:bg-violet-500/10 disabled:opacity-60"
                            >
                                <span>{{ item.emoji }}</span>
                                <span class="text-xs font-medium text-muted-foreground">{{ item.count }}</span>
                            </button>
                        </div>
                        <p v-else class="text-xs text-muted-foreground">No reactions yet — be the first!</p>

                        <!-- Add reaction button + picker -->
                        <div class="pt-1 border-t border-border">
                            <button
                                @click="showPicker = !showPicker"
                                class="flex items-center gap-1.5 rounded-full border border-dashed border-border px-3 py-1 text-sm text-muted-foreground transition-colors hover:border-violet-500/50 hover:text-violet-400"
                            >
                                <span class="text-base leading-none">😀</span>
                                <span class="text-xs">{{ showPicker ? 'Close' : 'Add reaction' }}</span>
                            </button>

                            <!-- Full picker dropdown -->
                            <div v-if="showPicker" class="mt-2 rounded-xl border border-border bg-popover shadow-lg overflow-hidden">
                                <!-- Search -->
                                <div class="p-2 border-b border-border">
                                    <input
                                        v-model="pickerSearch"
                                        placeholder="Search emoji…"
                                        class="w-full rounded-lg border border-border bg-background px-3 py-1.5 text-xs outline-none focus:border-violet-500"
                                        autofocus
                                    />
                                </div>

                                <!-- Search results -->
                                <div v-if="pickerSearch.trim()" class="p-2 max-h-40 overflow-y-auto">
                                    <div class="flex flex-wrap gap-1">
                                        <button
                                            v-for="emoji in EMOJI_CATEGORIES.flatMap(c => c.emojis).filter(e => e.includes(pickerSearch.trim()))"
                                            :key="emoji"
                                            @click="react(emoji)"
                                            :disabled="!!reactingEmoji"
                                            class="rounded p-1 text-lg leading-none hover:bg-violet-500/10 disabled:opacity-60 transition-colors"
                                        >{{ emoji }}</button>
                                    </div>
                                    <p v-if="!EMOJI_CATEGORIES.flatMap(c => c.emojis).filter(e => e.includes(pickerSearch.trim())).length"
                                       class="text-xs text-muted-foreground text-center py-3">No results</p>
                                </div>

                                <!-- Categorised grid -->
                                <template v-else>
                                    <!-- Category tabs -->
                                    <div class="flex overflow-x-auto border-b border-border">
                                        <button
                                            v-for="(cat, i) in EMOJI_CATEGORIES"
                                            :key="i"
                                            @click="activeCategory = i"
                                            class="shrink-0 px-2 py-1.5 text-base transition-colors"
                                            :class="activeCategory === i ? 'bg-violet-500/10' : 'hover:bg-muted'"
                                            :title="cat.label"
                                        >{{ cat.emojis[0] }}</button>
                                    </div>
                                    <!-- Emoji grid -->
                                    <div class="p-2 max-h-44 overflow-y-auto">
                                        <p class="text-[10px] text-muted-foreground mb-1.5">{{ EMOJI_CATEGORIES[activeCategory].label }}</p>
                                        <div class="flex flex-wrap gap-0.5">
                                            <button
                                                v-for="emoji in EMOJI_CATEGORIES[activeCategory].emojis"
                                                :key="emoji"
                                                @click="react(emoji)"
                                                :disabled="!!reactingEmoji"
                                                class="rounded p-1 text-lg leading-none hover:bg-violet-500/10 disabled:opacity-60 transition-colors"
                                                :class="reactingEmoji === emoji ? 'animate-bounce' : ''"
                                            >{{ emoji }}</button>
                                        </div>
                                    </div>
                                </template>
                            </div>
                        </div>
                    </div>

                    <!-- Tags section -->
                    <div class="rounded-xl border border-border bg-card p-4 space-y-3">
                        <div class="flex items-center justify-between">
                            <div class="flex items-center gap-2">
                                <Tag class="h-4 w-4 text-violet-400" />
                                <h3 class="text-sm font-semibold">Tags</h3>
                            </div>
                            <Button variant="ghost" size="sm" class="h-7 w-7 p-0" @click="showTagInput = !showTagInput">
                                <Plus class="h-4 w-4" />
                            </Button>
                        </div>

                        <div v-if="image.tags?.length" class="flex flex-wrap gap-1.5">
                            <div v-for="tag in image.tags" :key="tag.id" class="group flex items-center gap-1 rounded-full bg-violet-500/10 px-2.5 py-1 text-xs text-violet-400 border border-violet-500/20">
                                <span>{{ tag.name }}</span>
                                <button @click="removeTag(tag.id)" class="opacity-0 group-hover:opacity-100 transition-opacity text-violet-400 hover:text-rose-400">
                                    <X class="h-3 w-3" />
                                </button>
                            </div>
                        </div>
                        <p v-else class="text-xs text-muted-foreground">No tags yet</p>

                        <div v-if="showTagInput" class="flex gap-2">
                            <Input
                                v-model="tagInput"
                                placeholder="Add a tag..."
                                class="text-sm h-8"
                                @keydown.enter.prevent="addTag"
                            />
                            <Button size="sm" class="h-8 bg-gradient-to-r from-violet-500 to-cyan-400 text-white hover:opacity-90" :disabled="addingTag || !tagInput.trim()" @click="addTag">
                                <Check v-if="addingTag" class="h-3 w-3 animate-spin" />
                                <Plus v-else class="h-3 w-3" />
                            </Button>
                        </div>
                    </div>

                    <!-- Metadata -->
                    <div class="rounded-xl border border-border divide-y divide-border">
                        <div class="flex justify-between px-4 py-3 text-sm">
                            <span class="text-muted-foreground">Size</span>
                            <span class="font-medium">{{ image.size_human }}</span>
                        </div>
                        <div v-if="image.width && image.height" class="flex justify-between px-4 py-3 text-sm">
                            <span class="text-muted-foreground">Dimensions</span>
                            <span class="font-medium">{{ image.width }} × {{ image.height }}</span>
                        </div>
                        <div class="flex justify-between px-4 py-3 text-sm">
                            <span class="text-muted-foreground">Type</span>
                            <span class="font-medium">{{ image.mime_type }}</span>
                        </div>
                        <div class="flex justify-between px-4 py-3 text-sm">
                            <span class="text-muted-foreground">Uploaded</span>
                            <span class="font-medium">{{ image.created_at }}</span>
                        </div>
                        <div class="flex justify-between px-4 py-3 text-sm">
                            <span class="text-muted-foreground">Downloads</span>
                            <span class="font-medium">{{ image.download_count }}</span>
                        </div>
                        <div class="flex justify-between px-4 py-3 text-sm">
                            <span class="text-muted-foreground">Public URL</span>
                            <button @click="copyEmbed('url')" class="text-violet-400 hover:text-violet-300 text-xs font-mono truncate max-w-[150px]">
                                {{ copyStates.url ? 'Copied!' : '/i/' + image.public_token }}
                            </button>
                        </div>
                    </div>

                    <!-- EXIF Viewer -->
                    <div class="rounded-xl border border-border bg-card p-4">
                        <button @click="loadExif" class="flex items-center gap-2 w-full text-sm font-semibold">
                            <Code class="h-4 w-4 text-violet-400" />
                            {{ showExif ? 'Hide EXIF' : 'View EXIF' }}
                        </button>
                        
                        <div v-if="showExif" class="mt-3 space-y-2 text-xs">
                            <div v-if="exifLoading" class="text-muted-foreground">Loading EXIF data...</div>
                            <div v-else-if="exif" class="space-y-1">
                                <div v-if="exif.make" class="flex justify-between"><span class="text-muted-foreground">Camera</span><span>{{ exif.make }} {{ exif.model }}</span></div>
                                <div v-if="exif.dateTime" class="flex justify-between"><span class="text-muted-foreground">Date</span><span>{{ exif.dateTime }}</span></div>
                                <div v-if="exif.iso" class="flex justify-between"><span class="text-muted-foreground">ISO</span><span>{{ exif.iso }}</span></div>
                                <div v-if="exif.shutterSpeed" class="flex justify-between"><span class="text-muted-foreground">Shutter</span><span>{{ exif.shutterSpeed }}</span></div>
                                <div v-if="exif.aperture" class="flex justify-between"><span class="text-muted-foreground">Aperture</span><span>{{ exif.aperture }}</span></div>
                                <div v-if="exif.focalLength" class="flex justify-between"><span class="text-muted-foreground">Focal Length</span><span>{{ exif.focalLength }}</span></div>
                                <div v-if="exif.flash" class="flex justify-between"><span class="text-muted-foreground">Flash</span><span>{{ exif.flash }}</span></div>
                                <div v-if="exif.gps" class="flex justify-between"><span class="text-muted-foreground">GPS</span><span class="text-violet-400">{{ exif.gps.lat.toFixed(5) }}, {{ exif.gps.lng.toFixed(5) }}</span></div>
                            </div>
                            <div v-else class="text-muted-foreground">No EXIF data available.</div>
                        </div>
                    </div>

                    <!-- Download card -->
                    <div class="rounded-xl border border-border bg-card p-4 space-y-4">
                        <h3 class="text-sm font-semibold">Download</h3>

                        <div class="flex items-center justify-between">
                            <div>
                                <Label class="text-sm font-medium">Add watermark</Label>
                                <p class="text-xs text-muted-foreground">Embed text into the downloaded image</p>
                            </div>
                            <Switch v-model:checked="useWatermark" />
                        </div>

                        <Transition enter-active-class="transition-all duration-200" enter-from-class="opacity-0 -translate-y-1"
                                    leave-active-class="transition-all duration-150" leave-to-class="opacity-0 -translate-y-1">
                            <div v-if="useWatermark" class="space-y-3 pt-2 border-t border-border">
                                <div class="space-y-1">
                                    <Label class="text-xs text-muted-foreground">Watermark text</Label>
                                    <input v-model="wmText" type="text" maxlength="60" placeholder="e.g. © Your Name"
                                           class="w-full rounded-md border border-border bg-transparent px-3 py-1.5 text-sm outline-none focus:border-violet-500 transition-colors" />
                                </div>
                                <div class="space-y-1">
                                    <Label class="text-xs text-muted-foreground">Position</Label>
                                    <Select v-model="wmPosition">
                                        <SelectTrigger class="h-8 text-sm"><SelectValue /></SelectTrigger>
                                        <SelectContent>
                                            <SelectItem v-for="opt in positionOptions" :key="opt.value" :value="opt.value">{{ opt.label }}</SelectItem>
                                        </SelectContent>
                                    </Select>
                                </div>
                                <div class="space-y-1">
                                    <div class="flex justify-between">
                                        <Label class="text-xs text-muted-foreground">Opacity</Label>
                                        <span class="text-xs text-muted-foreground">{{ wmOpacity }}%</span>
                                    </div>
                                    <input v-model="wmOpacity" type="range" min="10" max="100" step="5" class="w-full accent-violet-500" />
                                </div>
                            </div>
                        </Transition>

                        <Button class="w-full gap-2 bg-gradient-to-r from-violet-500 to-cyan-400 text-white hover:opacity-90"
                                :disabled="downloading" @click="download">
                            <Download class="h-4 w-4" />
                            {{ downloading ? 'Preparing...' : useWatermark ? 'Download with watermark' : 'Download' }}
                        </Button>
                    </div>

                    <!-- Notes Panel -->
                    <div class="rounded-xl border border-border bg-card overflow-hidden">
                        <button
                            @click="notesExpanded = !notesExpanded"
                            class="flex items-center justify-between w-full p-4 text-sm font-semibold hover:bg-muted/50 transition-colors"
                        >
                            <div class="flex items-center gap-2">
                                <MessageSquare class="h-4 w-4 text-violet-400" />
                                <span>Notes</span>
                                <Badge v-if="image.notes?.length" variant="secondary" class="text-[10px] h-4 px-1.5">
                                    {{ image.notes.length }}
                                </Badge>
                            </div>
                            <ChevronUp v-if="notesExpanded" class="h-4 w-4 text-muted-foreground" />
                            <ChevronDown v-else class="h-4 w-4 text-muted-foreground" />
                        </button>

                        <div v-show="notesExpanded" class="px-4 pb-4 space-y-3">
                            <form @submit.prevent="addNote" class="flex gap-2">
                                <Input v-model="noteForm.body" placeholder="Add a private note..." class="flex-1 text-sm" />
                                <Button type="submit" size="sm" :disabled="noteForm.processing || !noteForm.body.trim()" class="bg-gradient-to-r from-violet-500 to-cyan-400 text-white hover:opacity-90">
                                    <Send class="h-3 w-3" />
                                </Button>
                            </form>

                            <div v-if="image.notes?.length" class="space-y-2 max-h-72 overflow-y-auto">
                                <div v-for="note in image.notes" :key="note.id" class="rounded-lg bg-muted/40 p-3 space-y-1.5">
                                    <template v-if="editingNoteId !== note.id">
                                        <div class="flex items-center justify-between">
                                            <div class="flex items-center gap-2">
                                                <div class="h-5 w-5 rounded-full bg-violet-500/15 flex items-center justify-center text-[10px] font-bold text-violet-400">
                                                    {{ note.user.name.charAt(0).toUpperCase() }}
                                                </div>
                                                <span class="text-xs font-medium">{{ note.user.name }}</span>
                                                <span class="text-[10px] text-muted-foreground">{{ note.created_at }}</span>
                                            </div>
                                            <div class="flex items-center gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
                                                <button @click="startEditNote(note)" class="text-muted-foreground hover:text-violet-400 transition-colors p-0.5">
                                                    <Pencil class="h-3 w-3" />
                                                </button>
                                                <button @click="deleteNote(note.id)" class="text-muted-foreground hover:text-rose-400 transition-colors p-0.5">
                                                    <Trash2 class="h-3 w-3" />
                                                </button>
                                            </div>
                                        </div>
                                        <p class="text-xs text-foreground whitespace-pre-wrap">{{ note.body }}</p>
                                    </template>
                                    <template v-else>
                                        <div class="space-y-2">
                                            <textarea
                                                v-model="editNoteForm.body"
                                                rows="2"
                                                class="w-full rounded-lg border border-border bg-background px-3 py-2 text-xs focus:outline-none focus:ring-2 focus:ring-violet-500/50 resize-none"
                                            ></textarea>
                                            <div class="flex gap-2">
                                                <Button size="sm" class="h-7 text-xs bg-gradient-to-r from-violet-500 to-cyan-400 text-white hover:opacity-90" :disabled="editNoteForm.processing" @click="saveNote(note.id)">
                                                    <Save class="h-3 w-3 mr-1" />
                                                    {{ editNoteForm.processing ? 'Saving...' : 'Save' }}
                                                </Button>
                                                <Button variant="outline" size="sm" class="h-7 text-xs" @click="cancelEditNote">Cancel</Button>
                                            </div>
                                        </div>
                                    </template>
                                </div>
                            </div>
                            <p v-else class="text-xs text-muted-foreground text-center py-2">No notes yet</p>
                        </div>
                    </div>

                    <!-- Active shared links -->
                    <div v-if="image.shared_links?.length">
                        <h3 class="text-sm font-semibold mb-2">Active shared links</h3>
                        <div class="space-y-2">
                            <div v-for="link in image.shared_links" :key="link.id"
                                 class="flex items-center justify-between rounded-lg border border-border px-3 py-2 text-sm">
                                <div class="flex items-center gap-2 text-muted-foreground">
                                    <Lock v-if="link.is_password_protected" class="h-3 w-3" />
                                    <Clock class="h-3 w-3" />
                                    <span>{{ link.expires_in_human }}</span>
                                </div>
                                <span class="text-xs text-muted-foreground">{{ link.view_count }} views</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Versions Tab -->
            <div v-else class="space-y-6">
                <div class="flex items-center justify-between">
                    <div>
                        <h2 class="text-lg font-semibold">Version History</h2>
                        <p class="text-sm text-muted-foreground">Previous versions of this image. Restore or download any version.</p>
                    </div>
                    <Button variant="outline" size="sm" class="gap-2" @click="showReplaceDialog = true">
                        <Upload class="h-4 w-4" />
                        Upload New Version
                    </Button>
                </div>

                <!-- Current version -->
                <div class="rounded-xl border border-violet-500/30 bg-violet-500/5 p-4">
                    <div class="flex items-center gap-3 mb-3">
                        <Badge class="bg-violet-500 text-white border-0">Current</Badge>
                        <span class="text-sm font-medium">{{ image.name }}</span>
                        <span class="text-xs text-muted-foreground ml-auto">{{ image.size_human }} · {{ image.width }}×{{ image.height }}</span>
                    </div>
                    <div class="rounded-lg overflow-hidden bg-muted max-w-xs">
                        <img :src="image.thumbnail_url" class="w-full h-32 object-cover" />
                    </div>
                </div>

                <!-- Previous versions -->
                <div v-if="image.versions?.length" class="space-y-3">
                    <div v-for="version in image.versions" :key="version.id"
                         class="group rounded-xl border border-border bg-card p-4 hover:border-violet-500/30 transition-colors">
                        <div class="flex items-start gap-4">
                            <div class="shrink-0 rounded-lg overflow-hidden bg-muted w-24 h-24">
                                <img :src="version.thumbnail_url" class="w-full h-full object-cover" />
                            </div>
                            <div class="flex-1 min-w-0 space-y-2">
                                <div class="flex items-center gap-2">
                                    <Badge variant="secondary" class="text-[10px]">v{{ version.version_number }}</Badge>
                                    <span class="text-xs text-muted-foreground">{{ version.created_at }}</span>
                                    <span class="text-xs text-muted-foreground ml-auto">{{ version.size_human }} · {{ version.width }}×{{ version.height }}</span>
                                </div>

                                <div v-if="editingVersionId !== version.id">
                                    <p v-if="version.label" class="text-sm font-medium">{{ version.label }}</p>
                                    <p v-if="version.change_note" class="text-xs text-muted-foreground">{{ version.change_note }}</p>
                                </div>

                                <div v-else class="space-y-2">
                                    <Input v-model="editVersionLabel" placeholder="Version label" class="text-sm h-8" />
                                    <Input v-model="editVersionNote" placeholder="Change note" class="text-sm h-8" />
                                    <div class="flex gap-2">
                                        <Button size="sm" class="h-7 text-xs" :disabled="savingVersionLabel" @click="saveVersionLabel(version.id)">
                                            {{ savingVersionLabel ? 'Saving...' : 'Save' }}
                                        </Button>
                                        <Button variant="outline" size="sm" class="h-7 text-xs" @click="editingVersionId = null">Cancel</Button>
                                    </div>
                                </div>

                                <div class="flex items-center gap-2 pt-1">
                                    <Button variant="outline" size="sm" class="h-7 text-xs gap-1" @click="restoreVersion(version.id)">
                                        <RotateCcw class="h-3 w-3" />
                                        Restore
                                    </Button>
                                    <Button variant="outline" size="sm" class="h-7 text-xs gap-1" @click="downloadVersion(version.id)">
                                        <Download class="h-3 w-3" />
                                        Download
                                    </Button>
                                    <Button variant="ghost" size="sm" class="h-7 text-xs gap-1" @click="startEditVersion(version)">
                                        <Pencil class="h-3 w-3" />
                                        Edit
                                    </Button>
                                    <Button variant="ghost" size="sm" class="h-7 text-xs gap-1 text-rose-400 hover:text-rose-500 hover:bg-rose-500/10" @click="deleteVersion(version.id)">
                                        <Trash2 class="h-3 w-3" />
                                        Delete
                                    </Button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div v-else class="text-center py-16">
                    <div class="flex size-16 items-center justify-center rounded-full bg-muted mx-auto mb-4">
                        <Archive class="h-8 w-8 text-muted-foreground" />
                    </div>
                    <h3 class="text-lg font-semibold mb-1">No previous versions</h3>
                    <p class="text-sm text-muted-foreground mb-4">Upload a new version to start tracking history.</p>
                    <Button class="gap-2 bg-gradient-to-r from-violet-500 to-cyan-400 text-white hover:opacity-90" @click="showReplaceDialog = true">
                        <Upload class="h-4 w-4" />
                        Upload New Version
                    </Button>
                </div>
            </div>
        </div>

        <!-- Replace/Upload Version Dialog -->
        <Dialog :open="showReplaceDialog" @update:open="showReplaceDialog = false">
            <DialogContent class="sm:max-w-lg">
                <DialogHeader>
                    <DialogTitle>Upload New Version</DialogTitle>
                    <DialogDescription>
                        Upload a new file to replace the current image. The current version will be saved automatically.
                    </DialogDescription>
                </DialogHeader>

                <div class="space-y-4 py-2">
                    <div
                        class="relative rounded-xl border-2 border-dashed border-border p-8 text-center cursor-pointer hover:border-violet-500/50 hover:bg-muted/30 transition-colors"
                        @click="($refs.replaceInput as HTMLInputElement).click()"
                    >
                        <input
                            ref="replaceInput"
                            type="file"
                            accept="image/*"
                            class="hidden"
                            @change="onReplaceFile"
                        />
                        <div v-if="!replacePreview" class="flex flex-col items-center gap-2">
                            <FileImage class="h-8 w-8 text-muted-foreground" />
                            <p class="text-sm font-medium">Click to select a new image</p>
                            <p class="text-xs text-muted-foreground">JPG, PNG, GIF, WEBP, SVG, TIFF · Max 100MB</p>
                        </div>
                        <div v-else class="flex items-center gap-3">
                            <img :src="replacePreview" class="h-16 w-16 rounded-lg object-cover" />
                            <div class="text-left">
                                <p class="text-sm font-medium">{{ replaceFile?.name }}</p>
                                <p class="text-xs text-muted-foreground">{{ replaceFile ? Math.round(replaceFile.size / 1024) + ' KB' : '' }}</p>
                            </div>
                            <Button variant="ghost" size="sm" class="ml-auto" @click.stop="replaceFile = null; replacePreview = null">Change</Button>
                        </div>
                    </div>

                    <div class="space-y-2">
                        <Label class="text-xs">Version label (optional)</Label>
                        <Input v-model="replaceLabel" placeholder="e.g. Final edit, Cropped, etc." />
                    </div>

                    <div class="space-y-2">
                        <Label class="text-xs">Change note (optional)</Label>
                        <textarea
                            v-model="replaceNote"
                            rows="2"
                            class="w-full rounded-lg border border-border bg-background px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-violet-500/50 resize-none"
                            placeholder="What changed in this version?"
                        ></textarea>
                    </div>
                </div>

                <DialogFooter>
                    <Button variant="outline" @click="showReplaceDialog = false">Cancel</Button>
                    <Button
                        class="bg-gradient-to-r from-violet-500 to-cyan-400 text-white hover:opacity-90"
                        :disabled="!replaceFile || replacing"
                        @click="submitReplace"
                    >
                        <Upload v-if="!replacing" class="h-4 w-4 mr-1" />
                        <span v-else class="h-4 w-4 animate-spin rounded-full border-2 border-white border-t-transparent mr-1" />
                        {{ replacing ? 'Uploading...' : 'Upload Version' }}
                    </Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>

        <!-- Delete Dialog -->
        <Dialog :open="showDeleteDialog" @update:open="showDeleteDialog = false">
            <DialogContent>
                <DialogHeader>
                    <DialogTitle>Delete image</DialogTitle>
                    <DialogDescription>
                        Are you sure you want to delete <strong>{{ image.name }}</strong>?
                        This cannot be undone and all shared links, versions, and notes will be removed.
                    </DialogDescription>
                </DialogHeader>
                <DialogFooter>
                    <Button variant="outline" @click="showDeleteDialog = false">Cancel</Button>
                    <Button variant="destructive" :disabled="deleting" @click="deleteImage">
                        {{ deleting ? 'Deleting...' : 'Delete' }}
                    </Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>

        <!-- Share Dialog -->
        <Dialog :open="showShareDialog" @update:open="showShareDialog = false">
            <DialogContent class="sm:max-w-md">
                <DialogHeader>
                    <DialogTitle>Share image</DialogTitle>
                    <DialogDescription>Create an expiring link to share this image.</DialogDescription>
                </DialogHeader>

                <div v-if="!shareUrl" class="space-y-4 py-2">
                    <div class="space-y-1.5">
                        <Label>Link expires in</Label>
                        <Select v-model="expiresIn">
                            <SelectTrigger><SelectValue /></SelectTrigger>
                            <SelectContent>
                                <SelectItem value="1">1 hour</SelectItem>
                                <SelectItem value="6">6 hours</SelectItem>
                                <SelectItem value="24">24 hours</SelectItem>
                                <SelectItem value="72">3 days</SelectItem>
                                <SelectItem value="168">7 days</SelectItem>
                                <SelectItem value="720">30 days</SelectItem>
                            </SelectContent>
                        </Select>
                    </div>
                    <div class="flex items-center justify-between">
                        <Label>Password protect</Label>
                        <Switch v-model:checked="usePassword" />
                    </div>
                    <div v-if="usePassword" class="space-y-1.5">
                        <Label>Password</Label>
                        <Input v-model="sharePassword" type="password" placeholder="Enter a password" />
                    </div>
                </div>

                <div v-else class="space-y-3 py-2">
                    <p class="text-sm text-muted-foreground">Your link is ready. Copy it and share.</p>
                    <div class="flex gap-2">
                        <Input :value="shareUrl" readonly class="font-mono text-xs" />
                        <Button variant="outline" size="icon" @click="copyShareUrl">
                            <Check v-if="shareCopied" class="h-4 w-4 text-emerald-500" />
                            <Copy v-else class="h-4 w-4" />
                        </Button>
                    </div>
                    <p v-if="shareCopied" class="text-xs text-emerald-500">Copied to clipboard!</p>
                </div>

                <DialogFooter>
                    <Button variant="outline" @click="showShareDialog = false">Close</Button>
                    <Button v-if="!shareUrl" class="bg-gradient-to-r from-violet-500 to-cyan-400 text-white hover:opacity-90"
                            :disabled="sharing" @click="createShareLink">
                        {{ sharing ? 'Creating...' : 'Create link' }}
                    </Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>
    </AppLayout>
</template>