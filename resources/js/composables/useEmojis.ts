import { ref, computed } from 'vue';

interface EmojiItem {
    emoji: string;
    name: string;
    category: string;
    group: string;
    keywords: string[];
}

interface EmojiCategory {
    label: string;
    emojis: { emoji: string; keywords: string }[];
}

export function useEmojis() {
    const emojis = ref<EmojiItem[]>([]);
    const loading = ref(false);
    const error = ref<string | null>(null);
    const fetched = ref(false);

    const categories = computed<EmojiCategory[]>(() => {
        const grouped = new Map<string, EmojiItem[]>();
        
        for (const item of emojis.value) {
            const cat = item.category || item.group || 'Other';
            if (!grouped.has(cat)) grouped.set(cat, []);
            grouped.get(cat)!.push(item);
        }

        return Array.from(grouped.entries()).map(([label, items]) => ({
            label,
            emojis: items.map(e => ({
                emoji: e.emoji,
                keywords: e.keywords.join(' '),
            })),
        }));
    });

    function searchEmojis(query: string): { emoji: string; keywords: string }[] {
        const q = query.toLowerCase().trim();
        if (!q) return [];

        return emojis.value
            .filter(e => 
                e.name.toLowerCase().includes(q) ||
                e.category.toLowerCase().includes(q) ||
                e.group.toLowerCase().includes(q) ||
                e.keywords.some(k => k.toLowerCase().includes(q))
            )
            .map(e => ({
                emoji: e.emoji,
                keywords: e.keywords.join(' '),
            }));
    }

    async function fetchEmojis(): Promise<void> {
        if (fetched.value && emojis.value.length > 0) return;
        
        loading.value = true;
        error.value = null;

        try {
            const response = await fetch('/api/emojis', {
                headers: {
                    'Accept': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest',
                },
            });

            if (!response.ok) {
                throw new Error(`HTTP ${response.status}: Failed to fetch emojis`);
            }

            const data = await response.json();
            
            if (!Array.isArray(data)) {
                throw new Error('Invalid emoji data format');
            }

            emojis.value = data;
            fetched.value = true;
        } catch (err) {
            error.value = err instanceof Error ? err.message : 'Failed to load emojis';
            emojis.value = [];
        } finally {
            loading.value = false;
        }
    }

    return {
        emojis,
        categories,
        loading,
        error,
        fetched,
        fetchEmojis,
        searchEmojis,
    };
}