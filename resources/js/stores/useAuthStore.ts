import { computed } from 'vue';
import { usePage, router } from '@inertiajs/vue3';

export function useAuthStore() {
    const page = usePage();

    // ─── State from Inertia shared props ──────────────────────────────────────

    const user = computed<App.UserResource | null>(
        () => (page.props.auth as any)?.user ?? null
    );

    const isAuthenticated = computed(() => !!user.value);

    const isAdmin = computed(() => user.value?.is_admin === true);

    const isVerified = computed(() => !!user.value?.email_verified_at);

    // ─── Plan helpers ─────────────────────────────────────────────────────────

    const plan = computed(() => user.value?.plan ?? null);

    const isFreePlan = computed(() => !plan.value || plan.value.is_free);

    const isProPlan = computed(() => plan.value?.slug === 'pro');

    const isTeamPlan = computed(() => plan.value?.slug === 'team');

    function hasFeature(feature: string): boolean {
        const features = plan.value?.features ?? [];
        return features.includes(feature);
    }

    // ─── Storage helpers ──────────────────────────────────────────────────────

    const storageUsed    = computed(() => user.value?.storage_used    ?? 0);
    const storageLimit   = computed(() => user.value?.storage_limit   ?? 0);
    const storagePercent = computed(() => user.value?.storage_percent ?? 0);
    const storageUsedHuman = computed(() => user.value?.storage_used_human ?? '0 B');

    const isStorageFull = computed(
        () => storageLimit.value > 0 && storageUsed.value >= storageLimit.value
    );

    const isStorageWarning = computed(() => storagePercent.value >= 70);
    const isStorageCritical = computed(() => storagePercent.value >= 90);

    // ─── Avatar & initials ────────────────────────────────────────────────────

    const avatar = computed(() => user.value?.avatar ?? null);

    const initials = computed(() => {
        if (!user.value?.name) return '?';
        return user.value.name
            .split(' ')
            .map(n => n[0])
            .join('')
            .toUpperCase()
            .slice(0, 2);
    });

    // ─── Actions ──────────────────────────────────────────────────────────────

    function logout() {
        router.post('/logout');
    }

    function goToProfile() {
        router.visit('/settings/profile');
    }

    function goToPlans() {
        router.visit('/plans');
    }

    return {
        user,
        isAuthenticated,
        isAdmin,
        isVerified,
        plan,
        isFreePlan,
        isProPlan,
        isTeamPlan,
        hasFeature,
        storageUsed,
        storageLimit,
        storagePercent,
        storageUsedHuman,
        isStorageFull,
        isStorageWarning,
        isStorageCritical,
        avatar,
        initials,
        logout,
        goToProfile,
        goToPlans,
    };
}
