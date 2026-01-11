<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('app_voice_settings', function (Blueprint $table) {
            $table->id();
            $table->foreignId('app_id')->constrained()->cascadeOnDelete();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->text('tone_description')->nullable();
            $table->string('default_language', 10)->default('auto');
            $table->string('signature')->nullable();
            $table->timestamps();

            $table->unique(['app_id', 'user_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('app_voice_settings');
    }
};
