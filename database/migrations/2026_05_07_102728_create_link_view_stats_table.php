<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('link_view_stats', function (Blueprint $table) {
            $table->id();
            $table->foreignId('shared_link_id')->constrained()->cascadeOnDelete();
            $table->string('country', 2)->nullable();
            $table->timestamp('viewed_at');

            $table->index(['shared_link_id', 'viewed_at']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('link_view_stats');
    }
};