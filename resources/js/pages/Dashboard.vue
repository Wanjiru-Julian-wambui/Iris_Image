<script setup lang="ts">
import { Head, Link } from '@inertiajs/vue3';
import AppLayout from '@/layouts/AppLayout.vue';
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
        shared_links: number;
        download_count: number;
    };
    charts: {
        storageTrend:  { date: string; size: number }[];
        uploadsPerDay: { date: string; count: number }[];
        linkViews:     { date: string; views: number }[];
    };
}>();

const breadcrumbs: BreadcrumbItem[] = [{ title: 'Dashboard', href: '/dashboard' }];

function formatBytes(bytes: number): string {
    if (!bytes || bytes === 0) return '0 B';
    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    const i = Math.min(Math.floor(Math.log(bytes) / Math.log(1024)), units.length - 1);
    const val = bytes / Math.pow(1024, i);
    return `${Number.isInteger(val) ? val : val.toFixed(2)} ${units[i]}`;
}

const storageUsed  = computed(() => props.user.storage_used_human ?? '0 B');
const storageLimit = computed(() => formatBytes(props.user.storage_limit ?? 0));

const animatedImages  = ref(0);
const animatedLinks   = ref(0);
const animatedDownloads = ref(0);
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
        animateCounter(props.stats.download_count,  v => animatedDownloads.value = v);
        animateCounter(props.user.storage_percent ?? 0, v => animatedPercent.value = v, 1400);
    }, 100);
});

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

const chartDates = computed(() => {
    const dates: string[] = [];
    for (let i = 29; i >= 0; i--) {
        dates.push(new Date(Date.now() - i * 86400000).toISOString().slice(0, 10));
    }
    return dates;
});

function fillData(dates: string[], data: { date: string; [key: string]: any }[], key: string): number[] {
    const map = new Map(data.map(d => [d.date, d[key]]));
    return dates.map(d => map.get(d) ?? 0);
}

const storageChartData = computed(() => {
    const dates = chartDates.value;
    return {
        labels: dates.map(d => d.slice(5)),
        datasets: [{
            label: 'Storage Used (MB)',
            data: fillData(dates, props.charts.storageTrend, 'size').map(s => Math.round(s / 1024 / 1024 * 100) / 100),
            borderColor: '#7B2FFF',
            backgroundColor: 'rgba(123, 47, 255, 0.1)',
            fill: true,
            tension: 0.4,
        }]
    };
});

const uploadsChartData = computed(() => {
    const dates = chartDates.value;
    return {
        labels: dates.map(d => d.slice(5)),
        datasets: [{
            label: 'Uploads',
            data: fillData(dates, props.charts.uploadsPerDay, 'count'),
            backgroundColor: '#00C6FF',
            borderRadius: 4,
        }]
    };
});

const viewsChartData = computed(() => {
    const dates = chartDates.value;
    return {
        labels: dates.map(d => d.slice(5)),
        datasets: [{
            label: 'Link Views',
            data: fillData(dates, props.charts.linkViews, 'views'),
            borderColor: '#10b981',
            backgroundColor: 'rgba(16, 185, 129, 0.1)',
            fill: true,
            tension: 0.4,
        }]
    };
});
</script>

