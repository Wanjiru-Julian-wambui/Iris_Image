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

const onScroll = () => { scrollY.value = window.scrollY; };
const onMouse = (e: MouseEvent) => {
    mouseX.value = (e.clientX / window.innerWidth - 0.5) * 20;
    mouseY.value = (e.clientY / window.innerHeight - 0.5) * 20;
};

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
    window.addEventListener('mousemove', onMouse, { passive: true });
    setTimeout(() => { heroVisible.value = true; }, 80);
});

onUnmounted(() => {
    window.removeEventListener('scroll', onScroll);
    window.removeEventListener('mousemove', onMouse);
});

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
        icon: `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></svg>`,
    },
    {
        title: 'Granular Privacy',
        desc: 'Password-protect, set expiry dates, or lock assets to specific team members.',
        color: '#00C6FF',
        icon: `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>`,
    },
    {
        title: 'Auto-Optimisation',
        desc: 'Upload anything. Iris compresses and converts to WebP automatically.',
        color: '#a855f7',
        icon: `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M12 3a6 6 0 0 0 9 9 9 9 0 1 1-9-9Z"/><path d="M20 3v4"/><path d="M22 5h-4"/></svg>`,
    },
    {
        title: 'Smart Workspace',
        desc: 'Nested folders, role-based access, and team sharing—built in from day one.',
        color: '#06b6d4',
        icon: `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"/></svg>`,
    },
    {
        title: 'EXIF Stripping',
        desc: 'GPS coordinates, camera model, timestamps—all scrubbed on upload.',
        color: '#10b981',
        icon: `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M9.88 9.88a3 3 0 1 0 4.24 4.24"/><path d="M10.73 5.08A10.43 10.43 0 0 1 12 5c7 0 10 7 10 7a13.16 13.16 0 0 1-1.67 2.68"/><path d="M6.61 6.61A13.526 13.526 0 0 0 2 12s3 7 10 7a9.74 9.74 0 0 0 5.39-1.61"/><line x1="2" y1="2" x2="22" y2="22"/></svg>`,
    },
    {
        title: 'One-Click Share',
        desc: 'Copy markdown, HTML, BBCode, or raw URLs instantly from your dashboard.',
        color: '#f59e0b',
        icon: `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71"/><path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71"/></svg>`,
    },
];

const mockImages = [
    { col: 'col-span-2', row: 'row-span-2', bg: 'from-violet-600/40 via-purple-800/30 to-indigo-900/50', delay: '0s', minH: '160px' },
    { col: 'col-span-1', row: 'row-span-1', bg: 'from-cyan-500/40 via-sky-700/30 to-blue-900/50', delay: '0.08s', minH: '72px' },
    { col: 'col-span-1', row: 'row-span-1', bg: 'from-emerald-500/40 via-teal-700/30 to-green-900/50', delay: '0.16s', minH: '72px' },
    { col: 'col-span-1', row: 'row-span-2', bg: 'from-pink-500/40 via-rose-700/30 to-red-900/50', delay: '0.12s', minH: '160px' },
    { col: 'col-span-2', row: 'row-span-1', bg: 'from-amber-500/40 via-orange-700/30 to-yellow-900/50', delay: '0.2s', minH: '72px' },
    { col: 'col-span-1', row: 'row-span-1', bg: 'from-indigo-500/40 via-violet-700/30 to-purple-900/50', delay: '0.04s', minH: '72px' },
];

const stats = [
    { label: 'Avg load time', value: '42ms', color: '#00C6FF', trend: 'up' },
    { label: 'Compression', value: '−68%', color: '#7B2FFF', trend: null },
    { label: 'Edge nodes', value: '200+', color: '#a855f7', trend: null },
];
</script>

