<script setup lang="ts">
import { ref, watch } from 'vue';
import { cn } from '@/lib/utils';

const props = defineProps<{
    defaultChecked?: boolean;
    value?: string;
    name?: string;
    id?: string;
    disabled?: boolean;
}>();

const emit = defineEmits<{
    (e: 'update:checked', value: boolean): void;
}>();

const checked = ref(props.defaultChecked ?? false);

watch(
    () => props.defaultChecked,
    (value) => {
        if (value !== undefined) {
            checked.value = value;
        }
    }
);

function onChange(event: Event) {
    const target = event.target as HTMLInputElement;
    checked.value = target.checked;
    emit('update:checked', checked.value);
}
</script>

<template>
    <label
        :for="props.id"
        :class="cn(
            'peer inline-flex h-6 w-11 shrink-0 cursor-pointer items-center rounded-full border-2 border-transparent transition-colors focus-within:outline-none focus-within:ring-2 focus-within:ring-ring focus-within:ring-offset-2 focus-within:ring-offset-background disabled:cursor-not-allowed disabled:opacity-50',
            checked ? 'bg-violet-500' : 'bg-input',
            $attrs.class ?? ''
        )"
    >
        <input
            :id="props.id"
            :name="props.name"
            :value="props.value"
            :checked="checked"
            :disabled="props.disabled"
            type="checkbox"
            class="sr-only"
            @change="onChange"
        />
        <span
            :class="cn(
                'pointer-events-none block h-5 w-5 rounded-full bg-background shadow-lg ring-0 transition-transform',
                checked ? 'translate-x-5' : 'translate-x-0'
            )"
        />
    </label>
</template>