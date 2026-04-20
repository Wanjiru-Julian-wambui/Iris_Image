<script setup lang="ts">
import { Head } from '@inertiajs/vue3';
import { Download, Clock, Eye, Lock } from 'lucide-vue-next';
import { Button } from '@/components/ui/button';

defineProps<{
    image: App.ImageResource;
    link: {
        token: string;
        view_count: number;
        expires_at: string | null;
        is_expired: boolean;
        is_password_protected: boolean;
        url: string;
    };
}>();

function formatDate(dateStr: string | null): string {
    if (!dateStr) return 'Never';
    return new Date(dateStr).toLocaleString();
}
</script>

<template>
    <Head :title="image.name" />

    <div class="min-h-screen bg-background flex flex-col items-center justify-center px-4 py-12">

        <!-- Brand -->
        <div class="flex items-center gap-2 mb-8">
            <div class="inline-flex items-center justify-center size-9 rounded-xl bg-gradient-to-br from-[#7B2FFF] to-[#00E5FF] shadow">
                <img src="/favicon.png" alt="Iris" class="size-5 object-contain" />
            </div>
            <span class="font-semibold text-lg tracking-tight">Iris</span>
        </div>

        <!-- Image card -->
        <div class="w-full max-w-3xl rounded-2xl border border-border bg-card shadow-lg overflow-hidden">

            <!-- Image -->
            <div class="w-full bg-muted flex items-center justify-center p-4" style="min-height: 300px">
                <img
                    :src="image.url"
                    :alt="image.name"
                    class="block w-auto h-auto max-w-full rounded"
                    style="max-height: 65vh; object-fit: contain"
                />
            </div>

            <!-- Meta -->
            <div class="p-6 space-y-4">
                <div class="flex items-start justify-between gap-4">
                    <div class="min-w-0">
                        <h1 class="text-lg font-semibold truncate">{{ image.name }}</h1>
                        <p class="text-sm text-muted-foreground">{{ image.size_human }}</p>
                    </div>
                    <a :href="image.url" :download="image.name" target="_blank">
                        <Button variant="outline" size="sm" class="shrink-0">
                            <Download class="h-4 w-4 mr-1.5" />
                            Download
                        </Button>
                    </a>
                </div>

                <div class="flex flex-wrap gap-4 text-sm text-muted-foreground pt-3 border-t border-border">
                    <span class="flex items-center gap-1.5">
                        <Eye class="h-4 w-4" />
                        {{ link.view_count }} view{{ link.view_count !== 1 ? 's' : '' }}
                    </span>
                    <span class="flex items-center gap-1.5">
                        <Clock class="h-4 w-4" />
                        Expires: {{ link.expires_at ? formatDate(link.expires_at) : 'Never' }}
                    </span>
                    <span v-if="link.is_password_protected" class="flex items-center gap-1.5">
                        <Lock class="h-4 w-4" />
                        Password protected
                    </span>
                </div>
            </div>
        </div>

        <p class="text-xs text-muted-foreground mt-6">
            Shared via <span class="font-medium">Iris</span>
        </p>
    </div>
</template>