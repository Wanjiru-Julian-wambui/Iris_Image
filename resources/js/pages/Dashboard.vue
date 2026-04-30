<script setup lang="ts">
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, computed } from 'vue';
import { Image, HardDrive, Link2, Eye, TrendingUp } from 'lucide-vue-next';
import AppLayout from '@/layouts/AppLayout.vue';
import { Bar, Line } from 'vue-chartjs';
import {
    Chart as ChartJS,
    CategoryScale, LinearScale,
    BarElement, LineElement, PointElement,
    Filler, Tooltip, Legend,
    type ChartOptions,
} from 'chart.js';
import type { BreadcrumbItem } from '@/types';

ChartJS.register(
    CategoryScale, LinearScale,
    BarElement, LineElement, PointElement,
    Filler, Tooltip, Legend,
);

const breadcrumbs: BreadcrumbItem[] = [{ title: 'Dashboard', href: '/dashboard' }];

const props = defineProps<{
    stats: {
        total_images: number;
        total_albums: number;
        total_links: number;
        total_views: number;
        storage_used: string;
        storage_percent: number;
        storage_limit?: number;
    };
    uploadHistory: { date: string; count: number }[];
    storageTrend:  { date: string; bytes: number }[];
    linkViews:     { date: string; views: number }[];
    recentImages?: { data: any[] };
    user?: {
        name: string;
        storage_limit?: number;
    };
}>();

// ── Formatting helpers ──────────────────────────────────────────────────────

function formatBytes(bytes: number): string {
    if (!bytes || bytes === 0) return '0 B';
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    const i = Math.min(Math.floor(Math.log(bytes) / Math.log(1024)), units.length - 1);
    const val = bytes / Math.pow(1024, i);
    return `${Number.isInteger(val) ? val : val.toFixed(2)} ${units[i]}`;
}

function formatDate(dateStr: string): string {
    const d = new Date(dateStr);
    return d.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
}

const storageLimit = computed(() =>
    props.stats.storage_limit ? formatBytes(props.stats.storage_limit) :
    props.user?.storage_limit  ? formatBytes(props.user.storage_limit)  : null
);

const actualPercent = computed(() => {
    const raw = props.stats.storage_percent ?? 0;
    return Math.round(raw * 100) / 100;
});

const arcPercent = computed(() => {
    const raw = props.stats.storage_percent ?? 0;
    if (raw > 0 && raw < 0.5) return 0.5;
    return raw;
});

// ── Animated counters ───────────────────────────────────────────────────────

const animatedImages = ref(0);
const animatedLinks  = ref(0);
const animatedViews  = ref(0);
const animatedArcPct = ref(0);
const mounted        = ref(false);
const waving         = ref(false);

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

function animateFloat(target: number, setter: (v: number) => void, duration = 1400) {
    const start = performance.now();
    const step  = (now: number) => {
        const progress = Math.min((now - start) / duration, 1);
        const ease     = 1 - Math.pow(1 - progress, 3);
        setter(Math.round(target * ease * 100) / 100);
        if (progress < 1) requestAnimationFrame(step);
    };
    requestAnimationFrame(step);
}

onMounted(() => {
    setTimeout(() => {
        mounted.value = true;
        waving.value  = true;
        setTimeout(() => { waving.value = false; }, 7000);

        animateCounter(props.stats.total_images, v => animatedImages.value = v);
        animateCounter(props.stats.total_links,  v => animatedLinks.value  = v);
        animateCounter(props.stats.total_views,  v => animatedViews.value  = v);
        animateFloat(arcPercent.value,           v => animatedArcPct.value = v);
    }, 100);
});

// ── Storage donut ───────────────────────────────────────────────────────────

const uid    = Math.random().toString(36).slice(2, 8);
const gradId = `sg-${uid}`;
const SIZE   = 120;
const STROKE = 18;
const R      = (SIZE - STROKE) / 2;
const CIRCUM = 2 * Math.PI * R;

const usedDash = computed(() => {
    const pct = Math.min(animatedArcPct.value, 100) / 100;
    return `${(pct * CIRCUM).toFixed(2)} ${CIRCUM.toFixed(2)}`;
});

// ── Chart.js data & options ─────────────────────────────────────────────────

