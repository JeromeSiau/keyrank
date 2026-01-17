<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('keyword_suggestions', function (Blueprint $table) {
            // Category for UI grouping: high_opportunity, competitor, long_tail, trending, related
            $table->string('category')->default('high_opportunity')->after('source');

            // Popularity score from ASA API (0-100, null if unknown)
            $table->unsignedTinyInteger('popularity')->nullable()->after('difficulty_label');

            // Why this keyword is suggested (AI-generated explanation)
            $table->string('reason')->nullable()->after('popularity');

            // Base keyword for long-tail/related (e.g., "budget tracker" for "budget tracker for couples")
            $table->string('based_on')->nullable()->after('reason');

            // Competitor app name for competitor category
            $table->string('competitor_name')->nullable()->after('based_on');

            // Index for category filtering
            $table->index(['app_id', 'country', 'category']);
        });
    }

    public function down(): void
    {
        Schema::table('keyword_suggestions', function (Blueprint $table) {
            $table->dropIndex(['app_id', 'country', 'category']);
            $table->dropColumn(['category', 'popularity', 'reason', 'based_on', 'competitor_name']);
        });
    }
};
