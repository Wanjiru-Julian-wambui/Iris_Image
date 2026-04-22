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

const onScroll = () => { scrollY.value = window.scrollY; };

onMounted(() => {
    if (
        localStorage.theme === 'dark' ||
        (!('theme' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches)
    ) {
        isDark.value = true;
        document.documentElement.classList.add('dark');
    } else {
        isDark.value = false;
        document.documentElement.classList.remove('dark');
    }
    window.addEventListener('scroll', onScroll, { passive: true });
    // Staggered hero entrance
    setTimeout(() => { heroVisible.value = true; }, 80);
});

onUnmounted(() => window.removeEventListener('scroll', onScroll));

const toggleTheme = () => {
    isDark.value = !isDark.value;
    document.documentElement.classList.toggle('dark', isDark.value);
    localStorage.theme = isDark.value ? 'dark' : 'light';
};

const features = [
    {
        title: 'Lightning CDN',
        desc: 'Assets served from 200+ edge nodes. Sub-50ms load times globally, every time.',
        color: '#7B2FFF',
        // Zap icon
        paths: ['M13 2L3 14h9l-1 8 10-12h-9l1-8z'],
    },
    {
        title: 'Granular Privacy',
        desc: 'Password-protect, set expiry dates, or lock assets to specific team members.',
        color: '#00C6FF',
        // Shield icon
        paths: ['M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z'],
    },
    {
        title: 'Auto-Optimisation',
        desc: 'Upload anything. Iris compresses and converts to WebP automatically.',
        color: '#a855f7',
        // Sparkles / wand
        paths: ['M15 4V2', 'M15 16v-2', 'M8 9h2', 'M20 9h2', 'M17.8 11.8L19 13', 'M15 9h.01', 'M17.8 6.2L19 5', 'M3 21l9-9', 'M12.2 6.2L11 5'],
    },
    {
        title: 'Smart Workspace',
        desc: 'Nested folders, role-based access, and team sharing—built in from day one.',
        color: '#06b6d4',
        // Folder icon
        paths: ['M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z'],
    },
    {
        title: 'EXIF Stripping',
        desc: 'GPS coordinates, camera model, timestamps—all scrubbed on upload.',
        color: '#10b981',
        // Eye-off icon
        paths: ['M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19m-6.72-1.07a3 3 0 1 1-4.24-4.24', 'M1 1l22 22'],
    },
    {
        title: 'One-Click Share',
        desc: 'Copy markdown, HTML, BBCode, or raw URLs instantly from your dashboard.',
        color: '#f59e0b',
        // Link icon
        paths: ['M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71', 'M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71'],
    },
];

// Mock image grid data
const mockImages = [
    { w: 2, h: 2, bg: 'from-violet-500/30 to-purple-900/50', delay: 0 },
    { w: 1, h: 1, bg: 'from-cyan-500/30 to-blue-900/50', delay: 0.1 },
    { w: 1, h: 1, bg: 'from-emerald-500/30 to-teal-900/50', delay: 0.2 },
    { w: 1, h: 2, bg: 'from-pink-500/30 to-rose-900/50', delay: 0.15 },
    { w: 2, h: 1, bg: 'from-amber-500/30 to-orange-900/50', delay: 0.25 },
    { w: 1, h: 1, bg: 'from-indigo-500/30 to-violet-900/50', delay: 0.05 },
];
</script>

<template>
    <Head title="Iris — The ultimate home for your visual assets" />

    <div class="min-h-screen bg-[#f8f7ff] text-slate-900 dark:bg-[#06040f] dark:text-white overflow-x-hidden transition-colors duration-500"
         style="font-family: 'DM Sans', system-ui, sans-serif;">

        <!-- Google Font import via inline style trick -->
        <component :is="'style'">
            @import url('https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&family=Syne:wght@700;800&display=swap');
        </component>

        <!-- ══ NAVBAR ══════════════════════════════════════════════ -->
        <header
            class="fixed top-0 left-0 right-0 z-50 flex items-center justify-between px-6 lg:px-12 h-16 transition-all duration-300"
            :class="scrollY > 20
                ? 'bg-white/80 dark:bg-[#06040f]/80 backdrop-blur-xl border-b border-slate-200/60 dark:border-white/[0.06] shadow-sm'
                : 'bg-transparent'"
        >
            <Link href="/" class="flex items-center gap-2.5 group">
                <div class="relative">
                    <div class="absolute inset-0 bg-gradient-to-br from-[#7B2FFF] to-[#00C6FF] rounded-full blur-md opacity-60 group-hover:opacity-90 transition-opacity"></div>
                    <img src="/favicon.png" alt="Iris" class="relative h-8 w-8 rounded-full object-cover" />
                </div>
                <span class="text-lg font-bold tracking-tight" style="font-family:'Syne',sans-serif">Iris</span>
            </Link>

            <nav class="flex items-center gap-1">
                <!-- Theme toggle -->
                <button @click="toggleTheme"
                    class="p-2 rounded-lg text-slate-500 hover:text-slate-800 hover:bg-slate-100 dark:text-white/50 dark:hover:text-white dark:hover:bg-white/8 transition-all"
                    aria-label="Toggle theme">
                    <!-- Sun -->
                    <svg v-if="isDark" class="h-4.5 w-4.5" style="width:18px;height:18px" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="5"/>
                        <line x1="12" y1="1" x2="12" y2="3"/><line x1="12" y1="21" x2="12" y2="23"/>
                        <line x1="4.22" y1="4.22" x2="5.64" y2="5.64"/><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"/>
                        <line x1="1" y1="12" x2="3" y2="12"/><line x1="21" y1="12" x2="23" y2="12"/>
                        <line x1="4.22" y1="19.78" x2="5.64" y2="18.36"/><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"/>
                    </svg>
                    <!-- Moon -->
                    <svg v-else style="width:18px;height:18px" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/>
                    </svg>
                </button>

                <div class="w-px h-4 bg-slate-200 dark:bg-white/10 mx-1"></div>

                <Link v-if="$page.props.auth?.user" href="/dashboard"
                    class="px-4 py-2 rounded-lg text-sm font-medium text-slate-700 hover:bg-slate-100 dark:text-white/80 dark:hover:bg-white/8 transition-all">
                    Dashboard
                </Link>
                <template v-else>
                    <Link v-if="canLogin" href="/login"
                        class="hidden sm:inline-block px-4 py-2 rounded-lg text-sm font-medium text-slate-600 hover:text-slate-900 dark:text-white/60 dark:hover:text-white transition-colors">
                        Sign in
                    </Link>
                    <Link v-if="canRegister" href="/register"
                        class="ml-1 px-5 py-2 rounded-lg text-sm font-semibold text-white transition-all duration-300 hover:-translate-y-px hover:shadow-lg hover:shadow-[#7B2FFF]/30"
                        style="background: linear-gradient(135deg, #7B2FFF, #00C6FF)">
                        Get started
                    </Link>
                </template>
            </nav>
        </header>

        <!-- ══ HERO ════════════════════════════════════════════════ -->
        <section class="relative min-h-screen flex items-center pt-16 overflow-hidden">

            <!-- Ambient background -->
            <div class="absolute inset-0 -z-10">
                <!-- Grid pattern -->
                <div class="absolute inset-0 opacity-[0.03] dark:opacity-[0.06]"
                    style="background-image: linear-gradient(#7B2FFF 1px, transparent 1px), linear-gradient(90deg, #7B2FFF 1px, transparent 1px); background-size: 48px 48px;"></div>
                <!-- Glow orbs -->
                <div class="absolute top-1/3 left-1/4 w-[700px] h-[700px] rounded-full blur-[140px]"
                    style="background: radial-gradient(circle, rgba(123,47,255,0.18) 0%, transparent 70%)"></div>
                <div class="absolute bottom-1/4 right-1/4 w-[500px] h-[500px] rounded-full blur-[120px]"
                    style="background: radial-gradient(circle, rgba(0,198,255,0.14) 0%, transparent 70%)"></div>
            </div>

            <div class="max-w-7xl mx-auto px-6 lg:px-12 w-full py-24 lg:py-0 grid lg:grid-cols-2 gap-16 items-center">

                <!-- Left: Text -->
                <div :class="heroVisible ? 'hero-text-in' : 'opacity-0'" class="z-10">

                    <!-- Pill badge -->
                    <div class="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full text-xs font-semibold mb-8 border transition-colors"
                        style="border-color: rgba(123,47,255,0.3); background: rgba(123,47,255,0.06); color: #9b6fff">
                        <span class="relative flex h-1.5 w-1.5">
                            <span class="animate-ping absolute inline-flex h-full w-full rounded-full opacity-75" style="background:#7B2FFF"></span>
                            <span class="relative inline-flex rounded-full h-1.5 w-1.5" style="background:#7B2FFF"></span>
                        </span>
                        Iris Cloud · Now in open beta
                    </div>

                    <h1 class="mb-6 leading-[1.08] tracking-tight" style="font-family:'Syne',sans-serif; font-size: clamp(2.8rem, 6vw, 4.5rem); font-weight:800;">
                        Your images.<br>
                        <span class="relative inline-block">
                            <span class="relative z-10" style="background: linear-gradient(135deg, #7B2FFF 0%, #00C6FF 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;">Everywhere.</span>
                            <!-- Underline decoration -->
                            <span class="absolute -bottom-1 left-0 right-0 h-0.5 rounded-full" style="background: linear-gradient(90deg, #7B2FFF, #00C6FF); opacity: 0.4"></span>
                        </span>
                    </h1>

                    <p class="text-lg text-slate-500 dark:text-white/50 max-w-lg mb-10 leading-relaxed">
                        A beautifully fast image hosting platform with CDN delivery, smart organisation, and privacy controls — built for developers and creators.
                    </p>

                    <!-- CTA Buttons -->
                    <div class="flex flex-wrap items-center gap-3 mb-12">
                        <Link v-if="canRegister" href="/register"
                            class="cta-primary group relative px-7 py-3.5 rounded-xl text-sm font-semibold text-white overflow-hidden transition-all duration-300 hover:-translate-y-0.5"
                            style="background: linear-gradient(135deg, #7B2FFF, #00C6FF); box-shadow: 0 8px 32px -8px rgba(123,47,255,0.5)">
                            <span class="relative z-10 flex items-center gap-2">
                                Start free
                                <svg style="width:16px;height:16px" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                    <line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/>
                                </svg>
                            </span>
                            <!-- Shine sweep -->
                            <span class="absolute inset-0 translate-x-[-100%] group-hover:translate-x-[100%] transition-transform duration-700 bg-gradient-to-r from-transparent via-white/20 to-transparent skew-x-12"></span>
                        </Link>
                        <Link v-if="canLogin" href="/login"
                            class="px-7 py-3.5 rounded-xl text-sm font-medium transition-all duration-300 hover:-translate-y-0.5 border"
                            :class="isDark
                                ? 'border-white/10 text-white/70 hover:text-white hover:border-white/20 hover:bg-white/5'
                                : 'border-slate-200 text-slate-600 hover:text-slate-900 hover:border-slate-300 hover:bg-white'">
                            Sign in
                        </Link>
                    </div>

                    <!-- Trust pills -->
                    <div class="flex flex-wrap gap-2">
                        <span v-for="t in ['No credit card', 'Free 1 GB', 'Instant setup', 'Cancel anytime']" :key="t"
                            class="inline-flex items-center gap-1.5 px-3 py-1 rounded-md text-xs font-medium"
                            :class="isDark ? 'bg-white/5 text-white/40' : 'bg-slate-100 text-slate-500'">
                            <svg style="width:10px;height:10px;color:#10b981" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                                <polyline points="20 6 9 17 4 12"/>
                            </svg>
                            {{ t }}
                        </span>
                    </div>
                </div>

                <!-- Right: Floating App Mockup -->
                <div :class="heroVisible ? 'hero-visual-in' : 'opacity-0'" class="relative z-10 hidden lg:block">

                    <!-- Outer glow halo -->
                    <div class="absolute inset-4 rounded-3xl blur-2xl opacity-30"
                        style="background: linear-gradient(135deg, #7B2FFF, #00C6FF)"></div>

                    <!-- App window card -->
                    <div class="relative rounded-2xl border overflow-hidden"
                        :class="isDark ? 'bg-[#0d0b1a] border-white/10' : 'bg-white border-slate-200'"
                        style="box-shadow: 0 40px 80px -20px rgba(0,0,0,0.5)">

                        <!-- Title bar -->
                        <div class="flex items-center justify-between px-4 py-3 border-b"
                            :class="isDark ? 'border-white/[0.06] bg-[#100e1f]' : 'border-slate-100 bg-slate-50'">
                            <div class="flex items-center gap-1.5">
                                <div class="h-3 w-3 rounded-full bg-[#ff5f56]"></div>
                                <div class="h-3 w-3 rounded-full bg-[#ffbd2e]"></div>
                                <div class="h-3 w-3 rounded-full bg-[#27c93f]"></div>
                            </div>
                            <div class="flex items-center gap-2 px-3 py-1 rounded-md text-xs font-mono"
                                :class="isDark ? 'bg-white/5 text-white/30' : 'bg-slate-100 text-slate-400'">
                                iris.app/gallery
                            </div>
                            <div class="w-16"></div>
                        </div>

                        <!-- Toolbar -->
                        <div class="flex items-center justify-between px-4 py-2.5 border-b"
                            :class="isDark ? 'border-white/[0.04]' : 'border-slate-100'">
                            <span class="text-xs font-semibold" :class="isDark ? 'text-white/60' : 'text-slate-500'">My Gallery</span>
                            <div class="flex items-center gap-2">
                                <div class="h-6 w-16 rounded-md" :class="isDark ? 'bg-white/5' : 'bg-slate-100'"></div>
                                <div class="h-6 w-6 rounded-md flex items-center justify-center"
                                    style="background: linear-gradient(135deg, #7B2FFF, #00C6FF)">
                                    <svg style="width:10px;height:10px;color:white" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                        <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
                                    </svg>
                                </div>
                            </div>
                        </div>

                        <!-- Image grid mockup -->
                        <div class="p-4 grid grid-cols-3 gap-2.5" style="min-height: 280px">
                            <div v-for="(img, i) in mockImages" :key="i"
                                class="image-tile rounded-xl overflow-hidden relative"
                                :class="[
                                    img.w === 2 ? 'col-span-2' : 'col-span-1',
                                    img.h === 2 ? 'row-span-2' : 'row-span-1',
                                    `bg-gradient-to-br ${img.bg}`,
                                ]"
                                :style="`animation-delay:${img.delay}s; min-height: ${img.h === 2 ? '160px' : '75px'}`"
                            >
                                <!-- shimmer lines -->
                                <div class="absolute bottom-2 left-2 right-2 space-y-1">
                                    <div class="h-1.5 rounded-full w-3/4" :class="isDark ? 'bg-white/10' : 'bg-black/10'"></div>
                                    <div class="h-1 rounded-full w-1/2" :class="isDark ? 'bg-white/6' : 'bg-black/6'"></div>
                                </div>
                                <!-- hover overlay -->
                                <div class="absolute inset-0 opacity-0 hover:opacity-100 transition-opacity duration-300 flex items-center justify-center"
                                    :class="isDark ? 'bg-black/40' : 'bg-black/20'">
                                    <div class="h-8 w-8 rounded-full bg-white/20 backdrop-blur-sm flex items-center justify-center">
                                        <svg style="width:14px;height:14px;color:white" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>
                                        </svg>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Status bar -->
                        <div class="flex items-center justify-between px-4 py-2.5 border-t text-[10px] font-medium"
                            :class="isDark ? 'border-white/[0.04] text-white/25' : 'border-slate-100 text-slate-400'">
                            <span>6 assets · 667 KB used</span>
                            <div class="flex items-center gap-1" style="color:#10b981">
                                <span class="relative flex h-1.5 w-1.5">
                                    <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-emerald-400 opacity-75"></span>
                                    <span class="relative inline-flex rounded-full h-1.5 w-1.5 bg-emerald-500"></span>
                                </span>
                                CDN online
                            </div>
                        </div>
                    </div>

                    <!-- Floating stat chips around the mockup -->
                    <div class="absolute -left-10 top-1/3 float-chip rounded-xl px-3.5 py-2 text-xs font-semibold shadow-xl border"
                        :class="isDark ? 'bg-[#0d0b1a] border-white/10 text-white' : 'bg-white border-slate-200 text-slate-700'"
                        style="animation-delay: 0.4s">
                        <div class="text-[10px] font-normal mb-0.5" :class="isDark ? 'text-white/40' : 'text-slate-400'">Avg load time</div>
                        <div class="flex items-center gap-1.5">
                            <span style="color:#00C6FF; font-size:1rem; font-family:'Syne',sans-serif">42ms</span>
                            <svg style="width:12px;height:12px;color:#10b981" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                <polyline points="23 6 13.5 15.5 8.5 10.5 1 18"/><polyline points="17 6 23 6 23 12"/>
                            </svg>
                        </div>
                    </div>

                    <div class="absolute -right-8 top-1/4 float-chip rounded-xl px-3.5 py-2 text-xs font-semibold shadow-xl border"
                        :class="isDark ? 'bg-[#0d0b1a] border-white/10 text-white' : 'bg-white border-slate-200 text-slate-700'"
                        style="animation-delay: 0.9s">
                        <div class="text-[10px] font-normal mb-0.5" :class="isDark ? 'text-white/40' : 'text-slate-400'">Compression</div>
                        <span style="color:#7B2FFF; font-size:1rem; font-family:'Syne',sans-serif">−68%</span>
                    </div>

                    <div class="absolute -right-4 bottom-16 float-chip rounded-xl px-3.5 py-2 text-xs font-semibold shadow-xl border"
                        :class="isDark ? 'bg-[#0d0b1a] border-white/10 text-white' : 'bg-white border-slate-200 text-slate-700'"
                        style="animation-delay: 1.3s">
                        <div class="text-[10px] font-normal mb-0.5" :class="isDark ? 'text-white/40' : 'text-slate-400'">Edge nodes</div>
                        <span style="color:#a855f7; font-size:1rem; font-family:'Syne',sans-serif">200+</span>
                    </div>
                </div>
            </div>
        </section>

        <!-- ══ FEATURES ════════════════════════════════════════════ -->
        <section class="px-6 lg:px-12 py-28 max-w-7xl mx-auto">

            <div class="text-center mb-16 max-w-2xl mx-auto">
                <p class="text-xs font-bold uppercase tracking-[0.2em] mb-4" style="color:#7B2FFF">What's inside</p>
                <h2 class="text-3xl lg:text-4xl font-bold mb-4 tracking-tight" style="font-family:'Syne',sans-serif">
                    Everything you need.<br>
                    <span :class="isDark ? 'text-white/30' : 'text-slate-400'">Nothing you don't.</span>
                </h2>
            </div>

            <div class="grid sm:grid-cols-2 lg:grid-cols-3 gap-5">
                <div v-for="(f, i) in features" :key="f.title"
                    class="feature-card group relative rounded-2xl p-7 border overflow-hidden cursor-default transition-all duration-300 hover:-translate-y-1"
                    :class="isDark
                        ? 'bg-white/[0.02] border-white/[0.06] hover:border-white/15 hover:bg-white/[0.04]'
                        : 'bg-white border-slate-200 hover:border-slate-300 shadow-sm hover:shadow-lg hover:shadow-slate-200/60'"
                    :style="`animation-delay: ${i * 0.07}s`">

                    <!-- Glow on hover -->
                    <div class="absolute inset-0 opacity-0 group-hover:opacity-100 transition-opacity duration-500 rounded-2xl pointer-events-none"
                        :style="`background: radial-gradient(circle at 30% 30%, ${f.color}12 0%, transparent 65%)`"></div>

                    <!-- Icon -->
                    <div class="relative mb-5 h-11 w-11 rounded-xl flex items-center justify-center transition-transform duration-300 group-hover:scale-110"
                        :style="`background: ${f.color}18; border: 1px solid ${f.color}30`">
                        <svg style="width:18px;height:18px" :style="`color:${f.color}`"
                            viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8"
                            stroke-linecap="round" stroke-linejoin="round">
                            <path v-for="(p, pi) in f.paths" :key="pi" :d="p"/>
                        </svg>
                    </div>

                    <h3 class="text-base font-bold mb-2 tracking-tight" style="font-family:'Syne',sans-serif">{{ f.title }}</h3>
                    <p class="text-sm leading-relaxed" :class="isDark ? 'text-white/45' : 'text-slate-500'">{{ f.desc }}</p>
                </div>
            </div>
        </section>

        <!-- ══ CTA ═════════════════════════════════════════════════ -->
        <section class="px-6 lg:px-12 pb-32">
            <div class="max-w-5xl mx-auto relative rounded-3xl overflow-hidden"
                :class="isDark ? 'bg-[#0d0b1a]' : 'bg-slate-900'">

                <!-- Mesh gradient bg -->
                <div class="absolute inset-0">
                    <div class="absolute -top-32 -left-32 w-80 h-80 rounded-full blur-[100px]" style="background:rgba(123,47,255,0.5)"></div>
                    <div class="absolute -bottom-32 -right-32 w-80 h-80 rounded-full blur-[100px]" style="background:rgba(0,198,255,0.35)"></div>
                    <!-- Fine grid overlay -->
                    <div class="absolute inset-0 opacity-[0.04]"
                        style="background-image: linear-gradient(white 1px, transparent 1px), linear-gradient(90deg, white 1px, transparent 1px); background-size: 32px 32px;"></div>
                </div>

                <div class="relative z-10 py-20 lg:py-24 px-8 lg:px-16 flex flex-col lg:flex-row items-center justify-between gap-12">
                    <div class="text-center lg:text-left">
                        <h2 class="text-3xl lg:text-4xl font-bold text-white mb-3 tracking-tight" style="font-family:'Syne',sans-serif">
                            Ready to ship faster?
                        </h2>
                        <p class="text-white/50 text-lg max-w-md">
                            Join developers and creators who've already switched to Iris for their visual infrastructure.
                        </p>
                    </div>
                    <div class="flex flex-col sm:flex-row items-center gap-3 shrink-0">
                        <Link v-if="canRegister" href="/register"
                            class="cta-primary group relative px-8 py-4 rounded-xl text-sm font-bold text-white overflow-hidden whitespace-nowrap transition-all duration-300 hover:-translate-y-0.5"
                            style="background: linear-gradient(135deg, #7B2FFF, #00C6FF); box-shadow: 0 8px 32px -8px rgba(123,47,255,0.6)">
                            <span class="relative z-10 flex items-center gap-2">
                                Create free workspace
                                <svg style="width:15px;height:15px" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                    <line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/>
                                </svg>
                            </span>
                            <span class="absolute inset-0 translate-x-[-100%] group-hover:translate-x-[100%] transition-transform duration-700 bg-gradient-to-r from-transparent via-white/20 to-transparent skew-x-12"></span>
                        </Link>
                        <Link v-if="canLogin" href="/login"
                            class="px-8 py-4 rounded-xl text-sm font-medium text-white/60 hover:text-white border border-white/10 hover:border-white/20 hover:bg-white/5 transition-all duration-300 whitespace-nowrap">
                            Sign in instead
                        </Link>
                    </div>
                </div>
            </div>
        </section>

        <!-- ══ FOOTER ══════════════════════════════════════════════ -->
        <footer class="border-t px-8 lg:px-12 py-8 flex flex-col md:flex-row items-center justify-between gap-5 text-sm transition-colors"
            :class="isDark ? 'border-white/[0.06] bg-[#06040f] text-white/30' : 'border-slate-200 bg-white text-slate-400'">

            <div class="flex items-center gap-2.5">
                <img src="/favicon.png" alt="Iris" class="h-5 w-5 rounded-full object-cover opacity-60" />
                <span class="font-bold" style="font-family:'Syne',sans-serif" :class="isDark ? 'text-white/50' : 'text-slate-500'">Iris</span>
                <span class="text-xs">© {{ new Date().getFullYear() }}</span>
            </div>

            <div class="flex items-center gap-6 text-xs font-medium">
                <a href="#" class="hover:text-[#7B2FFF] transition-colors">Privacy</a>
                <a href="#" class="hover:text-[#7B2FFF] transition-colors">Terms</a>
                <a href="#" class="hover:text-[#7B2FFF] transition-colors">Docs</a>
                <Link href="/login" class="hover:text-[#7B2FFF] transition-colors">Sign in</Link>
            </div>
        </footer>

    </div>
