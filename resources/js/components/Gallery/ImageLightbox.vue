<script setup lang="ts">
import { Download, ExternalLink, Info, Shield, Share2, X } from 'lucide-vue-next';
import { computed, onMounted, onUnmounted, ref, watch } from 'vue';
import ExpiringLinkModal from '@/components/Shared/ExpiringLinkModal.vue';
import type { ImageResource } from '@/types';

const props = defineProps<{
    images:       ImageResource[];
    initialIndex: number;
    open:         boolean;
}>();

const emit = defineEmits<{
    'update:open': [value: boolean];
    delete:        [image: ImageResource];
}>();

const currentIndex = ref(props.initialIndex);
const showInfo     = ref(false);
const showShare    = ref(false);

const current = computed(() => props.images[currentIndex.value] ?? null);
const hasPrev  = computed(() => currentIndex.value > 0);
const hasNext  = computed(() => currentIndex.value < props.images.length - 1);

watch(() => props.initialIndex, (val) => { currentIndex.value = val; });
watch(() => props.open, (val) => { if (!val) showInfo.value = false; });

function prev() { if (hasPrev.value) currentIndex.value--; }
function next() { if (hasNext.value) currentIndex.value++; }

function close() { emit('update:open', false); }

function download() {
    if (!current.value) return;
    const a = document.createElement('a');
    a.href     = current.value.url;
    a.download = current.value.original_name;
    a.click();
}

function onKeydown(e: KeyboardEvent) {
    if (!props.open) return;
    if (e.key === 'Escape')      close();
    if (e.key === 'ArrowLeft')   prev();
    if (e.key === 'ArrowRight')  next();
    if (e.key === 'i')           showInfo.value = !showInfo.value;
}

onMounted(() => window.addEventListener('keydown', onKeydown));
onUnmounted(() => window.removeEventListener('keydown', onKeydown));
</script>

