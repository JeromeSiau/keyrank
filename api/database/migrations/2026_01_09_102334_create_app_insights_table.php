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
        Schema::create('app_insights', function (Blueprint $table) {
            $table->id();
            $table->foreignId('app_id')->constrained()->onDelete('cascade');
            $table->enum('analysis_type', ['full', 'refresh'])->default('full');
            $table->integer('reviews_count');
            $table->json('countries');
            $table->date('period_start');
            $table->date('period_end');
            $table->json('category_scores');
            $table->json('category_summaries');
            $table->json('emergent_themes');
            $table->json('overall_strengths');
            $table->json('overall_weaknesses');
            $table->json('opportunities')->nullable();
            $table->text('raw_llm_response')->nullable();
            $table->timestamps();
            $table->index(['app_id', 'created_at']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('app_insights');
    }
};
