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
        Schema::create('actionable_insights', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->foreignId('app_id')->nullable()->constrained()->cascadeOnDelete();
            $table->enum('type', [
                'opportunity',      // Keyword trending, new market
                'warning',          // Ranking drop, rating decline
                'win',              // Milestone reached, improvement
                'competitor_move',  // Competitor action detected
                'theme',            // Pattern in reviews
                'suggestion',       // AI recommendation
            ]);
            $table->enum('priority', ['high', 'medium', 'low'])->default('medium');
            $table->string('title', 255);
            $table->text('description');
            $table->string('action_text', 255)->nullable();
            $table->string('action_url', 500)->nullable();
            $table->json('data_refs')->nullable(); // References to related data
            $table->boolean('is_read')->default(false);
            $table->boolean('is_dismissed')->default(false);
            $table->timestamp('generated_at')->useCurrent();
            $table->timestamp('expires_at')->nullable();
            $table->timestamps();

            // Indexes for common query patterns
            $table->index(['user_id', 'is_read', 'is_dismissed', 'generated_at'], 'insights_user_status_idx');
            $table->index(['app_id', 'type', 'generated_at'], 'insights_app_type_idx');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('actionable_insights');
    }
};
