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
        protected StorageService $storageService,
        protected ExifService    $exifService,
    ) {}

    public function uploadMany(array|UploadedFile $files, User $user, array $options = []): array
    {
        if (!is_array($files)) {
            $files = [$files];
        }

        $uploaded = [];
        foreach ($files as $file) {
            if ($file instanceof UploadedFile) {
                $uploaded[] = $this->upload($file, $user, $options);
            }
        }

        return $uploaded;
    }

    public function upload(UploadedFile $file, User $user, array $options = []): Image
    {
        $stripExif = $options['strip_exif'] ?? true;
        $isPrivate = $options['is_private'] ?? false;

        abort_unless(
            $this->storageService->hasSpace($user, $file->getSize()),
            403,
            'Storage limit reached.'
        );

        return DB::transaction(function () use ($file, $user, $stripExif, $isPrivate) {
            // Get dimensions BEFORE upload while the file is still local
            [$width, $height] = $this->getDimensions($file);

            // Strip EXIF on the local temp file BEFORE uploading to S3
            $exifStripped = false;
            if ($stripExif) {
                $localPath = $file->getRealPath();
                if ($localPath && file_exists($localPath)) {
                    $exifStripped = $this->exifService->strip($localPath);
                }
            }

            // Store file (uploads to configured disk — s3 on production)
            $path = $this->storageService->store($file, $user);

            // Verify upload succeeded using Storage facade (works with S3)
            $disk = config('filesystems.default');
            if (!Storage::disk($disk)->exists($path)) {
                throw new \Exception("File missing after upload: {$path}");
            }

            // Save to DB
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

            $user->increment('storage_used', $file->getSize());

            return $image;
        });
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