<script setup lang="ts">
import { Head, Link, router } from '@inertiajs/vue3';
import { ArrowLeft, Clock, Copy, Download, Eye, Lock, Share2, Shield, Trash2 } from 'lucide-vue-next';
import { ref } from 'vue';
import AppLayout from '@/layouts/AppLayout.vue';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import {
    Dialog,
    DialogContent,
    DialogDescription,
    DialogFooter,
    DialogHeader,
    DialogTitle,
} from '@/components/ui/dialog';
import {
    Select,
    SelectContent,
    SelectItem,
    SelectTrigger,
    SelectValue,
} from '@/components/ui/select';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Switch } from '@/components/ui/switch';
import type { BreadcrumbItem } from '@/types';

const props = defineProps<{
    image: App.ImageResource;
}>();

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Dashboard', href: '/dashboard' },
    { title: 'Images',    href: '/images' },
    { title: props.image.name, href: `/images/${props.image.id}` },
];

// ─── Delete ───────────────────────────────────────────────────────────────────
const showDeleteDialog = ref(false);
const deleting         = ref(false);

function deleteImage() {
    deleting.value = true;
    router.delete(`/images/${props.image.id}`, {
        onFinish: () => { deleting.value = false; },
    });
}

// ─── Share ────────────────────────────────────────────────────────────────────
const showShareDialog = ref(false);
const expiresIn       = ref('24');
const sharePassword   = ref('');
const usePassword     = ref(false);
const sharing         = ref(false);
const shareUrl        = ref('');
const copied          = ref(false);

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

function copyUrl() {
    navigator.clipboard.writeText(shareUrl.value);
    copied.value = true;
    setTimeout(() => { copied.value = false; }, 2000);
}

// ─── Watermark download ───────────────────────────────────────────────────────
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
        const token = decodeURIComponent(
            document.cookie.match(/XSRF-TOKEN=([^;]+)/)?.[1] ?? ''
        );
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
                <!-- Image -->
                <div class="lg:col-span-2">
                    <div class="rounded-xl overflow-hidden border border-border bg-muted flex items-center justify-center min-h-[300px]">
                        <img
                            :src="image.url"
                            :alt="image.name"
                            class="max-w-full max-h-[600px] object-contain"
                        />
                    </div>
                </div>

                <!-- Info + Download -->
                <div class="space-y-4">
                    <div>
                        <h1 class="text-xl font-bold tracking-tight break-all">{{ image.name }}</h1>
                        <p class="text-sm text-muted-foreground mt-1">{{ image.original_name }}</p>
                    </div>

                    <div class="flex flex-wrap gap-2">
                        <Badge variant="secondary">{{ image.extension.toUpperCase() }}</Badge>
                        <Badge v-if="image.is_private" variant="outline" class="gap-1">
                            <Eye class="h-3 w-3" /> Private
                        </Badge>
                        <Badge v-if="image.exif_stripped" variant="outline" class="gap-1">
                            <Shield class="h-3 w-3" /> EXIF stripped
                        </Badge>
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
                    </div>

                    <!-- Download card -->
                    <div class="rounded-xl border border-border bg-card p-4 space-y-4">
                        <h3 class="text-sm font-semibold">Download</h3>

                        <!-- Watermark toggle -->
                        <div class="flex items-center justify-between">
                            <div>
                                <Label class="text-sm font-medium">Add watermark</Label>
                                <p class="text-xs text-muted-foreground">Embed text into the downloaded image</p>
                            </div>
                            <Switch v-model:checked="useWatermark" />
                        </div>

                        <!-- Watermark options -->
                        <Transition
                            enter-active-class="transition-all duration-200"
                            enter-from-class="opacity-0 -translate-y-1"
                            leave-active-class="transition-all duration-150"
                            leave-to-class="opacity-0 -translate-y-1"
                        >
                            <div v-if="useWatermark" class="space-y-3 pt-2 border-t border-border">
                                <div class="space-y-1">
                                    <Label class="text-xs text-muted-foreground">Watermark text</Label>
                                    <input
                                        v-model="wmText"
                                        type="text"
                                        maxlength="60"
                                        placeholder="e.g. © Your Name"
                                        class="w-full rounded-md border border-border bg-transparent px-3 py-1.5 text-sm outline-none focus:border-[#7B2FFF] transition-colors"
                                    />
                                </div>
                                <div class="space-y-1">
                                    <Label class="text-xs text-muted-foreground">Position</Label>
                                    <Select v-model="wmPosition">
                                        <SelectTrigger class="h-8 text-sm">
                                            <SelectValue />
                                        </SelectTrigger>
                                        <SelectContent>
                                            <SelectItem
                                                v-for="opt in positionOptions"
                                                :key="opt.value"
                                                :value="opt.value"
                                            >
                                                {{ opt.label }}
                                            </SelectItem>
                                        </SelectContent>
                                    </Select>
                                </div>
                                <div class="space-y-1">
                                    <div class="flex justify-between">
                                        <Label class="text-xs text-muted-foreground">Opacity</Label>
                                        <span class="text-xs text-muted-foreground">{{ wmOpacity }}%</span>
                                    </div>
                                    <input
                                        v-model="wmOpacity"
                                        type="range"
                                        min="10"
                                        max="100"
                                        step="5"
                                        class="w-full accent-[#7B2FFF]"
                                    />
                                </div>
                            </div>
                        </Transition>

                        <Button
                            class="w-full gap-2 bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF] text-white hover:opacity-90"
                            :disabled="downloading"
                            @click="download"
                        >
                            <Download class="h-4 w-4" />
                            {{ downloading ? 'Preparing...' : useWatermark ? 'Download with watermark' : 'Download' }}
                        </Button>
                    </div>

                    <!-- Shared links -->
                    <div v-if="image.shared_links?.length">
                        <h3 class="text-sm font-semibold mb-2">Active shared links</h3>
                        <div class="space-y-2">
                            <div
                                v-for="link in image.shared_links"
                                :key="link.id"
                                class="flex items-center justify-between rounded-lg border border-border px-3 py-2 text-sm"
                            >
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
                        <Button variant="outline" size="icon" @click="copyUrl">
                            <Copy class="h-4 w-4" />
                        </Button>
                    </div>
                    <p v-if="copied" class="text-xs text-green-600">Copied to clipboard!</p>
                </div>

                <DialogFooter>
                    <Button variant="outline" @click="showShareDialog = false">Close</Button>
                    <Button
                        v-if="!shareUrl"
                        class="bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF] text-white hover:opacity-90"
                        :disabled="sharing"
                        @click="createShareLink"
                    >
                        {{ sharing ? 'Creating...' : 'Create link' }}
                    </Button>
                </DialogFooter>
            </DialogContent>
        </Dialog>
    </AppLayout>
</template>