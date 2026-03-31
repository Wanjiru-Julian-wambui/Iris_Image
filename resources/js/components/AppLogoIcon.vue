<script setup lang="ts">
import type { HTMLAttributes } from 'vue';

defineOptions({
    inheritAttrs: false,
});

type Props = {
    className?: HTMLAttributes['class'];
};

defineProps<Props>();
</script>

<template>
    <img
        src="/favicon.png"
        alt="Iris"
        :class="className"
        v-bind="$attrs"
        style="width: 100%; height: 100%; object-fit: cover; object-position: center;"
    />
</template>