<template>
    <Teleport to="body">
        <Transition name="lightbox">
            <div
                v-if="open && current"
                class="fixed inset-0 z-50 flex items-center justify-center bg-black/95"
                @click.self="close"
            >
                <!-- Top bar -->
                <div class="absolute top-0 left-0 right-0 flex items-center justify-between px-4 py-3 bg-gradient-to-b from-black/60 to-transparent z-10">
                    <div class="flex items-center gap-2 min-w-0">
                        <p class="text-white text-sm font-medium truncate max-w-xs">{{ current.name }}</p>
                        <span class="text-white/40 text-xs shrink-0">
                            {{ currentIndex + 1 }} / {{ images.length }}
                        </span>
                    </div>
                    <div class="flex items-center gap-1">
                        <!-- Info toggle -->
                        <button
                            @click="showInfo = !showInfo"
                            class="flex size-8 items-center justify-center rounded-full text-white/70 hover:text-white hover:bg-white/10 transition-colors"
                            title="Info (i)"
                        >
                            <Info class="h-4 w-4" />
                        </button>
                        <!-- Share -->
                        <button
                            @click="showShare = true"
                            class="flex size-8 items-center justify-center rounded-full text-white/70 hover:text-white hover:bg-white/10 transition-colors"
                            title="Share"
                        >
                            <Share2 class="h-4 w-4" />
                        </button>
                        <!-- Download -->
                        <button
                            @click="download"
                            class="flex size-8 items-center justify-center rounded-full text-white/70 hover:text-white hover:bg-white/10 transition-colors"
                            title="Download"
                        >
                            <Download class="h-4 w-4" />
                        </button>
                        <!-- Open full -->
                        <a :href="`/images/${current.id}`">
                            <button
                                class="flex size-8 items-center justify-center rounded-full text-white/70 hover:text-white hover:bg-white/10 transition-colors"
                                title="Open page"
                            >
                                <ExternalLink class="h-4 w-4" />
                            </button>
                        </a>
                        <!-- Close -->
                        <button
                            @click="close"
                            class="flex size-8 items-center justify-center rounded-full text-white/70 hover:text-white hover:bg-white/10 transition-colors ml-1"
                            title="Close (Esc)"
                        >
                            <X class="h-5 w-5" />
                        </button>
                    </div>
                </div>

                <!-- Prev button -->
                <button
                    v-if="hasPrev"
                    class="absolute left-3 top-1/2 -translate-y-1/2 z-10 flex size-10 items-center justify-center rounded-full bg-black/40 hover:bg-black/70 text-white transition-colors text-xl"
                    @click.stop="prev"
                >
                    ‹
                </button>

                <!-- Main image -->
                <div class="max-w-[90vw] max-h-[85vh] flex items-center justify-center px-14">
                    <Transition name="image-fade" mode="out-in">
                        <img
                            :key="current.id"
                            :src="current.url"
                            :alt="current.name"
                            class="max-w-full max-h-[85vh] object-contain rounded-lg select-none"
                            draggable="false"
                        />
                    </Transition>
                </div>

                <!-- Next button -->
                <button
                    v-if="hasNext"
                    class="absolute right-3 top-1/2 -translate-y-1/2 z-10 flex size-10 items-center justify-center rounded-full bg-black/40 hover:bg-black/70 text-white transition-colors text-xl"
                    @click.stop="next"
                >
                    ›
                </button>

                <!-- Info panel -->
                <Transition name="slide-right">
                    <div
                        v-if="showInfo"
                        class="absolute right-0 top-0 bottom-0 w-72 bg-[#111] border-l border-white/10 p-5 overflow-y-auto z-10"
                    >
                        <h3 class="text-white font-semibold mb-4">Image info</h3>
                        <div class="space-y-3 text-sm">
                            <div class="flex justify-between">
                                <span class="text-white/50">Name</span>
                                <span class="text-white truncate ml-4 max-w-[140px]">{{ current.name }}</span>
                            </div>
                            <div class="flex justify-between">
                                <span class="text-white/50">Size</span>
                                <span class="text-white">{{ current.size_human }}</span>
                            </div>
                            <div v-if="current.width && current.height" class="flex justify-between">
                                <span class="text-white/50">Dimensions</span>
                                <span class="text-white">{{ current.width }}×{{ current.height }}</span>
                            </div>
                            <div class="flex justify-between">
                                <span class="text-white/50">Type</span>
                                <span class="text-white">{{ current.mime_type }}</span>
                            </div>
                            <div class="flex justify-between">
                                <span class="text-white/50">Uploaded</span>
                                <span class="text-white text-xs">{{ current.created_at }}</span>
                            </div>
                            <div class="flex justify-between items-center">
                                <span class="text-white/50">EXIF</span>
                                <span class="flex items-center gap-1 text-xs" :class="current.exif_stripped ? 'text-green-400' : 'text-white/40'">
                                    <Shield v-if="current.exif_stripped" class="h-3 w-3" />
                                    {{ current.exif_stripped ? 'Stripped' : 'Not stripped' }}
                                </span>
                            </div>
                            <div class="flex justify-between">
                                <span class="text-white/50">Visibility</span>
                                <span class="text-white">{{ current.is_private ? 'Private' : 'Visible' }}</span>
                            </div>
                        </div>

                        <!-- Delete from info panel -->
                        <button
                            @click="emit('delete', current)"
                            class="mt-6 w-full py-2 rounded-lg border border-red-500/30 bg-red-500/10 text-red-400 text-sm font-medium hover:bg-red-500/20 transition-colors"
                        >
                            Delete image
                        </button>
                    </div>
                </Transition>

                <!-- Bottom dots -->
                <div
                    v-if="images.length > 1 && images.length <= 20"
                    class="absolute bottom-4 left-1/2 -translate-x-1/2 flex gap-1.5"
                >
                    <button
                        v-for="(_, i) in images"
                        :key="i"
                        class="rounded-full transition-all duration-200"
                        :class="i === currentIndex
                            ? 'w-4 h-1.5 bg-white'
                            : 'w-1.5 h-1.5 bg-white/30 hover:bg-white/60'"
                        @click.stop="currentIndex = i"
                    />
                </div>
            </div>
        </Transition>
    </Teleport>

    <!-- Share modal -->
    <ExpiringLinkModal
        v-if="current"
        v-model:open="showShare"
        :image-id="current.id"
        :image-name="current.name"
    />
</template>

<style scoped>
.lightbox-enter-active,
.lightbox-leave-active {
    transition: opacity 0.2s ease;
}
.lightbox-enter-from,
.lightbox-leave-to {
    opacity: 0;
}

.image-fade-enter-active,
.image-fade-leave-active {
    transition: opacity 0.15s ease;
}
.image-fade-enter-from,
.image-fade-leave-to {
    opacity: 0;
}

.slide-right-enter-active,
.slide-right-leave-active {
    transition: transform 0.25s ease, opacity 0.25s ease;
}
.slide-right-enter-from,
.slide-right-leave-to {
    transform: translateX(100%);
    opacity: 0;
}
</style>
