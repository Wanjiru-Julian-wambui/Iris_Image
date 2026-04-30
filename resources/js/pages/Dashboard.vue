<script setup lang="ts">
import { Head } from '@inertiajs/vue3';
import { Image, FolderOpen, Link2, Eye, HardDrive, TrendingUp } from 'lucide-vue-next';
import AppLayout from '@/layouts/AppLayout.vue';
import {
    BarChart,
    Bar,
    XAxis,
    YAxis,
    CartesianGrid,
    Tooltip,
    ResponsiveContainer,
    LineChart,
    Line,
    Area,
    AreaChart,
} from 'recharts';
import type { BreadcrumbItem } from '@/types';

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Dashboard', href: '/dashboard' },
];

const props = defineProps<{
    stats: {
        total_images: number;
        total_albums: number;
        total_links: number;
        total_views: number;
        storage_used: string;
        storage_percent: number;
    };
    uploadHistory: { date: string; count: number }[];
    storageTrend: { date: string; bytes: number }[];
    linkViews: { date: string; views: number }[];
}>();

function formatBytes(bytes: number): string {
    if (bytes >= 1073741824) return (bytes / 1073741824).toFixed(2) + ' GB';
    if (bytes >= 1048576) return (bytes / 1048576).toFixed(2) + ' MB';
    if (bytes >= 1024) return (bytes / 1024).toFixed(2) + ' KB';
    return bytes + ' B';
}

function formatDate(dateStr: string): string {
    const d = new Date(dateStr);
    return d.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
}

const chartColors = {
    violet: '#8b5cf6',
    cyan: '#22d3ee',
    emerald: '#34d399',
    rose: '#fb7185',
};

const tickStyle = { fill: '#94a3b8', fontSize: 11 };
const axisLineStyle = { stroke: 'rgba(255,255,255,0.1)' };
const tooltipStyle = {
    backgroundColor: '#1e1e2e',
    border: '1px solid rgba(255,255,255,0.1)',
    borderRadius: '12px',
    fontSize: '12px',
    color: '#e2e8f0',
};
</script>

