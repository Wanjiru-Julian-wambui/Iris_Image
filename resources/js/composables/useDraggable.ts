import { ref, type Ref } from 'vue';

interface DraggableItem {
    id: number;
    [key: string]: any;
}

interface UseDraggableOptions {
    onReorder?: (orderedIds: number[]) => void;
}

export function useDraggable<T extends DraggableItem>(
    containerRef: Ref<HTMLElement | null>,
    itemsRef: Ref<T[]>,
    options: UseDraggableOptions = {}
) {
    const draggedIndex = ref<number | null>(null);
    const dragOverIndex = ref<number | null>(null);

    function handleDragStart(e: DragEvent, index: number) {
        draggedIndex.value = index;
        if (e.dataTransfer) {
            e.dataTransfer.effectAllowed = 'move';
            e.dataTransfer.setData('text/plain', String(index));
        }
    }

    function handleDragOver(e: DragEvent, index: number) {
        e.preventDefault();
        dragOverIndex.value = index;
    }

    function handleDragLeave() {
        dragOverIndex.value = null;
    }

    function handleDrop(e: DragEvent, dropIndex: number) {
        e.preventDefault();
        const fromIndex = draggedIndex.value;
        
        if (fromIndex === null || fromIndex === dropIndex) {
            draggedIndex.value = null;
            dragOverIndex.value = null;
            return;
        }

        const items = [...itemsRef.value];
        const [moved] = items.splice(fromIndex, 1);
        items.splice(dropIndex, 0, moved);

        itemsRef.value = items;
        
        if (options.onReorder) {
            options.onReorder(items.map(i => i.id));
        }

        draggedIndex.value = null;
        dragOverIndex.value = null;
    }

    function handleDragEnd() {
        draggedIndex.value = null;
        dragOverIndex.value = null;
    }

    return {
        draggedIndex,
        dragOverIndex,
        handleDragStart,
        handleDragOver,
        handleDragLeave,
        handleDrop,
        handleDragEnd,
    };
}