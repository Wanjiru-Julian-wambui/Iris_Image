<script setup lang="ts">
import AppLogoIcon from '@/components/AppLogoIcon.vue';
</script>

<template>
    <div class="floating-wrapper">
        <div
            style="
                width: 2rem;
                height: 2rem;
                border-radius: 50%;
                overflow: hidden;
                box-shadow: 0 4px 15px rgba(99, 102, 241, 0.5), 0 2px 6px rgba(0,0,0,0.4);
                flex-shrink: 0;
            "
        >
            <AppLogoIcon style="width: 100%; height: 100%;" />
        </div>
    </div>
    <div class="ml-1 grid flex-1 text-left text-sm">
        <span class="mb-0.5 truncate leading-tight font-semibold">Iris</span>
    </div>
</template>

<style scoped>
.floating-wrapper {
    display: flex;
    align-items: center;
    justify-content: center;
    animation: float 3s ease-in-out infinite;
    will-change: transform;
}

@keyframes float {
    0%, 100% { transform: translateY(0px); }
    50% { transform: translateY(-4px); }
}
</style>