</template>

<style scoped>
/* ── Hero entrance ── */
.hero-text-in {
    animation: heroTextIn 0.7s cubic-bezier(0.22, 1, 0.36, 1) both;
}
.hero-visual-in {
    animation: heroVisualIn 0.9s cubic-bezier(0.22, 1, 0.36, 1) 0.15s both;
}
@keyframes heroTextIn {
    from { opacity: 0; transform: translateY(28px); }
    to   { opacity: 1; transform: translateY(0); }
}
@keyframes heroVisualIn {
    from { opacity: 0; transform: translateY(36px) scale(0.97); }
    to   { opacity: 1; transform: translateY(0) scale(1); }
}

/* ── App window float ── */
.hero-visual-in > div:nth-child(2) {
    animation: windowFloat 6s ease-in-out 1s infinite;
}
@keyframes windowFloat {
    0%, 100% { transform: translateY(0px) rotate(0deg); }
    33%       { transform: translateY(-10px) rotate(0.3deg); }
    66%       { transform: translateY(-5px) rotate(-0.2deg); }
}

/* ── Stat chips float independently ── */
.float-chip {
    animation: chipFloat 5s ease-in-out infinite;
}
@keyframes chipFloat {
    0%, 100% { transform: translateY(0px); }
    50%       { transform: translateY(-8px); }
}

/* ── Image tiles pop in ── */
.image-tile {
    animation: tileIn 0.5s cubic-bezier(0.34, 1.56, 0.64, 1) both;
}
@keyframes tileIn {
    from { opacity: 0; transform: scale(0.85); }
    to   { opacity: 1; transform: scale(1); }
}

/* ── Feature cards scroll reveal ── */
.feature-card {
    animation: featureIn 0.5s cubic-bezier(0.22, 1, 0.36, 1) both;
}
@keyframes featureIn {
    from { opacity: 0; transform: translateY(24px); }
    to   { opacity: 1; transform: translateY(0); }
}

/* ── CTA button shine ── */
.cta-primary:hover {
    box-shadow: 0 16px 48px -8px rgba(123, 47, 255, 0.6);
}
</style>

<style>
/* Global — wave keyframe for emoji if needed elsewhere */
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