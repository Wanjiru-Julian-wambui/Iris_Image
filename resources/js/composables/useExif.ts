import { ref } from 'vue';

export type ExifData = {
    make?:         string;
    model?:        string;
    software?:     string;
    dateTime?:     string;
    width?:        number;
    height?:       number;
    orientation?:  number;
    iso?:          number;
    shutterSpeed?: string;
    aperture?:     string;
    focalLength?:  string;
    flash?:        string;
    gps?:          { lat: number; lng: number } | null;
    raw?:          Record<string, unknown>;
};

export function useExif() {
    const exif    = ref<ExifData | null>(null);
    const loading = ref(false);
    const error   = ref<string | null>(null);

    /**
     * Read EXIF data from a File object in the browser.
     * Requires the `exifr` library — install with:
     *   npm install exifr
     */
    async function readFromFile(file: File): Promise<ExifData | null> {
        loading.value = true;
        error.value   = null;

        try {
            // Dynamic import so exifr is only loaded when needed
            const exifr = await import('exifr').catch(() => null);

            if (!exifr) {
                error.value = 'EXIF reader not available. Install exifr: npm install exifr';
                return null;
            }

            const raw = await exifr.default.parse(file, {
                tiff: true,
                exif: true,
                gps:  true,
                ifd0: true,
            });

            if (!raw) {
                exif.value = null;
                return null;
            }

            const result: ExifData = {
                make:         raw.Make,
                model:        raw.Model,
                software:     raw.Software,
                dateTime:     raw.DateTimeOriginal?.toString() ?? raw.DateTime?.toString(),
                width:        raw.ImageWidth  ?? raw.ExifImageWidth,
                height:       raw.ImageHeight ?? raw.ExifImageHeight,
                orientation:  raw.Orientation,
                iso:          raw.ISO,
                shutterSpeed: raw.ExposureTime ? `1/${Math.round(1 / raw.ExposureTime)}s` : undefined,
                aperture:     raw.FNumber     ? `f/${raw.FNumber}`   : undefined,
                focalLength:  raw.FocalLength ? `${raw.FocalLength}mm` : undefined,
                flash:        raw.Flash !== undefined ? (raw.Flash ? 'On' : 'Off') : undefined,
                gps:          raw.latitude && raw.longitude
                    ? { lat: raw.latitude, lng: raw.longitude }
                    : null,
                raw,
            };

            exif.value = result;
            return result;
        } catch (e) {
            error.value = 'Failed to read EXIF data.';
            return null;
        } finally {
            loading.value = false;
        }
    }

    /**
     * Check if a file likely contains EXIF data.
     * Only JPEG and TIFF files carry EXIF.
     */
    function fileHasExif(file: File): boolean {
        return ['image/jpeg', 'image/jpg', 'image/tiff'].includes(file.type);
    }

    /**
     * Format a GPS coordinate for display.
     */
    function formatGps(gps: { lat: number; lng: number }): string {
        const latDir = gps.lat >= 0 ? 'N' : 'S';
        const lngDir = gps.lng >= 0 ? 'E' : 'W';
        return `${Math.abs(gps.lat).toFixed(5)}° ${latDir}, ${Math.abs(gps.lng).toFixed(5)}° ${lngDir}`;
    }

    function clear() {
        exif.value  = null;
        error.value = null;
    }

    return {
        exif,
        loading,
        error,
        readFromFile,
        fileHasExif,
        formatGps,
        clear,
    };
}
