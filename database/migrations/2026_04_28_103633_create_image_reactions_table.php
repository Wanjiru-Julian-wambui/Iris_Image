<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('image_reactions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('image_id')->constrained()->cascadeOnDelete();
            $table->foreignId('user_id')->nullable()->constrained()->nullOnDelete();
            $table->string('emoji', 10);
            $table->string('ip_address', 45)->nullable();
            $table->string('session_fingerprint', 64)->nullable();
            $table->timestamps();

            $table->unique(['image_id', 'user_id', 'emoji'], 'reaction_user_unique');
            $table->unique(['image_id', 'ip_address', 'session_fingerprint', 'emoji'], 'reaction_guest_unique');
            $table->index(['image_id', 'emoji']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('image_reactions');
    }
};