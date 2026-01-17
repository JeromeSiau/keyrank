<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('tracked_keywords', function (Blueprint $table) {
            // Add performance indexes for team-based queries
            if (!$this->hasIndex('tracked_keywords', 'tracked_team_app')) {
                $table->index(['team_id', 'app_id'], 'tracked_team_app');
            }
            if (!$this->hasIndex('tracked_keywords', 'tracked_team_keyword')) {
                $table->index(['team_id', 'keyword_id'], 'tracked_team_keyword');
            }
        });
    }

    public function down(): void
    {
        Schema::table('tracked_keywords', function (Blueprint $table) {
            $table->dropIndex('tracked_team_app');
            $table->dropIndex('tracked_team_keyword');
        });
    }

    private function hasIndex(string $table, string $indexName): bool
    {
        $indexes = DB::select("SHOW INDEX FROM `{$table}` WHERE Key_name = ?", [$indexName]);
        return count($indexes) > 0;
    }
};
