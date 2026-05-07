<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('email_templates', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->nullable()->constrained()->cascadeOnDelete();
            $table->string('key');          // invite | digest | quota_warning
            $table->string('subject');
            $table->longText('html_body');
            $table->longText('text_body');
            $table->timestamps();

            // Each user (or the system) can have at most one template per key
            $table->unique(['user_id', 'key']);
            $table->index('key');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('email_templates');
    }
};