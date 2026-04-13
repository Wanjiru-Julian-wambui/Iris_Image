<script setup lang="ts">
import { computed } from 'vue';
import ImageCard from '@/components/Gallery/ImageCard.vue';

type GridSize = 'sm' | 'md' | 'lg';

const props = defineProps<{
    images:     App.ImageResource[];
    gridSize?:  GridSize;
    selectable?: boolean;
    selected?:  Set<number>;
}>();

const emit = defineEmits<{
    clickImage:  [image: App.ImageResource];
    selectImage: [image: App.ImageResource];
    deleteImage: [image: App.ImageResource];
    shareImage:  [image: App.ImageResource];
}>();

const gridClass = computed(() => ({
    sm: 'grid-cols-3 sm:grid-cols-4 md:grid-cols-6 lg:grid-cols-8 xl:grid-cols-10',
    md: 'grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6',
    lg: 'grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4',
}[props.gridSize ?? 'md']));
</script>

<template>
    <div :class="['grid gap-3', gridClass]">
        <ImageCard
            v-for="image in images"
            :key="image.id"
            :image="image"
            :selectable="selectable"
            :selected="selected?.has(image.id)"
            @click="emit('clickImage', image)"
            @select="emit('selectImage', image)"
            @delete="emit('deleteImage', image)"
            @share="emit('shareImage', image)"
        />
    </div>
</template>