<template>
    <Head title="Iris — The ultimate home for your visual assets" />

    <div
        class="min-h-screen overflow-x-hidden transition-colors duration-500"
        :class="isDark ? 'bg-[#06040f] text-white' : 'bg-[#f5f4ff] text-slate-900'"
        style="font-family: 'DM Sans', system-ui, sans-serif;"
    >
        <!-- Font imports -->
        <component :is="'style'">
            @import url('https://fonts.googleapis.com/css2?family=DM+Sans:ital,opsz,wght@0,9..40,300;0,9..40,400;0,9..40,500;0,9..40,600;0,9..40,700;1,9..40,300&family=Syne:wght@600;700;800&display=swap');
        </component>

        <!-- ══ NAVBAR ══════════════════════════════════════════ -->
        <header
            class="fixed top-0 left-0 right-0 z-50 flex items-center justify-between px-6 lg:px-14 h-[62px] transition-all duration-500"
            :class="scrollY > 20
                ? (isDark
                    ? 'bg-[#06040f]/85 backdrop-blur-2xl border-b border-white/[0.07] shadow-[0_1px_0_rgba(255,255,255,0.04)]'
                    : 'bg-white/90 backdrop-blur-2xl border-b border-slate-200/80 shadow-sm')
                : 'bg-transparent'"
        >
            <!-- Logo -->
            <Link href="/" class="flex items-center gap-2.5 group select-none">
                <div class="relative h-8 w-8">
                    <div class="absolute inset-0 rounded-full blur-lg opacity-70 group-hover:opacity-100 transition-opacity duration-300"
                        style="background: linear-gradient(135deg, #7B2FFF, #00C6FF)"></div>
                    <div class="relative h-8 w-8 rounded-full flex items-center justify-center overflow-hidden"
                        style="background: linear-gradient(135deg, #7B2FFF 0%, #5b9dff 50%, #00C6FF 100%)">
                        <svg style="width:16px;height:16px;color:white" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <circle cx="12" cy="12" r="3"/><path d="M12 1v4M12 19v4M4.22 4.22l2.83 2.83M16.95 16.95l2.83 2.83M1 12h4M19 12h4M4.22 19.78l2.83-2.83M16.95 7.05l2.83-2.83"/>
                        </svg>
                    </div>
                </div>
                <span class="text-[17px] font-bold tracking-[-0.02em]" style="font-family:'Syne',sans-serif">Iris</span>
            </Link>

            <nav class="flex items-center gap-1">
                <!-- Theme toggle -->
                <button @click="toggleTheme"
                    class="p-2 rounded-lg transition-all duration-200"
                    :class="isDark
                        ? 'text-white/40 hover:text-white/80 hover:bg-white/8'
                        : 'text-slate-400 hover:text-slate-700 hover:bg-slate-100'"
                    aria-label="Toggle theme">
                    <svg v-if="isDark" style="width:17px;height:17px" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="5"/>
                        <line x1="12" y1="1" x2="12" y2="3"/><line x1="12" y1="21" x2="12" y2="23"/>
                        <line x1="4.22" y1="4.22" x2="5.64" y2="5.64"/><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"/>
                        <line x1="1" y1="12" x2="3" y2="12"/><line x1="21" y1="12" x2="23" y2="12"/>
                        <line x1="4.22" y1="19.78" x2="5.64" y2="18.36"/><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"/>
                    </svg>
                    <svg v-else style="width:17px;height:17px" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/>
                    </svg>
                </button>

                <div class="w-px h-[18px] mx-1.5" :class="isDark ? 'bg-white/10' : 'bg-slate-200'"></div>

                <Link v-if="$page?.props?.auth?.user" href="/dashboard"
                    class="px-4 py-2 rounded-lg text-sm font-medium transition-all"
                    :class="isDark ? 'text-white/70 hover:text-white hover:bg-white/8' : 'text-slate-600 hover:bg-slate-100'">
                    Dashboard
                </Link>
                <template v-else>
                    <Link v-if="canLogin" href="/login"
                        class="hidden sm:inline-block px-4 py-2 rounded-lg text-sm font-medium transition-colors"
                        :class="isDark ? 'text-white/55 hover:text-white' : 'text-slate-500 hover:text-slate-900'">
                        Sign in
                    </Link>
                    <Link v-if="canRegister" href="/register"
                        class="ml-1 px-5 py-2 rounded-lg text-sm font-semibold text-white nav-cta-btn transition-all duration-300"
                        style="background: linear-gradient(135deg, #7B2FFF, #3b9eff)">
                        Get started
                    </Link>
                </template>
            </nav>
        </header>

        <!-- ══ HERO ══════════════════════════════════════════════ -->
        <section class="relative min-h-screen flex items-center pt-16 overflow-hidden">

            <!-- Layered ambient background -->
            <div class="absolute inset-0 -z-10 overflow-hidden">
                <!-- Fine grid -->
                <div class="absolute inset-0"
                    :class="isDark ? 'opacity-[0.055]' : 'opacity-[0.04]'"
                    style="background-image: linear-gradient(#7B2FFF 1px, transparent 1px), linear-gradient(90deg, #7B2FFF 1px, transparent 1px); background-size: 52px 52px;"></div>
                <!-- Primary orb -->
                <div class="orb-1 absolute top-[15%] left-[5%] w-[800px] h-[800px] rounded-full"
                    :style="`background: radial-gradient(circle, ${isDark ? 'rgba(123,47,255,0.22)' : 'rgba(123,47,255,0.1)'} 0%, transparent 65%); filter: blur(60px); transform: translate(${mouseX * 0.3}px, ${mouseY * 0.3}px)`"></div>
                <!-- Secondary orb -->
                <div class="orb-2 absolute bottom-[10%] right-[10%] w-[600px] h-[600px] rounded-full"
                    :style="`background: radial-gradient(circle, ${isDark ? 'rgba(0,198,255,0.18)' : 'rgba(0,150,255,0.1)'} 0%, transparent 65%); filter: blur(80px); transform: translate(${mouseX * -0.2}px, ${mouseY * -0.2}px)`"></div>
                <!-- Accent orb -->
                <div class="absolute top-[60%] left-[40%] w-[300px] h-[300px] rounded-full"
                    :style="`background: radial-gradient(circle, ${isDark ? 'rgba(168,85,247,0.12)' : 'rgba(168,85,247,0.07)'} 0%, transparent 70%); filter: blur(50px);`"></div>
                <!-- Noise texture overlay -->
                <div class="absolute inset-0 noise-overlay" :class="isDark ? 'opacity-[0.025]' : 'opacity-[0.015]'"></div>
            </div>

            <div class="max-w-7xl mx-auto px-6 lg:px-14 w-full py-24 lg:py-0 grid lg:grid-cols-[1fr_1.05fr] gap-20 items-center">

                <!-- Left: Text block -->
                <div :class="heroVisible ? 'hero-text-in' : 'opacity-0 translate-y-8'" class="z-10">

                    <!-- Badge -->
                    <div class="inline-flex items-center gap-2 px-3.5 py-1.5 rounded-full text-xs font-semibold mb-8 border hero-badge"
                        :style="isDark
                            ? 'border-color: rgba(123,47,255,0.35); background: rgba(123,47,255,0.08); color: #a88fff'
                            : 'border-color: rgba(123,47,255,0.25); background: rgba(123,47,255,0.06); color: #7B2FFF'">
                        <span class="relative flex h-1.5 w-1.5">
                            <span class="animate-ping absolute inline-flex h-full w-full rounded-full opacity-75" style="background:#7B2FFF"></span>
                            <span class="relative inline-flex rounded-full h-1.5 w-1.5" style="background:#7B2FFF"></span>
                        </span>
                        Iris Cloud · Now in open beta
                    </div>

                    <!-- Headline -->
                    <h1 class="mb-7 leading-[1.06] tracking-[-0.03em]"
                        style="font-family:'Syne',sans-serif; font-size: clamp(3rem, 6.5vw, 4.8rem); font-weight:800;">
                        Your images.<br>
                        <span class="gradient-text">Everywhere.</span>
                    </h1>

                    <p class="text-[1.05rem] max-w-[480px] mb-10 leading-relaxed"
                        :class="isDark ? 'text-white/48' : 'text-slate-500'">
                        A beautifully fast image hosting platform with CDN delivery, smart organisation, and privacy controls — built for developers and creators.
                    </p>

                    <!-- CTA row -->
                    <div class="flex flex-wrap items-center gap-3 mb-11">
                        <Link v-if="canRegister" href="/register"
                            class="cta-primary group relative px-7 py-3.5 rounded-xl text-sm font-semibold text-white overflow-hidden transition-all duration-300"
                            style="background: linear-gradient(135deg, #7B2FFF 0%, #3b9eff 100%); box-shadow: 0 8px 32px -10px rgba(123,47,255,0.55)">
                            <span class="relative z-10 flex items-center gap-2">
                                Start free
                                <svg style="width:15px;height:15px" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                    <line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/>
                                </svg>
                            </span>
                            <span class="shine-sweep absolute inset-0"></span>
                        </Link>
                        <Link v-if="canLogin" href="/login"
                            class="px-7 py-3.5 rounded-xl text-sm font-medium transition-all duration-300 border"
                            :class="isDark
                                ? 'border-white/10 text-white/60 hover:text-white hover:border-white/20 hover:bg-white/[0.04]'
                                : 'border-slate-200 text-slate-600 hover:text-slate-900 hover:border-slate-300 hover:bg-white shadow-sm'">
                            Sign in
                        </Link>
                    </div>

                    <!-- Trust chips -->
                    <div class="flex flex-wrap gap-2">
                        <span v-for="t in ['No credit card', 'Free 1 GB', 'Instant setup', 'Cancel anytime']" :key="t"
                            class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-medium trust-chip"
                            :class="isDark ? 'bg-white/[0.04] text-white/38 border border-white/[0.06]' : 'bg-white text-slate-500 border border-slate-200 shadow-sm'">
                            <svg style="width:10px;height:10px;color:#10b981;flex-shrink:0" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round">
                                <polyline points="20 6 9 17 4 12"/>
                            </svg>
                            {{ t }}
                        </span>
                    </div>
                </div>

                <!-- Right: App Mockup -->
                <div :class="heroVisible ? 'hero-visual-in' : 'opacity-0'" class="relative z-10 hidden lg:block">

                    <!-- Halo glow -->
                    <div class="absolute inset-6 rounded-3xl blur-3xl opacity-25 pointer-events-none"
                        style="background: linear-gradient(135deg, #7B2FFF, #00C6FF)"></div>

                    <!-- Window card -->
                    <div
                        class="mockup-window relative rounded-2xl border overflow-hidden"
                        :class="isDark ? 'bg-[#0d0b1a] border-white/[0.09]' : 'bg-white border-slate-200'"
                        style="box-shadow: 0 48px 96px -20px rgba(0,0,0,0.5), 0 0 0 1px rgba(123,47,255,0.08)"
                        :style="`transform: perspective(1200px) rotateX(${mouseY * -0.015}deg) rotateY(${mouseX * 0.015}deg)`"
                    >
                        <!-- Titlebar -->
                        <div class="flex items-center justify-between px-4 py-3 border-b"
                            :class="isDark ? 'border-white/[0.06] bg-[#0f0d1f]' : 'border-slate-100 bg-slate-50/80'">
                            <div class="flex items-center gap-1.5">
                                <div class="h-3 w-3 rounded-full bg-[#ff5f56] hover:brightness-110 transition-all cursor-pointer"></div>
                                <div class="h-3 w-3 rounded-full bg-[#ffbd2e] hover:brightness-110 transition-all cursor-pointer"></div>
                                <div class="h-3 w-3 rounded-full bg-[#27c93f] hover:brightness-110 transition-all cursor-pointer"></div>
                            </div>
                            <div class="flex items-center gap-1.5 px-3 py-1 rounded-md text-[11px] font-mono"
                                :class="isDark ? 'bg-white/[0.04] text-white/25' : 'bg-slate-100 text-slate-400'">
                                <svg style="width:10px;height:10px;opacity:.5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                                </svg>
                                iris.app/gallery
                            </div>
                            <div class="w-14"></div>
                        </div>

                        <!-- Toolbar -->
                        <div class="flex items-center justify-between px-4 py-2.5 border-b"
                            :class="isDark ? 'border-white/[0.04]' : 'border-slate-100'">
                            <div class="flex items-center gap-2">
                                <svg style="width:13px;height:13px" :class="isDark ? 'text-white/30' : 'text-slate-400'" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/>
                                </svg>
                                <span class="text-xs font-semibold" :class="isDark ? 'text-white/55' : 'text-slate-500'">My Gallery</span>
                                <span class="text-[10px] px-1.5 py-0.5 rounded-full" :class="isDark ? 'bg-white/8 text-white/30' : 'bg-slate-100 text-slate-400'">6</span>
                            </div>
                            <div class="flex items-center gap-1.5">
                                <div class="flex items-center gap-1 h-6 px-2 rounded-md text-[10px]" :class="isDark ? 'bg-white/[0.04] text-white/25' : 'bg-slate-100 text-slate-400'">
                                    <svg style="width:9px;height:9px" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                        <circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/>
                                    </svg>
                                    Search
                                </div>
                                <button class="h-6 w-6 rounded-md flex items-center justify-center hover:brightness-110 transition-all"
                                    style="background: linear-gradient(135deg, #7B2FFF, #3b9eff)">
                                    <svg style="width:10px;height:10px;color:white" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                        <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
                                    </svg>
                                </button>
                            </div>
                        </div>

                        <!-- Image grid -->
                        <div class="p-4 grid grid-cols-3 gap-2.5" style="min-height:290px">
                            <div v-for="(img, i) in mockImages" :key="i"
                                class="image-tile rounded-xl overflow-hidden relative group cursor-pointer"
                                :class="[img.col, img.row, `bg-gradient-to-br ${img.bg}`]"
                                :style="`animation-delay: ${img.delay}; min-height: ${img.minH}`"
                            >
                                <!-- Inner highlight edge -->
                                <div class="absolute inset-0 rounded-xl ring-1 ring-inset ring-white/10"></div>
                                <!-- Shimmer lines -->
                                <div class="absolute bottom-2.5 left-2.5 right-2.5 space-y-1.5">
                                    <div class="h-1.5 rounded-full w-3/4" :class="isDark ? 'bg-white/10' : 'bg-black/10'"></div>
                                    <div class="h-1 rounded-full w-2/5" :class="isDark ? 'bg-white/6' : 'bg-black/6'"></div>
                                </div>
                                <!-- Hover overlay -->
                                <div class="absolute inset-0 opacity-0 group-hover:opacity-100 transition-all duration-300 flex items-center justify-center"
                                    :class="isDark ? 'bg-black/45' : 'bg-black/25'">
                                    <div class="h-9 w-9 rounded-full bg-white/20 backdrop-blur-sm flex items-center justify-center scale-75 group-hover:scale-100 transition-transform duration-300">
                                        <svg style="width:15px;height:15px;color:white" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/>
                                        </svg>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Status bar -->
                        <div class="flex items-center justify-between px-4 py-2.5 border-t text-[10px] font-medium"
                            :class="isDark ? 'border-white/[0.04] text-white/22' : 'border-slate-100 text-slate-400'">
                            <div class="flex items-center gap-3">
                                <span>6 assets</span>
                                <span class="h-2.5 w-px" :class="isDark ? 'bg-white/10' : 'bg-slate-200'"></span>
                                <span>667 KB used</span>
                            </div>
                            <div class="flex items-center gap-1.5" style="color:#10b981">
                                <span class="relative flex h-1.5 w-1.5">
                                    <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-emerald-400 opacity-75"></span>
                                    <span class="relative inline-flex rounded-full h-1.5 w-1.5 bg-emerald-500"></span>
                                </span>
                                CDN online
                            </div>
                        </div>
                    </div>

                    <!-- Floating stat chips -->
                    <div v-for="(s, i) in stats" :key="s.label"
                        class="float-chip absolute rounded-2xl px-4 py-2.5 border shadow-2xl select-none"
                        :class="isDark ? 'bg-[#0e0c1e]/95 border-white/10 backdrop-blur-xl' : 'bg-white/95 border-slate-200 backdrop-blur-xl shadow-slate-200/60'"
                        :style="`
                            ${i === 0 ? 'left: -56px; top: 30%;' : ''}
                            ${i === 1 ? 'right: -44px; top: 18%;' : ''}
                            ${i === 2 ? 'right: -28px; bottom: 22%;' : ''}
                            animation-delay: ${0.4 + i * 0.45}s;
                        `"
                    >
                        <div class="text-[9px] font-semibold uppercase tracking-[0.1em] mb-1.5" :class="isDark ? 'text-white/30' : 'text-slate-400'">{{ s.label }}</div>
                        <div class="flex items-center gap-2">
                            <span :style="`color:${s.color}`" style="font-size:1.1rem; font-family:'Syne',sans-serif; font-weight:700; line-height:1">{{ s.value }}</span>
                            <svg v-if="s.trend === 'up'" style="width:12px;height:12px;color:#10b981" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                <polyline points="23 6 13.5 15.5 8.5 10.5 1 18"/><polyline points="17 6 23 6 23 12"/>
                            </svg>
                        </div>
                    </div>

                    <!-- Upload progress pill (bonus floating element) -->
                    <div class="float-chip absolute -bottom-4 left-[15%] right-[15%] rounded-2xl px-4 py-3 border shadow-2xl"
                        :class="isDark ? 'bg-[#0e0c1e]/95 border-white/10 backdrop-blur-xl' : 'bg-white/95 border-slate-200 backdrop-blur-xl'"
                        style="animation-delay: 1.8s">
                        <div class="flex items-center justify-between mb-2">
                            <div class="flex items-center gap-2">
                                <div class="h-5 w-5 rounded-md flex items-center justify-center" style="background: linear-gradient(135deg,#7B2FFF,#3b9eff)">
                                    <svg style="width:9px;height:9px;color:white" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/><polyline points="17 8 12 3 7 8"/><line x1="12" y1="3" x2="12" y2="15"/>
                                    </svg>
                                </div>
                                <span class="text-[10px] font-semibold" :class="isDark ? 'text-white/60' : 'text-slate-600'">hero-photo.jpg</span>
                            </div>
                            <span class="text-[10px] font-bold" style="color:#7B2FFF">74%</span>
                        </div>
                        <div class="h-1 rounded-full overflow-hidden" :class="isDark ? 'bg-white/8' : 'bg-slate-100'">
                            <div class="h-full rounded-full upload-bar" style="background:linear-gradient(90deg,#7B2FFF,#00C6FF); width:74%"></div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Scroll indicator -->
            <div class="absolute bottom-8 left-1/2 -translate-x-1/2 flex flex-col items-center gap-2 scroll-hint"
                :class="isDark ? 'text-white/20' : 'text-slate-300'">
                <span class="text-[10px] font-medium tracking-widest uppercase">Explore</span>
                <svg style="width:16px;height:16px" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="12" y1="5" x2="12" y2="19"/><polyline points="19 12 12 19 5 12"/>
                </svg>
            </div>
        </section>

        <!-- ══ FEATURES ══════════════════════════════════════════ -->
        <section class="px-6 lg:px-14 py-32 max-w-7xl mx-auto">

            <div class="text-center mb-16 max-w-2xl mx-auto">
                <p class="text-[11px] font-bold uppercase tracking-[0.22em] mb-4" style="color:#7B2FFF">What's inside</p>
                <h2 class="text-3xl lg:text-[2.6rem] font-bold tracking-[-0.03em] leading-tight" style="font-family:'Syne',sans-serif">
                    Everything you need.<br>
                    <span :class="isDark ? 'text-white/28' : 'text-slate-300'">Nothing you don't.</span>
                </h2>
            </div>

            <div class="grid sm:grid-cols-2 lg:grid-cols-3 gap-4">
                <div v-for="(f, i) in features" :key="f.title"
                    class="feature-card group relative rounded-2xl p-7 border overflow-hidden cursor-default"
                    :class="isDark
                        ? 'bg-white/[0.025] border-white/[0.07] hover:border-white/14 hover:bg-white/[0.04]'
                        : 'bg-white border-slate-200 hover:border-slate-300 shadow-sm hover:shadow-xl hover:shadow-slate-200/50'"
                    :style="`animation-delay: ${i * 0.08}s`">

                    <!-- Radial hover glow -->
                    <div class="absolute inset-0 opacity-0 group-hover:opacity-100 transition-opacity duration-700 pointer-events-none"
                        :style="`background: radial-gradient(ellipse at 25% 25%, ${f.color}14 0%, transparent 60%)`"></div>

                    <!-- Top-left corner accent line -->
                    <div class="absolute top-0 left-6 right-6 h-px opacity-0 group-hover:opacity-100 transition-opacity duration-500"
                        :style="`background: linear-gradient(90deg, transparent, ${f.color}50, transparent)`"></div>

                    <!-- Icon -->
                    <div class="relative mb-5 h-11 w-11 rounded-xl flex items-center justify-center transition-all duration-300 group-hover:scale-110 group-hover:-translate-y-0.5"
                        :style="`background: ${f.color}15; border: 1px solid ${f.color}28; color: ${f.color}`"
                        v-html="f.icon">
                    </div>

                    <h3 class="text-[15px] font-bold mb-2 tracking-[-0.01em]" style="font-family:'Syne',sans-serif">{{ f.title }}</h3>
                    <p class="text-sm leading-relaxed" :class="isDark ? 'text-white/42' : 'text-slate-500'">{{ f.desc }}</p>
                </div>
            </div>
        </section>

        <!-- ══ SOCIAL PROOF STRIP ════════════════════════════════ -->
        <section class="px-6 lg:px-14 pb-24 max-w-7xl mx-auto">
            <div class="grid grid-cols-2 sm:grid-cols-4 gap-px rounded-2xl overflow-hidden border"
                :class="isDark ? 'border-white/[0.06]' : 'border-slate-200'">
                <div v-for="(stat, i) in [
                    {n:'200+', label:'Edge nodes'},
                    {n:'99.99%', label:'Uptime SLA'},
                    {n:'< 50ms', label:'Global latency'},
                    {n:'Free', label:'To get started'},
                ]" :key="i"
                    class="stat-block flex flex-col items-center justify-center py-10 px-4 text-center"
                    :class="isDark ? 'bg-white/[0.02]' : 'bg-white'"
                    :style="`animation-delay:${i * 0.12}s`">
                    <div class="text-3xl font-bold tracking-[-0.03em] mb-1 gradient-text" style="font-family:'Syne',sans-serif">{{ stat.n }}</div>
                    <div class="text-xs font-medium" :class="isDark ? 'text-white/35' : 'text-slate-400'">{{ stat.label }}</div>
                </div>
            </div>
        </section>

        <!-- ══ CTA ═══════════════════════════════════════════════ -->
        <section class="px-6 lg:px-14 pb-36">
            <div class="max-w-5xl mx-auto relative rounded-3xl overflow-hidden"
                :class="isDark ? 'bg-[#0d0b1a]' : 'bg-slate-900'">

                <!-- BG mesh -->
                <div class="absolute inset-0 overflow-hidden">
                    <div class="absolute -top-40 -left-40 w-[500px] h-[500px] rounded-full blur-[100px]" style="background:rgba(123,47,255,0.45)"></div>
                    <div class="absolute -bottom-40 -right-40 w-[500px] h-[500px] rounded-full blur-[100px]" style="background:rgba(0,198,255,0.3)"></div>
                    <div class="absolute inset-0 opacity-[0.035]"
                        style="background-image: linear-gradient(white 1px, transparent 1px), linear-gradient(90deg, white 1px, transparent 1px); background-size: 32px 32px;"></div>
                    <div class="absolute inset-0 noise-overlay opacity-[0.02]"></div>
                </div>

                <div class="relative z-10 py-20 lg:py-24 px-8 lg:px-16 flex flex-col lg:flex-row items-center justify-between gap-12">
                    <div class="text-center lg:text-left">
                        <h2 class="text-3xl lg:text-[2.4rem] font-bold text-white mb-3 tracking-[-0.03em]" style="font-family:'Syne',sans-serif">
                            Ready to ship faster?
                        </h2>
                        <p class="text-white/48 text-[1.05rem] max-w-md leading-relaxed">
                            Join developers and creators who've already switched to Iris for their visual infrastructure.
                        </p>
                    </div>
                    <div class="flex flex-col sm:flex-row items-center gap-3 shrink-0">
                        <Link v-if="canRegister" href="/register"
                            class="cta-primary group relative px-8 py-4 rounded-xl text-sm font-bold text-white overflow-hidden whitespace-nowrap"
                            style="background: linear-gradient(135deg, #7B2FFF, #3b9eff); box-shadow: 0 8px 40px -8px rgba(123,47,255,0.65)">
                            <span class="relative z-10 flex items-center gap-2">
                                Create free workspace
                                <svg style="width:15px;height:15px" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                    <line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/>
                                </svg>
                            </span>
                            <span class="shine-sweep absolute inset-0"></span>
                        </Link>
                        <Link v-if="canLogin" href="/login"
                            class="px-8 py-4 rounded-xl text-sm font-medium text-white/55 hover:text-white border border-white/10 hover:border-white/20 hover:bg-white/[0.05] transition-all whitespace-nowrap">
                            Sign in instead
                        </Link>
                    </div>
                </div>
            </div>
        </section>

        <!-- ══ FOOTER ═════════════════════════════════════════════ -->
        <footer class="border-t px-8 lg:px-14 py-8 flex flex-col md:flex-row items-center justify-between gap-5 text-sm"
            :class="isDark ? 'border-white/[0.06] bg-[#06040f] text-white/25' : 'border-slate-100 bg-white text-slate-400'">
            <div class="flex items-center gap-2.5">
                <div class="h-5 w-5 rounded-full flex items-center justify-center opacity-50"
                    style="background:linear-gradient(135deg,#7B2FFF,#00C6FF)">
                    <svg style="width:9px;height:9px;color:white" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="3"/>
                    </svg>
                </div>
                <span class="font-bold text-sm" style="font-family:'Syne',sans-serif"
                    :class="isDark ? 'text-white/40' : 'text-slate-500'">Iris</span>
                <span class="text-[11px]">© {{ new Date().getFullYear() }}</span>
            </div>
            <div class="flex items-center gap-6 text-xs font-medium">
                <a href="#" class="hover:text-[#7B2FFF] transition-colors duration-200">Privacy</a>
                <a href="#" class="hover:text-[#7B2FFF] transition-colors duration-200">Terms</a>
                <a href="#" class="hover:text-[#7B2FFF] transition-colors duration-200">Docs</a>
                <Link href="/login" class="hover:text-[#7B2FFF] transition-colors duration-200">Sign in</Link>
            </div>
        </footer>

    </div>
</template>

<style scoped>
/* ─── Gradient text ─────────────────────────────────── */
.gradient-text {
    background: linear-gradient(135deg, #7B2FFF 0%, #3b9eff 55%, #00C6FF 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}

/* ─── Hero entrance ─────────────────────────────────── */
.hero-text-in {
    animation: heroTextIn 0.75s cubic-bezier(0.22, 1, 0.36, 1) both;
}
.hero-visual-in {
    animation: heroVisualIn 0.95s cubic-bezier(0.22, 1, 0.36, 1) 0.18s both;
}
@keyframes heroTextIn {
    from { opacity: 0; transform: translateY(32px); }
    to   { opacity: 1; transform: translateY(0); }
}
@keyframes heroVisualIn {
    from { opacity: 0; transform: translateY(40px) scale(0.96); }
    to   { opacity: 1; transform: translateY(0) scale(1); }
}

/* ─── Mockup window float ───────────────────────────── */
.mockup-window {
    animation: windowFloat 7s ease-in-out 1.2s infinite;
    transform-style: preserve-3d;
    will-change: transform;
    transition: transform 0.1s ease-out;
}
@keyframes windowFloat {
    0%, 100% { transform: perspective(1200px) translateY(0px); }
    40%       { transform: perspective(1200px) translateY(-12px); }
    70%       { transform: perspective(1200px) translateY(-6px); }
}

/* ─── Floating stat chips ────────────────────────────── */
.float-chip {
    animation: chipFloat 5.5s ease-in-out infinite;
    will-change: transform;
}
@keyframes chipFloat {
    0%, 100% { transform: translateY(0px) rotate(0deg); }
    30%       { transform: translateY(-9px) rotate(0.4deg); }
    65%       { transform: translateY(-4px) rotate(-0.2deg); }
}

/* ─── Image tiles pop-in ────────────────────────────── */
.image-tile {
    animation: tileIn 0.55s cubic-bezier(0.34, 1.56, 0.64, 1) both;
    transition: transform 0.3s ease, filter 0.3s ease;
}
.image-tile:hover {
    transform: scale(1.02);
    filter: brightness(1.08);
}
@keyframes tileIn {
    from { opacity: 0; transform: scale(0.8); }
    to   { opacity: 1; transform: scale(1); }
}

/* ─── Feature cards ─────────────────────────────────── */
.feature-card {
    animation: featureIn 0.55s cubic-bezier(0.22, 1, 0.36, 1) both;
    transition: transform 0.3s cubic-bezier(0.22, 1, 0.36, 1), box-shadow 0.3s ease, border-color 0.3s ease, background-color 0.3s ease;
}
.feature-card:hover {
    transform: translateY(-4px);
}
@keyframes featureIn {
    from { opacity: 0; transform: translateY(28px); }
    to   { opacity: 1; transform: translateY(0); }
}

/* ─── Stat blocks ───────────────────────────────────── */
.stat-block {
    animation: featureIn 0.5s cubic-bezier(0.22, 1, 0.36, 1) both;
    transition: background 0.25s ease;
}

/* ─── CTA button ────────────────────────────────────── */
.cta-primary {
    transition: transform 0.25s cubic-bezier(0.22, 1, 0.36, 1), box-shadow 0.25s ease;
}
.cta-primary:hover {
    transform: translateY(-2px);
    box-shadow: 0 20px 60px -10px rgba(123,47,255,0.65) !important;
}
.cta-primary:active { transform: translateY(0); }

/* ─── Shine sweep on CTA ────────────────────────────── */
.shine-sweep {
    background: linear-gradient(105deg, transparent 40%, rgba(255,255,255,0.18) 50%, transparent 60%);
    transform: translateX(-100%) skewX(-12deg);
    transition: transform 0s;
}
.cta-primary:hover .shine-sweep {
    transform: translateX(200%) skewX(-12deg);
    transition: transform 0.7s ease;
}

/* ─── Nav CTA ────────────────────────────────────────── */
.nav-cta-btn {
    transition: transform 0.2s ease, box-shadow 0.2s ease;
    box-shadow: 0 4px 20px -6px rgba(123,47,255,0.45);
}
.nav-cta-btn:hover {
    transform: translateY(-1px);
    box-shadow: 0 8px 28px -6px rgba(123,47,255,0.55);
}

/* ─── Hero badge shimmer ────────────────────────────── */
.hero-badge {
    animation: badgePulse 3s ease-in-out infinite;
}
@keyframes badgePulse {
    0%, 100% { box-shadow: 0 0 0 0 rgba(123,47,255,0); }
    50%       { box-shadow: 0 0 16px 0 rgba(123,47,255,0.15); }
}

/* ─── Trust chips stagger ───────────────────────────── */
.trust-chip:nth-child(1) { animation: featureIn 0.6s 0.65s both; }
.trust-chip:nth-child(2) { animation: featureIn 0.6s 0.72s both; }
.trust-chip:nth-child(3) { animation: featureIn 0.6s 0.79s both; }
.trust-chip:nth-child(4) { animation: featureIn 0.6s 0.86s both; }

/* ─── Upload progress bar animation ─────────────────── */
.upload-bar {
    animation: uploadProgress 3s ease-in-out 2.5s infinite;
}
@keyframes uploadProgress {
    0%   { width: 74%; }
    40%  { width: 91%; }
    60%  { width: 91%; }
    80%  { width: 100%; opacity:1; }
    85%  { opacity:0; width:100%; }
    86%  { opacity:0; width:0%; }
    87%  { opacity:1; width:0%; }
    100% { width:74%; }
}

/* ─── Scroll hint bounce ────────────────────────────── */
.scroll-hint {
    animation: scrollHint 2.5s ease-in-out 2s infinite;
}
@keyframes scrollHint {
    0%, 100% { opacity: 0.5; transform: translateX(-50%) translateY(0); }
    50%       { opacity: 0.9; transform: translateX(-50%) translateY(5px); }
}

/* ─── Orb drift ─────────────────────────────────────── */
.orb-1 { animation: orbDrift1 12s ease-in-out infinite; }
.orb-2 { animation: orbDrift2 15s ease-in-out infinite; }
@keyframes orbDrift1 {
    0%, 100% { transform: translate(0, 0) scale(1); }
    33%       { transform: translate(30px, -20px) scale(1.05); }
    66%       { transform: translate(-15px, 25px) scale(0.97); }
}
@keyframes orbDrift2 {
    0%, 100% { transform: translate(0, 0) scale(1); }
    40%       { transform: translate(-25px, 20px) scale(1.04); }
    70%       { transform: translate(20px, -10px) scale(0.98); }
}

/* ─── Noise texture ─────────────────────────────────── */
.noise-overlay {
    background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)'/%3E%3C/svg%3E");
    background-repeat: repeat;
    background-size: 160px 160px;
}
</style>

<style>
/* Global dark mode base */
html.dark { color-scheme: dark; }
</style>