const uploadsChartData = computed(() => ({
    labels: props.uploadHistory.map(d => formatDate(d.date)),
    datasets: [{
        label: 'Uploads',
        data: props.uploadHistory.map(d => d.count),
        backgroundColor: '#8b5cf6',
        borderRadius: 4,
        maxBarThickness: 32,
    }],
}));

const storageChartData = computed(() => ({
    labels: props.storageTrend.map(d => formatDate(d.date)),
    datasets: [{
        label: 'Storage used',
        data: props.storageTrend.map(d => d.bytes),
        borderColor: '#22d3ee',
        backgroundColor: 'rgba(34,211,238,0.12)',
        fill: true,
        tension: 0.4,
        pointRadius: 2,
        pointHoverRadius: 4,
    }],
}));

const linkViewsChartData = computed(() => ({
    labels: props.linkViews.map(d => formatDate(d.date)),
    datasets: [{
        label: 'Link views',
        data: props.linkViews.map(d => d.views),
        borderColor: '#34d399',
        backgroundColor: 'rgba(52,211,153,0.12)',
        fill: true,
        tension: 0.4,
        pointRadius: 2,
        pointHoverRadius: 4,
    }],
}));

const barOptions: ChartOptions<'bar'> = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
        legend: { display: false },
        tooltip: {
            backgroundColor: '#1e1e2e',
            borderColor: 'rgba(255,255,255,0.1)',
            borderWidth: 1,
            titleColor: '#94a3b8',
            bodyColor: '#e2e8f0',
            cornerRadius: 8,
        },
    },
    scales: {
        x: {
            ticks: { color: '#94a3b8', font: { size: 10 }, maxTicksLimit: 7 },
            grid:  { display: false },
        },
        y: {
            ticks: { color: '#94a3b8', font: { size: 10 }, precision: 0 },
            grid:  { color: 'rgba(255,255,255,0.05)' },
        },
    },
};

const lineOptions: ChartOptions<'line'> = {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
        legend: { display: false },
        tooltip: {
            backgroundColor: '#1e1e2e',
            borderColor: 'rgba(255,255,255,0.1)',
            borderWidth: 1,
            titleColor: '#94a3b8',
            bodyColor: '#e2e8f0',
            cornerRadius: 8,
        },
    },
    scales: {
        x: {
            ticks: { color: '#94a3b8', font: { size: 10 }, maxTicksLimit: 7 },
            grid:  { display: false },
        },
        y: {
            ticks: { color: '#94a3b8', font: { size: 10 } },
            grid:  { color: 'rgba(255,255,255,0.05)' },
        },
    },
};

const storageLineOptions = computed<ChartOptions<'line'>>(() => ({
    ...lineOptions,
    plugins: {
        ...lineOptions.plugins,
        tooltip: {
            ...lineOptions.plugins?.tooltip,
            callbacks: {
                label: (ctx) => formatBytes(ctx.parsed.y),
            },
        },
    },
    scales: {
        x: lineOptions.scales?.x,
        y: {
            ticks: {
                color: '#94a3b8',
                font: { size: 10 },
                callback: (val) => formatBytes(Number(val)),
            },
            grid: { color: 'rgba(255,255,255,0.05)' },
        },
    },
}));
</script>

