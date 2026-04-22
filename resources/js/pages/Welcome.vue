<script setup lang="ts">
import { Head, Link } from '@inertiajs/vue3';
import { ref, onMounted } from 'vue';

defineProps({
    canLogin: {
        type: Boolean,
        default: true,
    },
    canRegister: {
        type: Boolean,
        default: true,
    },
});

// Theme Toggle Logic
const isDark = ref(true);

onMounted(() => {
    // Check user's saved preference or system preference on load
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
});

const toggleTheme = () => {
    isDark.value = !isDark.value;
    if (isDark.value) {
        document.documentElement.classList.add('dark');
        localStorage.theme = 'dark';
    } else {
        document.documentElement.classList.remove('dark');
        localStorage.theme = 'light';
    }
};
</script>

<template>
    <Head title="Iris - The ultimate home for your visual assets." />

    <!-- Main Wrapper -->
    <div class="min-h-screen bg-slate-50 text-slate-900 transition-colors duration-300 dark:bg-[#050811] dark:text-white overflow-x-hidden font-sans selection:bg-[#7B2FFF]/30 selection:text-[#7B2FFF] dark:selection:text-[#00E5FF]">

        <!-- Navbar -->
        <header class="fixed top-0 left-0 right-0 z-50 flex items-center justify-between px-6 lg:px-12 py-4 backdrop-blur-xl border-b border-slate-200/50 bg-white/60 dark:border-white/5 dark:bg-[#050811]/60 transition-colors duration-300">
            <!-- Brand -->
            <Link href="/" class="flex items-center gap-3 group">
                <img src="/favicon.png" alt="Iris Logo" class="h-9 w-9 object-cover rounded-full shadow-md shadow-[#7B2FFF]/20 group-hover:scale-105 transition-transform duration-300" />
                <span class="text-xl font-extrabold tracking-tight text-slate-900 dark:text-white">
                    Iris
                </span>
            </Link>

            <nav class="flex items-center gap-2 sm:gap-4">
                <!-- Theme Toggle -->
                <button 
                    @click="toggleTheme" 
                    class="p-2 mr-1 rounded-full text-slate-500 hover:bg-slate-200/50 dark:text-white/60 dark:hover:bg-white/10 transition-colors focus:outline-none"
                    aria-label="Toggle Dark Mode"
                >
                    <!-- Sun Icon -->
                    <svg v-if="isDark" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="5"></circle>
                        <line x1="12" y1="1" x2="12" y2="3"></line>
                        <line x1="12" y1="21" x2="12" y2="23"></line>
                        <line x1="4.22" y1="4.22" x2="5.64" y2="5.64"></line>
                        <line x1="18.36" y1="18.36" x2="19.78" y2="19.78"></line>
                        <line x1="1" y1="12" x2="3" y2="12"></line>
                        <line x1="21" y1="12" x2="23" y2="12"></line>
                        <line x1="4.22" y1="19.78" x2="5.64" y2="18.36"></line>
                        <line x1="18.36" y1="5.64" x2="19.78" y2="4.22"></line>
                    </svg>
                    <!-- Moon Icon -->
                    <svg v-else xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path>
                    </svg>
                </button>

                <Link
                    v-if="$page.props.auth?.user"
                    href="/dashboard"
                    class="px-5 py-2.5 rounded-full text-sm font-medium text-slate-700 bg-slate-100 hover:bg-slate-200 dark:bg-white/5 dark:text-white/90 dark:hover:bg-white/10 transition-colors"
                >
                    Go to Dashboard
                </Link>
                <template v-else>
                    <Link
                        v-if="canLogin"
                        href="/login"
                        class="hidden sm:inline-block px-5 py-2 rounded-full text-sm font-medium text-slate-600 hover:text-slate-900 dark:text-white/70 dark:hover:text-white transition-colors"
                    >
                        Sign in
                    </Link>
                    <Link
                        v-if="canRegister"
                        href="/register"
                        class="px-5 py-2.5 rounded-full text-sm font-semibold bg-slate-900 text-white dark:bg-white dark:text-[#050811] hover:scale-105 transition-transform shadow-lg shadow-black/10 dark:shadow-white/10"
                    >
                        Join Iris
                    </Link>
                </template>
            </nav>
        </header>

        <!-- Redesigned Hero Section (Split Layout) -->
        <section class="relative pt-32 pb-20 lg:pt-48 lg:pb-32 overflow-hidden px-6 max-w-7xl mx-auto flex flex-col lg:flex-row items-center gap-16 lg:gap-12 z-10">
            
            <!-- Dynamic Background Glows -->
            <div class="absolute top-1/2 left-0 -translate-y-1/2 w-[600px] h-[600px] rounded-full bg-[#7B2FFF]/10 dark:bg-[#7B2FFF]/15 blur-[120px] pointer-events-none -z-10" />
            <div class="absolute top-1/4 right-0 w-[500px] h-[500px] rounded-full bg-[#00E5FF]/10 dark:bg-[#00E5FF]/15 blur-[100px] pointer-events-none -z-10" />

            <!-- Left Text Content -->
            <div class="flex-1 text-center lg:text-left z-10 w-full">
                <!-- Iris Badge -->
                <div class="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-white border border-slate-200 text-slate-700 dark:bg-white/5 dark:border-white/10 dark:text-white/90 text-sm font-semibold mb-8 shadow-sm transition-colors duration-300">
                    <span class="flex h-2 w-2 rounded-full bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF] animate-pulse"></span>
                    Meet the new Iris Cloud
                </div>

                <h1 class="text-5xl sm:text-6xl lg:text-7xl font-extrabold tracking-tight mb-6 leading-[1.1] text-slate-900 dark:text-white">
                    Flawless hosting.<br>
                    Powered by <span class="bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF] bg-clip-text text-transparent">Iris.</span>
                </h1>

                <p class="text-lg sm:text-xl text-slate-600 dark:text-white/60 max-w-2xl mx-auto lg:mx-0 mb-10 leading-relaxed">
                    Transform how your team stores, manages, and distributes visual assets. Iris delivers lightning-fast CDN delivery, bank-level security, and a beautifully intuitive workspace.
                </p>

                <!-- Actions -->
                <div class="flex flex-col sm:flex-row items-center justify-center lg:justify-start gap-4 mb-12">
                    <Link
                        v-if="canRegister"
                        href="/register"
                        class="w-full sm:w-auto px-8 py-4 rounded-xl text-base font-semibold bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF] text-white hover:shadow-lg hover:shadow-[#7B2FFF]/30 hover:-translate-y-0.5 transition-all duration-300"
                    >
                        Start using Iris free
                    </Link>
                    <Link
                        v-if="canLogin"
                        href="/login"
                        class="w-full sm:w-auto px-8 py-4 rounded-xl text-base font-medium text-slate-700 bg-white border border-slate-200 hover:border-slate-300 hover:bg-slate-50 dark:bg-white/5 dark:text-white dark:border-white/10 dark:hover:border-white/20 dark:hover:bg-white/10 transition-all duration-300 shadow-sm"
                    >
                        View demo
                    </Link>
                </div>

                <!-- Feature Pills -->
                <div class="flex flex-wrap justify-center lg:justify-start gap-2.5">
                    <span
                        v-for="feature in ['Instant CDN', 'Lossless Compression', 'Smart Tags', 'End-to-End Secure']"
                        :key="feature"
                        class="px-3.5 py-1.5 rounded-md text-xs font-semibold text-slate-500 bg-slate-100 dark:text-white/50 dark:bg-white/5 transition-colors duration-300"
                    >
                        {{ feature }}
                    </span>
                </div>
            </div>

            <!-- Right Visual Mockup (Glassmorphism) -->
            <div class="flex-1 w-full max-w-lg lg:max-w-none relative z-10 animate-float">
                <div class="absolute inset-0 bg-gradient-to-br from-[#7B2FFF] to-[#00E5FF] rounded-2xl blur-xl opacity-20 dark:opacity-30"></div>
                <div class="relative rounded-2xl bg-white/60 dark:bg-[#0d1220]/80 border border-white dark:border-white/10 backdrop-blur-xl shadow-2xl p-4 lg:p-6 overflow-hidden">
                    
                    <!-- Mac-like Window Controls -->
                    <div class="flex items-center gap-2 mb-6 px-2">
                        <div class="w-3 h-3 rounded-full bg-[#ff5f56]"></div>
                        <div class="w-3 h-3 rounded-full bg-[#ffbd2e]"></div>
                        <div class="w-3 h-3 rounded-full bg-[#27c93f]"></div>
                    </div>

                    <!-- Iris App Preview Card -->
                    <div class="aspect-[4/3] rounded-xl bg-slate-50 dark:bg-[#050811] border border-slate-200 dark:border-white/5 flex flex-col items-center justify-center relative overflow-hidden group">
                        <!-- Inner Glow -->
                        <div class="absolute inset-0 bg-gradient-to-t from-[#7B2FFF]/10 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-700"></div>
                        
                        <!-- Floating Logo inside mock -->
                        <div class="relative p-1 rounded-full bg-gradient-to-br from-[#7B2FFF] to-[#00E5FF] mb-6 shadow-xl shadow-[#7B2FFF]/20 animate-float-delayed">
                            <div class="bg-white dark:bg-[#050811] rounded-full p-2">
                                <img src="/favicon.png" alt="Iris Node" class="w-16 h-16 object-cover rounded-full" />
                            </div>
                        </div>

                        <h3 class="text-2xl font-bold tracking-tight text-slate-800 dark:text-white z-10 mb-1">Iris Engine</h3>
                        <div class="flex items-center gap-2 z-10">
                            <span class="relative flex h-2.5 w-2.5">
                                <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-emerald-400 opacity-75"></span>
                                <span class="relative inline-flex rounded-full h-2.5 w-2.5 bg-emerald-500"></span>
                            </span>
                            <p class="text-slate-500 dark:text-white/60 text-sm font-medium">All systems operational</p>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Features Grid -->
        <section class="px-6 pb-24 pt-12 max-w-7xl mx-auto">
            <div class="text-center max-w-3xl mx-auto mb-16">
                <h2 class="text-3xl lg:text-4xl font-bold mb-4 text-slate-900 dark:text-white">Built for the modern web</h2>
                <p class="text-lg text-slate-500 dark:text-white/50">Iris handles the heavy lifting of image hosting so you can focus on building.</p>
            </div>
            
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                <div
                    v-for="feature in [
                        { icon: '⚡', title: 'Lightning Fast CDN', desc: 'Iris distributes your images across 200+ global edge nodes for millisecond load times.' },
                        { icon: '🔒', title: 'Granular Privacy', desc: 'Password-protect individual assets, set expiration dates, or enforce team-only access.' },
                        { icon: '🪄', title: 'Auto-Optimization', desc: 'Upload raw files. Iris automatically compresses and converts them to next-gen WebP formats.' },
                        { icon: '📂', title: 'Workspace Folders', desc: 'Organize assets into nested folders. Assign specific viewing or editing rights to teammates.' },
                        { icon: '🛡️', title: 'Data Stripping', desc: 'Keep your location and camera data private. EXIF metadata is instantly scrubbed on upload.' },
                        { icon: '🎨', title: 'Seamless Integration', desc: 'Copy markdown, HTML, or raw URLs directly from your dashboard with one click.' },
                    ]"
                    :key="feature.title"
                    class="rounded-2xl border border-slate-200 bg-white p-8 shadow-sm hover:shadow-xl hover:shadow-[#7B2FFF]/5 hover:-translate-y-1 dark:border-white/5 dark:bg-white/[0.02] dark:hover:border-[#7B2FFF]/30 dark:hover:bg-white/[0.04] transition-all duration-300 group"
                >
                    <div class="h-12 w-12 rounded-xl bg-slate-50 dark:bg-white/5 flex items-center justify-center text-2xl mb-6 group-hover:scale-110 transition-transform duration-300">{{ feature.icon }}</div>
                    <h3 class="text-xl font-bold text-slate-900 dark:text-white mb-3">{{ feature.title }}</h3>
                    <p class="text-slate-600 dark:text-white/50 leading-relaxed">{{ feature.desc }}</p>
                </div>
            </div>
        </section>

        <!-- Call to Action -->
        <section class="px-6 pb-32">
            <div class="max-w-5xl mx-auto rounded-3xl overflow-hidden relative">
                <!-- BG Gradients -->
                <div class="absolute inset-0 bg-gradient-to-br from-slate-900 to-slate-800 dark:from-[#0d1220] dark:to-[#050811] z-0"></div>
                <div class="absolute inset-0 bg-[url('https://www.transparenttextures.com/patterns/cubes.png')] opacity-10 mix-blend-overlay z-0"></div>
                <div class="absolute -top-24 -right-24 w-96 h-96 bg-[#7B2FFF] rounded-full blur-[100px] opacity-40 z-0"></div>
                <div class="absolute -bottom-24 -left-24 w-96 h-96 bg-[#00E5FF] rounded-full blur-[100px] opacity-30 z-0"></div>

                <div class="relative z-10 px-8 py-20 lg:py-24 text-center flex flex-col items-center">
                    <!-- Footer-style Logo Float -->
                    <img src="/favicon.png" alt="Iris" class="w-16 h-16 object-cover rounded-full animate-float shadow-2xl shadow-black mb-8 border-2 border-white/10" />
                    
                    <h2 class="text-3xl lg:text-5xl font-bold mb-6 text-white tracking-tight">Experience clarity with Iris.</h2>
                    <p class="text-lg text-white/70 mb-10 max-w-xl mx-auto">
                        Join thousands of creators, developers, and teams who trust Iris for their daily image operations.
                    </p>
                    <Link
                        v-if="canRegister"
                        href="/register"
                        class="px-10 py-4 rounded-xl text-lg font-bold bg-white text-slate-900 hover:bg-slate-100 hover:scale-105 transition-all duration-300 shadow-xl shadow-black/20"
                    >
                        Create your free workspace
                    </Link>
                </div>
            </div>
        </section>

        <!-- Minimal Footer -->
        <footer class="border-t border-slate-200 bg-white px-8 py-10 flex flex-col md:flex-row items-center justify-between gap-6 dark:border-white/5 dark:bg-[#050811] transition-colors duration-300">
            <div class="flex items-center gap-3">
                <img src="/favicon.png" alt="Iris" class="h-6 w-6 object-cover rounded-full grayscale opacity-70 dark:opacity-50" />
                <span class="font-bold text-slate-700 dark:text-white/70">Iris</span>
            </div>
            
            <p class="text-slate-500 dark:text-white/40 text-sm">
                &copy; {{ new Date().getFullYear() }} Iris Platform. All rights reserved.
            </p>
            
            <div class="flex items-center gap-8 text-sm font-medium text-slate-600 dark:text-white/50">
                <a href="#" class="hover:text-[#7B2FFF] dark:hover:text-white transition-colors">Privacy</a>
                <a href="#" class="hover:text-[#7B2FFF] dark:hover:text-white transition-colors">Terms</a>
                <Link href="/login" class="hover:text-[#7B2FFF] dark:hover:text-white transition-colors">Sign in</Link>
            </div>
        </footer>

    </div>
</template>

<style scoped>
/* Base floating animation */
@keyframes float {
    0% { transform: translateY(0px); }
    50% { transform: translateY(-12px); }
    100% { transform: translateY(0px); }
}

/* Delayed floating animation for nested elements */
@keyframes float-delayed {
    0% { transform: translateY(0px); }
    50% { transform: translateY(-8px); }
    100% { transform: translateY(0px); }
}

.animate-float {
    animation: float 4s ease-in-out infinite;
}

.animate-float-delayed {
    animation: float-delayed 5s ease-in-out infinite;
    animation-delay: 1s;
}
</style>