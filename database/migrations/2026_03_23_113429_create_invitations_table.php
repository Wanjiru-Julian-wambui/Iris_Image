<?php

use App\Models\User;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('invitations', function (Blueprint $table) {
            $table->id();

            $table->string('email')->index();
            $table->uuid('token')->unique();

            $table->foreignIdFor(User::class, 'invited_by')
                ->constrained('users')
                ->cascadeOnDelete();

            $table->foreignIdFor(User::class, 'accepted_by')
                ->nullable()
                ->constrained('users')
                ->nullOnDelete();

            $table->boolean('is_accepted')->default(false);
            $table->timestamp('expires_at')->index();
            $table->timestamp('accepted_at')->nullable();

            $table->timestamps();

            $table->index(['email', 'is_accepted']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('invitations');
    }
};