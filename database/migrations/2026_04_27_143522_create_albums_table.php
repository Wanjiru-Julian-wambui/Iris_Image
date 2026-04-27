<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('albums', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->string('name', 120);
            $table->string('slug', 130)->unique();
            $table->text('description')->nullable();
            $table->string('cover_image_id')->nullable();
            $table->boolean('is_public')->default(false);
            $table->string('password')->nullable();
            $table->string('public_token', 16)->unique();
            $table->timestamps();

            $table->index(['user_id', 'created_at']);
            $table->index(['public_token', 'is_public']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('albums');
    }
};