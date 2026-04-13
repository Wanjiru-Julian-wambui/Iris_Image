import { ref } from 'vue';
import { router } from '@inertiajs/vue3';

export type SharedLinkOptions = {
    imageId:     number;
    expiresIn:   number;
    password?:   string | null;
};

export function useSharedLink() {
    const creating  = ref(false);
    const shareUrl  = ref<string | null>(null);
    const copied    = ref(false);
    const error     = ref<string | null>(null);

    /**
     * Create a new shared link for an image.
     */
    function create(options: SharedLinkOptions): Promise<string | null> {
        return new Promise((resolve) => {
            creating.value = true;
            error.value    = null;
            shareUrl.value = null;

            router.post('/shared-links', {
                image_id:   options.imageId,
                expires_in: options.expiresIn,
                password:   options.password ?? null,
            }, {
                preserveScroll: true,
                onSuccess: (page: any) => {
                    const url       = page.props.flash?.share_url ?? null;
                    shareUrl.value  = url;
                    creating.value  = false;
                    resolve(url);
                },
                onError: (errors) => {
                    error.value    = Object.values(errors).flat().join(' ');
                    creating.value = false;
                    resolve(null);
                },
            });
        });
    }

    /**
     * Copy the current share URL to clipboard.
     */
    async function copyUrl(url?: string) {
        const target = url ?? shareUrl.value;
        if (!target) return;

        try {
            await navigator.clipboard.writeText(target);
            copied.value = true;
            setTimeout(() => { copied.value = false; }, 2000);
        } catch {
            error.value = 'Failed to copy to clipboard.';
        }
    }

    /**
     * Delete a shared link by ID.
     */
    function deleteLink(id: number, onSuccess?: () => void) {
        router.delete(`/shared-links/${id}`, {
            preserveScroll: true,
            onSuccess: () => onSuccess?.(),
            onError: () => {
                error.value = 'Failed to delete the shared link.';
            },
        });
    }

    /**
     * Build a Google Maps URL from GPS coordinates.
     */
    function mapsUrl(lat: number, lng: number): string {
        return `https://www.google.com/maps?q=${lat},${lng}`;
    }

    function reset() {
        shareUrl.value = null;
        copied.value   = false;
        error.value    = null;
        creating.value = false;
    }

    return {
        creating,
        shareUrl,
        copied,
        error,
        create,
        copyUrl,
        deleteLink,
        mapsUrl,
        reset,
    };
}
