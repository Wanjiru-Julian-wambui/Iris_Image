<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('image_polls', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->string('question');
            $table->foreignId('image_a_id')->constrained('images')->cascadeOnDelete();
            $table->foreignId('image_b_id')->constrained('images')->cascadeOnDelete();
            $table->string('public_token', 16)->unique();
            $table->timestamps();

            $table->index('public_token');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('image_polls');
    }
};