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
const cursorX = ref(0);
const cursorY = ref(0);

const onScroll = () => { scrollY.value = window.scrollY; };
const onMouse = (e: MouseEvent) => {
    mouseX.value = (e.clientX / window.innerWidth - 0.5) * 30;
    mouseY.value = (e.clientY / window.innerHeight - 0.5) * 30;
    cursorX.value = e.clientX;
    cursorY.value = e.clientY;
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
    setTimeout(() => {
        heroVisible.value = true;
    }, 80);
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
        color: '#8B5CF6',
        glow: 'rgba(139,92,246,0.35)',
        icon: `<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/></svg>`,
    },
    {
        title: 'Granular Privacy',
        desc: 'Password-protect, set expiry dates, or lock assets to specific team members.',
        color: '#06B6D4',
        glow: 'rgba(6,182,212,0.35)',
        icon: `<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></svg>`,
    },
    {
        title: 'Auto-Optimisation',
        desc: 'Upload anything. Iris compresses and converts to WebP automatically.',
        color: '#A78BFA',
        glow: 'rgba(167,139,250,0.35)',
        icon: `<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="3"/><path d="M12 1v4M12 19v4M4.22 4.22l2.83 2.83M16.95 16.95l2.83 2.83M1 12h4M19 12h4M4.22 19.78l2.83-2.83M16.95 7.05l2.83-2.83"/></svg>`,
    },
    {
        title: 'Smart Workspace',
        desc: 'Nested folders, role-based access, and team sharing—built in from day one.',
        color: '#34D399',
        glow: 'rgba(52,211,153,0.35)',
        icon: `<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M22 19a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h5l2 3h9a2 2 0 0 1 2 2z"/></svg>`,
    },
    {
        title: 'EXIF Stripping',
        desc: 'GPS coordinates, camera model, timestamps—all scrubbed on upload.',
        color: '#F472B6',
        glow: 'rgba(244,114,182,0.35)',
        icon: `<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><path d="M17.94 17.94A10.07 10.07 0 0 1 12 20c-7 0-11-8-11-8a18.45 18.45 0 0 1 5.06-5.94M9.9 4.24A9.12 9.12 0 0 1 12 4c7 0 11 8 11 8a18.5 18.5 0 0 1-2.16 3.19"/><path d="M14.12 14.12a3 3 0 1 1-4.24-4.24"/><line x1="2" y1="2" x2="22" y2="22" stroke-width="1.75"/></svg>`,
    },
    {
        title: 'One-Click Share',
        desc: 'Copy markdown, HTML, BBCode, or raw URLs instantly from your dashboard.',
        color: '#FBBF24',
        glow: 'rgba(251,191,36,0.35)',
        icon: `<svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.75" stroke-linecap="round" stroke-linejoin="round"><circle cx="18" cy="5" r="3"/><circle cx="6" cy="12" r="3"/><circle cx="18" cy="19" r="3"/><line x1="8.59" y1="13.51" x2="15.42" y2="17.49"/><line x1="15.41" y1="6.51" x2="8.59" y2="10.49"/></svg>`,
    },
];

const mockImages = [
    { col: 'col-span-2', row: 'row-span-2', bg: 'from-violet-600/50 via-purple-700/40 to-indigo-800/60', delay: '0s', minH: '160px', label: 'portrait.jpg', size: '2.4 MB' },
    { col: 'col-span-1', row: 'row-span-1', bg: 'from-cyan-500/50 via-sky-600/40 to-blue-800/60', delay: '0.08s', minH: '72px', label: 'banner.png', size: '840 KB' },
    { col: 'col-span-1', row: 'row-span-1', bg: 'from-emerald-500/50 via-teal-600/40 to-green-800/60', delay: '0.16s', minH: '72px', label: 'thumb.webp', size: '120 KB' },
    { col: 'col-span-1', row: 'row-span-2', bg: 'from-pink-500/50 via-rose-600/40 to-red-800/60', delay: '0.12s', minH: '160px', label: 'cover.jpg', size: '1.8 MB' },
    { col: 'col-span-2', row: 'row-span-1', bg: 'from-amber-500/50 via-orange-600/40 to-yellow-800/60', delay: '0.2s', minH: '72px', label: 'product.png', size: '560 KB' },
    { col: 'col-span-1', row: 'row-span-1', bg: 'from-indigo-500/50 via-violet-600/40 to-purple-800/60', delay: '0.04s', minH: '72px', label: 'logo.svg', size: '18 KB' },
];

const stats = [
    { label: 'Avg load time', value: '42ms', color: '#06B6D4', trend: 'up', icon: '⚡' },
    { label: 'Compression', value: '−68%', color: '#8B5CF6', trend: null, icon: '🗜' },
    { label: 'Edge nodes', value: '200+', color: '#A78BFA', trend: null, icon: '🌐' },
];
</script>

