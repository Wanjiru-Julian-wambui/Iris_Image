<script setup lang="ts">
import { Copy, ExternalLink, Link2, Share2, Trash2 } from 'lucide-vue-next';
import { ref } from 'vue';
import { router } from '@inertiajs/vue3';
import { Button } from '@/components/ui/button';
import {
    DropdownMenu,
    DropdownMenuContent,
    DropdownMenuItem,
    DropdownMenuSeparator,
    DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import ExpiringLinkModal from '@/components/Shared/ExpiringLinkModal.vue';

const props = defineProps<{
    imageId: number;
    imageName?: string;
    existingLinks?: App.SharedLinkResource[];
    variant?: 'default' | 'outline' | 'ghost';
    size?: 'default' | 'sm' | 'icon';
}>();

const emit = defineEmits<{
    linked: [url: string];
}>();

const showModal  = ref(false);
const copiedId   = ref<number | null>(null);

function copyLink(link: App.SharedLinkResource) {
    navigator.clipboard.writeText(link.url);
    copiedId.value = link.id;
    setTimeout(() => { copiedId.value = null; }, 2000);
}

function deleteLink(link: App.SharedLinkResource) {
    router.delete(`/shared-links/${link.id}`, { preserveScroll: true });
}

function onCreated(url: string) {
    emit('linked', url);
}
</script>

<template>
    <div>
        <!-- Simple button if no existing links -->
        <Button
            v-if="!existingLinks?.length"
            :variant="variant ?? 'outline'"
            :size="size ?? 'default'"
            class="gap-2"
            @click="showModal = true"
        >
            <Share2 class="h-4 w-4" />
            <span v-if="size !== 'icon'">Share</span>
        </Button>

        <!-- Dropdown if existing links present -->
        <DropdownMenu v-else>
            <DropdownMenuTrigger as-child>
                <Button :variant="variant ?? 'outline'" :size="size ?? 'default'" class="gap-2">
                    <Share2 class="h-4 w-4" />
                    <span v-if="size !== 'icon'">Share</span>
                    <span
                        v-if="existingLinks?.length && size !== 'icon'"
                        class="ml-0.5 flex h-4 w-4 items-center justify-center rounded-full bg-[#7B2FFF]/15 text-[10px] font-semibold text-[#7B2FFF]"
                    >
                        {{ existingLinks.length }}
                    </span>
                </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end" class="w-64">
                <!-- Existing links -->
                <div v-if="existingLinks?.length" class="px-2 py-1.5">
                    <p class="text-xs font-medium text-muted-foreground mb-1.5">Active links</p>
                    <div
                        v-for="link in existingLinks"
                        :key="link.id"
                        class="flex items-center gap-2 rounded-lg px-2 py-1.5 hover:bg-muted group"
                    >
                        <div class="flex-1 min-w-0">
                            <p class="text-xs font-mono truncate text-muted-foreground">{{ link.token }}</p>
                            <p class="text-xs text-muted-foreground/60">
                                {{ link.is_expired ? 'Expired' : 'Expires ' + link.expires_in_human }}
                                · {{ link.view_count }} view{{ link.view_count !== 1 ? 's' : '' }}
                            </p>
                        </div>
                        <div class="flex items-center gap-0.5 opacity-0 group-hover:opacity-100 transition-opacity">
                            <button
                                class="flex size-6 items-center justify-center rounded hover:bg-background transition-colors"
                                :disabled="link.is_expired"
                                @click.stop="copyLink(link)"
                            >
                                <Copy class="h-3 w-3" :class="copiedId === link.id ? 'text-green-500' : 'text-muted-foreground'" />
                            </button>
                            <a :href="link.url" target="_blank" rel="noopener noreferrer">
                                <button class="flex size-6 items-center justify-center rounded hover:bg-background transition-colors">
                                    <ExternalLink class="h-3 w-3 text-muted-foreground" />
                                </button>
                            </a>
                            <button
                                class="flex size-6 items-center justify-center rounded hover:bg-background transition-colors"
                                @click.stop="deleteLink(link)"
                            >
                                <Trash2 class="h-3 w-3 text-destructive" />
                            </button>
                        </div>
                    </div>
                </div>

                <DropdownMenuSeparator v-if="existingLinks?.length" />

                <DropdownMenuItem class="gap-2 cursor-pointer" @click="showModal = true">
                    <Link2 class="h-4 w-4 text-[#7B2FFF]" />
                    Create new link
                </DropdownMenuItem>
            </DropdownMenuContent>
        </DropdownMenu>

        <!-- Modal -->
        <ExpiringLinkModal
            v-model:open="showModal"
            :image-id="imageId"
            :image-name="imageName"
            @created="onCreated"
        />
    </div>
</template>
