<script setup lang="ts">
import { Head, Link } from '@inertiajs/vue3';
import AppLayout from '@/layouts/AppLayout.vue';
import { dashboard } from '@/routes';
import type { BreadcrumbItem } from '@/types';
import { ref, onMounted, computed } from 'vue';

const props = defineProps<{
    user: {
        id: number;
        name: string;
        email: string;
        avatar: string;
        storage_used_human: string;
        storage_limit: number;
        storage_percent: number;
    };
    recentImages: { data: any[] };
    stats: {
        total_images: number;
        storage_percent: number;
        shared_links: number;
    };
}>();

const breadcrumbs: BreadcrumbItem[] = [{ title: 'Dashboard', href: dashboard() }];

// ── Storage display ────────────────────────────────────────────────
// storage_used_human comes pre-formatted from the Laravel model accessor.
// storage_limit is raw bytes from the plan — format it here.
function formatBytes(bytes: number): string {
    if (!bytes || bytes === 0) return '0 B';
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    const i = Math.min(Math.floor(Math.log(bytes) / Math.log(1024)), units.length - 1);
    const val = bytes / Math.pow(1024, i);
    return `${Number.isInteger(val) ? val : val.toFixed(2)} ${units[i]}`;
}

const storageUsed  = computed(() => props.user.storage_used_human ?? '0 B');
const storageLimit = computed(() => formatBytes(props.user.storage_limit ?? 0));

// ── Animated counters ──────────────────────────────────────────────
const animatedImages  = ref(0);
const animatedLinks   = ref(0);
const animatedPercent = ref(0);
const mounted         = ref(false);

function animateCounter(target: number, setter: (v: number) => void, duration = 1200) {
    const start = performance.now();
    const step  = (now: number) => {
        const progress = Math.min((now - start) / duration, 1);
        const ease     = 1 - Math.pow(1 - progress, 3);
        setter(Math.round(target * ease));
        if (progress < 1) requestAnimationFrame(step);
    };
    requestAnimationFrame(step);
}

onMounted(() => {
    setTimeout(() => {
        mounted.value = true;
        animateCounter(props.stats.total_images,    v => animatedImages.value  = v);
        animateCounter(props.stats.shared_links,    v => animatedLinks.value   = v);
        animateCounter(props.user.storage_percent ?? 0, v => animatedPercent.value = v, 1400);
    }, 100);
});

// ── Donut chart ────────────────────────────────────────────────────
// Random unique ID prevents scoped-CSS from mangling the gradient reference
const uid    = Math.random().toString(36).slice(2, 8);
const gradId = `sg-${uid}`;
const SIZE   = 130;
const STROKE = 15;
const R      = (SIZE - STROKE) / 2;
const CIRCUM = 2 * Math.PI * R;

const usedDash = computed(() => {
    const pct = Math.min(animatedPercent.value, 100) / 100;
    return `${(pct * CIRCUM).toFixed(2)} ${CIRCUM.toFixed(2)}`;
});
</script>

