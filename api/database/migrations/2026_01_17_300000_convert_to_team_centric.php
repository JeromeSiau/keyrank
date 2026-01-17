<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        // 1. Drop user_apps table (replaced by team_apps)
        Schema::dropIfExists('user_apps');

        // 2. tracked_keywords: add team_id, drop user_id
        if (!Schema::hasColumn('tracked_keywords', 'team_id')) {
            Schema::table('tracked_keywords', function (Blueprint $table) {
                $table->foreignId('team_id')->nullable()->after('id')->constrained()->cascadeOnDelete();
            });
        }
        if (Schema::hasColumn('tracked_keywords', 'user_id')) {
            $this->dropColumnWithDependencies('tracked_keywords', 'user_id');
        }
        if (!$this->hasIndex('tracked_keywords', 'tracked_keywords_team_app_keyword_unique')) {
            Schema::table('tracked_keywords', function (Blueprint $table) {
                $table->unique(['team_id', 'app_id', 'keyword_id'], 'tracked_keywords_team_app_keyword_unique');
            });
        }

        // 3. app_competitors: add team_id, drop user_id
        if (!Schema::hasColumn('app_competitors', 'team_id')) {
            Schema::table('app_competitors', function (Blueprint $table) {
                $table->foreignId('team_id')->nullable()->after('id')->constrained()->cascadeOnDelete();
            });
        }
        if (Schema::hasColumn('app_competitors', 'user_id')) {
            $this->dropColumnWithDependencies('app_competitors', 'user_id');
        }
        if (!$this->hasIndex('app_competitors', 'app_competitors_team_unique')) {
            Schema::table('app_competitors', function (Blueprint $table) {
                $table->unique(['team_id', 'owner_app_id', 'competitor_app_id'], 'app_competitors_team_unique');
            });
        }

        // 4. alert_rules: add team_id, drop user_id
        if (!Schema::hasColumn('alert_rules', 'team_id')) {
            Schema::table('alert_rules', function (Blueprint $table) {
                $table->foreignId('team_id')->nullable()->after('id')->constrained()->cascadeOnDelete();
            });
        }
        if (Schema::hasColumn('alert_rules', 'user_id')) {
            $this->dropColumnWithDependencies('alert_rules', 'user_id');
        }
        if (!$this->hasIndex('alert_rules', 'alert_rules_team_id_type_is_active_index')) {
            Schema::table('alert_rules', function (Blueprint $table) {
                $table->index(['team_id', 'type', 'is_active']);
                $table->index(['team_id', 'scope_type', 'scope_id']);
            });
        }

        // 5. tags: add team_id, drop user_id
        if (!Schema::hasColumn('tags', 'team_id')) {
            Schema::table('tags', function (Blueprint $table) {
                $table->foreignId('team_id')->nullable()->after('id')->constrained()->cascadeOnDelete();
            });
        }
        if (Schema::hasColumn('tags', 'user_id')) {
            $this->dropColumnWithDependencies('tags', 'user_id');
        }
        if (!$this->hasIndex('tags', 'tags_team_id_name_unique')) {
            Schema::table('tags', function (Blueprint $table) {
                $table->unique(['team_id', 'name']);
                $table->index('team_id');
            });
        }

        // 6. app_voice_settings: add team_id, drop user_id
        if (!Schema::hasColumn('app_voice_settings', 'team_id')) {
            Schema::table('app_voice_settings', function (Blueprint $table) {
                $table->foreignId('team_id')->nullable()->after('id')->constrained()->cascadeOnDelete();
            });
        }
        if (Schema::hasColumn('app_voice_settings', 'user_id')) {
            $this->dropColumnWithDependencies('app_voice_settings', 'user_id');
        }
        if (!$this->hasIndex('app_voice_settings', 'app_voice_settings_team_id_app_id_unique')) {
            Schema::table('app_voice_settings', function (Blueprint $table) {
                $table->unique(['team_id', 'app_id']);
            });
        }

        // 7. app_metadata_drafts: add team_id, drop user_id
        if (!Schema::hasColumn('app_metadata_drafts', 'team_id')) {
            Schema::table('app_metadata_drafts', function (Blueprint $table) {
                $table->foreignId('team_id')->nullable()->after('id')->constrained()->cascadeOnDelete();
            });
        }
        if (Schema::hasColumn('app_metadata_drafts', 'user_id')) {
            $this->dropColumnWithDependencies('app_metadata_drafts', 'user_id');
        }
        if (!$this->hasIndex('app_metadata_drafts', 'app_team_locale_unique')) {
            Schema::table('app_metadata_drafts', function (Blueprint $table) {
                $table->unique(['team_id', 'app_id', 'locale'], 'app_team_locale_unique');
                $table->index(['team_id', 'status']);
            });
        }

        // 8. subscriptions: add team_id, drop user_id
        if (!Schema::hasColumn('subscriptions', 'team_id')) {
            Schema::table('subscriptions', function (Blueprint $table) {
                $table->foreignId('team_id')->nullable()->after('id')->constrained()->cascadeOnDelete();
            });
        }
        if (Schema::hasColumn('subscriptions', 'user_id')) {
            $this->dropColumnWithDependencies('subscriptions', 'user_id');
        }
        if (!$this->hasIndex('subscriptions', 'subscriptions_team_id_stripe_status_index')) {
            Schema::table('subscriptions', function (Blueprint $table) {
                $table->index(['team_id', 'stripe_status']);
            });
        }
    }

    /**
     * Drop a column along with all its foreign keys and indexes.
     */
    private function dropColumnWithDependencies(string $table, string $column): void
    {
        // Double-check column exists with raw SQL
        $exists = DB::select("
            SELECT COLUMN_NAME
            FROM information_schema.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE()
            AND TABLE_NAME = ?
            AND COLUMN_NAME = ?
        ", [$table, $column]);

        if (empty($exists)) {
            return; // Column doesn't exist, nothing to do
        }

        // Disable FK checks to allow dropping indexes that MySQL thinks are needed
        DB::statement('SET FOREIGN_KEY_CHECKS=0');

        try {
            // First, drop all foreign keys that reference this column
            $foreignKeys = DB::select("
                SELECT CONSTRAINT_NAME
                FROM information_schema.KEY_COLUMN_USAGE
                WHERE TABLE_SCHEMA = DATABASE()
                AND TABLE_NAME = ?
                AND COLUMN_NAME = ?
                AND REFERENCED_TABLE_NAME IS NOT NULL
            ", [$table, $column]);

            foreach ($foreignKeys as $fk) {
                try {
                    DB::statement("ALTER TABLE `{$table}` DROP FOREIGN KEY `{$fk->CONSTRAINT_NAME}`");
                } catch (\Exception $e) {
                    // FK might already be dropped, continue
                }
            }

            // Then drop all indexes that include this column
            $indexes = DB::select("
                SELECT DISTINCT INDEX_NAME
                FROM information_schema.STATISTICS
                WHERE TABLE_SCHEMA = DATABASE()
                AND TABLE_NAME = ?
                AND COLUMN_NAME = ?
                AND INDEX_NAME != 'PRIMARY'
            ", [$table, $column]);

            foreach ($indexes as $idx) {
                try {
                    DB::statement("DROP INDEX `{$idx->INDEX_NAME}` ON `{$table}`");
                } catch (\Exception $e) {
                    // Index might already be dropped, continue
                }
            }

            // Finally drop the column
            try {
                DB::statement("ALTER TABLE `{$table}` DROP COLUMN `{$column}`");
            } catch (\Exception $e) {
                // Column might already be dropped
            }
        } finally {
            // Always re-enable FK checks
            DB::statement('SET FOREIGN_KEY_CHECKS=1');
        }
    }

    private function hasIndex(string $table, string $indexName): bool
    {
        $indexes = DB::select("SHOW INDEX FROM `{$table}` WHERE Key_name = ?", [$indexName]);
        return count($indexes) > 0;
    }

    public function down(): void
    {
        // Not implementing down() - this is a destructive migration for dev only
        throw new \Exception('This migration cannot be reversed');
    }
};
