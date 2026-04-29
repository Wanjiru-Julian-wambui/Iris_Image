<script setup lang="ts">
import { Head, router } from '@inertiajs/vue3';
import { Check, ArrowLeft } from 'lucide-vue-next';
import { ref, computed } from 'vue';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';

const props = defineProps<{
    poll: App.ImagePoll;
}>();

const voting       = ref(false);
const votedChoice  = ref<string | null>(props.poll.user_vote ?? null);
const votedChoices = ref<number[]>(props.poll.user_votes ?? []);
const hasVoted     = ref(props.poll.has_voted ?? false);

const isAb    = computed(() => props.poll.type === 'ab');
const isMulti = computed(() => props.poll.type === 'multi');

// ── A/B ──────────────────────────────────────────────────────────────────────

function voteAb(choice: 'a' | 'b') {
    if (hasVoted.value || voting.value) return;
    voting.value = true;
    router.post(`/poll/${props.poll.public_token}/vote`, { choice }, {
        preserveScroll: true,
        onSuccess: () => {
            votedChoice.value = choice;
            hasVoted.value = true;
        },
        onFinish: () => { voting.value = false; },
    });
}

// ── Multi ─────────────────────────────────────────────────────────────────────

const multiSelected = ref<number[]>([]);

function toggleImage(id: number) {
    if (hasVoted.value || voting.value) return;
    const idx = multiSelected.value.indexOf(id);
    if (idx === -1) {
        if (props.poll.max_choices && multiSelected.value.length >= props.poll.max_choices) return;
        multiSelected.value.push(id);
    } else {
        multiSelected.value.splice(idx, 1);
    }
}

function isMultiSelected(id: number) {
    return multiSelected.value.includes(id);
}

const canVoteMulti = computed(() => multiSelected.value.length > 0 && !hasVoted.value && !voting.value);

function submitMulti() {
    if (!canVoteMulti.value) return;
    voting.value = true;
    router.post(`/poll/${props.poll.public_token}/vote`, { image_ids: multiSelected.value }, {
        preserveScroll: true,
        onSuccess: () => {
            votedChoices.value = [...multiSelected.value];
            hasVoted.value = true;
        },
        onFinish: () => { voting.value = false; },
    });
}

// ── Results helpers ───────────────────────────────────────────────────────────

function resultForImage(imageId: number) {
    if (!props.poll.results?.items) return { count: 0, percent: 0 };
    return props.poll.results.items.find((r: any) => r.image_id === imageId) ?? { count: 0, percent: 0 };
}

