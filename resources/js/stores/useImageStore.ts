import { ref, computed } from 'vue';
import { router, usePage } from '@inertiajs/vue3';

export function useImageStore() {
    const page = usePage();

    const images      = ref<App.ImageResource[]>([]);
    const selected    = ref<Set<number>>(new Set());
    const searchQuery = ref('');
    const sortBy      = ref<'latest' | 'oldest' | 'largest' | 'smallest' | 'name'>('latest');
    const viewMode    = ref<'grid' | 'list'>('grid');
    const loading     = ref(false);

    // ─── Computed ─────────────────────────────────────────────────────────────

    const selectedCount = computed(() => selected.value.size);
    const hasSelection  = computed(() => selected.value.size > 0);
    const allSelected   = computed(
        () => images.value.length > 0 && selected.value.size === images.value.length
    );

    const filteredImages = computed(() => {
        let result = [...images.value];

        if (searchQuery.value.trim()) {
            const q = searchQuery.value.toLowerCase();
            result = result.filter(img =>
                img.name.toLowerCase().includes(q) ||
                img.original_name?.toLowerCase().includes(q)
            );
        }

        switch (sortBy.value) {
            case 'oldest':   result.sort((a, b) => a.created_at.localeCompare(b.created_at)); break;
            case 'largest':  result.sort((a, b) => b.size - a.size); break;
            case 'smallest': result.sort((a, b) => a.size - b.size); break;
            case 'name':     result.sort((a, b) => a.name.localeCompare(b.name)); break;
            default:         result.sort((a, b) => b.created_at.localeCompare(a.created_at)); break;
        }

        return result;
    });

    const totalSize = computed(() =>
        images.value.reduce((sum, img) => sum + img.size, 0)
    );

    const selectedImages = computed(() =>
        images.value.filter(img => selected.value.has(img.id))
    );

    // ─── Selection ────────────────────────────────────────────────────────────

    function toggleSelect(id: number) {
        if (selected.value.has(id)) {
            selected.value.delete(id);
        } else {
            selected.value.add(id);
        }
    }

    function selectAll() {
        images.value.forEach(img => selected.value.add(img.id));
    }

    function clearSelection() {
        selected.value.clear();
    }

    function isSelected(id: number): boolean {
        return selected.value.has(id);
    }

    // ─── Actions ──────────────────────────────────────────────────────────────

    function setImages(data: App.ImageResource[]) {
        images.value = data;
    }

    function addImage(image: App.ImageResource) {
        images.value.unshift(image);
    }

    function removeImage(id: number) {
        images.value = images.value.filter(img => img.id !== id);
        selected.value.delete(id);
    }

    function updateImage(id: number, data: Partial<App.ImageResource>) {
        const index = images.value.findIndex(img => img.id === id);
        if (index !== -1) {
            images.value[index] = { ...images.value[index], ...data };
        }
    }

    function deleteSelected() {
        if (!hasSelection.value) return;

        const ids = Array.from(selected.value);
        loading.value = true;

        router.delete('/images/bulk', {
            data: { ids },
            preserveScroll: true,
            onSuccess: () => {
                ids.forEach(id => removeImage(id));
                loading.value = false;
            },
            onError: () => { loading.value = false; },
        });
    }

    function applyFilters() {
        router.get('/images', {
            search: searchQuery.value || undefined,
            sort:   sortBy.value,
        }, {
            preserveState: true,
            replace:       true,
        });
    }

    function resetFilters() {
        searchQuery.value = '';
        sortBy.value      = 'latest';
    }

    return {
        images,
        selected,
        searchQuery,
        sortBy,
        viewMode,
        loading,
        selectedCount,
        hasSelection,
        allSelected,
        filteredImages,
        totalSize,
        selectedImages,
        toggleSelect,
        selectAll,
        clearSelection,
        isSelected,
        setImages,
        addImage,
        removeImage,
        updateImage,
        deleteSelected,
        applyFilters,
        resetFilters,
    };
}
