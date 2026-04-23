import { ref } from 'vue';

export type CompressionOptions = {
    enabled:   boolean;
    quality:   number;   // 0.1 – 1.0
    maxWidth:  number;   // 0 = no resize
    maxHeight: number;   // 0 = no resize
};

export type CompressionResult = {
    file:           File;
    originalSize:   number;
    compressedSize: number;
    savedPercent:   number;
    wasCompressed:  boolean;
};

const COMPRESSIBLE = ['image/jpeg', 'image/jpg', 'image/webp', 'image/png'];

export function useCompression() {
    const compressing = ref(false);

    function canCompress(file: File): boolean {
        return COMPRESSIBLE.includes(file.type);
    }

    function compress(file: File, options: CompressionOptions): Promise<CompressionResult> {
        const originalSize = file.size;

        if (!options.enabled || !canCompress(file)) {
            return Promise.resolve({
                file, originalSize,
                compressedSize: originalSize,
                savedPercent: 0,
                wasCompressed: false,
            });
        }

        return new Promise((resolve) => {
            const img = new Image();
            const url = URL.createObjectURL(file);

            img.onload = () => {
                URL.revokeObjectURL(url);

                let { width, height } = img;

                if (options.maxWidth > 0 && width > options.maxWidth) {
                    height = Math.round((height * options.maxWidth) / width);
                    width  = options.maxWidth;
                }
                if (options.maxHeight > 0 && height > options.maxHeight) {
                    width  = Math.round((width * options.maxHeight) / height);
                    height = options.maxHeight;
                }

                const canvas  = document.createElement('canvas');
                canvas.width  = width;
                canvas.height = height;
                const ctx     = canvas.getContext('2d')!;

                if (file.type === 'image/jpeg' || file.type === 'image/jpg') {
                    ctx.fillStyle = '#ffffff';
                    ctx.fillRect(0, 0, width, height);
                }

                ctx.drawImage(img, 0, 0, width, height);

                const outputType = file.type === 'image/png' ? 'image/png' : 'image/jpeg';

                canvas.toBlob((blob) => {
                    if (!blob || blob.size >= originalSize) {
                        resolve({ file, originalSize, compressedSize: originalSize, savedPercent: 0, wasCompressed: false });
                        return;
                    }

                    const ext  = outputType === 'image/png' ? 'png' : 'jpg';
                    const name = file.name.replace(/\.[^.]+$/, `.${ext}`);
                    const out  = new File([blob], name, { type: outputType });

                    resolve({
                        file:           out,
                        originalSize,
                        compressedSize: blob.size,
                        savedPercent:   Math.round((1 - blob.size / originalSize) * 100),
                        wasCompressed:  true,
                    });
                }, outputType, options.quality);
            };

            img.onerror = () => {
                URL.revokeObjectURL(url);
                resolve({ file, originalSize, compressedSize: originalSize, savedPercent: 0, wasCompressed: false });
            };

            img.src = url;
        });
    }

    async function compressAll(
        files: File[],
        options: CompressionOptions,
        onProgress?: (done: number, total: number) => void,
    ): Promise<CompressionResult[]> {
        compressing.value = true;
        const results: CompressionResult[] = [];

        for (let i = 0; i < files.length; i++) {
            results.push(await compress(files[i], options));
            onProgress?.(i + 1, files.length);
        }

        compressing.value = false;
        return results;
    }

    function formatSize(bytes: number): string {
        if (bytes >= 1048576) return (bytes / 1048576).toFixed(1) + ' MB';
        if (bytes >= 1024)    return (bytes / 1024).toFixed(0) + ' KB';
        return bytes + ' B';
    }

    return { compressing, canCompress, compress, compressAll, formatSize };
}