<template>
    <Head title="Iris — The ultimate home for your visual assets" />

    <!-- Custom cursor spotlight -->
    <div class="cursor-glow" :style="`left:${cursorX}px; top:${cursorY}px`"></div>

    <div
        class="min-h-screen overflow-x-hidden transition-colors duration-500 selection:bg-violet-500/30"
        :class="isDark ? 'bg-[#050311] text-white' : 'bg-[#f0eeff] text-slate-900'"
        style="font-family: 'Cabinet Grotesk', 'DM Sans', system-ui, sans-serif;"
    >
        <!-- Font imports -->
        <component :is="'style'">
            @import url('https://fonts.googleapis.com/css2?family=DM+Sans:opsz,wght@9..40,300;9..40,400;9..40,500;9..40,600;9..40,700&family=Instrument+Serif:ital@0;1&display=swap');
            * { box-sizing: border-box; }
        </component>

        <!-- ══ NAVBAR ══════════════════════════════════════════ -->
        <header
            class="fixed top-0 left-0 right-0 z-50 flex items-center justify-between px-6 lg:px-14 h-[64px] transition-all duration-500"
            :class="scrollY > 20
                ? (isDark
                    ? 'bg-[#050311]/80 backdrop-blur-2xl border-b border-white/[0.06]'
                    : 'bg-white/85 backdrop-blur-2xl border-b border-violet-200/60 shadow-sm')
                : 'bg-transparent'"
        >
            <!-- Logo -->
            <Link href="/" class="flex items-center gap-2.5 group select-none">
                <div class="relative h-9 w-9">
                    <div class="logo-pulse absolute inset-[-3px] rounded-full opacity-50"
                        style="background: conic-gradient(from 0deg, #8B5CF6, #06B6D4, #8B5CF6)"></div>
                    <img src="/favicon.png" alt="Iris Logo"
                        class="relative h-9 w-9 rounded-full object-cover z-10 group-hover:scale-105 transition-transform duration-300"
                        style="box-shadow: 0 0 0 2px rgba(139,92,246,0.3)" />
                </div>
                <span class="text-[18px] font-bold tracking-[-0.03em]" style="font-family:'Instrument Serif',serif; font-style:italic">Iris</span>
            </Link>

            <nav class="flex items-center gap-1">
                <button @click="toggleTheme"
                    class="p-2 rounded-lg transition-all duration-200"
                    :class="isDark ? 'text-white/40 hover:text-white/80 hover:bg-white/8' : 'text-slate-400 hover:text-slate-700 hover:bg-slate-100'"
                    aria-label="Toggle theme">
                    <svg v-if="isDark" width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="5"/>
                        <line x1="12" y1="1" x2="12" y2="3"/><line x1="12" y1="21" x2="12" y2="23"/>
                        <line x1="4.22" y1="4.22" x2="5.64" y2="5.64"/><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"/>
                        <line x1="1" y1="12" x2="3" y2="12"/><line x1="21" y1="12" x2="23" y2="12"/>
                        <line x1="4.22" y1="19.78" x2="5.64" y2="18.36"/><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"/>
                    </svg>
                    <svg v-else width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
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
                        :class="isDark ? 'text-white/50 hover:text-white' : 'text-slate-500 hover:text-slate-900'">
                        Sign in
                    </Link>
                    <Link v-if="canRegister" href="/register"
                        class="ml-1 px-5 py-[9px] rounded-xl text-sm font-semibold text-white nav-cta-btn transition-all duration-300"
                        style="background: linear-gradient(135deg, #7C3AED, #0891B2)">
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
                <div class="absolute inset-0 grid-bg" :class="isDark ? 'opacity-[0.06]' : 'opacity-[0.05]'"></div>
                <!-- Animated gradient mesh -->
                <div class="mesh-orb orb-1 absolute top-[12%] left-[2%] w-[700px] h-[700px] rounded-full"
                    :style="`background: radial-gradient(circle, ${isDark ? 'rgba(109,40,217,0.28)' : 'rgba(109,40,217,0.12)'} 0%, transparent 65%); filter: blur(80px); transform: translate(${mouseX * 0.25}px, ${mouseY * 0.25}px)`"></div>
                <div class="mesh-orb orb-2 absolute top-[50%] right-[8%] w-[550px] h-[550px] rounded-full"
                    :style="`background: radial-gradient(circle, ${isDark ? 'rgba(6,182,212,0.2)' : 'rgba(6,182,212,0.1)'} 0%, transparent 65%); filter: blur(80px); transform: translate(${mouseX * -0.18}px, ${mouseY * -0.18}px)`"></div>
                <div class="mesh-orb orb-3 absolute top-[30%] left-[45%] w-[400px] h-[400px] rounded-full"
                    :style="`background: radial-gradient(circle, ${isDark ? 'rgba(167,139,250,0.14)' : 'rgba(167,139,250,0.07)'} 0%, transparent 70%); filter: blur(60px);`"></div>
                <!-- Grain -->
                <div class="absolute inset-0 noise-overlay" :class="isDark ? 'opacity-[0.03]' : 'opacity-[0.02]'"></div>
            </div>

            <div class="max-w-7xl mx-auto px-6 lg:px-14 w-full py-24 lg:py-0 grid lg:grid-cols-[1fr_1.1fr] gap-16 items-center">

                <!-- Left: Text block -->
                <div :class="heroVisible ? 'hero-text-in' : 'opacity-0 translate-y-8'" class="z-10">

                    <!-- Animated badge -->
                    <div class="inline-flex items-center gap-2 px-4 py-2 rounded-full text-xs font-semibold mb-8 border hero-badge"
                        :style="isDark
                            ? 'border-color: rgba(139,92,246,0.3); background: rgba(139,92,246,0.07); color: #c4b5fd'
                            : 'border-color: rgba(109,40,217,0.2); background: rgba(109,40,217,0.05); color: #6D28D9'">
                        <span class="relative flex h-2 w-2">
                            <span class="animate-ping absolute inline-flex h-full w-full rounded-full opacity-75" style="background:#8B5CF6"></span>
                            <span class="relative inline-flex rounded-full h-2 w-2" style="background:#8B5CF6"></span>
                        </span>
                        Iris Cloud &nbsp;·&nbsp; Now in open beta
                        <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                            <line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/>
                        </svg>
                    </div>

                    <!-- Headline — mixed serif + sans -->
                    <h1 class="mb-7 leading-[1.04] tracking-[-0.02em]"
                        style="font-size: clamp(2.9rem, 6vw, 4.6rem); font-weight:700;">
                        <span :class="isDark ? 'text-white/90' : 'text-slate-900'">Your images.</span><br>
                        <span class="gradient-text italic" style="font-family:'Instrument Serif',serif; font-weight:400; font-size:1.12em; letter-spacing:-0.03em">Everywhere.</span>
                    </h1>

                    <p class="text-[1.05rem] max-w-[460px] mb-10 leading-[1.7]"
                        :class="isDark ? 'text-white/45' : 'text-slate-500'">
                        A beautifully fast image hosting platform with CDN delivery, smart organisation, and privacy controls — built for developers and creators.
                    </p>

                    <!-- CTA row -->
                    <div class="flex flex-wrap items-center gap-3 mb-11">
                        <Link v-if="canRegister" href="/register"
                            class="cta-primary group relative px-7 py-3.5 rounded-xl text-sm font-semibold text-white overflow-hidden inline-flex items-center gap-2"
                            style="background: linear-gradient(135deg, #7C3AED 0%, #0891B2 100%); box-shadow: 0 8px 32px -8px rgba(109,40,217,0.6)">
                            <span class="relative z-10 flex items-center gap-2">
                                Start free
                                <svg class="cta-arrow" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                    <line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/>
                                </svg>
                            </span>
                            <span class="shine-sweep absolute inset-0"></span>
                        </Link>
                        <Link v-if="canLogin" href="/login"
                            class="px-7 py-3.5 rounded-xl text-sm font-medium transition-all duration-300 border"
                            :class="isDark
                                ? 'border-white/10 text-white/55 hover:text-white hover:border-white/22 hover:bg-white/[0.04]'
                                : 'border-slate-200 text-slate-600 hover:text-slate-900 hover:border-violet-300 hover:bg-white shadow-sm'">
                            Sign in
                        </Link>
                    </div>

                    <!-- Trust chips -->
                    <div class="flex flex-wrap gap-2">
                        <span v-for="(t, i) in ['No credit card', 'Free 1 GB', 'Instant setup', 'Cancel anytime']" :key="t"
                            class="trust-chip inline-flex items-center gap-1.5 px-3 py-1.5 rounded-lg text-xs font-medium"
                            :class="isDark ? 'bg-white/[0.04] text-white/35 border border-white/[0.07]' : 'bg-white text-slate-500 border border-slate-200 shadow-sm'"
                            :style="`animation-delay: ${0.65 + i * 0.07}s`">
                            <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="#34D399" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" style="flex-shrink:0">
                                <polyline points="20 6 9 17 4 12"/>
                            </svg>
                            {{ t }}
                        </span>
                    </div>
                </div>

                <!-- Right: App Mockup -->
                <div :class="heroVisible ? 'hero-visual-in' : 'opacity-0'" class="relative z-10 hidden lg:block">

                    <!-- Halo -->
                    <div class="absolute inset-4 rounded-3xl blur-[60px] opacity-30 pointer-events-none"
                        style="background: linear-gradient(135deg, #7C3AED 0%, #0891B2 100%)"></div>

                    <!-- Window card -->
                    <div
                        class="mockup-window relative rounded-2xl border overflow-hidden"
                        :class="isDark ? 'bg-[#0c0920] border-white/[0.1]' : 'bg-white border-violet-200/60'"
                        style="box-shadow: 0 52px 100px -20px rgba(0,0,0,0.55), 0 0 0 1px rgba(139,92,246,0.1)"
                        :style="`transform: perspective(1400px) rotateX(${mouseY * -0.012}deg) rotateY(${mouseX * 0.012}deg)`"
                    >
                        <!-- Titlebar -->
                        <div class="flex items-center justify-between px-4 py-3 border-b"
                            :class="isDark ? 'border-white/[0.07] bg-[#0e0b24]' : 'border-slate-100 bg-slate-50/90'">
                            <div class="flex items-center gap-1.5">
                                <div class="h-3 w-3 rounded-full bg-[#FF5F57] cursor-pointer hover:brightness-110 transition-all"></div>
                                <div class="h-3 w-3 rounded-full bg-[#FEBC2E] cursor-pointer hover:brightness-110 transition-all"></div>
                                <div class="h-3 w-3 rounded-full bg-[#28C840] cursor-pointer hover:brightness-110 transition-all"></div>
                            </div>
                            <div class="flex items-center gap-1.5 px-3 py-1 rounded-lg text-[11px] font-mono select-none"
                                :class="isDark ? 'bg-white/[0.04] text-white/22' : 'bg-slate-100 text-slate-400'">
                                <svg width="9" height="9" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="opacity:0.5">
                                    <rect x="3" y="11" width="18" height="11" rx="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                                </svg>
                                iris.app/gallery
                            </div>
                            <div class="w-14"></div>
                        </div>

                        <!-- Toolbar -->
                        <div class="flex items-center justify-between px-4 py-2.5 border-b"
                            :class="isDark ? 'border-white/[0.05]' : 'border-slate-100'">
                            <div class="flex items-center gap-2">
                                <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" :class="isDark ? 'text-white/30' : 'text-slate-400'">
                                    <rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/>
                                </svg>
                                <span class="text-xs font-semibold" :class="isDark ? 'text-white/55' : 'text-slate-600'">My Gallery</span>
                                <span class="text-[10px] px-1.5 py-0.5 rounded-full font-mono" :class="isDark ? 'bg-white/8 text-white/30' : 'bg-slate-100 text-slate-400'">6</span>
                            </div>
                            <div class="flex items-center gap-1.5">
                                <div class="flex items-center gap-1 h-6 px-2.5 rounded-lg text-[11px]" :class="isDark ? 'bg-white/[0.04] text-white/25' : 'bg-slate-100 text-slate-400'">
                                    <svg width="9" height="9" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                        <circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/>
                                    </svg>
                                    Search
                                </div>
                                <button class="h-6 w-6 rounded-lg flex items-center justify-center hover:brightness-110 transition-all"
                                    style="background: linear-gradient(135deg, #7C3AED, #0891B2)">
                                    <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                        <line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/>
                                    </svg>
                                </button>
                            </div>
                        </div>

                        <!-- Image grid -->
                        <div class="p-3 grid grid-cols-3 gap-2" style="min-height:290px">
                            <div v-for="(img, i) in mockImages" :key="i"
                                class="image-tile rounded-xl overflow-hidden relative group cursor-pointer"
                                :class="[img.col, img.row, `bg-gradient-to-br ${img.bg}`]"
                                :style="`animation-delay: ${img.delay}; min-height: ${img.minH}`"
                            >
                                <!-- Inner border highlight -->
                                <div class="absolute inset-0 rounded-xl ring-1 ring-inset ring-white/[0.12]"></div>
                                <!-- Bottom meta label -->
                                <div class="absolute bottom-0 left-0 right-0 p-2 opacity-0 group-hover:opacity-100 transition-all duration-200"
                                    style="background: linear-gradient(to top, rgba(0,0,0,0.7), transparent)">
                                    <div class="text-[9px] font-semibold text-white/80 truncate">{{ img.label }}</div>
                                    <div class="text-[9px] text-white/40">{{ img.size }}</div>
                                </div>
                                <!-- Hover preview icon -->
                                <div class="absolute inset-0 opacity-0 group-hover:opacity-100 transition-all duration-300 flex items-center justify-center">
                                    <div class="h-9 w-9 rounded-full flex items-center justify-center scale-75 group-hover:scale-100 transition-transform duration-300 shadow-lg"
                                        style="background: rgba(255,255,255,0.15); backdrop-filter: blur(8px)">
                                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                            <path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/>
                                            <circle cx="12" cy="12" r="3"/>
                                        </svg>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Status bar -->
                        <div class="flex items-center justify-between px-4 py-2.5 border-t text-[10px] font-medium"
                            :class="isDark ? 'border-white/[0.05] text-white/22' : 'border-slate-100 text-slate-400'">
                            <div class="flex items-center gap-3">
                                <span>6 assets</span>
                                <span class="h-2.5 w-px" :class="isDark ? 'bg-white/10' : 'bg-slate-200'"></span>
                                <span>667 KB used</span>
                            </div>
                            <div class="flex items-center gap-1.5" style="color:#34D399">
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
                        class="float-chip absolute rounded-2xl px-4 py-3 border select-none"
                        :class="isDark ? 'bg-[#0e0b24]/92 border-white/10 backdrop-blur-xl' : 'bg-white/95 border-violet-100 backdrop-blur-xl shadow-lg shadow-violet-100/40'"
                        :style="`
                            ${i === 0 ? 'left: -62px; top: 28%;' : ''}
                            ${i === 1 ? 'right: -50px; top: 16%;' : ''}
                            ${i === 2 ? 'right: -36px; bottom: 24%;' : ''}
                            animation-delay: ${0.5 + i * 0.4}s;
                        `"
                    >
                        <div class="text-[9px] font-bold uppercase tracking-[0.12em] mb-1.5" :class="isDark ? 'text-white/28' : 'text-slate-400'">{{ s.label }}</div>
                        <div class="flex items-center gap-2">
                            <span :style="`color:${s.color}`" style="font-size:1.15rem; font-weight:700; line-height:1; font-variant-numeric: tabular-nums">{{ s.value }}</span>
                            <svg v-if="s.trend === 'up'" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#34D399" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                <polyline points="23 6 13.5 15.5 8.5 10.5 1 18"/><polyline points="17 6 23 6 23 12"/>
                            </svg>
                        </div>
                    </div>

                    <!-- Upload progress pill -->
                    <div class="float-chip absolute -bottom-5 left-[10%] right-[10%] rounded-2xl px-4 py-3 border"
                        :class="isDark ? 'bg-[#0e0b24]/92 border-white/10 backdrop-blur-xl' : 'bg-white/95 border-violet-100 backdrop-blur-xl shadow-lg'"
                        style="animation-delay: 1.6s">
                        <div class="flex items-center justify-between mb-2">
                            <div class="flex items-center gap-2">
                                <div class="h-5 w-5 rounded-lg flex items-center justify-center flex-shrink-0"
                                    style="background: linear-gradient(135deg,#7C3AED,#0891B2)">
                                    <!-- Upload arrow icon — corrected -->
                                    <svg width="9" height="9" viewBox="0 0 24 24" fill="none" stroke="white" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                        <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"/>
                                        <polyline points="17 8 12 3 7 8"/>
                                        <line x1="12" y1="3" x2="12" y2="15"/>
                                    </svg>
                                </div>
                                <span class="text-[10px] font-semibold truncate" :class="isDark ? 'text-white/60' : 'text-slate-600'">hero-photo.jpg</span>
                            </div>
                            <span class="text-[10px] font-bold tabular-nums" style="color:#8B5CF6">74%</span>
                        </div>
                        <div class="h-[3px] rounded-full overflow-hidden" :class="isDark ? 'bg-white/8' : 'bg-slate-100'">
                            <div class="h-full rounded-full upload-bar" style="background:linear-gradient(90deg,#7C3AED,#06B6D4); width:74%"></div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Scroll indicator -->
            <div class="absolute bottom-8 left-1/2 -translate-x-1/2 flex flex-col items-center gap-2 scroll-hint select-none"
                :class="isDark ? 'text-white/20' : 'text-slate-300'">
                <span class="text-[9px] font-bold tracking-[0.2em] uppercase">Explore</span>
                <div class="scroll-mouse">
                    <div class="scroll-dot"></div>
                </div>
            </div>
        </section>

        <!-- ══ FEATURES ══════════════════════════════════════════ -->
        <section class="px-6 lg:px-14 py-32 max-w-7xl mx-auto">

            <div class="text-center mb-16 max-w-2xl mx-auto">
                <p class="text-[11px] font-bold uppercase tracking-[0.24em] mb-4" style="color:#8B5CF6">What's inside</p>
                <h2 class="text-3xl lg:text-[2.6rem] font-bold tracking-[-0.025em] leading-tight">
                    Everything you need.<br>
                    <span :class="isDark ? 'text-white/22' : 'text-slate-300'" class="italic" style="font-family:'Instrument Serif',serif; font-weight:400">Nothing you don't.</span>
                </h2>
            </div>

            <div class="grid sm:grid-cols-2 lg:grid-cols-3 gap-4">
                <div v-for="(f, i) in features" :key="f.title"
                    class="feature-card group relative rounded-2xl p-7 border overflow-hidden cursor-default"
                    :class="isDark
                        ? 'bg-white/[0.02] border-white/[0.07] hover:border-white/13'
                        : 'bg-white border-slate-200 hover:border-violet-200 shadow-sm hover:shadow-2xl hover:shadow-violet-100/40'"
                    :style="`animation-delay: ${i * 0.08}s`">

                    <!-- Radial hover glow -->
                    <div class="absolute inset-0 opacity-0 group-hover:opacity-100 transition-opacity duration-700 pointer-events-none rounded-2xl"
                        :style="`background: radial-gradient(ellipse at 30% 30%, ${f.glow} 0%, transparent 55%)`"></div>

                    <!-- Top gradient line -->
                    <div class="absolute top-0 left-0 right-0 h-[1px] opacity-0 group-hover:opacity-100 transition-opacity duration-500"
                        :style="`background: linear-gradient(90deg, transparent 10%, ${f.color}60 50%, transparent 90%)`"></div>

                    <!-- Icon container with inner glow -->
                    <div class="relative mb-5 h-11 w-11 rounded-xl flex items-center justify-center transition-all duration-300 group-hover:scale-110 group-hover:-translate-y-0.5"
                        :style="`background: ${f.color}12; border: 1px solid ${f.color}25; color: ${f.color}`">
                        <div class="absolute inset-0 rounded-xl opacity-0 group-hover:opacity-100 transition-opacity duration-300"
                            :style="`background: ${f.color}1a; box-shadow: 0 0 16px ${f.color}40 inset`"></div>
                        <div class="relative z-10" v-html="f.icon"></div>
                    </div>

                    <h3 class="text-[15px] font-bold mb-2 tracking-[-0.01em]">{{ f.title }}</h3>
                    <p class="text-sm leading-[1.65]" :class="isDark ? 'text-white/40' : 'text-slate-500'">{{ f.desc }}</p>
                </div>
            </div>
        </section>

        <!-- ══ SOCIAL PROOF STRIP ════════════════════════════════ -->
        <section class="px-6 lg:px-14 pb-24 max-w-7xl mx-auto">
            <div class="grid grid-cols-2 sm:grid-cols-4 gap-px rounded-2xl overflow-hidden border"
                :class="isDark ? 'border-white/[0.07]' : 'border-slate-200/80'">
                <div v-for="(stat, i) in [
                    {n:'200+', label:'Edge nodes', icon:'🌐'},
                    {n:'99.99%', label:'Uptime SLA', icon:'✦'},
                    {n:'< 50ms', label:'Global latency', icon:'⚡'},
                    {n:'Free', label:'To get started', icon:'🎁'},
                ]" :key="i"
                    class="stat-block flex flex-col items-center justify-center py-10 px-4 text-center group cursor-default"
                    :class="isDark ? 'bg-white/[0.018] hover:bg-white/[0.03]' : 'bg-white hover:bg-violet-50/50'"
                    :style="`animation-delay:${i * 0.12}s; transition: background 0.3s ease`">
                    <div class="text-base mb-3 opacity-60">{{ stat.icon }}</div>
                    <div class="text-3xl font-bold tracking-[-0.03em] mb-1 gradient-text tabular-nums">{{ stat.n }}</div>
                    <div class="text-xs font-medium" :class="isDark ? 'text-white/32' : 'text-slate-400'">{{ stat.label }}</div>
                </div>
            </div>
        </section>

        <!-- ══ CTA ═══════════════════════════════════════════════ -->
        <section class="px-6 lg:px-14 pb-36">
            <div class="max-w-5xl mx-auto relative rounded-3xl overflow-hidden"
                :class="isDark ? 'bg-[#0a0720]' : 'bg-slate-900'">

                <!-- BG mesh -->
                <div class="absolute inset-0 overflow-hidden pointer-events-none">
                    <div class="absolute -top-32 -left-32 w-[450px] h-[450px] rounded-full blur-[90px]" style="background:rgba(109,40,217,0.5)"></div>
                    <div class="absolute -bottom-32 -right-32 w-[450px] h-[450px] rounded-full blur-[90px]" style="background:rgba(6,182,212,0.35)"></div>
                    <div class="absolute inset-0 opacity-[0.04]"
                        style="background-image: linear-gradient(white 1px, transparent 1px), linear-gradient(90deg, white 1px, transparent 1px); background-size: 36px 36px;"></div>
                    <div class="absolute inset-0 noise-overlay opacity-[0.025]"></div>
                </div>

                <div class="relative z-10 py-20 lg:py-24 px-8 lg:px-16 flex flex-col lg:flex-row items-center justify-between gap-12">
                    <div class="text-center lg:text-left">
                        <h2 class="text-3xl lg:text-[2.4rem] font-bold text-white mb-3 tracking-[-0.025em]">
                            Ready to ship faster?
                        </h2>
                        <p class="text-white/45 text-[1.05rem] max-w-md leading-[1.7]">
                            Join developers and creators who've already switched to Iris for their visual infrastructure.
                        </p>
                    </div>
                    <div class="flex flex-col sm:flex-row items-center gap-3 shrink-0">
                        <Link v-if="canRegister" href="/register"
                            class="cta-primary group relative px-8 py-4 rounded-xl text-sm font-bold text-white overflow-hidden whitespace-nowrap inline-flex items-center gap-2"
                            style="background: linear-gradient(135deg, #7C3AED, #0891B2); box-shadow: 0 8px 40px -8px rgba(109,40,217,0.7)">
                            <span class="relative z-10 flex items-center gap-2">
                                Create free workspace
                                <svg class="cta-arrow" width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                                    <line x1="5" y1="12" x2="19" y2="12"/><polyline points="12 5 19 12 12 19"/>
                                </svg>
                            </span>
                            <span class="shine-sweep absolute inset-0"></span>
                        </Link>
                        <Link v-if="canLogin" href="/login"
                            class="px-8 py-4 rounded-xl text-sm font-medium text-white/50 hover:text-white border border-white/10 hover:border-white/25 hover:bg-white/[0.06] transition-all whitespace-nowrap">
                            Sign in instead
                        </Link>
                    </div>
                </div>
            </div>
        </section>

        <!-- ══ FOOTER ═════════════════════════════════════════════ -->
        <footer class="border-t px-8 lg:px-14 py-8 flex flex-col md:flex-row items-center justify-between gap-5 text-sm"
            :class="isDark ? 'border-white/[0.06] bg-[#050311] text-white/22' : 'border-slate-100 bg-white text-slate-400'">
            <div class="flex items-center gap-2.5">
                <img src="/favicon.png" alt="Iris" class="h-6 w-6 rounded-full object-cover opacity-60" />
                <span class="font-bold text-sm italic" style="font-family:'Instrument Serif',serif"
                    :class="isDark ? 'text-white/40' : 'text-slate-500'">Iris</span>
                <span class="text-[11px]">© {{ new Date().getFullYear() }}</span>
            </div>
            <div class="flex items-center gap-6 text-xs font-medium">
                <a href="#" class="hover:text-[#8B5CF6] transition-colors duration-200">Privacy</a>
                <a href="#" class="hover:text-[#8B5CF6] transition-colors duration-200">Terms</a>
                <a href="#" class="hover:text-[#8B5CF6] transition-colors duration-200">Docs</a>
                <Link href="/login" class="hover:text-[#8B5CF6] transition-colors duration-200">Sign in</Link>
            </div>
        </footer>

    </div>
</template>

<style scoped>
/* ─── Cursor glow ─────────────────────────────────── */
.cursor-glow {
    position: fixed;
    pointer-events: none;
    z-index: 9999;
    width: 480px;
    height: 480px;
    border-radius: 50%;
    background: radial-gradient(circle, rgba(139,92,246,0.07) 0%, transparent 65%);
    transform: translate(-50%, -50%);
    transition: left 0.12s ease-out, top 0.12s ease-out;
    mix-blend-mode: screen;
}

/* ─── Gradient text ─────────────────────────────────── */
.gradient-text {
    background: linear-gradient(135deg, #8B5CF6 0%, #4FACFE 55%, #06B6D4 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}

/* ─── Fine grid background ──────────────────────────── */
.grid-bg {
    background-image:
        linear-gradient(rgba(139,92,246,0.35) 1px, transparent 1px),
        linear-gradient(90deg, rgba(139,92,246,0.35) 1px, transparent 1px);
    background-size: 56px 56px;
}

/* ─── Logo spin ─────────────────────────────────────── */
.logo-pulse {
    animation: logoPulse 4s linear infinite;
}
@keyframes logoPulse {
    from { transform: rotate(0deg); }
    to   { transform: rotate(360deg); }
}

/* ─── Hero entrances ─────────────────────────────────── */
.hero-text-in {
    animation: heroTextIn 0.8s cubic-bezier(0.22, 1, 0.36, 1) both;
}
.hero-visual-in {
    animation: heroVisualIn 1s cubic-bezier(0.22, 1, 0.36, 1) 0.2s both;
}
@keyframes heroTextIn {
    from { opacity: 0; transform: translateY(36px); }
    to   { opacity: 1; transform: translateY(0); }
}
@keyframes heroVisualIn {
    from { opacity: 0; transform: translateY(44px) scale(0.95); }
    to   { opacity: 1; transform: translateY(0) scale(1); }
}

/* ─── Mockup float ──────────────────────────────────── */
.mockup-window {
    animation: windowFloat 8s ease-in-out 1.2s infinite;
    will-change: transform;
    transition: transform 0.12s ease-out;
}
@keyframes windowFloat {
    0%, 100% { transform: perspective(1400px) translateY(0px); }
    40%       { transform: perspective(1400px) translateY(-14px); }
    70%       { transform: perspective(1400px) translateY(-7px); }
}

/* ─── Float chips ────────────────────────────────────── */
.float-chip {
    animation: chipFloat 6s ease-in-out infinite;
    will-change: transform;
}
@keyframes chipFloat {
    0%, 100% { transform: translateY(0px); }
    35%       { transform: translateY(-10px) rotate(0.5deg); }
    65%       { transform: translateY(-5px) rotate(-0.3deg); }
}

/* ─── Image tile pop-in + hover ─────────────────────── */
.image-tile {
    animation: tileIn 0.6s cubic-bezier(0.34, 1.56, 0.64, 1) both;
    transition: transform 0.35s cubic-bezier(0.22, 1, 0.36, 1), filter 0.35s ease, box-shadow 0.35s ease;
}
.image-tile:hover {
    transform: scale(1.04) translateY(-2px);
    filter: brightness(1.1) saturate(1.1);
    box-shadow: 0 8px 24px -4px rgba(0,0,0,0.4);
    z-index: 2;
}
@keyframes tileIn {
    from { opacity: 0; transform: scale(0.78) translateY(8px); }
    to   { opacity: 1; transform: scale(1) translateY(0); }
}

/* ─── Feature cards ──────────────────────────────────── */
.feature-card {
    animation: featureIn 0.6s cubic-bezier(0.22, 1, 0.36, 1) both;
    transition: transform 0.35s cubic-bezier(0.22, 1, 0.36, 1), box-shadow 0.35s ease, border-color 0.3s ease, background-color 0.3s ease;
}
.feature-card:hover {
    transform: translateY(-5px);
}
@keyframes featureIn {
    from { opacity: 0; transform: translateY(32px); }
    to   { opacity: 1; transform: translateY(0); }
}

/* ─── Stat blocks ────────────────────────────────────── */
.stat-block {
    animation: featureIn 0.55s cubic-bezier(0.22, 1, 0.36, 1) both;
}

/* ─── CTA primary ────────────────────────────────────── */
.cta-primary {
    transition: transform 0.28s cubic-bezier(0.22, 1, 0.36, 1), box-shadow 0.28s ease;
}
.cta-primary:hover {
    transform: translateY(-3px);
    box-shadow: 0 20px 64px -10px rgba(109,40,217,0.7) !important;
}
.cta-primary:active { transform: translateY(-1px); }

/* Arrow nudge on CTA hover */
.cta-primary:hover .cta-arrow {
    transform: translateX(3px);
    transition: transform 0.2s ease;
}
.cta-arrow {
    transition: transform 0.2s ease;
}

/* ─── Shine sweep ────────────────────────────────────── */
.shine-sweep {
    background: linear-gradient(110deg, transparent 38%, rgba(255,255,255,0.2) 50%, transparent 62%);
    transform: translateX(-120%) skewX(-15deg);
}
.cta-primary:hover .shine-sweep {
    transform: translateX(220%) skewX(-15deg);
    transition: transform 0.75s ease;
}

/* ─── Nav CTA ────────────────────────────────────────── */
.nav-cta-btn {
    transition: transform 0.2s ease, box-shadow 0.2s ease;
    box-shadow: 0 4px 18px -5px rgba(109,40,217,0.5);
}
.nav-cta-btn:hover {
    transform: translateY(-1px);
    box-shadow: 0 8px 28px -5px rgba(109,40,217,0.6);
}

/* ─── Badge pulse ────────────────────────────────────── */
.hero-badge {
    animation: badgePulse 3.5s ease-in-out infinite;
}
@keyframes badgePulse {
    0%, 100% { box-shadow: 0 0 0 0 rgba(139,92,246,0); }
    50%       { box-shadow: 0 0 20px 0 rgba(139,92,246,0.18); }
}

/* ─── Trust chips stagger ────────────────────────────── */
.trust-chip {
    animation: featureIn 0.6s cubic-bezier(0.22,1,0.36,1) both;
}

/* ─── Upload bar ─────────────────────────────────────── */
.upload-bar {
    animation: uploadProgress 3.5s ease-in-out 2.8s infinite;
}
@keyframes uploadProgress {
    0%   { width: 74%; }
    35%  { width: 90%; }
    55%  { width: 90%; }
    75%  { width: 100%; opacity:1; }
    80%  { opacity:0; width:100%; }
    81%  { opacity:0; width:0; }
    82%  { opacity:1; width:0; }
    100% { width:74%; }
}

/* ─── Scroll mouse indicator ─────────────────────────── */
.scroll-hint {
    animation: scrollHintFade 2.5s ease-in-out 2s infinite;
}
.scroll-mouse {
    width: 20px;
    height: 30px;
    border-radius: 10px;
    border: 1.5px solid currentColor;
    display: flex;
    justify-content: center;
    padding-top: 5px;
}
.scroll-dot {
    width: 3px;
    height: 6px;
    border-radius: 2px;
    background: currentColor;
    animation: scrollDotBounce 1.8s ease-in-out infinite;
}
@keyframes scrollDotBounce {
    0%, 100% { transform: translateY(0); opacity:0.8; }
    50%       { transform: translateY(8px); opacity:0.3; }
}
@keyframes scrollHintFade {
    0%, 100% { opacity:0.4; }
    50%       { opacity:0.8; }
}

/* ─── Orb drift ──────────────────────────────────────── */
.mesh-orb { transition: transform 0.15s ease-out; }
.orb-1 { animation: orbDrift1 14s ease-in-out infinite; }
.orb-2 { animation: orbDrift2 17s ease-in-out infinite; }
.orb-3 { animation: orbDrift3 11s ease-in-out infinite; }
@keyframes orbDrift1 {
    0%, 100% { transform: translate(0, 0) scale(1); }
    33%       { transform: translate(35px, -25px) scale(1.06); }
    66%       { transform: translate(-18px, 28px) scale(0.96); }
}
@keyframes orbDrift2 {
    0%, 100% { transform: translate(0, 0) scale(1); }
    40%       { transform: translate(-28px, 22px) scale(1.05); }
    70%       { transform: translate(22px, -12px) scale(0.97); }
}
@keyframes orbDrift3 {
    0%, 100% { transform: translate(0, 0); }
    50%       { transform: translate(15px, -18px); }
}

/* ─── Noise texture ──────────────────────────────────── */
.noise-overlay {
    background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)'/%3E%3C/svg%3E");
    background-repeat: repeat;
    background-size: 160px 160px;
    pointer-events: none;
}
</style>

<style>
html.dark { color-scheme: dark; }
</style>