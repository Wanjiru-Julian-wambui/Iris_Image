<script setup lang="ts">
import { Head, router } from '@inertiajs/vue3';
import { ArrowLeft, Download, Eye, Calendar, User, Tag, MessageSquare, Link2, Copy, Check, Plus, X, Send, ChevronDown, ChevronUp } from 'lucide-vue-next';
import { ref, computed, watch } from 'vue';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { useEmojis } from '@/composables/useEmojis';

const props = defineProps<{
    image: App.ImageResource;
}>();

// ─── Embed copy ─────────────────────────────────────────────────────────────
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

// ─── Tags (Public — guests can add/remove) ──────────────────────────────────
const showTagInput = ref(false);
const tagInput = ref('');
const addingTag = ref(false);

function addTag() {
    const name = tagInput.value.trim();
    if (!name) return;

    addingTag.value = true;
    router.post(`/i/${props.image.public_token}/tags`, {
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

    router.post(`/i/${props.image.public_token}/tags`, {
        tags: [tag.name],
        action: 'remove',
    }, {
        preserveScroll: true,
    });
}

// ─── Notes (Public — guests can add) ────────────────────────────────────────
const notesExpanded = ref(true);
const noteInput = ref('');
const addingNote = ref(false);

function addNote() {
    if (!noteInput.value.trim()) return;
    addingNote.value = true;
    router.post(`/i/${props.image.public_token}/notes`, {
        body: noteInput.value,
    }, {
        preserveScroll: true,
        onFinish: () => {
            addingNote.value = false;
            noteInput.value = '';
        },
    });
}

// ─── Reactions (Full feature parity with Show.vue) ──────────────────────────

// Picker tab: 'emoji' | 'gif' | 'sticker'
type PickerTab = 'emoji' | 'gif' | 'sticker';
const showPicker     = ref(false);
const pickerTab      = ref<PickerTab>('emoji');
const pickerSearch   = ref('');
const activeCategory = ref(0);

// GIF / sticker search state
const gifResults     = ref<any[]>([]);
const stickerResults = ref<any[]>([]);
const gifLoading     = ref(false);
const gifOffset      = ref(0);

// Per-type "submitting" flag
const submitting = ref(false);

// ── Emoji API integration ──────────────────────────────────────────────────
const { categories: emojiCategories, loading: emojisLoading, error: emojisError, fetchEmojis, searchEmojis } = useEmojis();

// Fetch emojis when picker opens
watch(showPicker, (open) => {
    if (open && emojiCategories.value.length === 0) {
        fetchEmojis();
    }
});

// Computed for emoji search filtering
const filteredEmojis = computed(() => {
    const q = pickerSearch.value.trim().toLowerCase();
    if (!q) return null;
    return searchEmojis(q);
});

// ── Computed: what's already reacted ────────────────────────────────────────

const reactions = computed(() => {
    const r = props.image.reactions;
    return {
        emoji:    (r && r.emoji)    ? r.emoji    : {},
        gifs:     (r && r.gifs)     ? r.gifs     : [],
        stickers: (r && r.stickers) ? r.stickers : [],
    } as {
        emoji: Record<string, number>;
        gifs: { media_url: string; media_label: string | null; media_source: string; count: number }[];
        stickers: { media_url: string; media_label: string | null; media_source: string; count: number }[];
    };
});

const emojiEntries = computed(() =>
    Object.entries(reactions.value.emoji)
        .map(([emoji, count]) => ({ emoji, count }))
        .sort((a, b) => b.count - a.count)
);

const hasAnyReaction = computed(() =>
    emojiEntries.value.length > 0 ||
    reactions.value.gifs.length > 0 ||
    reactions.value.stickers.length > 0
);

// ── React functions ──────────────────────────────────────────────────────────
function reactEmoji(emoji: string) {
    if (submitting.value) return;
    submitting.value = true;
    showPicker.value = false;
    
    router.post(`/i/${props.image.public_token}/react`, {
        type: 'emoji',
        emoji,
    }, {
        preserveScroll: true,
        onFinish: () => { submitting.value = false; },
    });
}

function reactMedia(type: 'gif' | 'sticker', media_url: string, media_label: string | null, media_source: string) {
    if (submitting.value) return;
    submitting.value = true;
    showPicker.value = false;
    
    router.post(`/i/${props.image.public_token}/react`, {
        type, media_url, media_label, media_source,
    }, {
        preserveScroll: true,
        onFinish: () => { submitting.value = false; },
    });
}

// ── GIF / Sticker search ─────────────────────────────────────────────────────

let searchDebounce: ReturnType<typeof setTimeout> | null = null;

function onPickerSearchInput() {
    if (pickerTab.value === 'emoji') return;
    if (searchDebounce) clearTimeout(searchDebounce);
    searchDebounce = setTimeout(() => fetchMedia(true), 400);
}

async function fetchMedia(reset = false) {
    const q = pickerSearch.value.trim();
    if (!q) { gifResults.value = []; stickerResults.value = []; return; }

    gifLoading.value = true;
    if (reset) { gifOffset.value = 0; gifResults.value = []; stickerResults.value = []; }

    try {
        if (pickerTab.value === 'gif') {
            const res = await fetch(`/reactions/giphy?q=${encodeURIComponent(q)}&offset=${gifOffset.value}&type=gif`).then(r => r.json());
            const results: any[] = (res?.data ?? []).map((g: any) => ({
                id: 'giphy-' + g.id,
                url: g.images?.fixed_height_small?.url ?? g.images?.downsized?.url,
                original_url: g.images?.original?.url,
                label: g.title,
                source: 'giphy',
            }));

            gifResults.value = reset ? results : [...gifResults.value, ...results];
            gifOffset.value += 20;

        } else {
            const res = await fetch(`/reactions/giphy?q=${encodeURIComponent(q)}&offset=${gifOffset.value}&type=sticker`).then(r => r.json());
            const results: any[] = (res?.data ?? []).map((g: any) => ({
                id: 'giphy-sticker-' + g.id,
                url: g.images?.fixed_height_small?.url ?? g.images?.downsized?.url,
                original_url: g.images?.original?.url,
                label: g.title,
                source: 'giphy',
            }));

            stickerResults.value = reset ? results : [...stickerResults.value, ...results];
            gifOffset.value += 20;
        }
    } catch {
        // silently fail
    } finally {
        gifLoading.value = false;
    }
}

function onPickerTabChange(tab: PickerTab) {
    pickerTab.value = tab;
    pickerSearch.value = '';
    gifResults.value = [];
    stickerResults.value = [];
    activeCategory.value = 0;
}

function togglePicker() {
    showPicker.value = !showPicker.value;
    if (!showPicker.value) {
        pickerSearch.value = '';
        gifResults.value = [];
        stickerResults.value = [];
        activeCategory.value = 0;
    }
}

// ─── Download ───────────────────────────────────────────────────────────────
const downloading = ref(false);

async function download() {
    downloading.value = true;
    try {
        const res = await fetch(props.image.url);
        const blob = await res.blob();
        const a = document.createElement('a');
        a.href = URL.createObjectURL(blob);
        a.download = props.image.original_name ?? props.image.name;
        a.click();
        URL.revokeObjectURL(a.href);
    } finally {
        downloading.value = false;
    }
}
</script>

<template>
    <Head :title="image.name" />

    <div class="min-h-screen bg-background">
        <!-- Header -->
        <header class="border-b border-border bg-card">
            <div class="max-w-4xl mx-auto px-4 py-4 flex items-center justify-between">
                <div class="flex items-center gap-3">
                    <div class="h-8 w-8 rounded-lg bg-gradient-to-br from-violet-500 to-cyan-400 flex items-center justify-center">
                        <span class="text-white font-bold text-sm">I</span>
                    </div>
                    <span class="font-bold tracking-tight">Iris</span>
                </div>
                <Link href="/login">
                    <Button variant="outline" size="sm">Sign in</Button>
                </Link>
            </div>
        </header>

        <div class="max-w-4xl mx-auto px-4 py-8">
            <!-- Back -->
            <button @click="$router.back()" class="flex items-center gap-2 text-sm text-muted-foreground hover:text-foreground mb-6 transition-colors">
                <ArrowLeft class="h-4 w-4" />
                Back
            </button>

            <!-- Image -->
            <div class="rounded-xl overflow-hidden border border-border bg-muted flex items-center justify-center min-h-[300px] mb-6">
                <img :src="image.url" :alt="image.alt_text || image.name" class="max-w-full max-h-[700px] object-contain" />
            </div>

            <!-- Info -->
            <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-6">
                <div>
                    <h1 class="text-xl font-bold tracking-tight break-all">{{ image.name }}</h1>
                    <div class="flex items-center gap-3 mt-2 text-sm text-muted-foreground">
                        <span class="flex items-center gap-1"><User class="h-3.5 w-3.5" /> {{ image.user?.name }}</span>
                        <span class="flex items-center gap-1"><Calendar class="h-3.5 w-3.5" /> {{ image.created_at }}</span>
                        <span class="flex items-center gap-1"><Eye class="h-3.5 w-3.5" /> Public</span>
                    </div>
                </div>
                <div class="flex items-center gap-2">
                    <Badge variant="secondary">{{ image.extension.toUpperCase() }}</Badge>
                    <Badge variant="outline">{{ image.size_human }}</Badge>
                    <Badge v-if="image.width && image.height" variant="outline">{{ image.width }} × {{ image.height }}</Badge>
                </div>
            </div>

            <!-- Caption -->
            <p v-if="image.caption" class="text-sm text-foreground mb-6 leading-relaxed">{{ image.caption }}</p>

            <!-- ── Tags (Public — guests can add/remove) ─────────────────────── -->
            <div class="rounded-xl border border-border bg-card p-4 space-y-3 mb-6">
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
                <p v-else class="text-xs text-muted-foreground">No tags yet — add one below</p>

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

            <!-- ── Reactions (Full feature parity with Show.vue) ─────────────── -->
            <div class="rounded-xl border border-border bg-card p-5 space-y-4 mb-6">
                <div class="flex items-center justify-between">
                    <h3 class="text-sm font-semibold">Reactions</h3>
                    <span v-if="hasAnyReaction" class="text-xs text-muted-foreground">
                        {{ emojiEntries.length + reactions.gifs.length + reactions.stickers.length }} types
                    </span>
                </div>

                <!-- Existing emoji reactions -->
                <div v-if="emojiEntries.length" class="flex flex-wrap gap-2">
                    <button
                        v-for="item in emojiEntries"
                        :key="item.emoji"
                        @click="reactEmoji(item.emoji)"
                        :disabled="submitting"
                        class="flex items-center gap-1.5 rounded-full border border-border bg-muted/50 px-3 py-1 text-sm transition-colors hover:border-violet-500/50 hover:bg-violet-500/10 disabled:opacity-60"
                    >
                        <span>{{ item.emoji }}</span>
                        <span class="text-xs font-medium text-muted-foreground">{{ item.count }}</span>
                    </button>
                </div>

                <!-- GIF reactions -->
                <div v-if="reactions.gifs.length" class="flex flex-wrap gap-2">
                    <button
                        v-for="gif in reactions.gifs"
                        :key="gif.media_url"
                        @click="reactMedia('gif', gif.media_url, gif.media_label, gif.media_source)"
                        :disabled="submitting"
                        class="relative rounded-lg overflow-hidden border border-border hover:border-violet-500/50 transition-colors disabled:opacity-60"
                        :title="gif.media_label ?? 'GIF'"
                    >
                        <img :src="gif.media_url" class="h-12 w-auto object-cover" />
                        <span class="absolute bottom-0.5 right-1 text-[10px] font-bold text-white drop-shadow">{{ gif.count }}</span>
                    </button>
                </div>

                <!-- Sticker reactions -->
                <div v-if="reactions.stickers.length" class="flex flex-wrap gap-2">
                    <button
                        v-for="sticker in reactions.stickers"
                        :key="sticker.media_url"
                        @click="reactMedia('sticker', sticker.media_url, sticker.media_label, sticker.media_source)"
                        :disabled="submitting"
                        class="relative rounded-lg overflow-hidden border border-border hover:border-violet-500/50 transition-colors disabled:opacity-60"
                        :title="sticker.media_label ?? 'Sticker'"
                    >
                        <img :src="sticker.media_url" class="h-12 w-auto object-cover" />
                        <span class="absolute bottom-0.5 right-1 text-[10px] font-bold text-white drop-shadow">{{ sticker.count }}</span>
                    </button>
                </div>

                <p v-if="!hasAnyReaction" class="text-xs text-muted-foreground">No reactions yet — be the first!</p>

                <!-- Add reaction trigger -->
                <div class="pt-2 border-t border-border">
                    <button
                        @click="togglePicker"
                        class="flex items-center gap-1.5 rounded-full border border-dashed border-border px-3 py-1 text-sm text-muted-foreground transition-colors hover:border-violet-500/50 hover:text-violet-400"
                    >
                        <span class="text-base leading-none">😀</span>
                        <span class="text-xs">{{ showPicker ? 'Close' : 'Add reaction' }}</span>
                    </button>

                    <!-- Picker panel -->
                    <div v-if="showPicker" class="mt-2 rounded-xl border border-border bg-popover shadow-lg overflow-hidden">

                        <!-- Tab bar: Emoji / GIF / Sticker -->
                        <div class="flex border-b border-border text-xs font-medium">
                            <button
                                v-for="tab in (['emoji', 'gif', 'sticker'] as const)"
                                :key="tab"
                                @click="onPickerTabChange(tab)"
                                class="flex-1 py-2 capitalize transition-colors"
                                :class="pickerTab === tab ? 'bg-violet-500/10 text-violet-400 border-b-2 border-violet-500' : 'text-muted-foreground hover:bg-muted'"
                            >{{ tab === 'gif' ? 'GIF' : tab === 'sticker' ? 'Sticker' : 'Emoji' }}</button>
                        </div>

                        <!-- Search bar (all tabs) -->
                        <div class="p-2 border-b border-border">
                            <input
                                v-model="pickerSearch"
                                :placeholder="pickerTab === 'emoji' ? 'Search emoji…' : pickerTab === 'gif' ? 'Search GIFs…' : 'Search stickers…'"
                                class="w-full rounded-lg border border-border bg-background px-3 py-1.5 text-xs outline-none focus:border-violet-500"
                                @input="onPickerSearchInput"
                                autofocus
                            />
                        </div>

                        <!-- ── Emoji tab ── -->
                        <template v-if="pickerTab === 'emoji'">
                            <div class="p-2 max-h-64 overflow-y-auto">
                                <!-- Loading -->
                                <div v-if="emojisLoading" class="flex justify-center py-6">
                                    <div class="h-5 w-5 animate-spin rounded-full border-2 border-violet-500 border-t-transparent" />
                                </div>

                                <!-- Error -->
                                <div v-else-if="emojisError" class="text-center py-6">
                                    <p class="text-xs text-muted-foreground">{{ emojisError }}</p>
                                    <Button size="sm" variant="outline" class="mt-2" @click="fetchEmojis">Retry</Button>
                                </div>

                                <!-- Empty state -->
                                <div v-else-if="emojiCategories.length === 0" class="text-center py-6">
                                    <p class="text-xs text-muted-foreground">No emojis available</p>
                                </div>

                                <!-- Search results -->
                                <div v-else-if="pickerSearch.trim()">
                                    <div v-if="filteredEmojis && filteredEmojis.length" class="flex flex-wrap gap-0.5">
                                        <button
                                            v-for="item in filteredEmojis"
                                            :key="item.emoji"
                                            @click="reactEmoji(item.emoji)"
                                            :disabled="submitting"
                                            class="rounded p-1 text-lg leading-none hover:bg-violet-500/10 disabled:opacity-60 transition-colors"
                                            :title="item.keywords"
                                        >{{ item.emoji }}</button>
                                    </div>
                                    <p v-else class="text-xs text-muted-foreground text-center py-3">No results for "{{ pickerSearch }}"</p>
                                </div>

                                <!-- Category browse -->
                                <template v-else>
                                    <div class="flex overflow-x-auto border-b border-border mb-2">
                                        <button
                                            v-for="(cat, i) in emojiCategories"
                                            :key="i"
                                            @click="activeCategory = i"
                                            class="shrink-0 px-2 py-1.5 text-xs font-medium transition-colors whitespace-nowrap"
                                            :class="activeCategory === i ? 'bg-violet-500/10 text-violet-400 border-b-2 border-violet-500' : 'text-muted-foreground hover:bg-muted'"
                                        >{{ cat.label }}</button>
                                    </div>
                                    <div class="flex flex-wrap gap-0.5">
                                        <button
                                            v-for="item in emojiCategories[activeCategory]?.emojis || []"
                                            :key="item.emoji"
                                            @click="reactEmoji(item.emoji)"
                                            :disabled="submitting"
                                            class="rounded p-1 text-lg leading-none hover:bg-violet-500/10 disabled:opacity-60 transition-colors"
                                            :title="item.keywords"
                                        >{{ item.emoji }}</button>
                                    </div>
                                </template>

                                <!-- Native emoji input fallback -->
                                <div class="mt-2 pt-2 border-t border-border">
                                    <input
                                        type="text"
                                        maxlength="8"
                                        placeholder="Paste any emoji & hit Enter…"
                                        class="w-full rounded-lg border border-border bg-background px-3 py-1.5 text-xs outline-none focus:border-violet-500 text-center text-lg"
                                        @keydown.enter.prevent="(e) => { const emoji = (e.target as HTMLInputElement).value.trim(); if (emoji) reactEmoji(emoji); (e.target as HTMLInputElement).value = ''; }"
                                    />
                                </div>
                            </div>
                        </template>

                        <!-- ── GIF / Sticker tab ── -->
                        <template v-else>
                            <div class="p-2 max-h-64 overflow-y-auto">
                                <!-- Prompt when no search yet -->
                                <p v-if="!pickerSearch.trim() && !gifLoading" class="text-xs text-muted-foreground text-center py-6">
                                    {{ pickerTab === 'gif' ? 'Type to search GIFs from Giphy' : 'Type to search stickers from Giphy' }}
                                </p>

                                <!-- Loading -->
                                <div v-else-if="gifLoading && (pickerTab === 'gif' ? gifResults : stickerResults).length === 0"
                                     class="flex justify-center py-6">
                                    <div class="h-5 w-5 animate-spin rounded-full border-2 border-violet-500 border-t-transparent" />
                                </div>

                                <!-- Results grid -->
                                <div v-else class="grid grid-cols-3 gap-1.5">
                                    <button
                                        v-for="item in (pickerTab === 'gif' ? gifResults : stickerResults)"
                                        :key="item.id"
                                        @click="reactMedia(pickerTab as 'gif' | 'sticker', item.original_url, item.label, item.source)"
                                        :disabled="submitting"
                                        class="relative rounded-lg overflow-hidden border border-border hover:border-violet-500/50 transition-colors disabled:opacity-60 aspect-video bg-muted"
                                        :title="item.label"
                                    >
                                        <img :src="item.url" class="w-full h-full object-cover" loading="lazy" />
                                    </button>

                                    <!-- Empty -->
                                    <p v-if="!gifLoading && (pickerTab === 'gif' ? gifResults : stickerResults).length === 0 && pickerSearch.trim()"
                                       class="col-span-3 text-xs text-muted-foreground text-center py-4">No results for "{{ pickerSearch }}"</p>
                                </div>

                                <!-- Load more -->
                                <button
                                    v-if="(pickerTab === 'gif' ? gifResults : stickerResults).length > 0"
                                    @click="fetchMedia(false)"
                                    :disabled="gifLoading"
                                    class="mt-2 w-full text-xs text-muted-foreground hover:text-violet-400 transition-colors py-1 disabled:opacity-50"
                                >{{ gifLoading ? 'Loading…' : 'Load more' }}</button>
                            </div>
                        </template>

                    </div>
                </div>
            </div>

            <!-- ── Notes (Public — guests can add) ───────────────────────────── -->
            <div class="rounded-xl border border-border bg-card overflow-hidden mb-6">
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
                    <!-- Add note form -->
                    <form @submit.prevent="addNote" class="flex gap-2">
                        <Input v-model="noteInput" placeholder="Add a public note..." class="flex-1 text-sm" />
                        <Button type="submit" size="sm" :disabled="addingNote || !noteInput.trim()" class="bg-gradient-to-r from-violet-500 to-cyan-400 text-white hover:opacity-90">
                            <Send class="h-3 w-3" />
                        </Button>
                    </form>

                    <!-- Notes list -->
                    <div v-if="image.notes?.length" class="space-y-2 max-h-72 overflow-y-auto">
                        <div v-for="note in image.notes" :key="note.id" class="rounded-lg bg-muted/40 p-3 space-y-1.5">
                            <div class="flex items-center justify-between">
                                <div class="flex items-center gap-2">
                                    <div class="h-5 w-5 rounded-full bg-violet-500/15 flex items-center justify-center text-[10px] font-bold text-violet-400">
                                        {{ note.user?.name?.charAt(0).toUpperCase() ?? 'G' }}
                                    </div>
                                    <span class="text-xs font-medium">{{ note.user?.name ?? 'Guest' }}</span>
                                    <span class="text-[10px] text-muted-foreground">{{ note.created_at }}</span>
                                </div>
                            </div>
                            <p class="text-xs text-foreground whitespace-pre-wrap">{{ note.body }}</p>
                        </div>
                    </div>
                    <p v-else class="text-xs text-muted-foreground text-center py-2">No notes yet — be the first!</p>
                </div>
            </div>

            <!-- URL / Embed card -->
            <div class="rounded-xl border border-border bg-card p-5 space-y-4 mb-6">
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
            </div>

            <!-- Download button -->
            <Button
                class="w-full gap-2 bg-gradient-to-r from-violet-500 to-cyan-400 text-white hover:opacity-90"
                :disabled="downloading"
                @click="download"
            >
                <Download class="h-4 w-4" />
                {{ downloading ? 'Downloading...' : 'Download image' }}
            </Button>
        </div>

        <!-- Footer -->
        <footer class="border-t border-border mt-12 py-6 text-center">
            <p class="text-sm text-muted-foreground">
                Hosted on <span class="font-semibold text-foreground">Iris</span> — Simple image hosting
            </p>
        </footer>
    </div>
</template>