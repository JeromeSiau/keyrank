<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('tracked_keywords', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->foreignId('app_id')->constrained()->cascadeOnDelete();
            $table->foreignId('keyword_id')->constrained()->cascadeOnDelete();
            $table->timestamp('created_at')->nullable();

            $table->unique(['app_id', 'keyword_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('tracked_keywords');
    }
};
