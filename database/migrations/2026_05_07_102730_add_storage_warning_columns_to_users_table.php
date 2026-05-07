<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->timestamp('storage_warning_70_sent_at')->nullable()->after('storage_used');
            $table->timestamp('storage_warning_90_sent_at')->nullable()->after('storage_warning_70_sent_at');
        });
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn(['storage_warning_70_sent_at', 'storage_warning_90_sent_at']);
        });
    }
};