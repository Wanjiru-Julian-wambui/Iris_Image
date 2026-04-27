<script setup lang="ts">
import { Head, Link, router, useForm } from '@inertiajs/vue3';
import { ArrowLeft, Check, Clock, Code, Copy, Download, Eye, Link2, Lock, Share2, Shield, Trash2, Pencil, MessageSquare, X, Send } from 'lucide-vue-next';
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

// Notes
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

function deleteNote(noteId: number) {
    if (!confirm('Delete this note?')) return;
    router.delete(`/images/${props.image.id}/notes/${noteId}`, { preserveScroll: true });
}

// Watermark download
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

// EXIF viewer
const showExif = ref(false);
const { exif, loading: exifLoading, readFromFile, fileHasExif } = useExif();

// Load EXIF from image URL
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

            <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
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

                    <!-- Notes panel -->
                                       <!-- Notes panel -->
                    <div class="rounded-xl border border-border bg-card p-4 space-y-3">
                        <div class="flex items-center gap-2">
                            <MessageSquare class="h-4 w-4 text-violet-400" />
                            <h3 class="text-sm font-semibold">Notes</h3>
                        </div>

                        <!-- Add note -->
                        <form @submit.prevent="addNote" class="flex gap-2">
                            <Input v-model="noteForm.body" placeholder="Add a note..." class="flex-1 text-sm" />
                            <Button type="submit" size="sm" :disabled="noteForm.processing || !noteForm.body.trim()" class="bg-gradient-to-r from-violet-500 to-cyan-400 text-white hover:opacity-90">
                                <Send class="h-3 w-3" />
                            </Button>
                        </form>

                        <!-- Notes list -->
                        <div v-if="image.notes?.length" class="space-y-2 max-h-60 overflow-y-auto">
                            <div v-for="note in image.notes" :key="note.id" class="rounded-lg bg-muted/40 p-3 space-y-1">
                                <div class="flex items-center justify-between">
                                    <div class="flex items-center gap-2">
                                        <div class="h-5 w-5 rounded-full bg-violet-500/15 flex items-center justify-center text-[10px] font-bold text-violet-400">
                                            {{ note.user.name.charAt(0).toUpperCase() }}
                                        </div>
                                        <span class="text-xs font-medium">{{ note.user.name }}</span>
                                        <span class="text-[10px] text-muted-foreground">{{ note.created_at }}</span>
                                    </div>
                                    <button @click="deleteNote(note.id)" class="text-muted-foreground hover:text-rose-400 transition-colors">
                                        <X class="h-3 w-3" />
                                    </button>
                                </div>
                                <p class="text-xs text-foreground whitespace-pre-wrap">{{ note.body }}</p>
                            </div>
                        </div>
                        <p v-else class="text-xs text-muted-foreground text-center py-2">No notes yet</p>
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
        </div>

        <!-- Delete Dialog -->
        <Dialog :open="showDeleteDialog" @update:open="showDeleteDialog = false">
            <DialogContent>
                <DialogHeader>
                    <DialogTitle>Delete image</DialogTitle>
                    <DialogDescription>
                        Are you sure you want to delete <strong>{{ image.name }}</strong>?
                        This cannot be undone and all shared links will be removed.
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