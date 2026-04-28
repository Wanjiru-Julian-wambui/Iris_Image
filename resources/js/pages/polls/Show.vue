<script setup lang="ts">
import { Head, router } from '@inertiajs/vue3';
import { BarChart3, Check, ArrowLeft } from 'lucide-vue-next';
import { ref } from 'vue';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';

const props = defineProps<{
    poll: App.ImagePoll;
}>();

const voting = ref(false);
const votedChoice = ref<string | null>(props.poll.user_vote);

function vote(choice: 'a' | 'b') {
    if (props.poll.has_voted || voting.value) return;

    voting.value = true;
    router.post(`/poll/${props.poll.public_token}/vote`, { choice }, {
        preserveScroll: true,
        onFinish: () => {
            voting.value = false;
            votedChoice.value = choice;
        },
    });
}
</script>

<template>
    <Head :title="poll.question" />

    <div class="min-h-screen bg-background">
        <!-- Header -->
        <header class="border-b border-border bg-card">
            <div class="max-w-4xl mx-auto px-4 py-4 flex items-center justify-between">
                <div class="flex items-center gap-3">
                    <div class="h-8 w-8 rounded-lg bg-gradient-to-br from-violet-500 to-cyan-400 flex items-center justify-center">
                        <span class="text-white font-bold text-sm">I</span>
                    </div>
                    <span class="font-bold tracking-tight">Iris Poll</span>
                </div>
                <Link href="/login">
                    <Button variant="outline" size="sm">Sign in</Button>
                </Link>
            </div>
        </header>

        <div class="max-w-3xl mx-auto px-4 py-8">
            <button @click="$router.back()" class="flex items-center gap-2 text-sm text-muted-foreground hover:text-foreground mb-6 transition-colors">
                <ArrowLeft class="h-4 w-4" />
                Back
            </button>

            <h1 class="text-xl font-bold tracking-tight mb-8 text-center">{{ poll.question }}</h1>

            <!-- Voting view -->
            <div v-if="!poll.has_voted && !votedChoice" class="grid grid-cols-1 sm:grid-cols-2 gap-6">
                <button
                    @click="vote('a')"
                    :disabled="voting"
                    class="group relative rounded-xl overflow-hidden border-2 border-border hover:border-violet-500 transition-all bg-card"
                >
                    <div class="aspect-square">
                        <img :src="poll.image_a.url" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300" />
                    </div>
                    <div class="p-4 text-center">
                        <span class="text-sm font-medium">Vote for A</span>
                    </div>
                    <div v-if="voting" class="absolute inset-0 bg-background/60 flex items-center justify-center">
                        <span class="h-8 w-8 animate-spin rounded-full border-3 border-violet-500 border-t-transparent" />
                    </div>
                </button>

                <button
                    @click="vote('b')"
                    :disabled="voting"
                    class="group relative rounded-xl overflow-hidden border-2 border-border hover:border-cyan-400 transition-all bg-card"
                >
                    <div class="aspect-square">
                        <img :src="poll.image_b.url" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300" />
                    </div>
                    <div class="p-4 text-center">
                        <span class="text-sm font-medium">Vote for B</span>
                    </div>
                    <div v-if="voting" class="absolute inset-0 bg-background/60 flex items-center justify-center">
                        <span class="h-8 w-8 animate-spin rounded-full border-3 border-cyan-400 border-t-transparent" />
                    </div>
                </button>
            </div>

            <!-- Results view -->
            <div v-else class="space-y-6">
                <div class="flex items-center justify-center gap-2 text-emerald-400">
                    <Check class="h-5 w-5" />
                    <span class="font-medium">Thanks for voting!</span>
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
                    <!-- Result A -->
                    <div class="rounded-xl border border-border overflow-hidden" :class="votedChoice === 'a' || poll.user_vote === 'a' ? 'ring-2 ring-violet-500' : ''">
                        <div class="relative aspect-square">
                            <img :src="poll.image_a.url" class="w-full h-full object-cover" />
                            <div class="absolute inset-0 bg-black/40 flex items-center justify-center">
                                <span class="text-3xl font-bold text-white">{{ poll.results.a_percent }}%</span>
                            </div>
                        </div>
                        <div class="p-3">
                            <div class="flex items-center justify-between text-sm">
                                <span class="font-medium">{{ poll.results.a_count }} votes</span>
                                <Badge v-if="votedChoice === 'a' || poll.user_vote === 'a'" variant="secondary" class="text-[10px]">Your vote</Badge>
                            </div>
                            <div class="mt-2 h-2 rounded-full bg-muted overflow-hidden">
                                <div class="h-full bg-violet-500 rounded-full transition-all duration-500" :style="{ width: poll.results.a_percent + '%' }" />
                            </div>
                        </div>
                    </div>

                    <!-- Result B -->
                    <div class="rounded-xl border border-border overflow-hidden" :class="votedChoice === 'b' || poll.user_vote === 'b' ? 'ring-2 ring-cyan-400' : ''">
                        <div class="relative aspect-square">
                            <img :src="poll.image_b.url" class="w-full h-full object-cover" />
                            <div class="absolute inset-0 bg-black/40 flex items-center justify-center">
                                <span class="text-3xl font-bold text-white">{{ poll.results.b_percent }}%</span>
                            </div>
                        </div>
                        <div class="p-3">
                            <div class="flex items-center justify-between text-sm">
                                <span class="font-medium">{{ poll.results.b_count }} votes</span>
                                <Badge v-if="votedChoice === 'b' || poll.user_vote === 'b'" variant="secondary" class="text-[10px]">Your vote</Badge>
                            </div>
                            <div class="mt-2 h-2 rounded-full bg-muted overflow-hidden">
                                <div class="h-full bg-cyan-400 rounded-full transition-all duration-500" :style="{ width: poll.results.b_percent + '%' }" />
                            </div>
                        </div>
                    </div>
                </div>

                <div class="text-center text-sm text-muted-foreground">
                    {{ poll.results.total }} total vote{{ poll.results.total !== 1 ? 's' : '' }}
                </div>
            </div>
        </div>

        <footer class="border-t border-border mt-12 py-6 text-center">
            <p class="text-sm text-muted-foreground">
                Hosted on <span class="font-semibold text-foreground">Iris</span> — Simple image hosting
            </p>
        </footer>
    </div>
</template>