<template>
    <Head title="Dashboard" />

    <AppLayout :breadcrumbs="breadcrumbs">
        <div class="flex h-full flex-1 flex-col gap-6 p-6">

            <!-- ── Welcome banner ──────────────────────────────────── -->
            <div
                class="relative overflow-hidden rounded-2xl px-8 py-7"
                style="background: linear-gradient(135deg, #7B2FFF 0%, #3b82f6 55%, #00C6FF 100%)"
                :class="mounted ? 'banner-in' : 'opacity-0'"
            >
                <div class="pointer-events-none absolute -right-12 -top-12 h-52 w-52 rounded-full bg-white/10" />
                <div class="pointer-events-none absolute -bottom-10 right-28 h-32 w-32 rounded-full bg-white/10" />
                <div class="pointer-events-none absolute right-64 -top-6 h-20 w-20 rounded-full bg-white/5" />

                <p class="text-base font-medium text-white/70 mb-1">Welcome back</p>
                <h1 class="text-3xl font-bold text-white tracking-tight flex items-center gap-3">
                    {{ props.user?.name ?? 'there' }}
                    <span style="display:inline-block;transform-origin:70% 70%;animation:waveHand 2.2s ease-in-out 0.6s 3 both" aria-hidden="true">👋</span>
                </h1>
                <p class="mt-2 text-sm text-white/60">Here's what's happening with your files today.</p>
            </div>

            <!-- ── Stat cards ──────────────────────────────────────── -->
            <div class="grid gap-4 sm:grid-cols-3">

                <!-- Total images -->
                <div
                    class="stat-card rounded-2xl border border-border bg-card p-6 flex flex-col gap-4"
                    :class="mounted ? 'card-in' : 'opacity-0'"
                    style="animation-delay: 0.05s"
                >
                    <div class="flex items-center justify-between">
                        <span class="text-sm font-semibold uppercase tracking-widest text-muted-foreground">Total Images</span>
                        <span class="flex h-9 w-9 items-center justify-center rounded-xl bg-violet-500/15">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-violet-400" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                                <rect x="3" y="3" width="18" height="18" rx="2"/>
                                <circle cx="8.5" cy="8.5" r="1.5"/>
                                <polyline points="21 15 16 10 5 21"/>
                            </svg>
                        </span>
                    </div>
                    <span class="text-5xl font-bold tabular-nums text-foreground leading-none">{{ animatedImages }}</span>
                    <div class="h-1.5 w-full rounded-full bg-muted overflow-hidden mt-auto">
                        <div
                            class="h-full rounded-full bg-gradient-to-r from-violet-500 to-fuchsia-400"
                            style="transition: width 1.2s cubic-bezier(0.34,1.56,0.64,1)"
                            :style="{ width: mounted ? '100%' : '0%' }"
                        />
                    </div>
                </div>

                <!-- Storage donut -->
                <div
                    class="stat-card rounded-2xl border border-border bg-card p-6 flex flex-col gap-4"
                    :class="mounted ? 'card-in' : 'opacity-0'"
                    style="animation-delay: 0.12s"
                >
                    <div class="flex items-center justify-between">
                        <span class="text-sm font-semibold uppercase tracking-widest text-muted-foreground">Storage</span>
                        <span class="flex h-9 w-9 items-center justify-center rounded-xl bg-cyan-500/15">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-cyan-400" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                                <ellipse cx="12" cy="5" rx="9" ry="3"/>
                                <path d="M21 12c0 1.66-4 3-9 3s-9-1.34-9-3"/>
                                <path d="M3 5v14c0 1.66 4 3 9 3s9-1.34 9-3V5"/>
                            </svg>
                        </span>
                    </div>

                    <div class="flex items-center gap-5">
                        <!--
                            Donut SVG
                            IMPORTANT: The <defs> gradient is defined inline with a unique
                            runtime ID so Vue's scoped-CSS hashing never breaks the url() ref.
                        -->
                        <div class="relative shrink-0" :style="`width:${SIZE}px;height:${SIZE}px`">
                            <svg
                                :width="SIZE"
                                :height="SIZE"
                                :viewBox="`0 0 ${SIZE} ${SIZE}`"
                                style="transform: rotate(-90deg); display: block;"
                            >
                                <defs>
                                    <linearGradient :id="gradId" x1="0%" y1="0%" x2="100%" y2="0%">
                                        <stop offset="0%"   stop-color="#7B2FFF" />
                                        <stop offset="100%" stop-color="#00C6FF" />
                                    </linearGradient>
                                </defs>
                                <!-- track -->
                                <circle
                                    :cx="SIZE / 2" :cy="SIZE / 2" :r="R"
                                    fill="none"
                                    stroke="#e5e7eb"
                                    :stroke-width="STROKE"
                                />
                                <!-- filled arc -->
                                <circle
                                    :cx="SIZE / 2" :cy="SIZE / 2" :r="R"
                                    fill="none"
                                    :stroke="`url(#${gradId})`"
                                    :stroke-width="STROKE"
                                    stroke-linecap="round"
                                    :stroke-dasharray="usedDash"
                                    style="transition: stroke-dasharray 1.4s cubic-bezier(0.34,1.56,0.64,1)"
                                />
                            </svg>
                            <!-- centre label -->
                            <div class="absolute inset-0 flex flex-col items-center justify-center" style="pointer-events:none">
                                <span class="text-2xl font-bold tabular-nums text-foreground leading-none">{{ animatedPercent }}%</span>
                                <span class="text-xs text-muted-foreground mt-1">used</span>
                            </div>
                        </div>

                        <!-- Storage legend -->
                        <div class="flex flex-col gap-3 min-w-0">
                            <div>
                                <p class="text-base font-bold text-foreground leading-tight">{{ storageUsed }}</p>
                                <p class="text-sm text-muted-foreground mt-0.5">of {{ storageLimit }}</p>
                            </div>
                            <div class="flex flex-col gap-2">
                                <div class="flex items-center gap-2">
                                    <span class="h-2.5 w-2.5 rounded-full shrink-0" style="background: linear-gradient(135deg,#7B2FFF,#00C6FF)" />
                                    <span class="text-sm text-muted-foreground">Used</span>
                                </div>
                                <div class="flex items-center gap-2">
                                    <span class="h-2.5 w-2.5 rounded-full shrink-0 bg-gray-200 dark:bg-gray-700" />
                                    <span class="text-sm text-muted-foreground">Free</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Active links -->
                <div
                    class="stat-card rounded-2xl border border-border bg-card p-6 flex flex-col gap-4"
                    :class="mounted ? 'card-in' : 'opacity-0'"
                    style="animation-delay: 0.19s"
                >
                    <div class="flex items-center justify-between">
                        <span class="text-sm font-semibold uppercase tracking-widest text-muted-foreground">Active Links</span>
                        <span class="flex h-9 w-9 items-center justify-center rounded-xl bg-emerald-500/15">
                            <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-emerald-400" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71"/>
                                <path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71"/>
                            </svg>
                        </span>
                    </div>
                    <span class="text-5xl font-bold tabular-nums text-foreground leading-none">{{ animatedLinks }}</span>
                    <Link
                        href="/shared-links"
                        class="mt-auto text-sm font-medium text-emerald-400 hover:text-emerald-300 transition-colors"
                    >
                        Manage links →
                    </Link>
                </div>
            </div>

            <!-- ── Recent uploads ──────────────────────────────────── -->
            <div
                class="rounded-2xl border border-border bg-card p-6"
                :class="mounted ? 'card-in' : 'opacity-0'"
                style="animation-delay: 0.28s"
            >
                <div class="mb-5 flex items-center justify-between">
                    <h2 class="text-lg font-semibold text-foreground">Recent Uploads</h2>
                    <Link href="/images" class="text-sm font-medium text-violet-400 hover:text-violet-300 transition-colors">
                        View all →
                    </Link>
                </div>

                <div
                    v-if="recentImages.data.length > 0"
                    class="grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5"
                >
                    <div
                        v-for="(image, i) in recentImages.data"
                        :key="image.id"
                        class="image-tile group relative aspect-square overflow-hidden rounded-xl bg-muted border border-border cursor-pointer"
                        :style="{ animationDelay: `${0.3 + i * 0.05}s` }"
                        :class="mounted ? 'tile-in' : 'opacity-0'"
                    >
                        <img
                            :src="image.thumbnail_url"
                            :alt="image.name"
                            class="h-full w-full object-cover transition-transform duration-500 group-hover:scale-110"
                            loading="lazy"
                        />
                        <div class="absolute inset-0 flex flex-col justify-end bg-gradient-to-t from-black/70 via-black/20 to-transparent p-3 opacity-0 transition-opacity duration-300 group-hover:opacity-100">
                            <span class="truncate text-xs font-medium text-white">{{ image.name }}</span>
                            <span class="text-[10px] text-white/60 mt-0.5">{{ image.size_human }}</span>
                        </div>
                    </div>
                </div>

                <div v-else class="flex flex-col items-center justify-center py-16 text-center">
                    <div class="mb-4 flex h-16 w-16 items-center justify-center rounded-2xl bg-muted">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8 text-muted-foreground" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                            <rect x="3" y="3" width="18" height="18" rx="2"/>
                            <circle cx="8.5" cy="8.5" r="1.5"/>
                            <polyline points="21 15 16 10 5 21"/>
                        </svg>
                    </div>
                    <p class="font-medium text-foreground mb-1">No images yet</p>
                    <p class="text-sm text-muted-foreground mb-4">Start by uploading your first file.</p>
                    <Link
                        href="/images/create"
                        class="rounded-xl bg-gradient-to-r from-violet-500 to-cyan-400 px-5 py-2 text-sm font-semibold text-white hover:opacity-90 transition-opacity"
                    >
                        Upload images
                    </Link>
                </div>
            </div>

        </div>
    </AppLayout>
