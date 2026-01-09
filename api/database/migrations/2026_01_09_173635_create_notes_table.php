<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('notes', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->foreignId('tracked_keyword_id')->nullable()->constrained('tracked_keywords')->cascadeOnDelete();
            $table->foreignId('app_insight_id')->nullable()->constrained('app_insights')->cascadeOnDelete();
            $table->text('content');
            $table->timestamps();

            $table->unique(['user_id', 'tracked_keyword_id']);
            $table->unique(['user_id', 'app_insight_id']);
            $table->index('user_id');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('notes');
    }
};
