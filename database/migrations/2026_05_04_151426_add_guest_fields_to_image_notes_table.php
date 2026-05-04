<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('image_notes', function (Blueprint $table) {
            $table->string('ip_address', 45)->nullable()->after('user_id');
            $table->string('session_fingerprint', 64)->nullable()->after('ip_address');
            
            // Make user_id nullable for guest notes
            $table->unsignedBigInteger('user_id')->nullable()->change();
        });
    }

    public function down(): void
    {
        Schema::table('image_notes', function (Blueprint $table) {
            $table->dropColumn(['ip_address', 'session_fingerprint']);
            $table->unsignedBigInteger('user_id')->nullable(false)->change();
        });
    }
};