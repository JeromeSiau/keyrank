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
        Schema::create('review_insights', function (Blueprint $table) {
            $table->id();
            $table->foreignId('app_id')->constrained()->cascadeOnDelete();
            $table->enum('type', ['feature_request', 'bug_report']);
            $table->string('title', 255);
            $table->text('description')->nullable();
            $table->json('keywords');
            $table->integer('mention_count')->default(1);
            $table->enum('priority', ['low', 'medium', 'high', 'critical'])->default('medium');
            $table->enum('status', ['open', 'planned', 'in_progress', 'resolved', 'wont_fix'])->default('open');
            $table->string('platform', 20)->nullable();
            $table->string('affected_version', 50)->nullable();
            $table->date('first_mentioned_at');
            $table->date('last_mentioned_at');
            $table->timestamps();

            $table->index(['app_id', 'type', 'status']);
            $table->index(['app_id', 'type', 'priority']);
            $table->index(['app_id', 'type', 'mention_count']);
        });

        Schema::create('review_insight_mentions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('review_insight_id')->constrained()->cascadeOnDelete();
            $table->foreignId('app_review_id')->constrained()->cascadeOnDelete();
            $table->timestamps();

            $table->unique(['review_insight_id', 'app_review_id']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('review_insight_mentions');
        Schema::dropIfExists('review_insights');
    }
};