<template>
    <Head title="Dashboard" />
    <AppLayout :breadcrumbs="breadcrumbs">
        <div class="flex h-full flex-1 flex-col gap-6 p-6">
            <div class="relative overflow-hidden rounded-2xl px-8 py-7 bg-gradient-to-br from-violet-600 via-blue-500 to-cyan-400"
                 :class="mounted ? 'banner-in' : 'opacity-0'">
                <div class="pointer-events-none absolute -right-12 -top-12 h-52 w-52 rounded-full bg-white/10" />
                <div class="pointer-events-none absolute -bottom-10 right-28 h-32 w-32 rounded-full bg-white/10" />
                <p class="text-base font-medium text-white/70 mb-1">Welcome back</p>
                <h1 class="text-3xl font-bold text-white tracking-tight">{{ props.user?.name ?? 'there' }}</h1>
                <p class="mt-2 text-sm text-white/60">Here's what's happening with your files today.</p>
            </div>

            <div class="grid gap-4 sm:grid-cols-4">
                <div class="stat-card rounded-2xl border border-border bg-card p-6 flex flex-col gap-4"
                     :class="mounted ? 'card-in' : 'opacity-0'" style="animation-delay: 0.05s">
                    <span class="text-sm font-semibold uppercase tracking-widest text-muted-foreground">Total Images</span>
                    <span class="text-4xl font-bold tabular-nums text-foreground">{{ animatedImages }}</span>
                </div>
                <div class="stat-card rounded-2xl border border-border bg-card p-6 flex flex-col gap-4"
                     :class="mounted ? 'card-in' : 'opacity-0'" style="animation-delay: 0.12s">
                    <span class="text-sm font-semibold uppercase tracking-widest text-muted-foreground">Storage</span>
                    <div class="flex items-center gap-4">
                        <div class="relative shrink-0" :style="`width:${SIZE}px;height:${SIZE}px`">
                            <svg :width="SIZE" :height="SIZE" :viewBox="`0 0 ${SIZE} ${SIZE}`" style="transform: rotate(-90deg)">
                                <defs>
                                    <linearGradient :id="gradId" x1="0%" y1="0%" x2="100%" y2="0%">
                                        <stop offset="0%" stop-color="#7B2FFF" />
                                        <stop offset="100%" stop-color="#00C6FF" />
                                    </linearGradient>
                                </defs>
                                <circle :cx="SIZE/2" :cy="SIZE/2" :r="R" fill="none" stroke="currentColor" class="text-muted/20" :stroke-width="STROKE" />
                                <circle :cx="SIZE/2" :cy="SIZE/2" :r="R" fill="none" :stroke="`url(#${gradId})`" :stroke-width="STROKE" stroke-linecap="round" :stroke-dasharray="usedDash" style="transition: stroke-dasharray 1.4s cubic-bezier(0.34,1.56,0.64,1)" />
                            </svg>
                            <div class="absolute inset-0 flex flex-col items-center justify-center pointer-events-none">
                                <span class="text-xl font-bold text-foreground">{{ animatedPercent }}%</span>
                            </div>
                        </div>
                        <div>
                            <p class="text-base font-bold text-foreground">{{ storageUsed }}</p>
                            <p class="text-sm text-muted-foreground">of {{ storageLimit }}</p>
                        </div>
                    </div>
                </div>
                <div class="stat-card rounded-2xl border border-border bg-card p-6 flex flex-col gap-4"
                     :class="mounted ? 'card-in' : 'opacity-0'" style="animation-delay: 0.19s">
                    <span class="text-sm font-semibold uppercase tracking-widest text-muted-foreground">Active Links</span>
                    <span class="text-4xl font-bold tabular-nums text-foreground">{{ animatedLinks }}</span>
                </div>
                <div class="stat-card rounded-2xl border border-border bg-card p-6 flex flex-col gap-4"
                     :class="mounted ? 'card-in' : 'opacity-0'" style="animation-delay: 0.26s">
                    <span class="text-sm font-semibold uppercase tracking-widest text-muted-foreground">Downloads</span>
                    <span class="text-4xl font-bold tabular-nums text-foreground">{{ animatedDownloads }}</span>
                </div>
            </div>

            <div class="grid gap-4 lg:grid-cols-3">
                <div class="rounded-2xl border border-border bg-card p-5" :class="mounted ? 'card-in' : 'opacity-0'" style="animation-delay: 0.33s">
                    <h3 class="text-sm font-semibold mb-4">Storage Used (30 days)</h3>
                    <LineChart :data="storageChartData" :height="180" />
                </div>
                <div class="rounded-2xl border border-border bg-card p-5" :class="mounted ? 'card-in' : 'opacity-0'" style="animation-delay: 0.40s">
                    <h3 class="text-sm font-semibold mb-4">Uploads Per Day</h3>
                    <BarChart :data="uploadsChartData" :height="180" />
                </div>
                <div class="rounded-2xl border border-border bg-card p-5" :class="mounted ? 'card-in' : 'opacity-0'" style="animation-delay: 0.47s">
                    <h3 class="text-sm font-semibold mb-4">Link Views (30 days)</h3>
                    <LineChart :data="viewsChartData" :height="180" />
                </div>
            </div>

            <div class="rounded-2xl border border-border bg-card p-6" :class="mounted ? 'card-in' : 'opacity-0'" style="animation-delay: 0.54s">
                <div class="mb-5 flex items-center justify-between">
                    <h2 class="text-lg font-semibold">Recent Uploads</h2>
                    <Link href="/images" class="text-sm font-medium text-violet-400 hover:text-violet-300">View all →</Link>
                </div>
                <div v-if="recentImages.data.length > 0" class="grid grid-cols-2 gap-3 sm:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5">
                    <div v-for="(image, i) in recentImages.data" :key="image.id"
                         class="group relative aspect-square overflow-hidden rounded-xl bg-muted border border-border cursor-pointer"
                         :style="{ animationDelay: `${0.6 + i * 0.05}s` }" :class="mounted ? 'tile-in' : 'opacity-0'">
                        <img :src="image.thumbnail_url" :alt="image.name" class="h-full w-full object-cover transition-transform duration-500 group-hover:scale-110" loading="lazy" />
                        <div class="absolute inset-0 flex flex-col justify-end bg-gradient-to-t from-black/70 via-black/20 to-transparent p-3 opacity-0 transition-opacity duration-300 group-hover:opacity-100">
                            <span class="truncate text-xs font-medium text-white">{{ image.name }}</span>
                        </div>
                    </div>
                </div>
                <div v-else class="flex flex-col items-center justify-center py-16 text-center">
                    <p class="font-medium text-foreground mb-1">No images yet</p>
                    <Link href="/images/create" class="rounded-xl bg-gradient-to-r from-violet-500 to-cyan-400 px-5 py-2 text-sm font-semibold text-white hover:opacity-90">Upload images</Link>
                </div>
            </div>
        </div>
    </AppLayout>
</template>

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