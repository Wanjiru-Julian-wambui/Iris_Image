<script setup lang="ts">
import { Moon, Sun, Monitor } from 'lucide-vue-next';
import { Button } from '@/components/ui/button';
import {
    DropdownMenu,
    DropdownMenuContent,
    DropdownMenuItem,
    DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu';
import { useAppearance } from '@/composables/useAppearance';

const { appearance, updateAppearance } = useAppearance();
</script>

<template>
    <DropdownMenu>
        <DropdownMenuTrigger as-child>
            <Button variant="ghost" size="icon" class="h-9 w-9">
                <Sun v-if="appearance === 'light'" class="h-5 w-5" />
                <Moon v-else-if="appearance === 'dark'" class="h-5 w-5" />
                <Monitor v-else class="h-5 w-5" />
                <span class="sr-only">Toggle theme</span>
            </Button>
        </DropdownMenuTrigger>
        <DropdownMenuContent align="end">
            <DropdownMenuItem @click="updateAppearance('light')">
                <Sun class="mr-2 h-4 w-4" /> Light
            </DropdownMenuItem>
            <DropdownMenuItem @click="updateAppearance('dark')">
                <Moon class="mr-2 h-4 w-4" /> Dark
            </DropdownMenuItem>
            <DropdownMenuItem @click="updateAppearance('system')">
                <Monitor class="mr-2 h-4 w-4" /> System
            </DropdownMenuItem>
        </DropdownMenuContent>
    </DropdownMenu>
</template>