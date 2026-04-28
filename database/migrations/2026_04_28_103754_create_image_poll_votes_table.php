<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('image_poll_votes', function (Blueprint $table) {
            $table->id();
            $table->foreignId('poll_id')->constrained('image_polls')->cascadeOnDelete();
            $table->enum('choice', ['a', 'b']);
            $table->foreignId('user_id')->nullable()->constrained()->nullOnDelete();
            $table->string('ip_address', 45)->nullable();
            $table->string('session_fingerprint', 64)->nullable();
            $table->timestamps();

            // Prevent duplicate votes
            $table->unique(['poll_id', 'user_id'], 'poll_vote_user_unique');
            $table->unique(['poll_id', 'ip_address', 'session_fingerprint'], 'poll_vote_guest_unique');
            $table->index(['poll_id', 'choice']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('image_poll_votes');
    }
};