<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { Head, Link } from '@inertiajs/vue3';
import { dashboard, login, register } from '@/routes';

withDefaults(
    defineProps<{
        canRegister: boolean;
    }>(),
    {
        canRegister: true,
    },
);

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
    <Head title="Iris - Your images. Crystal clear." />

    <!-- Main Wrapper: transitions smoothly between light (slate-50) and dark (#080c18) -->
    <div class="min-h-screen bg-slate-50 text-slate-900 transition-colors duration-300 dark:bg-[#080c18] dark:text-white overflow-x-hidden font-sans">

        <!-- Navbar -->
        <header class="fixed top-0 left-0 right-0 z-50 flex items-center justify-between px-6 lg:px-12 py-4 backdrop-blur-md border-b border-slate-200/80 bg-white/70 dark:border-white/5 dark:bg-[#080c18]/70 transition-colors duration-300">
            <!-- Logo: Replaced with favicon.png, made rounded and floating -->
            <Link href="/" class="flex items-center gap-2 block">
                <img src="/favicon.png" alt="Iris" class="h-8 w-8 object-cover rounded-full animate-float shadow-md dark:shadow-white/10" />
            </Link>

            <nav class="flex items-center gap-1 sm:gap-3">
                <!-- Theme Toggle -->
                <button 
                    @click="toggleTheme" 
                    class="p-2 mr-2 rounded-lg text-slate-500 hover:bg-slate-200 dark:text-white/60 dark:hover:bg-white/10 transition-colors focus:outline-none"
                    aria-label="Toggle Dark Mode"
                >
                    <!-- Sun Icon (shows in dark mode) -->
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
                    <!-- Moon Icon (shows in light mode) -->
                    <svg v-else xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path>
                    </svg>
                </button>

                <Link
                    v-if="$page.props.auth.user"
                    :href="dashboard()"
                    class="px-4 py-2 sm:px-5 rounded-lg text-sm font-medium text-slate-600 hover:text-slate-900 dark:text-white/80 dark:hover:text-white transition-colors"
                >
                    Dashboard
                </Link>
                <template v-else>
                    <Link
                        :href="login()"
                        class="hidden sm:inline-block px-5 py-2 rounded-lg text-sm font-medium text-slate-600 hover:text-slate-900 dark:text-white/60 dark:hover:text-white transition-colors"
                    >
                        Log in
                    </Link>
                    <Link
                        v-if="canRegister"
                        :href="register()"
                        class="px-4 py-2 sm:px-5 rounded-lg text-sm font-semibold bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF] text-white hover:opacity-90 transition-opacity"
                    >
                        Get started
                    </Link>
                </template>
            </nav>
        </header>

        <!-- Hero -->
        <section class="relative flex flex-col items-center justify-center min-h-screen px-6 text-center pt-20">
            <!-- Glows (Subtler in light mode) -->
            <div class="absolute top-1/3 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[700px] h-[700px] rounded-full bg-[#7B2FFF]/5 dark:bg-[#7B2FFF]/10 blur-[100px] dark:blur-[130px] pointer-events-none transition-all duration-300" />
            <div class="absolute top-1/2 left-1/4 w-[400px] h-[400px] rounded-full bg-[#00E5FF]/5 blur-[80px] dark:blur-[100px] pointer-events-none transition-all duration-300" />

            <!-- Logo: Added rounded-full and animate-float -->
            <div class="relative mb-8">
                <div class="absolute inset-0 rounded-full bg-gradient-to-br from-[#7B2FFF]/10 to-[#00E5FF]/10 dark:from-[#7B2FFF]/20 dark:to-[#00E5FF]/20 blur-2xl dark:blur-3xl scale-150 transition-all duration-300" />
                <img src="/favicon.png" alt="Iris" class="relative w-24 h-24 object-cover rounded-full animate-float drop-shadow-xl dark:drop-shadow-2xl" />
            </div>

            <h1 class="text-5xl sm:text-6xl lg:text-7xl font-bold tracking-tight mb-6 max-w-4xl leading-tight text-slate-900 dark:text-white transition-colors duration-300">
                Your images.
                <span class="bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF] bg-clip-text text-transparent">
                    Crystal clear.
                </span>
            </h1>

            <p class="text-lg text-slate-600 dark:text-white/50 max-w-xl mb-10 leading-relaxed transition-colors duration-300">
                A powerful image platform built for teams. Upload, organize, share, and collaborate — with privacy and control built in.
            </p>

            <div class="flex flex-col sm:flex-row items-center gap-4 mb-16">
                <Link
                    v-if="canRegister"
                    :href="register()"
                    class="px-8 py-3.5 rounded-xl text-base font-semibold bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF] text-white hover:opacity-90 transition-opacity shadow-lg shadow-[#7B2FFF]/25"
                >
                    Start for free
                </Link>
                <Link
                    :href="login()"
                    class="px-8 py-3.5 rounded-xl text-base font-medium text-slate-700 bg-white border border-slate-200 hover:border-slate-300 hover:bg-slate-50 dark:bg-transparent dark:text-white/60 dark:border-white/10 dark:hover:border-white/20 dark:hover:text-white/80 transition-all shadow-sm dark:shadow-none"
                >
                    Sign in
                </Link>
            </div>

            <!-- Feature pills -->
            <div class="flex flex-wrap justify-center gap-2">
                <span
                    v-for="feature in ['Drag & Drop Upload', 'Expiring Links', 'EXIF Stripping', 'Team Sharing', 'Storage Limits', 'Dark · Light · System']"
                    :key="feature"
                    class="px-4 py-1.5 rounded-full text-xs font-medium text-slate-600 border border-slate-200 bg-white shadow-sm dark:shadow-none dark:text-white/40 dark:border-white/10 dark:bg-white/5 transition-colors duration-300"
                >
                    {{ feature }}
                </span>
            </div>
        </section>

        <!-- Dropzone Preview -->
        <section class="relative px-6 pb-24 flex flex-col items-center">
            <div class="w-full max-w-3xl rounded-2xl border border-dashed border-[#7B2FFF]/30 bg-white shadow-xl shadow-[#7B2FFF]/5 dark:border-[#7B2FFF]/40 dark:bg-[#0d1220] p-12 flex flex-col items-center gap-4 dark:shadow-[0_0_80px_#7B2FFF15] transition-all duration-300">
                <!-- Added rounded-full and animate-float -->
                <img src="/favicon.png" alt="" class="w-14 h-14 object-cover rounded-full animate-float opacity-40 dark:opacity-50 transition-opacity duration-300" />
                <p class="text-slate-500 dark:text-white/50 text-base transition-colors duration-300">Drag and drop your images here</p>
                <p class="text-slate-400 dark:text-white/20 text-sm transition-colors duration-300">or</p>
                <Link
                    :href="$page.props.auth.user ? dashboard() : register()"
                    class="px-8 py-3 rounded-xl font-semibold bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF] text-white hover:opacity-90 transition-opacity"
                >
                    Upload to Iris
                </Link>
            </div>
        </section>

        <!-- Features -->
        <section class="px-6 pb-24 max-w-6xl mx-auto">
            <h2 class="text-3xl font-bold text-center mb-3 text-slate-900 dark:text-white transition-colors duration-300">Everything your team needs</h2>
            <p class="text-slate-500 dark:text-white/40 text-center mb-12 transition-colors duration-300">Built for teams that care about privacy, speed and simplicity.</p>
            
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
                <div
                    v-for="feature in [
                        { icon: '⬆️', title: 'Smart Upload', desc: 'Drag & drop, clipboard paste, or URL import. EXIF metadata stripped automatically on upload.' },
                        { icon: '🔗', title: 'Expiring Links', desc: 'Share images with links that self-destruct after a set time. Full control, always.' },
                        { icon: '👥', title: 'Team Sharing', desc: 'Create shared folders with view-only or upload-only permissions for guests.' },
                        { icon: '🔒', title: 'Privacy First', desc: 'Password-protect any image or album. View history shows who accessed what and when.' },
                        { icon: '📦', title: 'Storage Plans', desc: 'Freemium model with per-user storage limits. Upgrade to Pro or Team when you need more.' },
                        { icon: '🎨', title: 'Dark · Light · System', desc: 'Fully supports dark, light, and system theme. Looks great on every screen.' },
                    ]"
                    :key="feature.title"
                    class="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm hover:border-[#7B2FFF]/40 hover:shadow-md dark:border-white/5 dark:bg-[#0d1220] dark:hover:border-[#7B2FFF]/30 dark:shadow-none transition-all duration-300"
                >
                    <div class="text-2xl mb-3">{{ feature.icon }}</div>
                    <h3 class="font-semibold text-slate-900 dark:text-white mb-2 transition-colors duration-300">{{ feature.title }}</h3>
                    <p class="text-sm text-slate-600 dark:text-white/40 leading-relaxed transition-colors duration-300">{{ feature.desc }}</p>
                </div>
            </div>
        </section>

        <!-- Pricing -->
        <section class="px-6 pb-28 max-w-5xl mx-auto text-center">
            <h2 class="text-3xl font-bold mb-3 text-slate-900 dark:text-white transition-colors duration-300">Simple pricing</h2>
            <p class="text-slate-500 dark:text-white/40 mb-14 transition-colors duration-300">Start free. Upgrade when you're ready.</p>
            
            <div class="grid grid-cols-1 sm:grid-cols-3 gap-6">

                <!-- Free -->
                <div class="rounded-2xl border border-slate-200 bg-white p-8 text-left flex flex-col shadow-sm dark:shadow-none dark:border-white/5 dark:bg-[#0d1220] transition-all duration-300">
                    <p class="text-sm font-medium text-slate-500 dark:text-white/40 mb-2">Free</p>
                    <p class="text-4xl font-bold mb-1 text-slate-900 dark:text-white">$0</p>
                    <p class="text-slate-400 dark:text-white/30 text-sm mb-6">Forever free</p>
                    <ul class="space-y-2.5 text-sm text-slate-600 dark:text-white/50 mb-8 flex-1 transition-colors duration-300">
                        <li>✓ 1 GB storage</li>
                        <li>✓ Expiring links</li>
                        <li>✓ EXIF stripping</li>
                        <li>✓ Basic sharing</li>
                    </ul>
                    <Link :href="register()" class="block text-center px-6 py-2.5 rounded-xl border border-slate-200 text-slate-700 hover:border-slate-300 hover:bg-slate-50 dark:bg-transparent dark:border-white/10 dark:text-white/60 dark:hover:border-white/20 dark:hover:text-white transition-all text-sm font-medium">
                        Get started free
                    </Link>
                </div>

                <!-- Pro -->
                <div class="rounded-2xl border border-[#7B2FFF]/30 bg-gradient-to-br from-[#7B2FFF]/5 to-[#00E5FF]/5 p-8 text-left flex flex-col relative overflow-hidden shadow-md dark:shadow-none dark:border-[#7B2FFF]/40 dark:from-[#7B2FFF]/10 dark:to-[#00E5FF]/5 transition-all duration-300">
                    <div class="absolute top-4 right-4 px-3 py-1 rounded-full text-xs font-semibold bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF] text-white">
                        Popular
                    </div>
                    <p class="text-sm font-medium text-slate-600 dark:text-white/40 mb-2 transition-colors duration-300">Pro</p>
                    <p class="text-4xl font-bold mb-1 text-slate-900 dark:text-white">$9<span class="text-lg text-slate-400 dark:text-white/30 font-normal">/mo</span></p>
                    <p class="text-slate-500 dark:text-white/30 text-sm mb-6 transition-colors duration-300">Per user</p>
                    <ul class="space-y-2.5 text-sm text-slate-700 dark:text-white/70 mb-8 flex-1 transition-colors duration-300">
                        <li class="font-medium">✓ 50 GB storage</li>
                        <li>✓ Password-protected links</li>
                        <li>✓ Team folders</li>
                        <li>✓ View history</li>
                        <li>✓ Priority support</li>
                    </ul>
                    <Link :href="register()" class="block text-center px-6 py-2.5 rounded-xl bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF] text-white hover:opacity-90 transition-opacity text-sm font-semibold shadow-md shadow-[#7B2FFF]/20 dark:shadow-none">
                        Start Pro trial
                    </Link>
                </div>

                <!-- Team -->
                <div class="rounded-2xl border border-slate-200 bg-white p-8 text-left flex flex-col shadow-sm dark:shadow-none dark:border-white/5 dark:bg-[#0d1220] transition-all duration-300">
                    <p class="text-sm font-medium text-slate-500 dark:text-white/40 mb-2">Team</p>
                    <p class="text-4xl font-bold mb-1 text-slate-900 dark:text-white">$29<span class="text-lg text-slate-400 dark:text-white/30 font-normal">/mo</span></p>
                    <p class="text-slate-400 dark:text-white/30 text-sm mb-6">Per workspace</p>
                    <ul class="space-y-2.5 text-sm text-slate-600 dark:text-white/50 mb-8 flex-1 transition-colors duration-300">
                        <li>✓ 200 GB storage</li>
                        <li>✓ Everything in Pro</li>
                        <li>✓ Admin dashboard</li>
                        <li>✓ Invite-only registration</li>
                        <li>✓ Priority support</li>
                    </ul>
                    <Link :href="register()" class="block text-center px-6 py-2.5 rounded-xl border border-slate-200 text-slate-700 hover:border-slate-300 hover:bg-slate-50 dark:bg-transparent dark:border-white/10 dark:text-white/60 dark:hover:border-white/20 dark:hover:text-white transition-all text-sm font-medium">
                        Get Team
                    </Link>
                </div>
            </div>
        </section>

        <!-- CTA -->
        <section class="px-6 pb-24 text-center">
            <div class="max-w-2xl mx-auto rounded-2xl border border-slate-200 bg-white px-8 py-14 shadow-lg shadow-slate-200/50 dark:shadow-none dark:border-[#7B2FFF]/20 dark:bg-[#0d1220] dark:bg-gradient-to-br dark:from-[#7B2FFF]/10 dark:to-[#00E5FF]/5 transition-all duration-300">
                <!-- Added rounded-full and animate-float -->
                <img src="/favicon.png" alt="Iris" class="w-14 h-14 object-cover rounded-full animate-float mx-auto mb-4 opacity-70 dark:opacity-80 transition-opacity duration-300" />
                <h2 class="text-3xl font-bold mb-3 text-slate-900 dark:text-white transition-colors duration-300">Ready to get started?</h2>
                <p class="text-slate-500 dark:text-white/40 mb-8 transition-colors duration-300">Join teams already using Iris to manage their images.</p>
                <Link
                    v-if="canRegister"
                    :href="register()"
                    class="inline-block px-10 py-3.5 rounded-xl text-base font-semibold bg-gradient-to-r from-[#7B2FFF] to-[#00E5FF] text-white hover:opacity-90 transition-opacity shadow-lg shadow-[#7B2FFF]/25"
                >
                    Create free account
                </Link>
            </div>
        </section>

        <!-- Footer -->
        <footer class="border-t border-slate-200 bg-slate-50 px-8 py-8 flex flex-col sm:flex-row items-center justify-between gap-4 dark:border-white/5 dark:bg-transparent transition-colors duration-300">
            <div class="flex items-center gap-2">
                <!-- Replaced with favicon.png, made rounded and floating -->
                <img src="/favicon.png" alt="Iris" class="h-6 w-6 object-cover rounded-full animate-float opacity-60 dark:opacity-50 transition-opacity duration-300" />
            </div>
            
            <p class="text-slate-400 dark:text-white/20 text-sm transition-colors duration-300">&copy; {{ new Date().getFullYear() }} Iris. All rights reserved.</p>
            
            <div class="flex items-center gap-6 text-sm text-slate-500 dark:text-white/30 transition-colors duration-300">
                <a href="mailto:admin@iris.app" class="hover:text-slate-900 dark:hover:text-white/60 transition-colors">Contact</a>
                <Link :href="login()" class="hover:text-slate-900 dark:hover:text-white/60 transition-colors">Sign in</Link>
                <Link v-if="canRegister" :href="register()" class="hover:text-slate-900 dark:hover:text-white/60 transition-colors">Register</Link>
            </div>
        </footer>

    </div>
</template>

<style scoped>
/* Custom floating animation for the favicon */
@keyframes float {
    0% {
        transform: translateY(0px);
    }
    50% {
        transform: translateY(-8px);
    }
    100% {
        transform: translateY(0px);
    }
}

.animate-float {
    animation: float 3s ease-in-out infinite;
}
</style>