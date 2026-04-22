<script setup lang="ts">
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted, onUnmounted } from 'vue';

defineProps({
    canLogin:    { type: Boolean, default: true },
    canRegister: { type: Boolean, default: true },
});

const isDark = ref(true);
const scrollY = ref(0);
const heroVisible = ref(false);
const mouseX = ref(0);
const mouseY = ref(0);
const tickerPos = ref(0);
let tickerRAF: number;

const onScroll = () => { scrollY.value = window.scrollY; };
const onMouse = (e: MouseEvent) => {
    mouseX.value = (e.clientX / window.innerWidth - 0.5) * 24;
    mouseY.value = (e.clientY / window.innerHeight - 0.5) * 24;
};
const runTicker = () => {
    tickerPos.value -= 0.4;
    tickerRAF = requestAnimationFrame(runTicker);
};

onMounted(() => {
    if (localStorage.theme === 'dark' || (!('theme' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
        isDark.value = true;
        document.documentElement.classList.add('dark');
    } else {
        isDark.value = false;
        document.documentElement.classList.remove('dark');
    }
    window.addEventListener('scroll', onScroll, { passive: true });
    window.addEventListener('mousemove', onMouse, { passive: true });
    setTimeout(() => { heroVisible.value = true; }, 100);
    tickerRAF = requestAnimationFrame(runTicker);
});

onUnmounted(() => {
    window.removeEventListener('scroll', onScroll);
    window.removeEventListener('mousemove', onMouse);
    cancelAnimationFrame(tickerRAF);
});

const toggleTheme = () => {
    isDark.value = !isDark.value;
    document.documentElement.classList.toggle('dark', isDark.value);
    localStorage.theme = isDark.value ? 'dark' : 'light';
};

const features = [
    {
        num: '01', title: 'Lightning CDN',
        desc: 'Assets served from 200+ edge nodes. Sub-50ms load times globally, every time.',
        stat: '42ms', statLabel: 'avg latency', color: '#C9A84C',
        icon: `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></svg>`,
    },
    {
        num: '02', title: 'Granular Privacy',
        desc: 'Password-protect, set expiry dates, or lock assets to specific team members.',
        stat: '256-bit', statLabel: 'encryption', color: '#7EB8D4',
        icon: `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>`,
    },
    {
        num: '03', title: 'Auto-Optimisation',
        desc: 'Upload anything. Iris compresses and converts to modern WebP automatically.',
        stat: '−68%', statLabel: 'file size', color: '#A8D5A2',
        icon: `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M12 3a6 6 0 0 0 9 9 9 9 0 1 1-9-9z"/></svg>`,
    },
    {
        num: '04', title: 'Smart Workspace',
        desc: 'Nested folders, role-based access, and team sharing built in from day one.',
        stat: '∞', statLabel: 'folders', color: '#C9A84C',
        icon: `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"/></svg>`,
    },
    {
        num: '05', title: 'EXIF Stripping',
        desc: 'GPS, camera model, timestamps — all metadata scrubbed on upload, automatically.',
        stat: '100%', statLabel: 'metadata removed', color: '#E8A598',
        icon: `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19"/><path d="M14.12 14.12a3 3 0 1 1-4.24-4.24"/><line x1="2" y1="2" x2="22" y2="22" stroke-width="1.6"/></svg>`,
    },
    {
        num: '06', title: 'One-Click Share',
        desc: 'Copy markdown, HTML, BBCode, or raw URLs instantly from your dashboard.',
        stat: '4', statLabel: 'copy formats', color: '#7EB8D4',
        icon: `<svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"><circle cx="18" cy="5" r="3"/><circle cx="6" cy="12" r="3"/><circle cx="18" cy="19" r="3"/><line x1="8.59" y1="13.51" x2="15.42" y2="17.49"/><line x1="15.41" y1="6.51" x2="8.59" y2="10.49"/></svg>`,
    },
];

const tickerItems = ['Lightning CDN', '200+ Edge Nodes', '42ms Avg Latency', 'WebP Auto-Convert', 'EXIF Stripping', '99.99% Uptime', 'Free 1 GB Storage', 'Instant Setup', 'Zero Credit Card'];

const mockImages = [
    { col: 'col-span-2', row: 'row-span-2', bg: 'from-violet-500/60 via-purple-600/50 to-indigo-700/60', label: 'hero-portrait.jpg' },
    { col: 'col-span-1', row: 'row-span-1', bg: 'from-sky-400/60 via-cyan-500/50 to-blue-600/60', label: 'banner.png' },
    { col: 'col-span-1', row: 'row-span-1', bg: 'from-emerald-400/60 via-teal-500/50 to-green-700/60', label: 'thumb.webp' },
    { col: 'col-span-1', row: 'row-span-2', bg: 'from-rose-400/60 via-pink-500/50 to-red-700/60', label: 'cover.jpg' },
    { col: 'col-span-2', row: 'row-span-1', bg: 'from-amber-400/60 via-orange-500/50 to-yellow-600/60', label: 'product.png' },
    { col: 'col-span-1', row: 'row-span-1', bg: 'from-indigo-400/60 via-violet-500/50 to-purple-700/60', label: 'logo.svg' },
];
</script>

<template>
    <Head title="Iris — The ultimate home for your visual assets" />

    <div
        class="min-h-screen overflow-x-hidden transition-colors duration-500"
        :class="isDark ? 'bg-[#080810] text-[#E8E4D9]' : 'bg-[#F7F5EF] text-[#1a1814]'"
        style="font-family: 'Crimson Pro', Georgia, serif;"
    >
        <component :is="'style'">
            @import url('https://fonts.googleapis.com/css2?family=Crimson+Pro:ital,wght@0,300;0,400;0,500;1,300;1,400&family=Space+Mono:wght@400;700&family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;0,700;1,300;1,400;1,600&display=swap');
            *, *::before, *::after { box-sizing: border-box; }
        </component>

        <!-- ══ NAVBAR ══ -->
        <header
            class="fixed top-0 left-0 right-0 z-50 flex items-center justify-between px-6 lg:px-14 h-[60px] transition-all duration-500"
            :class="scrollY > 20
                ? (isDark ? 'bg-[#080810]/92 backdrop-blur-xl border-b border-[#C9A84C]/14' : 'bg-[#F7F5EF]/92 backdrop-blur-xl border-b border-[#C9A84C]/22')
                : 'bg-transparent'"
        >
            <Link href="/" class="flex items-center gap-3 group select-none">
                <div class="relative">
                    <div class="absolute inset-0 rounded-full blur-md opacity-0 group-hover:opacity-50 transition-opacity duration-500" style="background:#C9A84C"></div>
                    <img src="/favicon.png" alt="Iris"
                        class="relative h-8 w-8 rounded-full object-cover z-10 transition-all duration-300 group-hover:scale-105"
                        style="box-shadow: 0 0 0 1px rgba(201,168,76,0.4), 0 2px 8px rgba(0,0,0,0.3)" />
                </div>
                <span class="text-[20px] tracking-[-0.01em]"
                    style="font-family:'Cormorant Garamond',serif; font-weight:600; font-style:italic"
                    :class="isDark ? 'text-[#E8E4D9]' : 'text-[#1a1814]'">Iris</span>
            </Link>

            <div class="hidden lg:flex items-center gap-2 font-mono text-[10px] uppercase tracking-[0.2em]"
                :class="isDark ? 'text-[#E8E4D9]/22' : 'text-[#1a1814]/28'">
                <span class="w-7 h-px" :class="isDark ? 'bg-[#C9A84C]/25' : 'bg-[#C9A84C]/35'"></span>
                Visual Asset Platform
                <span class="w-7 h-px" :class="isDark ? 'bg-[#C9A84C]/25' : 'bg-[#C9A84C]/35'"></span>
            </div>

            <nav class="flex items-center gap-2">
                <button @click="toggleTheme"
                    class="p-2 rounded transition-all duration-200 opacity-40 hover:opacity-90"
                    :class="isDark ? 'text-[#E8E4D9]' : 'text-[#1a1814]'">
                    <svg v-if="isDark" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="5"/>
                        <line x1="12" y1="1" x2="12" y2="3"/><line x1="12" y1="21" x2="12" y2="23"/>
                        <line x1="4.22" y1="4.22" x2="5.64" y2="5.64"/><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"/>
                        <line x1="1" y1="12" x2="3" y2="12"/><line x1="21" y1="12" x2="23" y2="12"/>
                        <line x1="4.22" y1="19.78" x2="5.64" y2="18.36"/><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"/>
                    </svg>
                    <svg v-else width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/>
                    </svg>
                </button>
                <div class="w-px h-4 mx-1" :class="isDark ? 'bg-[#E8E4D9]/12' : 'bg-[#1a1814]/12'"></div>
                <Link v-if="$page?.props?.auth?.user" href="/dashboard"
                    class="px-4 py-2 font-mono text-[11px] uppercase tracking-wider transition-colors"
                    :class="isDark ? 'text-[#E8E4D9]/45 hover:text-[#E8E4D9]' : 'text-[#1a1814]/45 hover:text-[#1a1814]'">
                    Dashboard
                </Link>
                <template v-else>
                    <Link v-if="canLogin" href="/login"
                        class="hidden sm:inline-block px-4 py-2 font-mono text-[11px] uppercase tracking-wider transition-colors"
                        :class="isDark ? 'text-[#E8E4D9]/38 hover:text-[#E8E4D9]/75' : 'text-[#1a1814]/38 hover:text-[#1a1814]/75'">
                        Sign in
                    </Link>
                    <Link v-if="canRegister" href="/register"
                        class="nav-cta-btn px-5 py-2 font-mono text-[11px] uppercase tracking-wider text-[#080810]"
                        style="background:#C9A84C">
                        Get started
                    </Link>
                </template>
            </nav>
        </header>

        <!-- ══ HERO ══ -->
        <section class="relative min-h-screen flex items-center overflow-hidden pt-16">

            <!-- Layered background -->
            <div class="absolute inset-0 -z-10 overflow-hidden">
                <!-- Gold architectural grid -->
                <div class="absolute inset-0 arch-grid" :class="isDark ? 'opacity-[0.04]' : 'opacity-[0.055]'"></div>
                <!-- Hatching texture -->
                <div class="absolute inset-0"
                    :class="isDark ? 'opacity-[0.02]' : 'opacity-[0.035]'"
                    style="background: repeating-linear-gradient(-55deg, currentColor 0, currentColor 1px, transparent 0, transparent 48%); background-size: 38px 38px;"></div>
                <!-- Gold ambient glow -->
                <div class="absolute top-[5%] left-[-8%] w-[75vw] h-[75vh] rounded-full"
                    :style="`background: radial-gradient(ellipse, ${isDark ? 'rgba(201,168,76,0.07)' : 'rgba(201,168,76,0.11)'} 0%, transparent 60%); filter:blur(90px); transform:translate(${mouseX*0.18}px, ${mouseY*0.14}px)`"></div>
                <!-- Steel-blue ambient -->
                <div class="absolute bottom-[-5%] right-[-5%] w-[55vw] h-[55vh] rounded-full"
                    :style="`background: radial-gradient(ellipse, ${isDark ? 'rgba(126,184,212,0.06)' : 'rgba(126,184,212,0.09)'} 0%, transparent 60%); filter:blur(100px); transform:translate(${mouseX*-0.1}px, ${mouseY*-0.1}px)`"></div>
                <!-- Grain -->
                <div class="absolute inset-0 grain-tex pointer-events-none" :class="isDark ? 'opacity-[0.032]' : 'opacity-[0.022]'"></div>
            </div>

            <!-- Vertical rules -->
            <div class="absolute left-14 top-0 bottom-0 w-px hidden xl:block" :class="isDark ? 'bg-[#C9A84C]/10' : 'bg-[#C9A84C]/18'"></div>
            <div class="absolute right-14 top-0 bottom-0 w-px hidden xl:block" :class="isDark ? 'bg-[#C9A84C]/10' : 'bg-[#C9A84C]/18'"></div>

            <div class="max-w-[1400px] mx-auto px-6 lg:px-14 w-full py-24 grid lg:grid-cols-[1fr_1fr] gap-16 items-center">

                <!-- Left: text -->
                <div :class="heroVisible ? 'hero-in' : 'opacity-0'" class="z-10">

                    <!-- Edition rule -->
                    <div class="flex items-center gap-3 mb-10">
                        <div class="flex items-center gap-2 font-mono text-[10px] uppercase tracking-[0.22em]" style="color:#C9A84C; opacity:0.8">
                            <span class="relative flex h-1.5 w-1.5">
                                <span class="animate-ping absolute inline-flex h-full w-full rounded-full opacity-55" style="background:#C9A84C"></span>
                                <span class="relative inline-flex rounded-full h-1.5 w-1.5" style="background:#C9A84C"></span>
                            </span>
                            Open Beta
                        </div>
                        <div class="flex-1 h-px" :class="isDark ? 'bg-[#C9A84C]/18' : 'bg-[#C9A84C]/28'"></div>
                        <span class="font-mono text-[10px] uppercase tracking-[0.2em]" :class="isDark ? 'text-[#E8E4D9]/22' : 'text-[#1a1814]/28'">Vol. I · 2025</span>
                    </div>

                    <!-- Headline -->
                    <h1 class="mb-8 leading-[0.93]"
                        style="font-family:'Cormorant Garamond',serif; font-size:clamp(4rem,8.5vw,7.2rem); font-weight:300; letter-spacing:-0.025em;">
                        <span :class="isDark ? 'text-[#E8E4D9]' : 'text-[#1a1814]'">Your<br>images.</span><br>
                        <em style="color:#C9A84C; font-style:italic">Everywhere.</em>
                    </h1>

                    <!-- Ornament rule -->
                    <div class="flex items-center gap-4 mb-8">
                        <div class="h-px flex-1" :class="isDark ? 'bg-[#E8E4D9]/10' : 'bg-[#1a1814]/10'"></div>
                        <svg width="11" height="11" viewBox="0 0 12 12"><path d="M6 0L7.5 4.5L12 6L7.5 7.5L6 12L4.5 7.5L0 6L4.5 4.5Z" fill="#C9A84C"/></svg>
                        <div class="h-px flex-1" :class="isDark ? 'bg-[#E8E4D9]/10' : 'bg-[#1a1814]/10'"></div>
                    </div>

                    <p class="text-[1.1rem] max-w-[440px] mb-10 leading-[1.78]"
                        style="font-family:'Crimson Pro',serif; font-weight:300;"
                        :class="isDark ? 'text-[#E8E4D9]/50' : 'text-[#1a1814]/52'">
                        A beautifully fast image hosting platform with CDN delivery, smart organisation, and privacy controls — built for developers and creators.
                    </p>

                    <!-- CTAs -->
                    <div class="flex flex-wrap items-center gap-3 mb-12">
                        <Link v-if="canRegister" href="/register"
                            class="cta-gold px-8 py-3.5 font-mono text-[11px] uppercase tracking-wider text-[#080810] relative overflow-hidden"
                            style="background:#C9A84C">
                            <span class="relative z-10 flex items-center gap-2.5">
                                Start free
                                <svg class="cta-arr" width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                    <line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/>
                                </svg>
                            </span>
                            <span class="shine-s absolute inset-0"></span>
                        </Link>
                        <Link v-if="canLogin" href="/login"
                            class="px-8 py-3.5 font-mono text-[11px] uppercase tracking-wider border transition-all duration-300"
                            :class="isDark
                                ? 'border-[#E8E4D9]/14 text-[#E8E4D9]/45 hover:text-[#E8E4D9] hover:border-[#E8E4D9]/28'
                                : 'border-[#1a1814]/18 text-[#1a1814]/45 hover:text-[#1a1814] hover:border-[#1a1814]/38'">
                            Sign in
                        </Link>
                    </div>

                    <!-- Trust row -->
                    <div class="flex flex-wrap gap-x-5 gap-y-2">
                        <span v-for="t in ['No credit card', 'Free 1 GB', 'Instant setup']" :key="t"
                            class="flex items-center gap-1.5 font-mono text-[10px] uppercase tracking-wider"
                            :class="isDark ? 'text-[#E8E4D9]/28' : 'text-[#1a1814]/32'">
                            <span style="color:#C9A84C; font-size:8px">✦</span>
                            {{ t }}
                        </span>
                    </div>
                </div>

                <!-- Right: Mockup -->
                <div :class="heroVisible ? 'hero-vis-in' : 'opacity-0'" class="relative z-10 hidden lg:block">

                    <!-- Halo behind window -->
                    <div class="absolute inset-10 rounded-2xl blur-[55px] opacity-18 pointer-events-none"
                        style="background: conic-gradient(from 200deg, #C9A84C, #7EB8D4, #C9A84C)"></div>

                    <!-- App window -->
                    <div
                        class="mockup-win relative rounded-xl overflow-hidden"
                        :class="isDark ? 'bg-[#0d0d18] border border-[#C9A84C]/18' : 'bg-white border border-[#C9A84C]/28'"
                        style="box-shadow: 0 60px 120px -18px rgba(0,0,0,0.65), 0 0 0 1px rgba(201,168,76,0.07)"
                        :style="`transform: perspective(1200px) rotateX(${mouseY*-0.01}deg) rotateY(${mouseX*0.01}deg)`"
                    >
                        <!-- Titlebar -->
                        <div class="flex items-center justify-between px-4 py-3 border-b"
                            :class="isDark ? 'border-[#C9A84C]/10 bg-[#0b0b15]' : 'border-[#C9A84C]/14 bg-[#EDE9E0]'">
                            <div class="flex items-center gap-1.5">
                                <div class="h-2.5 w-2.5 rounded-full bg-[#FF5F57]"></div>
                                <div class="h-2.5 w-2.5 rounded-full bg-[#FEBC2E]"></div>
                                <div class="h-2.5 w-2.5 rounded-full bg-[#28C840]"></div>
                            </div>
                            <div class="flex items-center gap-1 px-3 py-1 rounded font-mono text-[10px]"
                                :class="isDark ? 'bg-white/[0.04] text-[#E8E4D9]/18' : 'bg-black/[0.05] text-[#1a1814]/30'">
                                <svg width="8" height="8" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/></svg>
                                iris.app/gallery
                            </div>
                            <div class="w-14"></div>
                        </div>

                        <!-- Toolbar -->
                        <div class="flex items-center justify-between px-4 py-2 border-b"
                            :class="isDark ? 'border-white/[0.04]' : 'border-[#1a1814]/[0.05]'">
                            <div class="flex items-center gap-2">
                                <svg width="11" height="11" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"
                                    :class="isDark ? 'text-[#E8E4D9]/22' : 'text-[#1a1814]/28'">
                                    <rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/>
                                    <rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/>
                                </svg>
                                <span class="font-mono text-[10px] uppercase tracking-wider" :class="isDark ? 'text-[#E8E4D9]/42' : 'text-[#1a1814]/48'">Gallery</span>
                                <span class="font-mono text-[9px] px-1.5 py-0.5 rounded" style="background:rgba(201,168,76,0.14); color:#C9A84C">6</span>
                            </div>
                            <div class="flex gap-1.5">
                                <div class="flex items-center gap-1 px-2 h-6 rounded font-mono text-[10px]"
                                    :class="isDark ? 'bg-white/[0.04] text-[#E8E4D9]/20' : 'bg-black/[0.05] text-[#1a1814]/32'">
                                    <svg width="8" height="8" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></svg>
                                    Search
                                </div>
                                <button class="h-6 w-6 rounded flex items-center justify-center flex-shrink-0" style="background:#C9A84C">
                                    <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#080810" stroke-width="2.5"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
                                </button>
                            </div>
                        </div>

                        <!-- Image grid -->
                        <div class="p-3 grid grid-cols-3 gap-2" style="min-height:280px">
                            <div v-for="(img, i) in mockImages" :key="i"
                                class="img-tile rounded-lg overflow-hidden relative group cursor-pointer"
                                :class="[img.col, img.row, `bg-gradient-to-br ${img.bg}`]"
                                :style="`animation-delay:${i*0.07}s; min-height:${(img.col==='col-span-2'&&img.row==='row-span-2')||img.row==='row-span-2'?'140px':'62px'}`"
                            >
                                <div class="absolute inset-0 ring-1 ring-inset ring-white/10 rounded-lg"></div>
                                <!-- Gold shimmer on hover -->
                                <div class="absolute inset-0 opacity-0 group-hover:opacity-100 transition-opacity duration-300"
                                    style="background:linear-gradient(135deg, rgba(201,168,76,0.18), transparent 55%)"></div>
                                <!-- Hover label -->
                                <div class="absolute bottom-0 left-0 right-0 px-2 py-1.5 opacity-0 group-hover:opacity-100 transition-all duration-250"
                                    style="background:linear-gradient(to top, rgba(8,8,16,0.75), transparent)">
                                    <div class="font-mono text-[8px] text-white/65 truncate">{{ img.label }}</div>
                                </div>
                                <!-- View icon -->
                                <div class="absolute inset-0 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-all duration-250">
                                    <div class="h-8 w-8 rounded-full flex items-center justify-center scale-75 group-hover:scale-100 transition-transform duration-250"
                                        style="background:rgba(201,168,76,0.18); backdrop-filter:blur(6px); border:1px solid rgba(201,168,76,0.38)">
                                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="#C9A84C" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                                            <circle cx="12" cy="12" r="3"/>
                                        </svg>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Status bar -->
                        <div class="flex items-center justify-between px-4 py-2 border-t font-mono text-[9px] uppercase tracking-wider"
                            :class="isDark ? 'border-white/[0.04] text-[#E8E4D9]/18' : 'border-[#1a1814]/[0.06] text-[#1a1814]/28'">
                            <span>6 assets · 667 KB</span>
                            <div class="flex items-center gap-1.5" style="color:#C9A84C">
                                <span class="relative flex h-1.5 w-1.5">
                                    <span class="animate-ping absolute inline-flex h-full w-full rounded-full opacity-55" style="background:#C9A84C"></span>
                                    <span class="relative inline-flex rounded-full h-1.5 w-1.5" style="background:#C9A84C"></span>
                                </span>
                                CDN Live
                            </div>
                        </div>
                    </div>

                    <!-- Floating stat chips -->
                    <div class="fc-1 absolute -left-16 top-[26%] px-4 py-3 rounded-lg border"
                        :class="isDark ? 'bg-[#0d0d18]/95 border-[#C9A84C]/18 backdrop-blur-xl' : 'bg-white/95 border-[#C9A84C]/28 backdrop-blur-xl shadow-lg shadow-amber-100/30'">
                        <div class="font-mono text-[9px] uppercase tracking-[0.15em] mb-1" :class="isDark ? 'text-[#E8E4D9]/28' : 'text-[#1a1814]/32'">Avg load</div>
                        <div class="font-mono text-xl font-bold leading-none" style="color:#C9A84C">42<span class="text-sm font-normal">ms</span></div>
                    </div>
                    <div class="fc-2 absolute -right-14 top-[12%] px-4 py-3 rounded-lg border"
                        :class="isDark ? 'bg-[#0d0d18]/95 border-[#7EB8D4]/18 backdrop-blur-xl' : 'bg-white/95 border-[#7EB8D4]/28 backdrop-blur-xl shadow-lg shadow-sky-100/30'">
                        <div class="font-mono text-[9px] uppercase tracking-[0.15em] mb-1" :class="isDark ? 'text-[#E8E4D9]/28' : 'text-[#1a1814]/32'">Compression</div>
                        <div class="font-mono text-xl font-bold leading-none" style="color:#7EB8D4">−68%</div>
                    </div>
                    <div class="fc-3 absolute -right-10 bottom-[24%] px-4 py-3 rounded-lg border"
                        :class="isDark ? 'bg-[#0d0d18]/95 border-[#C9A84C]/18 backdrop-blur-xl' : 'bg-white/95 border-[#C9A84C]/28 backdrop-blur-xl shadow-lg shadow-amber-100/30'">
                        <div class="font-mono text-[9px] uppercase tracking-[0.15em] mb-1" :class="isDark ? 'text-[#E8E4D9]/28' : 'text-[#1a1814]/32'">Edge nodes</div>
                        <div class="font-mono text-xl font-bold leading-none" style="color:#C9A84C">200+</div>
                    </div>
                    <!-- Upload pill -->
                    <div class="fc-4 absolute -bottom-6 left-[6%] right-[6%] px-4 py-3 rounded-lg border"
                        :class="isDark ? 'bg-[#0d0d18]/95 border-[#C9A84C]/14 backdrop-blur-xl' : 'bg-white/95 border-[#C9A84C]/22 backdrop-blur-xl shadow-lg'">
                        <div class="flex items-center justify-between mb-2">
                            <div class="flex items-center gap-2">
                                <div class="h-5 w-5 rounded flex items-center justify-center flex-shrink-0" style="background:#C9A84C">
                                    <svg width="9" height="9" viewBox="0 0 24 24" fill="none" stroke="#080810" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
                                        <polyline points="17 8 12 3 7 8"/>
                                        <line x1="12" y1="3" x2="12" y2="15"/>
                                    </svg>
                                </div>
                                <span class="font-mono text-[10px]" :class="isDark ? 'text-[#E8E4D9]/50' : 'text-[#1a1814]/50'">hero-photo.jpg</span>
                            </div>
                            <span class="font-mono text-[10px] font-bold" style="color:#C9A84C">74%</span>
                        </div>
                        <div class="h-[2px] rounded-full overflow-hidden" :class="isDark ? 'bg-white/7' : 'bg-[#1a1814]/8'">
                            <div class="h-full rounded-full upload-bar" style="background:#C9A84C; width:74%"></div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Scroll cue -->
            <div class="absolute bottom-8 left-1/2 -translate-x-1/2 scroll-cue flex flex-col items-center gap-3 select-none"
                :class="isDark ? 'text-[#E8E4D9]/18' : 'text-[#1a1814]/22'">
                <span class="font-mono text-[9px] uppercase tracking-[0.26em]">Scroll</span>
                <div class="w-px h-10 scroll-ln" :class="isDark ? 'bg-[#C9A84C]/28' : 'bg-[#C9A84C]/38'"></div>
            </div>
        </section>

        <!-- ══ TICKER ══ -->
        <div class="relative overflow-hidden border-y py-3.5"
            :class="isDark ? 'border-[#C9A84C]/10 bg-[#0b0b16]' : 'border-[#C9A84C]/18 bg-[#ECE8DE]'">
            <div class="ticker-track flex items-center gap-8 whitespace-nowrap will-change-transform"
                :style="`transform:translateX(${tickerPos % -820}px)`">
                <span v-for="(item, i) in [...tickerItems, ...tickerItems, ...tickerItems, ...tickerItems]" :key="i"
                    class="inline-flex items-center gap-3 font-mono text-[11px] uppercase tracking-[0.18em] flex-shrink-0"
                    :class="isDark ? 'text-[#E8E4D9]/25' : 'text-[#1a1814]/32'">
                    <span style="color:#C9A84C; font-size:7px">◆</span>
                    {{ item }}
                </span>
            </div>
        </div>

        <!-- ══ FEATURES ══ -->
        <section class="px-6 lg:px-14 py-32 max-w-[1400px] mx-auto">

            <!-- Section header -->
            <div class="flex items-end justify-between mb-14 border-b pb-6"
                :class="isDark ? 'border-[#C9A84C]/10' : 'border-[#C9A84C]/18'">
                <div>
                    <p class="font-mono text-[10px] uppercase tracking-[0.25em] mb-3" style="color:#C9A84C">Capabilities</p>
                    <h2 style="font-family:'Cormorant Garamond',serif; font-size:clamp(2.2rem,4vw,3.4rem); font-weight:300; letter-spacing:-0.02em; line-height:1.1"
                        :class="isDark ? 'text-[#E8E4D9]' : 'text-[#1a1814]'">
                        Built without<br><em style="color:#C9A84C">compromise.</em>
                    </h2>
                </div>
                <div class="hidden lg:block text-right font-mono text-[10px] uppercase tracking-[0.18em]"
                    :class="isDark ? 'text-[#E8E4D9]/22' : 'text-[#1a1814]/28'">
                    Six features<br>One platform
                </div>
            </div>

            <!-- Feature rows — editorial table -->
            <div>
                <div v-for="(f, i) in features" :key="f.title"
                    class="feat-row group flex items-start gap-6 py-6 border-b cursor-default transition-all duration-300"
                    :class="isDark ? 'border-[#E8E4D9]/[0.055] hover:bg-[#C9A84C]/[0.028]' : 'border-[#1a1814]/[0.07] hover:bg-[#C9A84C]/[0.035]'"
                    :style="`animation-delay:${i*0.07}s`">
                    <!-- Number -->
                    <div class="font-mono text-[10px] uppercase tracking-wider w-7 pt-1 flex-shrink-0"
                        :class="isDark ? 'text-[#E8E4D9]/18' : 'text-[#1a1814]/22'">{{ f.num }}</div>
                    <!-- Icon -->
                    <div class="w-9 h-9 rounded-lg flex items-center justify-center flex-shrink-0 transition-all duration-300 group-hover:scale-105"
                        :style="`background:${f.color}10; border:1px solid ${f.color}22; color:${f.color}`">
                        <div v-html="f.icon"></div>
                    </div>
                    <!-- Content -->
                    <div class="flex-1 min-w-0">
                        <h3 class="text-[15px] font-semibold mb-1 transition-colors duration-200"
                            :class="isDark ? 'text-[#E8E4D9]/82 group-hover:text-[#E8E4D9]' : 'text-[#1a1814]/82 group-hover:text-[#1a1814]'">
                            {{ f.title }}
                        </h3>
                        <p style="font-family:'Crimson Pro',serif; font-size:1rem; font-weight:300; line-height:1.7"
                            :class="isDark ? 'text-[#E8E4D9]/38' : 'text-[#1a1814]/42'">{{ f.desc }}</p>
                    </div>
                    <!-- Stat -->
                    <div class="text-right flex-shrink-0 hidden sm:block">
                        <div class="font-mono text-xl font-bold" :style="`color:${f.color}`">{{ f.stat }}</div>
                        <div class="font-mono text-[9px] uppercase tracking-wider mt-0.5"
                            :class="isDark ? 'text-[#E8E4D9]/22' : 'text-[#1a1814]/28'">{{ f.statLabel }}</div>
                    </div>
                    <!-- Arrow -->
                    <div class="w-5 flex-shrink-0 flex items-start pt-1 opacity-0 group-hover:opacity-100 transition-all duration-300 translate-x-2 group-hover:translate-x-0"
                        style="color:#C9A84C">
                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/>
                        </svg>
                    </div>
                </div>
            </div>
        </section>

        <!-- ══ STATS STRIP ══ -->
        <section class="px-6 lg:px-14 pb-28 max-w-[1400px] mx-auto">
            <div class="grid grid-cols-2 lg:grid-cols-4 border"
                :class="isDark ? 'border-[#C9A84C]/14' : 'border-[#C9A84C]/22'">
                <div v-for="(s, i) in [
                    { n:'200+', label:'Edge Nodes', sub:'Worldwide' },
                    { n:'99.99%', label:'Uptime SLA', sub:'Guaranteed' },
                    { n:'< 50ms', label:'Latency', sub:'Global avg' },
                    { n:'Free', label:'To Start', sub:'No card' },
                ]" :key="i"
                    class="stat-cell flex flex-col justify-center items-center py-12 px-6 text-center border-r last:border-r-0 border-b lg:border-b-0 transition-colors duration-300 group"
                    :class="isDark ? 'border-[#C9A84C]/14 hover:bg-[#C9A84C]/[0.04]' : 'border-[#C9A84C]/22 hover:bg-[#C9A84C]/[0.05]'"
                    :style="`animation-delay:${i*0.1}s`">
                    <div class="font-mono text-[9px] uppercase tracking-[0.2em] mb-4" :class="isDark ? 'text-[#E8E4D9]/22' : 'text-[#1a1814]/28'">{{ s.sub }}</div>
                    <div class="font-mono tabular-nums mb-1 leading-none" style="font-family:'Cormorant Garamond',serif; color:#C9A84C; font-size:2.6rem; font-weight:300; font-style:italic">{{ s.n }}</div>
                    <div class="font-mono text-[10px] uppercase tracking-[0.18em] mt-2" :class="isDark ? 'text-[#E8E4D9]/38' : 'text-[#1a1814]/42'">{{ s.label }}</div>
                </div>
            </div>
        </section>

        <!-- ══ CTA SECTION ══ -->
        <section class="px-6 lg:px-14 pb-36">
            <div class="max-w-[1400px] mx-auto relative overflow-hidden"
                :class="isDark ? 'bg-[#0d0b08]' : 'bg-[#18140e]'"
                style="border:1px solid rgba(201,168,76,0.22)">

                <!-- Corner brackets -->
                <div class="absolute top-0 left-0 w-14 h-14 border-r border-b opacity-35" style="border-color:#C9A84C"></div>
                <div class="absolute top-0 right-0 w-14 h-14 border-l border-b opacity-35" style="border-color:#C9A84C"></div>
                <div class="absolute bottom-0 left-0 w-14 h-14 border-r border-t opacity-35" style="border-color:#C9A84C"></div>
                <div class="absolute bottom-0 right-0 w-14 h-14 border-l border-t opacity-35" style="border-color:#C9A84C"></div>

                <!-- BG glow + grid -->
                <div class="absolute top-[-25%] left-[25%] right-[25%] h-[280px] rounded-full blur-[90px] opacity-20"
                    style="background:radial-gradient(ellipse, #C9A84C 0%, transparent 70%)"></div>
                <div class="absolute inset-0 arch-grid opacity-[0.035]"></div>

                <div class="relative z-10 py-20 lg:py-28 px-8 lg:px-20 flex flex-col lg:flex-row items-center justify-between gap-12">
                    <div>
                        <div class="flex items-center gap-3 mb-8">
                            <div class="h-px w-8" style="background:#C9A84C; opacity:0.7"></div>
                            <svg width="9" height="9" viewBox="0 0 12 12"><path d="M6 0L7.5 4.5L12 6L7.5 7.5L6 12L4.5 7.5L0 6L4.5 4.5Z" fill="#C9A84C"/></svg>
                            <div class="h-px w-8" style="background:#C9A84C; opacity:0.7"></div>
                        </div>
                        <h2 style="font-family:'Cormorant Garamond',serif; font-size:clamp(2.4rem,4.5vw,4rem); font-weight:300; letter-spacing:-0.02em; line-height:1.05"
                            class="text-[#E8E4D9] mb-4">
                            Ready to ship<br><em style="color:#C9A84C">faster?</em>
                        </h2>
                        <p class="text-[#E8E4D9]/42 max-w-md leading-relaxed"
                            style="font-family:'Crimson Pro',serif; font-size:1.05rem; font-weight:300">
                            Join developers and creators who've already switched to Iris for their visual infrastructure.
                        </p>
                    </div>
                    <div class="flex flex-col sm:flex-row items-center gap-4 shrink-0">
                        <Link v-if="canRegister" href="/register"
                            class="cta-gold px-10 py-4 font-mono text-[11px] uppercase tracking-wider text-[#080810] relative overflow-hidden whitespace-nowrap"
                            style="background:#C9A84C">
                            <span class="relative z-10 flex items-center gap-3">
                                Create free workspace
                                <svg class="cta-arr" width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                    <line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/>
                                </svg>
                            </span>
                            <span class="shine-s absolute inset-0"></span>
                        </Link>
                        <Link v-if="canLogin" href="/login"
                            class="px-10 py-4 font-mono text-[11px] uppercase tracking-wider border border-[#E8E4D9]/12 text-[#E8E4D9]/42 hover:text-[#E8E4D9] hover:border-[#E8E4D9]/25 transition-all whitespace-nowrap">
                            Sign in instead
                        </Link>
                    </div>
                </div>
            </div>
        </section>

        <!-- ══ FOOTER ══ -->
        <footer class="border-t px-8 lg:px-14 py-8 flex flex-col md:flex-row items-center justify-between gap-5"
            :class="isDark ? 'border-[#C9A84C]/10 bg-[#080810]' : 'border-[#C9A84C]/18 bg-[#F7F5EF]'">
            <div class="flex items-center gap-3">
                <img src="/favicon.png" alt="Iris" class="h-6 w-6 rounded-full object-cover opacity-45" />
                <span class="italic text-base" style="font-family:'Cormorant Garamond',serif; font-weight:600"
                    :class="isDark ? 'text-[#E8E4D9]/38' : 'text-[#1a1814]/42'">Iris</span>
                <span class="font-mono text-[10px] uppercase tracking-wider"
                    :class="isDark ? 'text-[#E8E4D9]/16' : 'text-[#1a1814]/20'">© {{ new Date().getFullYear() }}</span>
            </div>
            <div class="flex items-center gap-6 font-mono text-[10px] uppercase tracking-wider"
                :class="isDark ? 'text-[#E8E4D9]/25' : 'text-[#1a1814]/32'">
                <a href="#" class="transition-colors duration-200 hover:text-[#C9A84C]">Privacy</a>
                <a href="#" class="transition-colors duration-200 hover:text-[#C9A84C]">Terms</a>
                <a href="#" class="transition-colors duration-200 hover:text-[#C9A84C]">Docs</a>
                <Link href="/login" class="transition-colors duration-200 hover:text-[#C9A84C]">Sign in</Link>
            </div>
        </footer>

    </div>
</template>

<style scoped>
/* ── Gold grid ──────────────────────────────────────── */
.arch-grid {
    background-image:
        linear-gradient(rgba(201,168,76,0.55) 1px, transparent 1px),
        linear-gradient(90deg, rgba(201,168,76,0.55) 1px, transparent 1px);
    background-size: 64px 64px;
}

/* ── Grain ──────────────────────────────────────────── */
.grain-tex {
    background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.85' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)'/%3E%3C/svg%3E");
    background-size: 180px 180px;
}

/* ── Hero entrance ──────────────────────────────────── */
.hero-in {
    animation: heroIn 0.9s cubic-bezier(0.22,1,0.36,1) both;
}
.hero-vis-in {
    animation: heroVisIn 1.1s cubic-bezier(0.22,1,0.36,1) 0.22s both;
}
@keyframes heroIn {
    from { opacity:0; transform:translateY(40px); }
    to   { opacity:1; transform:translateY(0); }
}
@keyframes heroVisIn {
    from { opacity:0; transform:translateY(50px) scale(0.95); }
    to   { opacity:1; transform:translateY(0) scale(1); }
}

/* ── Mockup float ───────────────────────────────────── */
.mockup-win {
    animation: winFloat 9s ease-in-out 1.4s infinite;
    will-change: transform;
    transition: transform 0.1s ease-out;
}
@keyframes winFloat {
    0%,100% { transform:perspective(1200px) translateY(0); }
    45%     { transform:perspective(1200px) translateY(-13px); }
    75%     { transform:perspective(1200px) translateY(-6px); }
}

/* ── Floating chips ─────────────────────────────────── */
.fc-1 { animation: cf1 7s ease-in-out 0.6s infinite; }
.fc-2 { animation: cf2 6.5s ease-in-out 1s infinite; }
.fc-3 { animation: cf3 8s ease-in-out 1.5s infinite; }
.fc-4 { animation: cf1 5.8s ease-in-out 2s infinite; }

@keyframes cf1 {
    0%,100% { transform:translateY(0) rotate(0deg); }
    40%     { transform:translateY(-10px) rotate(0.3deg); }
    70%     { transform:translateY(-5px) rotate(-0.2deg); }
}
@keyframes cf2 {
    0%,100% { transform:translateY(0) rotate(0deg); }
    38%     { transform:translateY(-9px) rotate(-0.35deg); }
    68%     { transform:translateY(-4px) rotate(0.2deg); }
}
@keyframes cf3 {
    0%,100% { transform:translateY(0); }
    50%     { transform:translateY(-12px) rotate(0.25deg); }
}

/* ── Image tiles ────────────────────────────────────── */
.img-tile {
    animation: tileIn 0.5s cubic-bezier(0.34,1.56,0.64,1) both;
    transition: transform 0.3s cubic-bezier(0.22,1,0.36,1), filter 0.3s ease;
}
.img-tile:hover {
    transform: scale(1.04) translateY(-2px);
    filter: brightness(1.07) saturate(1.06);
}
@keyframes tileIn {
    from { opacity:0; transform:scale(0.78); }
    to   { opacity:1; transform:scale(1); }
}

/* ── Feature rows ───────────────────────────────────── */
.feat-row {
    animation: rowIn 0.55s cubic-bezier(0.22,1,0.36,1) both;
}
@keyframes rowIn {
    from { opacity:0; transform:translateX(-14px); }
    to   { opacity:1; transform:translateX(0); }
}

/* ── Stat cells ─────────────────────────────────────── */
.stat-cell {
    animation: rowIn 0.55s cubic-bezier(0.22,1,0.36,1) both;
}

/* ── Gold CTA button ────────────────────────────────── */
.cta-gold {
    display: inline-flex;
    align-items: center;
    transition: transform 0.25s cubic-bezier(0.22,1,0.36,1), box-shadow 0.25s ease, filter 0.25s ease;
    box-shadow: 0 4px 20px -5px rgba(201,168,76,0.45);
}
.cta-gold:hover {
    transform: translateY(-2px);
    filter: brightness(1.08);
    box-shadow: 0 12px 36px -6px rgba(201,168,76,0.6);
}
.cta-gold:active { transform:translateY(0); }
.cta-gold:hover .cta-arr { transform:translateX(4px); }
.cta-arr { transition: transform 0.2s ease; }

/* Shine sweep on CTA */
.shine-s {
    background: linear-gradient(110deg, transparent 40%, rgba(255,255,255,0.22) 50%, transparent 60%);
    transform: translateX(-120%) skewX(-15deg);
}
.cta-gold:hover .shine-s {
    transform: translateX(220%) skewX(-15deg);
    transition: transform 0.7s ease;
}

/* ── Nav button ─────────────────────────────────────── */
.nav-cta-btn {
    transition: transform 0.2s ease, box-shadow 0.2s ease, filter 0.2s ease;
    box-shadow: 0 2px 12px -4px rgba(201,168,76,0.4);
    display: inline-block;
}
.nav-cta-btn:hover {
    transform: translateY(-1px);
    filter: brightness(1.06);
}

/* ── Upload bar ─────────────────────────────────────── */
.upload-bar {
    animation: uploadAnim 3.5s ease-in-out 3s infinite;
}
@keyframes uploadAnim {
    0%   { width:74%; }
    35%  { width:92%; }
    55%  { width:92%; }
    76%  { width:100%; opacity:1; }
    80%  { opacity:0; width:100%; }
    81%  { opacity:0; width:0; }
    82%  { opacity:1; width:0; }
    100% { width:74%; }
}

/* ── Scroll cue ─────────────────────────────────────── */
.scroll-cue { animation: scFade 3s ease-in-out 2.2s infinite; }
@keyframes scFade {
    0%,100% { opacity:0.3; }
    50%     { opacity:0.65; }
}
.scroll-ln { animation: scGrow 3s ease-in-out 2.2s infinite; transform-origin:top; }
@keyframes scGrow {
    0%,100% { transform:scaleY(1); }
    50%     { transform:scaleY(1.15); }
}
</style>

<style>
html.dark { color-scheme: dark; }
</style>