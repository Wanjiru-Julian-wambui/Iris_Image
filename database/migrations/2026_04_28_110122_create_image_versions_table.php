<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('image_versions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('image_id')->constrained()->cascadeOnDelete();
            $table->string('path');
            $table->string('url');
            $table->string('thumbnail_path')->nullable();
            $table->string('thumbnail_url')->nullable();
            $table->unsignedBigInteger('size');
            $table->unsignedInteger('width')->default(0);
            $table->unsignedInteger('height')->default(0);
            $table->unsignedInteger('version_number');
            $table->string('label')->nullable();
            $table->text('change_note')->nullable();
            $table->timestamps();

            $table->unique(['image_id', 'version_number']);
            $table->index(['image_id', 'created_at']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('image_versions');
    }
};