<script setup lang="ts">
import { Link, usePage } from '@inertiajs/vue3';
import { computed } from 'vue';
import {
    CreditCard,
    Image as ImageIcon,
    LayoutGrid,
    Link as LinkIcon,
    Mail,
    Shield,
    Images,
} from 'lucide-vue-next';
import AppLogo from '@/components/AppLogo.vue';
import NavMain from '@/components/NavMain.vue';
import NavUser from '@/components/NavUser.vue';
import StorageBar from '@/components/StorageBar.vue';
import {
    Sidebar,
    SidebarContent,
    SidebarFooter,
    SidebarHeader,
    SidebarMenu,
    SidebarMenuButton,
    SidebarMenuItem,
    SidebarSeparator,
} from '@/components/ui/sidebar';
import { dashboard } from '@/routes';
import type { NavItem } from '@/types';

const page = usePage();
const user = computed(() => (page.props.auth as any)?.user ?? null);
const isAdmin = computed(() => user.value?.is_admin === true);

const mainNavItems: NavItem[] = [
    {
        title: 'Dashboard',
        href: dashboard(),
        icon: LayoutGrid,
    },
    {
        title: 'Images',
        href: '/images',
        icon: Images,
    },
    {
        title: 'Gallery',
        href: '/gallery',
        icon: ImageIcon,
    },
    {
        title: 'Shared Links',
        href: '/shared-links',
        icon: LinkIcon,
    },
    {
        title: 'Plans',
        href: '/plans',
        icon: CreditCard,
    },
];

const adminNavItems: NavItem[] = [
    {
        title: 'Admin',
        href: '/admin',
        icon: Shield,
    },
    {
        title: 'Invitations',
        href: '/invitations',
        icon: Mail,
    },
];
</script>

<template>
    <Sidebar collapsible="icon" variant="inset">
        <SidebarHeader>
            <SidebarMenu>
                <SidebarMenuItem>
                    <SidebarMenuButton size="lg" as-child>
                        <Link :href="dashboard()">
                            <AppLogo />
                        </Link>
                    </SidebarMenuButton>
                </SidebarMenuItem>
            </SidebarMenu>
        </SidebarHeader>

        <SidebarContent>
            <NavMain :items="mainNavItems" />

            <template v-if="isAdmin">
                <SidebarSeparator />
                <NavMain :items="adminNavItems" />
            </template>
        </SidebarContent>

        <SidebarFooter>
            <!-- Storage bar -->
            <div v-if="user" class="px-3 pb-2">
                <StorageBar
                    compact
                    :used="user.storage_used ?? 0"
                    :limit="user.storage_limit ?? 0"
                    :used-human="user.storage_used_human ?? '0 B'"
                    :limit-human="user.plan?.storage_limit_human ?? '1 GB'"
                    :percent="user.storage_percent ?? 0"
                />
            </div>
            <NavUser />
        </SidebarFooter>
    </Sidebar>
    <slot />
</template>