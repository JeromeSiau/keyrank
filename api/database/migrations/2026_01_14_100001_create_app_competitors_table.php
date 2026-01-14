<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('app_competitors', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->foreignId('owner_app_id')->constrained('apps')->onDelete('cascade');
            $table->foreignId('competitor_app_id')->constrained('apps')->onDelete('cascade');
            $table->enum('source', ['manual', 'auto_discovered', 'keyword_overlap'])->default('manual');
            $table->timestamp('created_at')->useCurrent();

            $table->unique(['user_id', 'owner_app_id', 'competitor_app_id'], 'unique_competitor');
            $table->index(['user_id', 'owner_app_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('app_competitors');
    }
};
