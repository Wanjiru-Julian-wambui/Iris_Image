<script setup lang="ts">
import { Eye, Lock, Share2, Shield, Trash2 } from 'lucide-vue-next';
import { ref } from 'vue';

const props = defineProps<{
    image:      App.ImageResource;
    selected?:  boolean;
    selectable?: boolean;
    size?:      'sm' | 'md' | 'lg';
}>();

const emit = defineEmits<{
    click:        [image: App.ImageResource];
    select:       [image: App.ImageResource];
    delete:       [image: App.ImageResource];
    share:        [image: App.ImageResource];
}>();

const hovered = ref(false);
</script>

<template>
    <div
        class="group relative rounded-xl overflow-hidden border bg-muted transition-all duration-200 aspect-square cursor-pointer"
        :class="[
            selected
                ? 'border-[#7B2FFF] ring-2 ring-[#7B2FFF]/30'
                : 'border-border hover:border-[#7B2FFF]/30',
        ]"
        @mouseenter="hovered = true"
        @mouseleave="hovered = false"
        @click="emit('click', image)"
    >
        <!-- Image -->
        <img
            :src="image.thumbnail_url"
            :alt="image.name"
            class="w-full h-full object-cover transition-transform duration-300"
            :class="hovered ? 'scale-105' : 'scale-100'"
            loading="lazy"
        />

        <!-- Selection checkbox -->
        <div
            v-if="selectable"
            class="absolute top-2 left-2 transition-opacity duration-150"
            :class="selected || hovered ? 'opacity-100' : 'opacity-0'"
            @click.stop="emit('select', image)"
        >
            <div
                class="flex size-5 items-center justify-center rounded-full border-2 transition-colors"
                :class="selected
                    ? 'border-[#7B2FFF] bg-[#7B2FFF]'
                    : 'border-white/80 bg-black/30'"
            >
                <svg v-if="selected" class="h-3 w-3 text-white" viewBox="0 0 12 12" fill="none">
                    <path d="M2 6l3 3 5-5" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
            </div>
        </div>

        <!-- Badges (top right) -->
        <div class="absolute top-2 right-2 flex flex-col gap-1 items-end">
            <div
                v-if="image.is_private"
                class="flex size-5 items-center justify-center rounded-full bg-black/60 transition-opacity"
                :class="hovered ? 'opacity-0' : 'opacity-100'"
                title="Private"
            >
                <Lock class="h-2.5 w-2.5 text-white" />
            </div>
            <div
                v-if="image.exif_stripped"
                class="flex size-5 items-center justify-center rounded-full bg-green-500/80 transition-opacity"
                :class="hovered ? 'opacity-0' : 'opacity-100'"
                title="EXIF stripped"
            >
                <Shield class="h-2.5 w-2.5 text-white" />
            </div>
        </div>

        <!-- Hover overlay -->
        <div
            class="absolute inset-0 bg-gradient-to-t from-black/70 via-black/20 to-transparent flex flex-col justify-between p-2.5 transition-opacity duration-200"
            :class="hovered ? 'opacity-100' : 'opacity-0'"
        >
            <!-- Top actions -->
            <div class="flex justify-end gap-1">
                <button
                    class="flex size-7 items-center justify-center rounded-full bg-black/50 hover:bg-[#7B2FFF] text-white transition-colors"
                    title="Share"
                    @click.stop="emit('share', image)"
                >
                    <Share2 class="h-3.5 w-3.5" />
                </button>
                <button
                    class="flex size-7 items-center justify-center rounded-full bg-black/50 hover:bg-red-500 text-white transition-colors"
                    title="Delete"
                    @click.stop="emit('delete', image)"
                >
                    <Trash2 class="h-3.5 w-3.5" />
                </button>
            </div>

            <!-- Bottom info -->
            <div>
                <p class="text-white text-xs font-medium truncate leading-tight">{{ image.name }}</p>
                <div class="flex items-center gap-2 mt-0.5">
                    <span class="text-white/60 text-xs">{{ image.size_human }}</span>
                    <span v-if="image.width && image.height" class="text-white/40 text-xs">
                        {{ image.width }}×{{ image.height }}
                    </span>
                    <span v-if="image.is_private" class="flex items-center gap-0.5 text-white/60 text-xs">
                        <Eye class="h-2.5 w-2.5" /> Private
                    </span>
                </div>
            </div>
        </div>

        <!-- Selected overlay -->
        <div
            v-if="selected"
            class="absolute inset-0 bg-[#7B2FFF]/10 pointer-events-none"
        />
    </div>
</template>