<template>
    <Head title="Dashboard" />
    <AppLayout :breadcrumbs="breadcrumbs">
        <div class="flex h-full flex-1 flex-col gap-6 p-6">

            <!-- Hero Banner -->
            <div
                class="relative overflow-hidden rounded-2xl px-8 py-7 bg-gradient-to-br from-violet-600 via-blue-500 to-cyan-400"
                :class="mounted ? 'banner-in' : 'opacity-0'"
            >
                <div class="pointer-events-none absolute -right-12 -top-12 h-52 w-52 rounded-full bg-white/10" />
                <div class="pointer-events-none absolute -bottom-10 right-28 h-32 w-32 rounded-full bg-white/10" />
                <p class="text-base font-medium text-white/70 mb-1">Welcome back</p>
                <h1 class="text-3xl font-bold text-white tracking-tight flex items-center gap-3">
                    {{ user?.name ?? 'there' }}
                    <span
                        class="wave-emoji"
                        :class="{ 'is-waving': waving }"
                        aria-hidden="true"
                        @mouseenter="waving = true"
                        @mouseleave="waving = false"
                    >👋</span>
                </h1>
                <p class="mt-2 text-sm text-white/60">Here's what's happening with your files today.</p>
            </div>

            <!-- Stat Cards -->
            <div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">

                <!-- Total Images -->
                <div
                    class="stat-card rounded-2xl border border-border bg-card p-6 flex flex-col gap-3"
                    :class="mounted ? 'card-in' : 'opacity-0'"
                    style="animation-delay: 0.05s"
                >
                    <div class="flex items-center gap-2 text-violet-400">
                        <Image class="h-4 w-4" />
                        <span class="text-xs font-bold uppercase tracking-widest text-muted-foreground">Images</span>
                    </div>
                    <span class="text-4xl font-bold tabular-nums">{{ animatedImages }}</span>
                </div>

                <!-- Storage Donut -->
                <div
                    class="stat-card rounded-2xl border border-border bg-card p-6 flex flex-col gap-3"
                    :class="mounted ? 'card-in' : 'opacity-0'"
                    style="animation-delay: 0.12s"
                >
                    <div class="flex items-center gap-2 text-cyan-400">
                        <HardDrive class="h-4 w-4" />
                        <span class="text-xs font-bold uppercase tracking-widest text-muted-foreground">Storage</span>
                    </div>
                    <div class="flex items-center gap-4">
                        <div class="relative shrink-0" :style="`width:${SIZE}px;height:${SIZE}px`">
                            <svg
                                :width="SIZE" :height="SIZE"
                                :viewBox="`0 0 ${SIZE} ${SIZE}`"
                                style="transform: rotate(-90deg);"
                            >
                                <defs>
                                    <linearGradient :id="gradId" x1="0%" y1="0%" x2="100%" y2="0%">
                                        <stop offset="0%" stop-color="#7B2FFF" />
                                        <stop offset="100%" stop-color="#00C6FF" />
                                    </linearGradient>
                                </defs>
                                <!-- Track ring -->
                                <circle
                                    :cx="SIZE / 2" :cy="SIZE / 2" :r="R"
                                    fill="none"
                                    stroke="#e5e7eb"
                                    :stroke-width="STROKE"
                                />
                                <!-- Progress arc -->
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
                            <div class="absolute inset-0 flex flex-col items-center justify-center pointer-events-none">
                                <span class="text-sm font-bold leading-none">{{ actualPercent }}%</span>
                            </div>
                        </div>
                        <div class="flex flex-col gap-1">
                            <p class="text-lg font-bold leading-tight">{{ stats.storage_used }}</p>
                            <p v-if="storageLimit" class="text-xs text-muted-foreground">of {{ storageLimit }}</p>
                        </div>
                    </div>
                </div>

                <!-- Active Links -->
                <div
                    class="stat-card rounded-2xl border border-border bg-card p-6 flex flex-col gap-3"
                    :class="mounted ? 'card-in' : 'opacity-0'"
                    style="animation-delay: 0.19s"
                >
                    <div class="flex items-center gap-2 text-cyan-400">
                        <Link2 class="h-4 w-4" />
                        <span class="text-xs font-bold uppercase tracking-widest text-muted-foreground">Links</span>
                    </div>
                    <span class="text-4xl font-bold tabular-nums">{{ animatedLinks }}</span>
                </div>

                <!-- Views -->
                <div
                    class="stat-card rounded-2xl border border-border bg-card p-6 flex flex-col gap-3"
                    :class="mounted ? 'card-in' : 'opacity-0'"
                    style="animation-delay: 0.26s"
                >
                    <div class="flex items-center gap-2 text-emerald-400">
                        <Eye class="h-4 w-4" />
                        <span class="text-xs font-bold uppercase tracking-widest text-muted-foreground">Views</span>
                    </div>
                    <span class="text-4xl font-bold tabular-nums">{{ animatedViews }}</span>
                </div>
            </div>

            <!-- Charts -->
            <div class="grid gap-4 lg:grid-cols-3">

                <!-- Upload History -->
                <div
                    class="rounded-2xl border border-border bg-card p-5"
                    :class="mounted ? 'card-in' : 'opacity-0'"
                    style="animation-delay: 0.33s"
                >
                    <h3 class="text-sm font-semibold mb-1 flex items-center gap-2">
                        <TrendingUp class="h-4 w-4 text-violet-400" />
                        Uploads per day
                    </h3>
                    <p class="text-xs text-muted-foreground mb-4">Last 30 days</p>
                    <div class="h-48">
                        <Bar :data="uploadsChartData" :options="barOptions" />
                    </div>
                </div>

                <!-- Storage Trend -->
                <div
                    class="rounded-2xl border border-border bg-card p-5"
                    :class="mounted ? 'card-in' : 'opacity-0'"
                    style="animation-delay: 0.40s"
                >
                    <h3 class="text-sm font-semibold mb-1 flex items-center gap-2">
                        <HardDrive class="h-4 w-4 text-cyan-400" />
                        Storage trend
                    </h3>
                    <p class="text-xs text-muted-foreground mb-4">Cumulative over time</p>
                    <div class="h-48">
                        <Line :data="storageChartData" :options="storageLineOptions" />
                    </div>
                </div>

                <!-- Link Views -->
                <div
                    class="rounded-2xl border border-border bg-card p-5"
                    :class="mounted ? 'card-in' : 'opacity-0'"
                    style="animation-delay: 0.47s"
                >
                    <h3 class="text-sm font-semibold mb-1 flex items-center gap-2">
                        <Eye class="h-4 w-4 text-emerald-400" />
                        Link views
                    </h3>
                    <p class="text-xs text-muted-foreground mb-4">Views per day</p>
                    <div class="h-48">
                        <Line :data="linkViewsChartData" :options="lineOptions" />
                    </div>
                </div>
            </div>

            <!-- Recent Uploads -->
            <div
                class="rounded-2xl border border-border bg-card p-6"
                :class="mounted ? 'card-in' : 'opacity-0'"
                style="animation-delay: 0.54s"
            >
                <div class="mb-5 flex items-center justify-between">
                    <h2 class="text-lg font-semibold">Recent Uploads</h2>
                    <Link href="/images" class="text-sm font-medium text-violet-400 hover:text-violet-300">
                        View all →
                    </Link>
                </div>

                <div
                    v-if="recentImages && recentImages.data.length > 0"
                    class="grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-4 xl:grid-cols-6"
                >
                    <div
                        v-for="(image, i) in recentImages.data"
                        :key="image.id"
                        class="group relative aspect-square overflow-hidden rounded-xl bg-muted border border-border cursor-pointer"
                        :style="{ animationDelay: `${0.6 + i * 0.05}s` }"
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
                        </div>
                    </div>
                </div>

                <div v-else class="flex flex-col items-center justify-center py-16 text-center gap-3">
                    <p class="font-medium text-foreground">No images yet</p>
                    <Link
                        href="/images/create"
                        class="rounded-xl bg-gradient-to-r from-violet-500 to-cyan-400 px-5 py-2 text-sm font-semibold text-white hover:opacity-90"
                    >
                        Upload images
                    </Link>
                </div>
            </div>

        </div>
    </AppLayout>
