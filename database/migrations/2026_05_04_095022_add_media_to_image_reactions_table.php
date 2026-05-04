<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('image_reactions', function (Blueprint $table) {
            // 'emoji' | 'gif' | 'sticker'
            $table->string('type')->default('emoji')->after('image_id');

            // For GIF/sticker reactions: the remote URL (Giphy, Tenor, or user upload URL)
            $table->string('media_url', 500)->nullable()->after('emoji');

            // Friendly label shown on hover (e.g. GIF title from Giphy/Tenor)
            $table->string('media_label', 100)->nullable()->after('media_url');

            // Source of the media: 'giphy' | 'tenor' | 'upload'
            $table->string('media_source', 20)->nullable()->after('media_label');

            // Make emoji nullable — it is only set for type='emoji'
            $table->string('emoji', 10)->nullable()->change();
        });
    }

    public function down(): void
    {
        Schema::table('image_reactions', function (Blueprint $table) {
            $table->dropColumn(['type', 'media_url', 'media_label', 'media_source']);
            $table->string('emoji', 10)->nullable(false)->change();
        });
    }
};