const sortedByVotes = computed(() => {
    if (!props.poll.images) return [];
    return [...props.poll.images].sort((a, b) => {
        return resultForImage(b.id).count - resultForImage(a.id).count;
    });
});
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

            <h1 class="text-xl font-bold tracking-tight mb-2 text-center">{{ poll.question }}</h1>

            <p v-if="isMulti && !hasVoted" class="text-center text-sm text-muted-foreground mb-8">
                <template v-if="poll.max_choices">
                    Pick up to <strong>{{ poll.max_choices }}</strong> favorite{{ poll.max_choices !== 1 ? 's' : '' }}
                </template>
                <template v-else>
                    Pick your favorites — select as many as you like
                </template>
            </p>
            <div v-else class="mb-8" />

            <!-- ══ A/B Poll ════════════════════════════════════════════════ -->
            <template v-if="isAb">
                <div v-if="!hasVoted" class="grid grid-cols-1 sm:grid-cols-2 gap-6">
                    <button
                        v-for="side in (['a', 'b'] as const)"
                        :key="side"
                        @click="voteAb(side)"
                        :disabled="voting"
                        class="group relative rounded-xl overflow-hidden border-2 border-border transition-all bg-card"
                        :class="side === 'a' ? 'hover:border-violet-500' : 'hover:border-cyan-400'"
                    >
                        <div class="aspect-square">
                            <img
                                :src="side === 'a' ? poll.image_a?.url : poll.image_b?.url"
                                class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                            />
                        </div>
                        <div class="p-4 text-center">
                            <span class="text-sm font-medium">Vote for {{ side.toUpperCase() }}</span>
                        </div>
                        <div v-if="voting" class="absolute inset-0 bg-background/60 flex items-center justify-center">
                            <span class="h-8 w-8 animate-spin rounded-full border-3 border-violet-500 border-t-transparent" />
                        </div>
                    </button>
                </div>

                <div v-else class="space-y-6">
                    <div class="flex items-center justify-center gap-2 text-emerald-400">
                        <Check class="h-5 w-5" />
                        <span class="font-medium">Thanks for voting!</span>
                    </div>

                    <div class="grid grid-cols-1 sm:grid-cols-2 gap-6">
                        <div
                            v-for="side in (['a', 'b'] as const)"
                            :key="side"
                            class="rounded-xl border border-border overflow-hidden"
                            :class="(votedChoice === side || poll.user_vote === side)
                                ? (side === 'a' ? 'ring-2 ring-violet-500' : 'ring-2 ring-cyan-400')
                                : ''"
                        >
                            <div class="relative aspect-square">
                                <img :src="side === 'a' ? poll.image_a?.url : poll.image_b?.url" class="w-full h-full object-cover" />
                                <div class="absolute inset-0 bg-black/40 flex items-center justify-center">
                                    <span class="text-3xl font-bold text-white">
                                        {{ side === 'a' ? poll.results?.a_percent : poll.results?.b_percent }}%
                                    </span>
                                </div>
                            </div>
                            <div class="p-3">
                                <div class="flex items-center justify-between text-sm">
                                    <span class="font-medium">{{ side === 'a' ? poll.results?.a_count : poll.results?.b_count }} votes</span>
                                    <Badge v-if="votedChoice === side || poll.user_vote === side" variant="secondary" class="text-[10px]">Your vote</Badge>
                                </div>
                                <div class="mt-2 h-2 rounded-full bg-muted overflow-hidden">
                                    <div
                                        class="h-full rounded-full transition-all duration-500"
                                        :class="side === 'a' ? 'bg-violet-500' : 'bg-cyan-400'"
                                        :style="{ width: (side === 'a' ? poll.results?.a_percent : poll.results?.b_percent) + '%' }"
                                    />
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="text-center text-sm text-muted-foreground">
                        {{ poll.results?.total }} total vote{{ poll.results?.total !== 1 ? 's' : '' }}
                    </div>
                </div>
            </template>

            <!-- ══ Multi Poll ══════════════════════════════════════════════ -->
            <template v-else-if="isMulti">
                <div v-if="!hasVoted" class="space-y-6">
                    <div class="grid grid-cols-2 sm:grid-cols-3 gap-4">
                        <button
                            v-for="img in poll.images"
                            :key="img.id"
                            @click="toggleImage(img.id)"
                            :disabled="voting || (!isMultiSelected(img.id) && !!poll.max_choices && multiSelected.length >= poll.max_choices)"
                            class="relative rounded-xl overflow-hidden border-2 transition-all bg-card aspect-square group"
                            :class="isMultiSelected(img.id)
                                ? 'border-violet-500 scale-[0.97]'
                                : 'border-border hover:border-violet-300 disabled:opacity-40'"
                        >
                            <img :src="img.url" class="w-full h-full object-cover" />
                            <div
                                class="absolute inset-0 flex items-center justify-center transition-opacity"
                                :class="isMultiSelected(img.id)
                                    ? 'bg-violet-500/30 opacity-100'
                                    : 'opacity-0 group-hover:opacity-100 group-hover:bg-black/10'"
                            >
                                <div v-if="isMultiSelected(img.id)" class="bg-violet-600 rounded-full p-1 shadow-lg">
                                    <Check class="h-5 w-5 text-white" />
                                </div>
                            </div>
                        </button>
                    </div>

                    <div class="flex items-center justify-between pt-2">
                        <span class="text-sm text-muted-foreground">
                            {{ multiSelected.length }} selected
                            <template v-if="poll.max_choices"> / {{ poll.max_choices }} max</template>
                        </span>
                        <Button
                            @click="submitMulti"
                            :disabled="!canVoteMulti"
                            class="bg-violet-600 hover:bg-violet-700 disabled:opacity-50"
                        >
                            {{ voting ? 'Submitting…' : 'Submit Votes' }}
                        </Button>
                    </div>
                </div>

                <div v-else class="space-y-6">
                    <div class="flex items-center justify-center gap-2 text-emerald-400">
                        <Check class="h-5 w-5" />
                        <span class="font-medium">Thanks for voting!</span>
                    </div>

                    <div class="grid grid-cols-2 sm:grid-cols-3 gap-4">
                        <div
                            v-for="img in sortedByVotes"
                            :key="img.id"
                            class="rounded-xl border border-border overflow-hidden"
                            :class="(votedChoices.includes(img.id) || (poll.user_votes ?? []).includes(img.id))
                                ? 'ring-2 ring-violet-500' : ''"
                        >
                            <div class="relative aspect-square">
                                <img :src="img.url" class="w-full h-full object-cover" />
                                <div class="absolute inset-0 bg-black/40 flex items-center justify-center">
                                    <span class="text-2xl font-bold text-white">{{ resultForImage(img.id).percent }}%</span>
                                </div>
                            </div>
                            <div class="p-2">
                                <div class="flex items-center justify-between text-xs">
                                    <span class="font-medium">{{ resultForImage(img.id).count }} votes</span>
                                    <Badge
                                        v-if="votedChoices.includes(img.id) || (poll.user_votes ?? []).includes(img.id)"
                                        variant="secondary"
                                        class="text-[10px]"
                                    >
                                        Your pick
                                    </Badge>
                                </div>
                                <div class="mt-1.5 h-1.5 rounded-full bg-muted overflow-hidden">
                                    <div
                                        class="h-full bg-violet-500 rounded-full transition-all duration-700"
                                        :style="{ width: resultForImage(img.id).percent + '%' }"
                                    />
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="text-center text-sm text-muted-foreground">
                        {{ poll.results?.total_voters }} voter{{ poll.results?.total_voters !== 1 ? 's' : '' }} ·
                        {{ poll.results?.total_votes }} total vote{{ poll.results?.total_votes !== 1 ? 's' : '' }}
                    </div>
                </div>
            </template>
        </div>

        <footer class="border-t border-border mt-12 py-6 text-center">
            <p class="text-sm text-muted-foreground">
                Hosted on <span class="font-semibold text-foreground">Iris</span> — Simple image hosting
            </p>
        </footer>
    </div>
</template>