</template>

<style>
.wave-emoji {
    display: inline-block;
    transform-origin: 70% 70%;
    cursor: default;
    font-size: 1.8rem;
    line-height: 1;
}
.wave-emoji.is-waving {
    animation: wave-hand 2.2s ease-in-out 3;
}
@keyframes wave-hand {
    0%   { transform: rotate(  0deg); }
    10%  { transform: rotate( 14deg); }
    20%  { transform: rotate( -8deg); }
    30%  { transform: rotate( 14deg); }
    40%  { transform: rotate( -4deg); }
    50%  { transform: rotate( 10deg); }
    60%  { transform: rotate(  0deg); }
    100% { transform: rotate(  0deg); }
}
</style>

<style scoped>
.banner-in { animation: slideDown 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) both; }
@keyframes slideDown {
    from { opacity: 0; transform: translateY(-16px); }
    to   { opacity: 1; transform: translateY(0); }
}
.card-in { animation: fadeUp 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) both; }
@keyframes fadeUp {
    from { opacity: 0; transform: translateY(20px); }
    to   { opacity: 1; transform: translateY(0); }
}
.tile-in { animation: popIn 0.4s cubic-bezier(0.34, 1.56, 0.64, 1) both; }
@keyframes popIn {
    from { opacity: 0; transform: scale(0.88); }
    to   { opacity: 1; transform: scale(1); }
}
.stat-card { transition: transform 0.2s ease, box-shadow 0.2s ease; }
.stat-card:hover { transform: translateY(-3px); box-shadow: 0 12px 32px -8px rgba(123, 47, 255, 0.18); }
</style>