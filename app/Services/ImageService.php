<?php

namespace App\Services;

use App\Models\Image;
use App\Models\User;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;

class ImageService
{
    public function __construct(
        protected StorageService           $storageService,
        protected ExifService              $exifService,
        protected DuplicateDetectorService $duplicateDetector,
        protected CloudinaryService        $cloudinary,
    ) {}

    /**
     * Upload multiple files, skipping exact SHA-256 duplicates.
     *
     * @return array{ uploaded: Image[], skipped: array }
     */
    public function uploadMany(array|UploadedFile $files, User $user, array $options = []): array
    {
        if (!is_array($files)) {
            $files = [$files];
        }

        $uploaded = [];
        $skipped  = [];

        $checks = $this->duplicateDetector->checkBatch(
            array_values(array_filter($files, fn($f) => $f instanceof UploadedFile)),
            $user
        );

        foreach ($checks as $check) {
            if ($check['duplicate'] !== null) {
                $skipped[] = ['file' => $check['file'], 'existing' => $check['duplicate']];
                continue;
            }

            $image = $this->upload($check['file'], $user, $options, $check['hash']);
            if ($image) {
                $uploaded[] = $image;
            }
        }

        return compact('uploaded', 'skipped');
    }

    /**
     * Upload a single file, routing to Cloudinary or disk storage based on config.
     */
    public function upload(
        UploadedFile $file,
        User         $user,
        array        $options = [],
        ?string      $hash    = null,
    ): Image {
        $stripExif = $options['strip_exif'] ?? true;
        $isPrivate = $options['is_private'] ?? false;

        abort_unless(
            $this->storageService->hasSpace($user, $file->getSize()),
            403,
            'Storage limit reached.'
        );

        return DB::transaction(function () use ($file, $user, $stripExif, $isPrivate, $hash) {
            [$width, $height] = $this->getDimensions($file);

            $exifStripped = false;
            if ($stripExif) {
                $localPath = $file->getRealPath();
                if ($localPath && file_exists($localPath)) {
                    $exifStripped = $this->exifService->strip($localPath);
                }
            }

            $hash = $hash ?? hash_file('sha256', $file->getRealPath());

            // ── Route to Cloudinary or disk ───────────────────────────────────
            if ($this->cloudinary->isEnabled()) {
                return $this->uploadViaCloudinary(
                    $file, $user, $hash, $width, $height, $exifStripped, $isPrivate
                );
            }

            return $this->uploadViaDisk(
                $file, $user, $hash, $width, $height, $exifStripped, $isPrivate
            );
        });
    }

    private function uploadViaDisk(
        UploadedFile $file,
        User         $user,
        string       $hash,
        int          $width,
        int          $height,
        bool         $exifStripped,
        bool         $isPrivate,
    ): Image {
        $path = $this->storageService->store($file, $user);

        $disk = config('iris.storage_disk', 'public');
        if (!Storage::disk($disk)->exists($path)) {
            throw new \Exception("File missing after upload: {$path}");
        }

        $image = Image::create([
            'user_id'              => $user->id,
            'name'                 => pathinfo($file->getClientOriginalName(), PATHINFO_FILENAME),
            'original_name'        => $file->getClientOriginalName(),
            'path'                 => $path,
            'cloudinary_public_id' => null,
            'mime_type'            => $file->getMimeType(),
            'extension'            => strtolower($file->getClientOriginalExtension()),
            'size'                 => $file->getSize(),
            'width'                => $width,
            'height'               => $height,
            'hash'                 => $hash,
            'exif_stripped'        => $exifStripped,
            'is_private'           => $isPrivate,
        ]);

        $user->increment('storage_used', $file->getSize());

        return $image;
    }

    private function uploadViaCloudinary(
        UploadedFile $file,
        User         $user,
        string       $hash,
        int          $width,
        int          $height,
        bool         $exifStripped,
        bool         $isPrivate,
    ): Image {
        $result = $this->cloudinary->upload($file, $user);

        $image = Image::create([
            'user_id'              => $user->id,
            'name'                 => pathinfo($file->getClientOriginalName(), PATHINFO_FILENAME),
            'original_name'        => $file->getClientOriginalName(),
            'path'                 => $result['public_id'], // store public_id as path
            'cloudinary_public_id' => $result['public_id'],
            'mime_type'            => $file->getMimeType(),
            'extension'            => strtolower($file->getClientOriginalExtension()),
            'size'                 => $result['bytes'] ?? $file->getSize(),
            'width'                => $result['width']  ?? $width,
            'height'               => $result['height'] ?? $height,
            'hash'                 => $hash,
            'exif_stripped'        => $exifStripped,
            'is_private'           => $isPrivate,
        ]);

        $user->increment('storage_used', $image->size);

        return $image;
    }

    /**
     * Delete an image from storage and database.
     */
    public function delete(Image $image): void
    {
        if ($this->cloudinary->isEnabled() && $image->cloudinary_public_id) {
            $this->cloudinary->delete($image->cloudinary_public_id);
        } else {
            $disk = config('iris.storage_disk', 'public');
            Storage::disk($disk)->delete($image->path);
        }

        $image->user->decrement('storage_used', $image->size);
        $image->delete();
    }

    private function getDimensions(UploadedFile $file): array
    {
        try {
            [$w, $h] = getimagesize($file->getRealPath());
            return [$w ?? 0, $h ?? 0];
        } catch (\Throwable) {
            return [0, 0];
        }
    }
}