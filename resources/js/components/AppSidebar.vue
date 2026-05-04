<script setup lang="ts">
import { Link, usePage } from '@inertiajs/vue3';
import {
    CreditCard,
    Image as ImageIcon,
    Key,
    KeyRound,
    LayoutGrid,
    Link as LinkIcon,
    Mail,
    Shield,
    Images,
    FolderOpen,
    Tags,
    BarChart3
} from 'lucide-vue-next';
import { computed } from 'vue';
import AppLogo from '@/components/AppLogo.vue';
import NavMain from '@/components/NavMain.vue';
import NavUser from '@/components/NavUser.vue';
import PlanBadge from '@/components/Plans/PlanBadge.vue';
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

const page    = usePage();
const user    = computed(() => (page.props.auth as any)?.user ?? null);
const isAdmin = computed(() => user.value?.is_admin === true);
const userPlan = computed(() => user.value?.plan ?? null);

const mainNavItems: NavItem[] = [
    { title: 'Dashboard',       href: dashboard(),                    icon: LayoutGrid  },
    { title: 'Images',          href: '/images',                      icon: Images      },
    { title: 'Gallery',         href: '/gallery',                     icon: ImageIcon   },
    { title: 'Albums',          href: '/albums',                      icon: FolderOpen  },
    { title: 'Shared Links',    href: '/shared-links',                icon: LinkIcon    },
    { title: 'API Keys',        href: '/settings/api-keys',           icon: Key         },
    { title: 'API Credentials', href: '/settings/api-credentials',    icon: KeyRound    },
    { title: 'Tags',            href: '/tags',                        icon: Tags        },
];

const adminNavItems: NavItem[] = [
    { title: 'Polls',       href: '/polls',       icon: BarChart3 },
    { title: 'Admin',       href: '/admin',       icon: Shield    },
    { title: 'Invitations', href: '/invitations', icon: Mail      },
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

            <!-- Plans item with current plan badge -->
            <SidebarMenu class="-mt-1 px-2">
                <SidebarMenuItem>
                    <SidebarMenuButton as-child>
                        <Link href="/plans" class="flex items-center gap-2 w-full">
                            <CreditCard class="h-4 w-4 shrink-0" />
                            <span class="flex-1">Plans</span>
                            <span class="group-data-[collapsible=icon]:hidden">
                                <PlanBadge :plan="userPlan" size="sm" />
                            </span>
                        </Link>
                    </SidebarMenuButton>
                </SidebarMenuItem>
            </SidebarMenu>

            <template v-if="isAdmin">
                <SidebarSeparator />
                <NavMain :items="adminNavItems" />
            </template>
        </SidebarContent>

        <SidebarFooter>
            <div
                v-if="user"
                class="px-3 pb-2 group-data-[collapsible=icon]:hidden"
            >
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