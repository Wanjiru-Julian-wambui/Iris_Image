<?php

namespace App\Services;

use App\Models\Image;
use App\Models\User;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;

class ImageService
{
    public function __construct(
        protected StorageService $storageService,
        protected ExifService    $exifService,
    ) {}

    /**
     * Upload multiple images for a user.
     */
    public function uploadMany(array $files, User $user, array $options = []): array
    {
        $uploaded = [];

        foreach ($files as $file) {
            $uploaded[] = $this->upload($file, $user, $options);
        }

        return $uploaded;
    }

    /**
     * Upload a single image.
     */
    public function upload(UploadedFile $file, User $user, array $options = []): Image
    {
        $stripExif = $options['strip_exif'] ?? config('iris.strip_exif', true);
        $isPrivate = $options['is_private'] ?? false;

        abort_unless(
            $this->storageService->hasSpace($user, $file->getSize()),
            403,
            'You have reached your storage limit.'
        );

        return DB::transaction(function () use ($file, $user, $stripExif, $isPrivate) {
            // Store the file
            $path = $this->storageService->store($file, $user);

            // Get image dimensions
            [$width, $height] = $this->getDimensions($file);

            // Strip EXIF if requested
            $exifStripped = false;
            if ($stripExif) {
                $fullPath     = storage_path('app/public/' . $path);
                $exifStripped = $this->exifService->strip($fullPath);
            }

            // Create the image record
            $image = Image::create([
                'user_id'       => $user->id,
                'name'          => pathinfo($file->getClientOriginalName(), PATHINFO_FILENAME),
                'original_name' => $file->getClientOriginalName(),
                'path'          => $path,
                'mime_type'     => $file->getMimeType(),
                'extension'     => strtolower($file->getClientOriginalExtension()),
                'size'          => $file->getSize(),
                'width'         => $width,
                'height'        => $height,
                'exif_stripped' => $exifStripped,
                'is_private'    => $isPrivate,
            ]);

            // Update user storage usage
            $user->increment('storage_used', $file->getSize());

            return $image;
        });
    }

    /**
     * Delete an image and its files.
     */
    public function delete(Image $image): bool
    {
        return DB::transaction(function () use ($image) {
            $image->sharedLinks()->delete();
            $image->delete(); // boot method handles file + storage decrement
            return true;
        });
    }

    /**
     * Get image dimensions from uploaded file.
     */
    private function getDimensions(UploadedFile $file): array
    {
        try {
            if (in_array($file->getMimeType(), ['image/jpeg', 'image/png', 'image/gif', 'image/webp'])) {
                [$width, $height] = getimagesize($file->getRealPath());
                return [$width ?? 0, $height ?? 0];
            }
        } catch (\Throwable) {}

        return [0, 0];
    }
}