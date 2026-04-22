<script setup lang="ts">
import { Head, Link } from '@inertiajs/vue3';
import AppLayout from '@/layouts/AppLayout.vue';
import { dashboard } from '@/routes';
import type { BreadcrumbItem } from '@/types';
import { ref, onMounted, computed } from 'vue';

const props = defineProps<{
    user: any;
    recentImages: { data: any[] };
    stats: {
        total_images: number;
        storage_used: string;
        storage_limit: string;
        storage_percent: number;
        shared_links: number;
    };
}>();

const breadcrumbs: BreadcrumbItem[] = [{ title: 'Dashboard', href: dashboard() }];

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
        animateCounter(props.stats.storage_percent, v => animatedPercent.value = v, 1400);
    }, 100);
});

// ── Donut chart ────────────────────────────────────────────────────
const SIZE   = 120;
const STROKE = 14;
const R      = (SIZE - STROKE) / 2;
const CIRCUM = 2 * Math.PI * R;
const gradId = 'storageGrad';

const usedDash = computed(() => {
    const pct = Math.min(animatedPercent.value, 100) / 100;
    return `${pct * CIRCUM} ${CIRCUM}`;
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

                <p class="text-sm font-medium text-white/70 mb-1">Welcome back</p>
                <h1 class="text-2xl font-bold text-white tracking-tight">{{ user.name }} 👋</h1>
                <p class="mt-1 text-sm text-white/60">Here's what's happening with your files today.</p>
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
                        <span class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">Total Images</span>
                        <span class="flex h-9 w-9 items-center justify-center rounded-xl bg-violet-500/15 text-lg">🖼️</span>
                    </div>
                    <span class="text-5xl font-bold tabular-nums text-foreground leading-none">{{ animatedImages }}</span>
                    <div class="h-1.5 w-full rounded-full bg-muted overflow-hidden mt-auto">
                        <div
                            class="h-full rounded-full bg-gradient-to-r from-violet-500 to-fuchsia-400 transition-all duration-[1200ms] ease-out"
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
                        <span class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">Storage</span>
                        <span class="flex h-9 w-9 items-center justify-center rounded-xl bg-cyan-500/15 text-lg">💾</span>
                    </div>

                    <div class="flex items-center gap-4">
                        <!-- Donut -->
                        <div class="relative shrink-0" :style="`width:${SIZE}px;height:${SIZE}px`">
                            <svg :width="SIZE" :height="SIZE" style="transform:rotate(-90deg);overflow:visible">
                                <defs>
                                    <linearGradient :id="gradId" x1="0%" y1="0%" x2="100%" y2="0%">
                                        <stop offset="0%"   stop-color="#7B2FFF" />
                                        <stop offset="100%" stop-color="#00C6FF" />
                                    </linearGradient>
                                </defs>
                                <!-- track -->
                                <circle
                                    :cx="SIZE/2" :cy="SIZE/2" :r="R"
                                    fill="none"
                                    class="text-muted stroke-current"
                                    :stroke-width="STROKE"
                                    stroke-opacity="0.3"
                                />
                                <!-- filled arc -->
                                <circle
                                    :cx="SIZE/2" :cy="SIZE/2" :r="R"
                                    fill="none"
                                    :stroke="`url(#${gradId})`"
                                    :stroke-width="STROKE"
                                    stroke-linecap="round"
                                    :stroke-dasharray="usedDash"
                                    style="transition: stroke-dasharray 1.4s cubic-bezier(0.34,1.56,0.64,1)"
                                />
                            </svg>
                            <!-- centre label -->
                            <div class="absolute inset-0 flex flex-col items-center justify-center pointer-events-none">
                                <span class="text-xl font-bold tabular-nums text-foreground leading-none">{{ animatedPercent }}%</span>
                                <span class="text-[10px] text-muted-foreground mt-0.5">used</span>
                            </div>
                        </div>

                        <!-- Legend -->
                        <div class="flex flex-col gap-2 min-w-0">
                            <div>
                                <p class="text-sm font-semibold text-foreground">{{ stats.storage_used }}</p>
                                <p class="text-xs text-muted-foreground">of {{ stats.storage_limit }}</p>
                            </div>
                            <div class="flex flex-col gap-1.5 mt-1">
                                <div class="flex items-center gap-1.5">
                                    <span class="inline-block h-2 w-2 rounded-full bg-gradient-to-br from-violet-500 to-cyan-400 shrink-0" />
                                    <span class="text-xs text-muted-foreground">Used</span>
                                </div>
                                <div class="flex items-center gap-1.5">
                                    <span class="inline-block h-2 w-2 rounded-full bg-muted shrink-0" />
                                    <span class="text-xs text-muted-foreground">Free</span>
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
                        <span class="text-xs font-semibold uppercase tracking-widest text-muted-foreground">Active Links</span>
                        <span class="flex h-9 w-9 items-center justify-center rounded-xl bg-emerald-500/15 text-lg">🔗</span>
                    </div>
                    <span class="text-5xl font-bold tabular-nums text-foreground leading-none">{{ animatedLinks }}</span>
                    <Link
                        href="/shared-links"
                        class="mt-auto text-xs font-medium text-emerald-400 hover:text-emerald-300 transition-colors inline-flex items-center gap-1"
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
                    <h2 class="text-base font-semibold text-foreground">Recent Uploads</h2>
                    <Link
                        href="/images"
                        class="text-xs font-medium text-violet-400 hover:text-violet-300 transition-colors"
                    >
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
                    <div class="mb-4 flex h-16 w-16 items-center justify-center rounded-2xl bg-muted text-3xl">📸</div>
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
/* Banner slide-in */
.banner-in {
    animation: slideDown 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) both;
}
@keyframes slideDown {
    from { opacity: 0; transform: translateY(-16px); }
    to   { opacity: 1; transform: translateY(0); }
}

/* Cards */
.card-in {
    animation: fadeUp 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) both;
}
@keyframes fadeUp {
    from { opacity: 0; transform: translateY(20px); }
    to   { opacity: 1; transform: translateY(0); }
}

/* Image tiles */
.tile-in {
    animation: popIn 0.4s cubic-bezier(0.34, 1.56, 0.64, 1) both;
}
@keyframes popIn {
    from { opacity: 0; transform: scale(0.88); }
    to   { opacity: 1; transform: scale(1); }
}

/* Card hover lift */
.stat-card {
    transition: transform 0.2s ease, box-shadow 0.2s ease;
}
.stat-card:hover {
    transform: translateY(-3px);
    box-shadow: 0 12px 32px -8px rgba(123, 47, 255, 0.18);
}
</style>