<template>
    <Head title="Dashboard" />

    <AppLayout :breadcrumbs="breadcrumbs">
        <div class="mx-auto max-w-6xl px-4 py-8 space-y-8">
            <!-- Header -->
            <div>
                <h1 class="text-2xl font-bold tracking-tight">Dashboard</h1>
                <p class="mt-1 text-sm text-muted-foreground">
                    Overview of your Iris account
                </p>
            </div>

            <!-- Stats Grid -->
            <div class="grid grid-cols-2 gap-4 lg:grid-cols-3 xl:grid-cols-6">
                <div class="rounded-2xl border border-white/8 bg-card p-4 space-y-2">
                    <div class="flex items-center gap-2 text-violet-400">
                        <Image class="h-4 w-4" />
                        <span class="text-[10px] font-bold uppercase tracking-wider">Images</span>
                    </div>
                    <p class="text-2xl font-bold">{{ stats.total_images }}</p>
                </div>

                <div class="rounded-2xl border border-white/8 bg-card p-4 space-y-2">
                    <div class="flex items-center gap-2 text-cyan-400">
                        <FolderOpen class="h-4 w-4" />
                        <span class="text-[10px] font-bold uppercase tracking-wider">Albums</span>
                    </div>
                    <p class="text-2xl font-bold">{{ stats.total_albums }}</p>
                </div>

                <div class="rounded-2xl border border-white/8 bg-card p-4 space-y-2">
                    <div class="flex items-center gap-2 text-emerald-400">
                        <Link2 class="h-4 w-4" />
                        <span class="text-[10px] font-bold uppercase tracking-wider">Links</span>
                    </div>
                    <p class="text-2xl font-bold">{{ stats.total_links }}</p>
                </div>

                <div class="rounded-2xl border border-white/8 bg-card p-4 space-y-2">
                    <div class="flex items-center gap-2 text-rose-400">
                        <Eye class="h-4 w-4" />
                        <span class="text-[10px] font-bold uppercase tracking-wider">Views</span>
                    </div>
                    <p class="text-2xl font-bold">{{ stats.total_views }}</p>
                </div>

                <div class="rounded-2xl border border-white/8 bg-card p-4 space-y-2 col-span-2 lg:col-span-1 xl:col-span-2">
                    <div class="flex items-center gap-2 text-amber-400">
                        <HardDrive class="h-4 w-4" />
                        <span class="text-[10px] font-bold uppercase tracking-wider">Storage</span>
                    </div>
                    <div class="flex items-baseline gap-2">
                        <p class="text-2xl font-bold">{{ stats.storage_used }}</p>
                        <span class="text-xs text-muted-foreground">{{ stats.storage_percent }}%</span>
                    </div>
                    <div class="h-1.5 w-full rounded-full bg-muted overflow-hidden">
                        <div
                            class="h-full rounded-full bg-amber-400 transition-all"
                            :style="{ width: `${Math.min(stats.storage_percent, 100)}%` }"
                        />
                    </div>
                </div>
            </div>

            <!-- Charts Grid -->
            <div class="grid gap-6 lg:grid-cols-2">
                <!-- Upload History — Bar Chart -->
                <div class="rounded-2xl border border-white/8 bg-card p-6 space-y-4 lg:col-span-2">
                    <div class="flex items-center justify-between">
                        <div>
                            <h2 class="text-sm font-semibold flex items-center gap-2">
                                <TrendingUp class="h-4 w-4 text-violet-400" />
                                Upload history
                            </h2>
                            <p class="text-xs text-muted-foreground mt-0.5">Images uploaded per day — last 30 days</p>
                        </div>
                    </div>
                    <div class="h-64 w-full">
                        <ResponsiveContainer width="100%" height="100%">
                            <BarChart :data="uploadHistory" :margin="{ top: 5, right: 5, left: -20, bottom: 5 }">
                                <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.05)" />
                                <XAxis
                                    dataKey="date"
                                    :tickFormatter="formatDate"
                                    :tick="tickStyle"
                                    :axisLine="axisLineStyle"
                                />
                                <YAxis
                                    :tick="tickStyle"
                                    :axisLine="axisLineStyle"
                                    :allowDecimals="false"
                                />
                                <Tooltip
                                    :contentStyle="tooltipStyle"
                                    :formatter="(value: number) => [`${value} images`, 'Uploads']"
                                    :labelFormatter="(label: string) => formatDate(label)"
                                />
                                <Bar
                                    dataKey="count"
                                    :fill="chartColors.violet"
                                    :radius="[4, 4, 0, 0]"
                                    :maxBarSize="40"
                                />
                            </BarChart>
                        </ResponsiveContainer>
                    </div>
                </div>

                <!-- Storage Trend — Area Chart -->
                <div class="rounded-2xl border border-white/8 bg-card p-6 space-y-4">
                    <div>
                        <h2 class="text-sm font-semibold flex items-center gap-2">
                            <HardDrive class="h-4 w-4 text-cyan-400" />
                            Storage trend
                        </h2>
                        <p class="text-xs text-muted-foreground mt-0.5">Cumulative storage used over time</p>
                    </div>
                    <div class="h-64 w-full">
                        <ResponsiveContainer width="100%" height="100%">
                            <AreaChart :data="storageTrend" :margin="{ top: 5, right: 5, left: -20, bottom: 5 }">
                                <defs>
                                    <linearGradient id="storageGradient" x1="0" y1="0" x2="0" y2="1">
                                        <stop offset="5%" :stopColor="chartColors.cyan" :stopOpacity="0.3" />
                                        <stop offset="95%" :stopColor="chartColors.cyan" :stopOpacity="0" />
                                    </linearGradient>
                                </defs>
                                <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.05)" />
                                <XAxis
                                    dataKey="date"
                                    :tickFormatter="formatDate"
                                    :tick="tickStyle"
                                    :axisLine="axisLineStyle"
                                />
                                <YAxis
                                    :tick="tickStyle"
                                    :axisLine="axisLineStyle"
                                    :tickFormatter="(value: number) => formatBytes(value)"
                                />
                                <Tooltip
                                    :contentStyle="tooltipStyle"
                                    :formatter="(value: number) => [formatBytes(value), 'Storage used']"
                                    :labelFormatter="(label: string) => formatDate(label)"
                                />
                                <Area
                                    type="monotone"
                                    dataKey="bytes"
                                    :stroke="chartColors.cyan"
                                    :strokeWidth="2"
                                    fill="url(#storageGradient)"
                                />
                            </AreaChart>
                        </ResponsiveContainer>
                    </div>
                </div>

                <!-- Link Views — Line Chart -->
                <div class="rounded-2xl border border-white/8 bg-card p-6 space-y-4">
                    <div>
                        <h2 class="text-sm font-semibold flex items-center gap-2">
                            <Eye class="h-4 w-4 text-emerald-400" />
                            Link views
                        </h2>
                        <p class="text-xs text-muted-foreground mt-0.5">Shared link views per day</p>
                    </div>
                    <div class="h-64 w-full">
                        <ResponsiveContainer width="100%" height="100%">
                            <LineChart :data="linkViews" :margin="{ top: 5, right: 5, left: -20, bottom: 5 }">
                                <CartesianGrid strokeDasharray="3 3" stroke="rgba(255,255,255,0.05)" />
                                <XAxis
                                    dataKey="date"
                                    :tickFormatter="formatDate"
                                    :tick="tickStyle"
                                    :axisLine="axisLineStyle"
                                />
                                <YAxis
                                    :tick="tickStyle"
                                    :axisLine="axisLineStyle"
                                    :allowDecimals="false"
                                />
                                <Tooltip
                                    :contentStyle="tooltipStyle"
                                    :formatter="(value: number) => [`${value} views`, 'Link views']"
                                    :labelFormatter="(label: string) => formatDate(label)"
                                />
                                <Line
                                    type="monotone"
                                    dataKey="views"
                                    :stroke="chartColors.emerald"
                                    :strokeWidth="2"
                                    :dot="{ fill: chartColors.emerald, r: 3 }"
                                    :activeDot="{ r: 5, fill: chartColors.emerald }"
                                />
                            </LineChart>
                        </ResponsiveContainer>
                    </div>
                </div>
            </div>
        </div>
    </AppLayout>
</template>