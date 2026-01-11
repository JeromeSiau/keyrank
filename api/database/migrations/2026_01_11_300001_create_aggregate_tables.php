<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('app_ranking_aggregates', function (Blueprint $table) {
            $table->id();
            $table->foreignId('app_id')->constrained()->cascadeOnDelete();
            $table->foreignId('keyword_id')->constrained()->cascadeOnDelete();
            $table->enum('period_type', ['weekly', 'monthly']);
            $table->date('period_start');
            $table->decimal('avg_position', 5, 2);
            $table->unsignedInteger('min_position');
            $table->unsignedInteger('max_position');
            $table->unsignedTinyInteger('data_points');

            $table->unique(['app_id', 'keyword_id', 'period_type', 'period_start'], 'ranking_agg_unique');
            $table->index(['period_type', 'period_start']);
        });

        Schema::create('keyword_popularity_aggregates', function (Blueprint $table) {
            $table->id();
            $table->foreignId('keyword_id')->constrained()->cascadeOnDelete();
            $table->enum('period_type', ['weekly', 'monthly']);
            $table->date('period_start');
            $table->decimal('avg_popularity', 5, 2);
            $table->unsignedInteger('min_popularity');
            $table->unsignedInteger('max_popularity');
            $table->unsignedTinyInteger('data_points');

            $table->unique(['keyword_id', 'period_type', 'period_start'], 'popularity_agg_unique');
            $table->index(['period_type', 'period_start']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('keyword_popularity_aggregates');
        Schema::dropIfExists('app_ranking_aggregates');
    }
};
