export interface Plan {
    id: number;
    name: string;
    slug: string;
    price: number;
    price_formatted: string;
    storage_limit: number;
    storage_limit_human: string;
    features: string[];
    is_active: boolean;
    is_free: boolean;
    created_at: string | null;
}

export const featureLabels: Record<string, string> = {
    expiring_links:           'Expiring links',
    exif_stripping:           'EXIF data stripping',
    basic_sharing:            'Basic sharing',
    password_protected_links: 'Password-protected links',
    team_folders:             'Team folders',
    view_history:             'View history',
    admin_dashboard:          'Admin dashboard',
    invite_only_registration: 'Invite-only registration',
    priority_support:         'Priority support',
};

export const allFeatures = Object.entries(featureLabels).map(([value, label]) => ({
    value,
    label,
}));