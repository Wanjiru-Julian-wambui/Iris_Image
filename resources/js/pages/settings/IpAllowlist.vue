<script setup lang="ts">
import { Head, useForm } from '@inertiajs/vue3';
import { ref } from 'vue';
import AppLayout from '@/layouts/AppLayout.vue';
import SettingsLayout from '@/layouts/settings/Layout.vue';
import Heading from '@/components/Heading.vue';
import { Button } from '@/components/ui/button';
import type { BreadcrumbItem } from '@/types';

const props = defineProps<{
    allowlist: string[];
}>();

const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Settings', href: '/settings/profile' },
    { title: 'IP Allowlist', href: '/settings/ip-allowlist' },
];

const form = useForm({
    entries: [...(props.allowlist ?? [])] as string[],
});

const newEntry = ref('');
const entryError = ref('');

function addEntry() {
    const val = newEntry.value.trim();
    if (!val) return;

    if (form.entries.includes(val)) {
        entryError.value = 'Already in the list.';
        return;
    }

    form.entries.push(val);
    newEntry.value = '';
    entryError.value = '';
}

function removeEntry(index: number) {
    form.entries.splice(index, 1);
}

function save() {
    form.put('/settings/ip-allowlist', { preserveScroll: true });
}

function isValidEntry(val: string): boolean {
    const ipv4 = /^(\d{1,3}\.){3}\d{1,3}(\/\d{1,2})?$/;
    const ipv6  = /^[0-9a-fA-F:]+(\\/\d{1,3})?$/;
    return ipv4.test(val) || ipv6.test(val);
}
</script>

<template>
    <AppLayout :breadcrumbs="breadcrumbs">
        <Head title="IP Allowlist" />

        <SettingsLayout>
            <div class="space-y-6">
                <Heading
                    variant="small"
                    title="IP Allowlist"
                    description="Restrict access to your account to specific IP addresses or CIDR ranges. Leave empty to allow all IPs."
                />

                <!-- Warning banner when allowlist is active -->
                <div
                    v-if="form.entries.length > 0"
                    class="rounded-xl border border-amber-500/30 bg-amber-500/10 px-4 py-3 flex gap-3 items-start"
                >
                    <span class="text-amber-400 mt-0.5">⚠</span>
                    <div class="text-sm text-amber-300">
                        <strong class="font-semibold">Active restriction.</strong>
                        Only the {{ form.entries.length }} listed IP{{ form.entries.length !== 1 ? 's' : '' }} can access your account.
                        Make sure your own IP is included before saving.
                    </div>
                </div>

                <!-- Add entry -->
                <div class="space-y-2">
                    <label class="text-sm font-medium text-muted-foreground">Add IP address or CIDR range</label>
                    <div class="flex gap-2">
                        <input
                            v-model="newEntry"
                            type="text"
                            placeholder="e.g. 203.0.113.1 or 192.168.1.0/24"
                            class="flex-1 rounded-xl border border-border bg-background px-4 py-2.5 text-sm text-foreground placeholder:text-muted-foreground focus:outline-none focus:ring-2 focus:ring-violet-500/50"
                            @keydown.enter.prevent="addEntry"
                        />
                        <Button
                            type="button"
                            variant="outline"
                            @click="addEntry"
                            :disabled="!newEntry.trim()"
                        >
                            Add
                        </Button>
                    </div>
                    <p v-if="entryError" class="text-xs text-rose-400">{{ entryError }}</p>
                    <p v-if="form.errors.entries" class="text-xs text-rose-400">{{ form.errors.entries }}</p>
                </div>

                <!-- Entry list -->
                <div v-if="form.entries.length > 0" class="rounded-xl border border-border overflow-hidden">
                    <ul class="divide-y divide-border">
                        <li
                            v-for="(entry, i) in form.entries"
                            :key="entry"
                            class="flex items-center justify-between px-4 py-3 hover:bg-muted/30 transition-colors"
                        >
                            <div class="flex items-center gap-3">
                                <div class="flex h-7 w-7 items-center justify-center rounded-lg bg-violet-500/15 text-xs text-violet-400 font-bold">
                                    IP
                                </div>
                                <code class="text-sm font-mono text-foreground">{{ entry }}</code>
                                <span
                                    v-if="entry.includes('/')"
                                    class="rounded-md bg-sky-500/15 px-1.5 py-0.5 text-[10px] font-semibold text-sky-400"
                                >
                                    CIDR
                                </span>
                                <span
                                    v-if="!isValidEntry(entry)"
                                    class="rounded-md bg-rose-500/15 px-1.5 py-0.5 text-[10px] font-semibold text-rose-400"
                                >
                                    invalid
                                </span>
                            </div>
                            <button
                                @click="removeEntry(i)"
                                class="text-xs text-muted-foreground hover:text-rose-400 transition-colors"
                            >
                                Remove
                            </button>
                        </li>
                    </ul>
                </div>

                <!-- Empty state -->
                <div
                    v-else
                    class="rounded-xl border border-dashed border-border py-10 text-center"
                >
                    <p class="text-sm text-muted-foreground">No IP restrictions active.</p>
                    <p class="text-xs text-muted-foreground mt-1">All IP addresses can access your account.</p>
                </div>

                <!-- Save -->
                <div class="flex items-center gap-4">
                    <Button
                        @click="save"
                        :disabled="form.processing"
                    >
                        {{ form.processing ? 'Saving…' : 'Save allowlist' }}
                    </Button>

                    <Transition
                        enter-active-class="transition ease-in-out"
                        enter-from-class="opacity-0"
                        leave-active-class="transition ease-in-out"
                        leave-to-class="opacity-0"
                    >
                        <p v-show="form.recentlySuccessful" class="text-sm text-muted-foreground">Saved.</p>
                    </Transition>
                </div>

                <!-- Help -->
                <div class="rounded-xl border border-border bg-card p-5 space-y-2 text-xs text-muted-foreground">
                    <p class="font-semibold text-foreground">Supported formats</p>
                    <ul class="space-y-1 list-disc list-inside">
                        <li><code class="bg-muted px-1 rounded">203.0.113.5</code> — single IPv4 address</li>
                        <li><code class="bg-muted px-1 rounded">192.168.1.0/24</code> — IPv4 CIDR range (256 addresses)</li>
                        <li><code class="bg-muted px-1 rounded">2001:db8::1</code> — single IPv6 address</li>
                        <li><code class="bg-muted px-1 rounded">2001:db8::/32</code> — IPv6 CIDR range</li>
                    </ul>
                </div>
            </div>
        </SettingsLayout>
    </AppLayout>
</template>