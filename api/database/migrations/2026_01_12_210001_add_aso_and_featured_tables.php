<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // ASO Metadata snapshots - track ASO-relevant fields over time
        Schema::create('app_aso_snapshots', function (Blueprint $table) {
            $table->id();
            $table->foreignId('app_id')->constrained()->onDelete('cascade');
            $table->string('country', 5);

            // Core ASO fields
            $table->string('title')->nullable();
            $table->string('subtitle')->nullable(); // iOS only
            $table->text('description')->nullable();
            $table->text('whats_new')->nullable(); // Release notes
            $table->string('promotional_text', 500)->nullable(); // iOS only

            // Calculated metrics
            $table->unsignedSmallInteger('title_length')->nullable();
            $table->unsignedSmallInteger('subtitle_length')->nullable();
            $table->unsignedInteger('description_length')->nullable();
            $table->json('keyword_density')->nullable(); // Top keywords in metadata

            $table->timestamp('snapshot_at');
            $table->timestamps();

            $table->unique(['app_id', 'country', 'snapshot_at'], 'aso_snapshot_unique');
            $table->index(['app_id', 'country']);
        });

        // Featured apps placements
        Schema::create('featured_placements', function (Blueprint $table) {
            $table->id();
            $table->foreignId('app_id')->constrained()->onDelete('cascade');
            $table->string('platform', 10);
            $table->string('country', 5);
            $table->string('placement_type', 50); // today_tab, apps_tab, games_tab, story, collection, banner
            $table->string('placement_id')->nullable();
            $table->string('placement_title')->nullable();
            $table->unsignedSmallInteger('position')->nullable();
            $table->date('first_seen_at');
            $table->date('last_seen_at');
            $table->timestamps();

            $table->index(['app_id', 'platform', 'country']);
            $table->index(['placement_type', 'country', 'last_seen_at']);
        });

        // Category rankings for tracked apps
        Schema::create('app_category_rankings', function (Blueprint $table) {
            $table->id();
            $table->foreignId('app_id')->constrained()->onDelete('cascade');
            $table->string('country', 5);
            $table->string('collection', 20); // top_free, top_paid, top_grossing
            $table->unsignedSmallInteger('position')->nullable(); // null = not in top 200
            $table->date('recorded_at');
            $table->timestamps();

            $table->unique(['app_id', 'country', 'collection', 'recorded_at'], 'category_ranking_unique');
            $table->index(['app_id', 'recorded_at']);
            $table->index(['app_id', 'country', 'collection', 'recorded_at'], 'category_ranking_lookup');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('app_aso_snapshots');
        Schema::dropIfExists('featured_placements');
        Schema::dropIfExists('app_category_rankings');
    }
};
