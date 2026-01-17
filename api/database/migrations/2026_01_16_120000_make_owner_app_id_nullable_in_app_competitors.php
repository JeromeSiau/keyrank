<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        // Helper to check if index exists
        $indexExists = fn($table, $index) => collect(
            DB::select("SHOW INDEX FROM {$table} WHERE Key_name = ?", [$index])
        )->isNotEmpty();

        // Helper to check if foreign key exists
        $fkExists = fn($table, $fk) => collect(DB::select("
            SELECT 1 FROM information_schema.TABLE_CONSTRAINTS
            WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? AND CONSTRAINT_NAME = ? AND CONSTRAINT_TYPE = 'FOREIGN KEY'
        ", [$table, $fk]))->isNotEmpty();

        // 1. Drop foreign key on owner_app_id if it exists
        if ($fkExists('app_competitors', 'app_competitors_owner_app_id_foreign')) {
            Schema::table('app_competitors', function (Blueprint $table) {
                $table->dropForeign('app_competitors_owner_app_id_foreign');
            });
        }

        // 2. Create a simple index on user_id (if not exists)
        if (!$indexExists('app_competitors', 'app_competitors_user_id_index')) {
            Schema::table('app_competitors', function (Blueprint $table) {
                $table->index('user_id', 'app_competitors_user_id_index');
            });
        }

        // 3. Drop the composite index (if exists)
        if ($indexExists('app_competitors', 'app_competitors_user_id_owner_app_id_index')) {
            Schema::table('app_competitors', function (Blueprint $table) {
                $table->dropIndex('app_competitors_user_id_owner_app_id_index');
            });
        }

        // 4. Drop orphaned index from former foreign key (if exists)
        if ($indexExists('app_competitors', 'app_competitors_owner_app_id_foreign')) {
            Schema::table('app_competitors', function (Blueprint $table) {
                $table->dropIndex('app_competitors_owner_app_id_foreign');
            });
        }

        // 5. Make owner_app_id nullable
        Schema::table('app_competitors', function (Blueprint $table) {
            $table->unsignedBigInteger('owner_app_id')->nullable()->change();
        });

        // 6. Re-add foreign key on owner_app_id (if not exists)
        if (!$fkExists('app_competitors', 'app_competitors_owner_app_id_foreign')) {
            Schema::table('app_competitors', function (Blueprint $table) {
                $table->foreign('owner_app_id')
                      ->references('id')
                      ->on('apps')
                      ->onDelete('cascade');
            });
        }

        // 7. Migrate global competitors from user_apps (if column exists)
        if (Schema::hasColumn('user_apps', 'is_competitor')) {
            DB::statement("
                INSERT INTO app_competitors (user_id, owner_app_id, competitor_app_id, source, created_at)
                SELECT ua.user_id, NULL, ua.app_id, 'manual', ua.created_at
                FROM user_apps ua
                WHERE ua.is_competitor = 1
                AND NOT EXISTS (
                    SELECT 1 FROM app_competitors ac
                    WHERE ac.user_id = ua.user_id
                    AND ac.owner_app_id IS NULL
                    AND ac.competitor_app_id = ua.app_id
                )
            ");
        }

        // 8. Add unique constraint and composite index (if not exist)
        if (!$indexExists('app_competitors', 'unique_competitor')) {
            Schema::table('app_competitors', function (Blueprint $table) {
                $table->unique(['user_id', 'owner_app_id', 'competitor_app_id'], 'unique_competitor');
            });
        }
        if (!$indexExists('app_competitors', 'app_competitors_user_id_owner_app_id_index')) {
            Schema::table('app_competitors', function (Blueprint $table) {
                $table->index(['user_id', 'owner_app_id'], 'app_competitors_user_id_owner_app_id_index');
            });
        }

        // 9. Drop temporary user_id index (if exists)
        if ($indexExists('app_competitors', 'app_competitors_user_id_index')) {
            Schema::table('app_competitors', function (Blueprint $table) {
                $table->dropIndex('app_competitors_user_id_index');
            });
        }

        // 10. Remove is_competitor from user_apps (if column exists)
        if (Schema::hasColumn('user_apps', 'is_competitor')) {
            Schema::table('user_apps', function (Blueprint $table) {
                $table->dropColumn('is_competitor');
            });
        }
    }

    public function down(): void
    {
        // 1. Re-add is_competitor to user_apps
        Schema::table('user_apps', function (Blueprint $table) {
            $table->boolean('is_competitor')->default(false)->after('is_owner');
        });

        // 2. Migrate global competitors back to user_apps
        DB::statement("
            UPDATE user_apps ua
            INNER JOIN app_competitors ac ON ac.user_id = ua.user_id AND ac.competitor_app_id = ua.app_id
            SET ua.is_competitor = 1
            WHERE ac.owner_app_id IS NULL
        ");

        // 3. Delete global competitors from app_competitors
        DB::table('app_competitors')->whereNull('owner_app_id')->delete();

        // 4. Drop constraints
        Schema::table('app_competitors', function (Blueprint $table) {
            $table->dropForeign(['owner_app_id']);
            $table->dropUnique('unique_competitor');
            $table->dropIndex('app_competitors_user_id_owner_app_id_index');
        });

        // 5. Make owner_app_id required again
        Schema::table('app_competitors', function (Blueprint $table) {
            $table->unsignedBigInteger('owner_app_id')->nullable(false)->change();
        });

        // 6. Re-add original foreign key and index
        Schema::table('app_competitors', function (Blueprint $table) {
            $table->foreign('owner_app_id')
                  ->references('id')
                  ->on('apps')
                  ->onDelete('cascade');
            $table->index(['user_id', 'owner_app_id'], 'app_competitors_user_id_owner_app_id_index');
        });
    }
};
