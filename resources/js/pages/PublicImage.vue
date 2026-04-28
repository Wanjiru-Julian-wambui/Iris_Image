<script setup lang="ts">
import { Head, router } from '@inertiajs/vue3';
import { Download, Eye, Calendar, User, ArrowLeft } from 'lucide-vue-next';
import { ref, computed } from 'vue';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';

const props = defineProps<{
    image: App.ImageResource;
}>();

const ALLOWED_EMOJIS = ['👍', '❤️', '😂', '😮', '😢', '🔥'];
const reacting = ref<string | null>(null);

const reactionEntries = computed(() => {
    if (!props.image.reactions) return [];
    return Object.entries(props.image.reactions).sort((a, b) => b[1] - a[1]);
});

const totalReactions = computed(() => {
    return reactionEntries.value.reduce((sum, [, count]) => sum + count, 0);
});

function react(emoji: string) {
    reacting.value = emoji;
    router.post(`/i/${props.image.id}/react`, { emoji }, {
        preserveScroll: true,
        onFinish: () => { reacting.value = null; },
    });
}

function getReactionCount(emoji: string): number {
    return props.image.reactions?.[emoji] ?? 0;
}

function isActive(emoji: string): boolean {
    return props.image.user_reaction === emoji;
}
</script>

<template>
    <Head :title="image.name" />

    <div class="min-h-screen bg-background">
        <!-- Header -->
        <header class="border-b border-border bg-card">
            <div class="max-w-4xl mx-auto px-4 py-4 flex items-center justify-between">
                <div class="flex items-center gap-3">
                    <div class="h-8 w-8 rounded-lg bg-gradient-to-br from-violet-500 to-cyan-400 flex items-center justify-center">
                        <span class="text-white font-bold text-sm">I</span>
                    </div>
                    <span class="font-bold tracking-tight">Iris</span>
                </div>
                <Link href="/login">
                    <Button variant="outline" size="sm">Sign in</Button>
                </Link>
            </div>
        </header>

        <div class="max-w-4xl mx-auto px-4 py-8">
            <!-- Back -->
            <button @click="$router.back()" class="flex items-center gap-2 text-sm text-muted-foreground hover:text-foreground mb-6 transition-colors">
                <ArrowLeft class="h-4 w-4" />
                Back
            </button>

            <!-- Image -->
            <div class="rounded-xl overflow-hidden border border-border bg-muted flex items-center justify-center min-h-[300px] mb-6">
                <img :src="image.url" :alt="image.alt_text || image.name" class="max-w-full max-h-[700px] object-contain" />
            </div>

            <!-- Info -->
            <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-6">
                <div>
                    <h1 class="text-xl font-bold tracking-tight break-all">{{ image.name }}</h1>
                    <div class="flex items-center gap-3 mt-2 text-sm text-muted-foreground">
                        <span class="flex items-center gap-1"><User class="h-3.5 w-3.5" /> {{ image.user?.name }}</span>
                        <span class="flex items-center gap-1"><Calendar class="h-3.5 w-3.5" /> {{ image.created_at }}</span>
                        <span class="flex items-center gap-1"><Eye class="h-3.5 w-3.5" /> Public</span>
                    </div>
                </div>
                <div class="flex items-center gap-2">
                    <Badge variant="secondary">{{ image.extension.toUpperCase() }}</Badge>
                    <Badge variant="outline">{{ image.size_human }}</Badge>
                    <Badge v-if="image.width && image.height" variant="outline">{{ image.width }} × {{ image.height }}</Badge>
                </div>
            </div>

            <!-- Caption -->
            <p v-if="image.caption" class="text-sm text-foreground mb-6 leading-relaxed">{{ image.caption }}</p>

            <!-- Tags -->
            <div v-if="image.tags?.length" class="flex flex-wrap gap-1.5 mb-6">
                <Badge v-for="tag in image.tags" :key="tag.id" variant="secondary" class="text-xs">
                    {{ tag.name }}
                </Badge>
            </div>

            <!-- Reactions -->
            <div class="rounded-xl border border-border bg-card p-5 space-y-3">
                <div class="flex items-center justify-between">
                    <h3 class="text-sm font-semibold">Reactions</h3>
                    <span v-if="totalReactions > 0" class="text-xs text-muted-foreground">{{ totalReactions }} total</span>
                </div>

                <div class="flex flex-wrap gap-2">
                    <button
                        v-for="emoji in ALLOWED_EMOJIS"
                        :key="emoji"
                        @click="react(emoji)"
                        :disabled="!!reacting"
                        class="group relative flex items-center gap-1.5 rounded-lg border px-3 py-2 text-lg transition-all"
                        :class="isActive(emoji)
                            ? 'border-violet-500 bg-violet-500/10 text-violet-400'
                            : 'border-border bg-muted/40 hover:border-violet-500/30 hover:bg-violet-500/5'"
                    >
                        <span class="leading-none">{{ emoji }}</span>
                        <span v-if="getReactionCount(emoji) > 0" class="text-xs font-medium text-muted-foreground group-hover:text-foreground">
                            {{ getReactionCount(emoji) }}
                        </span>
                        <span v-if="reacting === emoji" class="absolute inset-0 flex items-center justify-center bg-background/50 rounded-lg">
                            <span class="h-4 w-4 animate-spin rounded-full border-2 border-violet-500 border-t-transparent" />
                        </span>
                    </button>
                </div>

                <p class="text-xs text-muted-foreground">
                    Click an emoji to react. Your reaction helps the creator know what people think.
                </p>
            </div>
        </div>

        <!-- Footer -->
        <footer class="border-t border-border mt-12 py-6 text-center">
            <p class="text-sm text-muted-foreground">
                Hosted on <span class="font-semibold text-foreground">Iris</span> — Simple image hosting
            </p>
        </footer>
    </div>
</template>