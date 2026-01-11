<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // Step 1: Create user_apps pivot table
        Schema::create('user_apps', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->foreignId('app_id')->constrained()->cascadeOnDelete();
            $table->timestamp('created_at')->useCurrent();

            $table->unique(['user_id', 'app_id']);
            $table->index('app_id');
        });

        // Step 2: Migrate existing user->app relationships to pivot table
        DB::statement('
            INSERT INTO user_apps (user_id, app_id, created_at)
            SELECT user_id, id, created_at FROM apps
        ');

        // Step 3: Find and merge duplicate apps (same platform + store_id)
        // Get groups of duplicate apps
        $duplicates = DB::table('apps')
            ->select('platform', 'store_id', DB::raw('MIN(id) as keep_id'), DB::raw('GROUP_CONCAT(id) as all_ids'))
            ->groupBy('platform', 'store_id')
            ->havingRaw('COUNT(*) > 1')
            ->get();

        foreach ($duplicates as $group) {
            $keepId = $group->keep_id;
            $allIds = array_map('intval', explode(',', $group->all_ids));
            $duplicateIds = array_filter($allIds, fn($id) => $id !== $keepId);

            if (empty($duplicateIds)) {
                continue;
            }

            // Migrate user_apps from duplicates to kept app (ignore conflicts)
            foreach ($duplicateIds as $duplicateId) {
                DB::table('user_apps')
                    ->where('app_id', $duplicateId)
                    ->whereNotExists(function ($query) use ($keepId) {
                        $query->select(DB::raw(1))
                            ->from('user_apps as ua2')
                            ->whereColumn('ua2.user_id', 'user_apps.user_id')
                            ->where('ua2.app_id', $keepId);
                    })
                    ->update(['app_id' => $keepId]);

                // Delete remaining duplicate user_apps entries
                DB::table('user_apps')->where('app_id', $duplicateId)->delete();
            }

            // Migrate tracked_keywords from duplicates to kept app
            foreach ($duplicateIds as $duplicateId) {
                // Update tracked_keywords, skip if would create duplicate
                DB::table('tracked_keywords')
                    ->where('app_id', $duplicateId)
                    ->whereNotExists(function ($query) use ($keepId) {
                        $query->select(DB::raw(1))
                            ->from('tracked_keywords as tk2')
                            ->whereColumn('tk2.user_id', 'tracked_keywords.user_id')
                            ->whereColumn('tk2.keyword_id', 'tracked_keywords.keyword_id')
                            ->where('tk2.app_id', $keepId);
                    })
                    ->update(['app_id' => $keepId]);

                // Delete remaining duplicate tracked_keywords
                DB::table('tracked_keywords')->where('app_id', $duplicateId)->delete();
            }

            // Migrate app_rankings from duplicates to kept app
            foreach ($duplicateIds as $duplicateId) {
                DB::table('app_rankings')
                    ->where('app_id', $duplicateId)
                    ->whereNotExists(function ($query) use ($keepId) {
                        $query->select(DB::raw(1))
                            ->from('app_rankings as ar2')
                            ->whereColumn('ar2.keyword_id', 'app_rankings.keyword_id')
                            ->whereColumn('ar2.recorded_at', 'app_rankings.recorded_at')
                            ->where('ar2.app_id', $keepId);
                    })
                    ->update(['app_id' => $keepId]);

                DB::table('app_rankings')->where('app_id', $duplicateId)->delete();
            }

            // Migrate app_ratings from duplicates to kept app
            foreach ($duplicateIds as $duplicateId) {
                DB::table('app_ratings')
                    ->where('app_id', $duplicateId)
                    ->whereNotExists(function ($query) use ($keepId) {
                        $query->select(DB::raw(1))
                            ->from('app_ratings as ar2')
                            ->whereColumn('ar2.country', 'app_ratings.country')
                            ->whereColumn('ar2.recorded_at', 'app_ratings.recorded_at')
                            ->where('ar2.app_id', $keepId);
                    })
                    ->update(['app_id' => $keepId]);

                DB::table('app_ratings')->where('app_id', $duplicateId)->delete();
            }

            // Migrate app_reviews from duplicates to kept app
            foreach ($duplicateIds as $duplicateId) {
                DB::table('app_reviews')
                    ->where('app_id', $duplicateId)
                    ->whereNotExists(function ($query) use ($keepId) {
                        $query->select(DB::raw(1))
                            ->from('app_reviews as arv2')
                            ->whereColumn('arv2.country', 'app_reviews.country')
                            ->whereColumn('arv2.review_id', 'app_reviews.review_id')
                            ->where('arv2.app_id', $keepId);
                    })
                    ->update(['app_id' => $keepId]);

                DB::table('app_reviews')->where('app_id', $duplicateId)->delete();
            }

            // Delete duplicate apps
            DB::table('apps')->whereIn('id', $duplicateIds)->delete();
        }

        // Step 4: Update tracked_keywords unique constraint
        // Change from [app_id, keyword_id] to [user_id, app_id, keyword_id]
        // For MySQL: need to drop FK first, then drop unique, add new unique, recreate FK
        if (DB::getDriverName() === 'mysql') {
            // Drop FKs that use the unique index
            DB::statement('ALTER TABLE tracked_keywords DROP FOREIGN KEY tracked_keywords_keyword_id_foreign');
            DB::statement('ALTER TABLE tracked_keywords DROP FOREIGN KEY tracked_keywords_app_id_foreign');
            // Now we can drop the unique index
            DB::statement('ALTER TABLE tracked_keywords DROP INDEX tracked_keywords_app_id_keyword_id_unique');
            // Create new unique index
            DB::statement('CREATE UNIQUE INDEX tracked_keywords_user_app_keyword_unique ON tracked_keywords (user_id, app_id, keyword_id)');
            // Recreate FKs - they will use the new unique index or create their own index
            DB::statement('ALTER TABLE tracked_keywords ADD CONSTRAINT tracked_keywords_keyword_id_foreign FOREIGN KEY (keyword_id) REFERENCES keywords(id) ON DELETE CASCADE');
            DB::statement('ALTER TABLE tracked_keywords ADD CONSTRAINT tracked_keywords_app_id_foreign FOREIGN KEY (app_id) REFERENCES apps(id) ON DELETE CASCADE');
        } else {
            Schema::table('tracked_keywords', function (Blueprint $table) {
                $table->dropUnique(['app_id', 'keyword_id']);
            });
            Schema::table('tracked_keywords', function (Blueprint $table) {
                $table->unique(['user_id', 'app_id', 'keyword_id'], 'tracked_keywords_user_app_keyword_unique');
            });
        }

        // Step 5: Recreate apps table without user_id (SQLite compatible)
        Schema::create('apps_new', function (Blueprint $table) {
            $table->id();
            $table->enum('platform', ['ios', 'android']);
            $table->string('store_id', 150);
            $table->string('bundle_id', 150)->nullable();
            $table->string('name', 255);
            $table->string('icon_url', 500)->nullable();
            $table->string('developer', 255)->nullable();
            $table->decimal('rating', 2, 1)->nullable();
            $table->unsignedInteger('rating_count')->default(0);
            $table->string('storefront', 10)->nullable();
            $table->timestamp('ratings_fetched_at')->nullable();
            $table->timestamp('reviews_fetched_at')->nullable();
            $table->timestamps();

            $table->unique(['platform', 'store_id'], 'apps_platform_store_unique');
        });

        // Copy data (excluding user_id)
        DB::statement('
            INSERT INTO apps_new (id, platform, store_id, bundle_id, name, icon_url, developer, rating, rating_count, storefront, ratings_fetched_at, reviews_fetched_at, created_at, updated_at)
            SELECT id, platform, store_id, bundle_id, name, icon_url, developer, rating, rating_count, storefront, ratings_fetched_at, reviews_fetched_at, created_at, updated_at
            FROM apps
        ');

        // Drop old table and rename
        // Disable FK checks for MySQL to allow dropping table with references
        if (DB::getDriverName() === 'mysql') {
            DB::statement('SET FOREIGN_KEY_CHECKS=0');
        }
        Schema::drop('apps');
        Schema::rename('apps_new', 'apps');
        if (DB::getDriverName() === 'mysql') {
            DB::statement('SET FOREIGN_KEY_CHECKS=1');
        }

        // Step 6: Recreate foreign keys on child tables
        // user_apps already has FK from creation
        // tracked_keywords, app_rankings, app_ratings, app_reviews need FK recreation
        // SQLite doesn't support adding FK to existing table, but the CASCADE works via the original FK
    }

    public function down(): void
    {
        // Step 1: Recreate apps table with user_id
        Schema::create('apps_old', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->enum('platform', ['ios', 'android']);
            $table->string('store_id', 150);
            $table->string('bundle_id', 150)->nullable();
            $table->string('name', 255);
            $table->string('icon_url', 500)->nullable();
            $table->string('developer', 255)->nullable();
            $table->decimal('rating', 2, 1)->nullable();
            $table->unsignedInteger('rating_count')->default(0);
            $table->string('storefront', 10)->nullable();
            $table->timestamp('ratings_fetched_at')->nullable();
            $table->timestamp('reviews_fetched_at')->nullable();
            $table->timestamps();

            $table->unique(['user_id', 'platform', 'store_id'], 'apps_user_platform_store_unique');
        });

        // Copy data back with user_id from first user in user_apps
        DB::statement('
            INSERT INTO apps_old (id, user_id, platform, store_id, bundle_id, name, icon_url, developer, rating, rating_count, storefront, ratings_fetched_at, reviews_fetched_at, created_at, updated_at)
            SELECT a.id, ua.user_id, a.platform, a.store_id, a.bundle_id, a.name, a.icon_url, a.developer, a.rating, a.rating_count, a.storefront, a.ratings_fetched_at, a.reviews_fetched_at, a.created_at, a.updated_at
            FROM apps a
            INNER JOIN (
                SELECT app_id, MIN(user_id) as user_id
                FROM user_apps
                GROUP BY app_id
            ) ua ON ua.app_id = a.id
        ');

        Schema::drop('apps');
        Schema::rename('apps_old', 'apps');

        // Step 2: Restore tracked_keywords unique constraint
        Schema::table('tracked_keywords', function (Blueprint $table) {
            $table->dropUnique('tracked_keywords_user_app_keyword_unique');
        });
        Schema::table('tracked_keywords', function (Blueprint $table) {
            $table->unique(['app_id', 'keyword_id']);
        });

        // Step 3: Drop user_apps pivot table
        Schema::dropIfExists('user_apps');
    }
};
