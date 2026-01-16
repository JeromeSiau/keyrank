<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        // 1. Drop foreign key on owner_app_id if it exists
        $foreignKeys = collect(DB::select("
            SELECT CONSTRAINT_NAME
            FROM information_schema.TABLE_CONSTRAINTS
            WHERE TABLE_SCHEMA = DATABASE()
            AND TABLE_NAME = 'app_competitors'
            AND CONSTRAINT_TYPE = 'FOREIGN KEY'
            AND CONSTRAINT_NAME = 'app_competitors_owner_app_id_foreign'
        "));

        if ($foreignKeys->isNotEmpty()) {
            Schema::table('app_competitors', function (Blueprint $table) {
                $table->dropForeign('app_competitors_owner_app_id_foreign');
            });
        }

        // 2. Create a simple index on user_id so we can drop the composite one
        // (MySQL needs an index for the user_id foreign key)
        Schema::table('app_competitors', function (Blueprint $table) {
            $table->index('user_id', 'app_competitors_user_id_index');
        });

        // 3. Now we can safely drop the composite index
        Schema::table('app_competitors', function (Blueprint $table) {
            $table->dropIndex('app_competitors_user_id_owner_app_id_index');
        });

        // 4. Drop the orphaned index from former foreign key if it exists
        $indexes = collect(DB::select("SHOW INDEX FROM app_competitors WHERE Key_name = 'app_competitors_owner_app_id_foreign'"));
        if ($indexes->isNotEmpty()) {
            Schema::table('app_competitors', function (Blueprint $table) {
                $table->dropIndex('app_competitors_owner_app_id_foreign');
            });
        }

        // 5. Make owner_app_id nullable
        Schema::table('app_competitors', function (Blueprint $table) {
            $table->unsignedBigInteger('owner_app_id')->nullable()->change();
        });

        // 6. Re-add foreign key on owner_app_id (now allows NULL)
        Schema::table('app_competitors', function (Blueprint $table) {
            $table->foreign('owner_app_id')
                  ->references('id')
                  ->on('apps')
                  ->onDelete('cascade');
        });

        // 7. Migrate global competitors from user_apps to app_competitors
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

        // 8. Add unique constraint and new composite index
        Schema::table('app_competitors', function (Blueprint $table) {
            $table->unique(['user_id', 'owner_app_id', 'competitor_app_id'], 'unique_competitor');
            $table->index(['user_id', 'owner_app_id'], 'app_competitors_user_id_owner_app_id_index');
        });

        // 9. Drop the temporary simple user_id index (composite index can now be used)
        Schema::table('app_competitors', function (Blueprint $table) {
            $table->dropIndex('app_competitors_user_id_index');
        });

        // 10. Remove is_competitor from user_apps
        Schema::table('user_apps', function (Blueprint $table) {
            $table->dropColumn('is_competitor');
        });
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
