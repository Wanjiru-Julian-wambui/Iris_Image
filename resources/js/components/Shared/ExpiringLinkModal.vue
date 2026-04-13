<script setup lang="ts">
import { router } from '@inertiajs/vue3';
import { Copy, ExternalLink, Link2, Lock } from 'lucide-vue-next';
import { ref } from 'vue';
import { Button } from '@/components/ui/button';
import {
    Dialog,
    DialogContent,
    DialogDescription,
    DialogFooter,
    DialogHeader,
    DialogTitle,
} from '@/components/ui/dialog';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import {
    Select,
    SelectContent,
    SelectItem,
    SelectTrigger,
    SelectValue,
} from '@/components/ui/select';
import { Switch } from '@/components/ui/switch';

const props = defineProps<{
    open: boolean;
    imageId: number;
    imageName?: string;
}>();

const emit = defineEmits<{
    'update:open': [value: boolean];
    created: [url: string];
}>();

const expiresIn   = ref('24');
const usePassword = ref(false);
const password    = ref('');
const creating    = ref(false);
const shareUrl    = ref('');
const copied      = ref(false);
const error       = ref('');

function close() {
    emit('update:open', false);
    setTimeout(reset, 300);
}

function reset() {
    expiresIn.value   = '24';
    usePassword.value = false;
    password.value    = '';
    shareUrl.value    = '';
    copied.value      = false;
    error.value       = '';
    creating.value    = false;
}

function create() {
    creating.value = true;
    error.value    = '';

    router.post('/shared-links', {
        image_id:   props.imageId,
        expires_in: parseInt(expiresIn.value),
        password:   usePassword.value ? password.value : null,
    }, {
        preserveScroll: true,
        onSuccess: (page: any) => {
            const url = page.props.flash?.share_url ?? '';
            shareUrl.value = url;
            creating.value = false;
            emit('created', url);
        },
        onError: (errors) => {
            error.value    = Object.values(errors).flat().join(' ');
            creating.value = false;
        },
    });
}

function copyUrl() {
    navigator.clipboard.writeText(shareUrl.value);
    copied.value = true;
    setTimeout(() => {
        copied.value = false;
    }, 2000);
}
</script>

<template>
    <Dialog :open="open" @update:open="close">
        <DialogContent class="sm:max-w-md">
            <DialogHeader>
                <DialogTitle class="flex items-center gap-2">
                    <Link2 class="h-4 w-4 text-[#7B2FFF]" />
                    Share image
                </DialogTitle>
                <DialogDescription v-if="imageName">
                    Create an expiring link for <strong>{{ imageName }}</strong>
                </DialogDescription>
                <DialogDescription v-else>
                    Create an expiring link to share this image.
                </DialogDescription>
            </DialogHeader>

            <!-- Step 1: Configure -->
            <div v-if="!shareUrl" class="space-y-4 py-1">
                <!-- Expires in -->
                <div class="space-y-1.5">
                    <Label>Link expires in</Label>
                    <Select v-model="expiresIn">
                        <SelectTrigger>
                            <SelectValue />
                        </SelectTrigger>
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

                <!-- Password protect -->
                <div class="flex items-center justify-between rounded-xl border border-border px-4 py-3">
                    <div class="flex items-center gap-2">
                        <Lock class="h-4 w-4 text-muted-foreground" />
                        <div>
                            <p class="text-sm font-medium">Password protect</p>
                            <p class="text-xs text-muted-foreground">Require a password to view</p>
                        </div>
                    </div>
                    <Switch v-model:checked="usePassword" />
                </div>

                <div v-if="usePassword" class="space-y-1.5">
                    <Label>Password</Label>
                    <Input
                        v-model="password"
                        type="password"
                        placeholder="Min. 4 characters"
                        autocomplete="new-password"
                    />
                </div>

                <p v-if="error" class="text-sm text-destructive">{{ error }}</p>
            </div>

            <!-- Step 2: Share URL -->
            <div v-else class="space-y-4 py-1">
                <div class="rounded-xl border border-[#7B2FFF]/30 bg-[#7B2FFF]/5 p-4 space-y-3">
                    <div class="flex items-center gap-2">
                        <div class="flex size-8 items-center justify-center rounded-full bg-[#7B2FFF]/15">
                            <Link2 class="h-4 w-4 text-[#7B2FFF]" />
                        </div>
                        <p class="text-sm font-medium text-[#7B2FFF]">Your link is ready</p>
                    </div>
                    <div class="flex gap-2">
                        <Input :value="shareUrl" readonly class="font-mono text-xs" />
                        <Button variant="outline" size="icon" @click="copyUrl" class="shrink-0">
                            <Copy class="h-4 w-4" :class="copied ? 'text-green-500' : ''" />
                        </Button>
                    </div>
                    <p v-if="copied" class="text-xs text-green-600 font-medium">Copied to clipboard!</p>
                </div>

                <div class="flex items-center gap-2 text-xs text-muted-foreground">
                    <Lock v-if="usePassword" class="h-3.5 w-3.5" />
                    <span>
                        Expires in {{ expiresIn }} hour{{ parseInt(expiresIn) !== 1 ? 's' : '' }}
                        <span v-if="usePassword"> · Password protected</span>
                    </span>
                </div>
            </div>

            <DialogFooter>
                <Button variant="outline" @click="close">
                    {{ shareUrl ? 'Close' : 'Cancel' }}
                </Button>
                <template v-if="!shareUrl">
                    <Button
                        class="bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF] text-white hover:opacity-90"
                        :disabled="creating || (usePassword && password.length < 4)"
                        @click="create"
                    >
                        {{ creating ? 'Creating...' : 'Create link' }}
                    </Button>
                </template>
                <template v-else>
                    <a :href="shareUrl" target="_blank" rel="noopener noreferrer">
                        <Button variant="outline" class="gap-2">
                            <ExternalLink class="h-4 w-4" />
                            Open link
                        </Button>
                    </a>
                </template>
            </DialogFooter>
        </DialogContent>
    </Dialog>
</template>
