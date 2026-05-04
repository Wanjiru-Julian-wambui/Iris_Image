<?php

namespace App\Console\Commands;

use App\Models\Image;
use Illuminate\Console\Command;
use Illuminate\Support\Str;

class BackfillPublicTokens extends Command
{
    protected $signature = 'images:backfill-tokens';
    protected $description = 'Generate public tokens for images missing them';

    public function handle(): int
    {
        $images = Image::whereNull('public_token')
            ->orWhere('public_token', '')
            ->get();
        
        $count = 0;
        foreach ($images as $image) {
            $image->public_token = Str::random(8);
            $image->saveQuietly();
            $count++;
        }

        $this->info("Backfilled {$count} images with public tokens.");
        return 0;
    }
}