</template>

<style scoped>
.banner-in {
    animation: slideDown 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) both;
}
@keyframes slideDown {
    from { opacity: 0; transform: translateY(-16px); }
    to   { opacity: 1; transform: translateY(0); }
}

.card-in {
    animation: fadeUp 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) both;
}
@keyframes fadeUp {
    from { opacity: 0; transform: translateY(20px); }
    to   { opacity: 1; transform: translateY(0); }
}

.tile-in {
    animation: popIn 0.4s cubic-bezier(0.34, 1.56, 0.64, 1) both;
}
@keyframes popIn {
    from { opacity: 0; transform: scale(0.88); }
    to   { opacity: 1; transform: scale(1); }
}

.stat-card {
    transition: transform 0.2s ease, box-shadow 0.2s ease;
}
.stat-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 12px 32px -8px rgba(123, 47, 255, 0.18);
}

/* Waving hand */

</style>

<style>
/* Wave keyframe — must be global (not scoped) so inline animation: ref works */
@keyframes waveHand {
    0%   { transform: rotate(0deg); }
    10%  { transform: rotate(14deg); }
    20%  { transform: rotate(-8deg); }
    30%  { transform: rotate(14deg); }
    40%  { transform: rotate(-4deg); }
    50%  { transform: rotate(10deg); }
    60%  { transform: rotate(0deg); }
    100% { transform: rotate(0deg); }
}
</style>