import { ref, computed } from 'vue';
import { router } from '@inertiajs/vue3';
import { v4 as uuid } from 'uuid';

export type UploadFile = {
    id:        string;
    file:      File;
    preview:   string;
    progress:  number;
    status:    'pending' | 'uploading' | 'done' | 'error';
    error?:    string;
    isPrivate: boolean;
    stripExif: boolean;
};

const ALLOWED_TYPES = [
    'image/jpeg', 'image/png', 'image/gif',
    'image/webp', 'image/svg+xml', 'image/tiff',
];
const MAX_SIZE  = 100 * 1024 * 1024; // 100 MB
const MAX_FILES = 20;

export function useUpload() {
    const files      = ref<UploadFile[]>([]);
    const uploading  = ref(false);
    const errors     = ref<string[]>([]);

    const hasFiles    = computed(() => files.value.length > 0);
    const pendingCount = computed(() => files.value.filter(f => f.status === 'pending').length);
    const doneCount    = computed(() => files.value.filter(f => f.status === 'done').length);
    const errorCount   = computed(() => files.value.filter(f => f.status === 'error').length);
    const allDone      = computed(() => files.value.length > 0 && doneCount.value === files.value.length);

    function addFiles(rawFiles: File[], defaults?: { stripExif?: boolean; isPrivate?: boolean }) {
        errors.value = [];

        for (const file of rawFiles) {
            if (files.value.length >= MAX_FILES) {
                errors.value.push(`Maximum ${MAX_FILES} files per upload.`);
                break;
            }
            if (!ALLOWED_TYPES.includes(file.type)) {
                errors.value.push(`${file.name}: unsupported file type.`);
                continue;
            }
            if (file.size > MAX_SIZE) {
                errors.value.push(`${file.name}: exceeds 100 MB limit.`);
                continue;
            }

            const preview = URL.createObjectURL(file);

            files.value.push({
                id:        uuid(),
                file,
                preview,
                progress:  0,
                status:    'pending',
                isPrivate: defaults?.isPrivate ?? false,
                stripExif: defaults?.stripExif ?? true,
            });
        }
    }

    function removeFile(id: string) {
        const item = files.value.find(f => f.id === id);
        if (item) URL.revokeObjectURL(item.preview);
        files.value = files.value.filter(f => f.id !== id);
    }

    function togglePrivate(id: string) {
        const item = files.value.find(f => f.id === id);
        if (item) item.isPrivate = !item.isPrivate;
    }

    function toggleStripExif(id: string) {
        const item = files.value.find(f => f.id === id);
        if (item) item.stripExif = !item.stripExif;
    }

    function setAllPrivate(value: boolean) {
        files.value.forEach(f => { f.isPrivate = value; });
    }

    function setAllStripExif(value: boolean) {
        files.value.forEach(f => { f.stripExif = value; });
    }

    async function upload() {
        if (!hasFiles.value || uploading.value) return;

        uploading.value = true;
        errors.value    = [];

        const formData = new FormData();

        files.value.forEach((item, index) => {
            formData.append(`images[${index}]`, item.file);
            item.status   = 'uploading';
            item.progress = 0;
        });

        // Use the first file's settings as global (or you can make per-file)
        const first = files.value[0];
        formData.append('is_private',  first?.isPrivate ? '1' : '0');
        formData.append('strip_exif',  first?.stripExif  ? '1' : '0');

        router.post('/images', formData, {
            forceFormData: true,
            onProgress: (event) => {
                if (event?.percentage !== undefined) {
                    files.value.forEach(f => {
                        if (f.status === 'uploading') {
                            f.progress = event.percentage ?? 0;
                        }
                    });
                }
            },
            onSuccess: () => {
                files.value.forEach(f => {
                    f.status   = 'done';
                    f.progress = 100;
                });
                uploading.value = false;
            },
            onError: (errs) => {
                files.value.forEach(f => {
                    f.status = 'error';
                    f.error  = 'Upload failed.';
                });
                errors.value    = Object.values(errs).flat() as string[];
                uploading.value = false;
            },
            onFinish: () => {
                uploading.value = false;
            },
        });
    }

    function reset() {
        files.value.forEach(f => URL.revokeObjectURL(f.preview));
        files.value  = [];
        errors.value = [];
        uploading.value = false;
    }

    return {
        files,
        uploading,
        errors,
        hasFiles,
        pendingCount,
        doneCount,
        errorCount,
        allDone,
        addFiles,
        removeFile,
        togglePrivate,
        toggleStripExif,
        setAllPrivate,
        setAllStripExif,
        upload,
        reset,
    };
}
