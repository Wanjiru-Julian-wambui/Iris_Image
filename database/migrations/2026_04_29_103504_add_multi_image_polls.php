<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // New pivot table: poll <-> images (for multi polls)
        Schema::create('image_poll_items', function (Blueprint $table) {
            $table->id();
            $table->foreignId('image_poll_id')->constrained()->cascadeOnDelete();
            $table->foreignId('image_id')->constrained()->cascadeOnDelete();
            $table->unsignedSmallInteger('sort_order')->default(0);
            $table->timestamps();

            $table->unique(['image_poll_id', 'image_id']);
        });

        // Add type column to existing polls table
        Schema::table('image_polls', function (Blueprint $table) {
            // 'ab' = classic A/B, 'multi' = pick multiple favorites
            $table->string('type')->default('ab')->after('question');
            // For multi polls, how many choices can a voter pick (null = unlimited)
            $table->unsignedSmallInteger('max_choices')->nullable()->after('type');
        });

        // Add support for multi-choice votes (choice becomes nullable, use pivot for multi)
        Schema::create('image_poll_multi_votes', function (Blueprint $table) {
            $table->id();
            $table->foreignId('image_poll_id')->constrained()->cascadeOnDelete();
            $table->foreignId('image_id')->constrained()->cascadeOnDelete();
            $table->foreignId('user_id')->nullable()->constrained()->nullOnDelete();
            $table->string('ip_address', 45)->nullable();
            $table->string('session_fingerprint')->nullable();
            $table->timestamps();

            $table->index(['image_poll_id', 'ip_address', 'session_fingerprint']);
            $table->index(['image_poll_id', 'user_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('image_poll_multi_votes');
        Schema::table('image_polls', function (Blueprint $table) {
            $table->dropColumn(['type', 'max_choices']);
        });
        Schema::dropIfExists('image_poll_items');
    }
};