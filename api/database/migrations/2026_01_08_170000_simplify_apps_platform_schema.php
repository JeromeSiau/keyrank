<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // Step 1: Create new apps table with proper schema
        // SQLite requires table recreation to add NOT NULL constraint
        Schema::create('apps_new', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
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

        // Step 2: Migrate existing data
        // iOS apps: where apple_id is set
        DB::statement("
            INSERT INTO apps_new (id, user_id, platform, store_id, bundle_id, name, icon_url, developer, rating, rating_count, storefront, ratings_fetched_at, reviews_fetched_at, created_at, updated_at)
            SELECT id, user_id, 'ios', apple_id, bundle_id, name, icon_url, developer, rating, rating_count, storefront, ratings_fetched_at, reviews_fetched_at, created_at, updated_at
            FROM apps
            WHERE apple_id IS NOT NULL
        ");

        // Android apps: where google_play_id is set (and apple_id is null)
        // Merge google_* fields into main fields
        DB::statement("
            INSERT INTO apps_new (id, user_id, platform, store_id, bundle_id, name, icon_url, developer, rating, rating_count, storefront, ratings_fetched_at, reviews_fetched_at, created_at, updated_at)
            SELECT id, user_id, 'android', google_play_id, bundle_id, name, google_icon_url, developer, google_rating, google_rating_count, storefront, google_ratings_fetched_at, google_reviews_fetched_at, created_at, updated_at
            FROM apps
            WHERE apple_id IS NULL AND google_play_id IS NOT NULL
        ");

        // Step 3: Drop old table and rename new one
        Schema::drop('apps');
        Schema::rename('apps_new', 'apps');

        // Step 4: Update child tables - drop platform column
        // app_ratings: drop platform column and update unique constraint
        Schema::table('app_ratings', function (Blueprint $table) {
            $table->dropUnique('app_ratings_app_id_platform_country_recorded_at_unique');
        });
        Schema::table('app_ratings', function (Blueprint $table) {
            $table->dropColumn('platform');
            $table->unique(['app_id', 'country', 'recorded_at'], 'app_ratings_app_id_country_recorded_at_unique');
        });

        // app_reviews: drop platform column and update index
        Schema::table('app_reviews', function (Blueprint $table) {
            $table->dropIndex('app_reviews_app_id_platform_country_index');
        });
        Schema::table('app_reviews', function (Blueprint $table) {
            $table->dropColumn('platform');
        });

        // app_rankings: drop platform column and update unique constraint
        Schema::table('app_rankings', function (Blueprint $table) {
            $table->dropUnique('app_rankings_app_id_platform_keyword_id_recorded_at_unique');
        });
        Schema::table('app_rankings', function (Blueprint $table) {
            $table->dropColumn('platform');
            $table->unique(['app_id', 'keyword_id', 'recorded_at'], 'app_rankings_app_id_keyword_id_recorded_at_unique');
        });
    }

    public function down(): void
    {
        // Restore app_rankings platform column
        Schema::table('app_rankings', function (Blueprint $table) {
            $table->dropUnique('app_rankings_app_id_keyword_id_recorded_at_unique');
        });
        Schema::table('app_rankings', function (Blueprint $table) {
            $table->enum('platform', ['ios', 'android'])->default('ios')->after('recorded_at');
            $table->unique(['app_id', 'platform', 'keyword_id', 'recorded_at'], 'app_rankings_app_id_platform_keyword_id_recorded_at_unique');
        });

        // Restore app_reviews platform column
        Schema::table('app_reviews', function (Blueprint $table) {
            $table->enum('platform', ['ios', 'android'])->default('ios')->after('updated_at');
            $table->index(['app_id', 'platform', 'country'], 'app_reviews_app_id_platform_country_index');
        });

        // Restore app_ratings platform column
        Schema::table('app_ratings', function (Blueprint $table) {
            $table->dropUnique('app_ratings_app_id_country_recorded_at_unique');
        });
        Schema::table('app_ratings', function (Blueprint $table) {
            $table->enum('platform', ['ios', 'android'])->default('ios')->after('recorded_at');
            $table->unique(['app_id', 'platform', 'country', 'recorded_at'], 'app_ratings_app_id_platform_country_recorded_at_unique');
        });

        // Restore apps table columns
        Schema::table('apps', function (Blueprint $table) {
            $table->dropUnique('apps_user_platform_store_unique');
        });

        Schema::table('apps', function (Blueprint $table) {
            $table->string('apple_id', 20)->nullable()->after('user_id');
            $table->string('google_play_id', 150)->nullable()->after('apple_id');
            $table->string('google_icon_url', 500)->nullable()->after('icon_url');
            $table->decimal('google_rating', 2, 1)->nullable()->after('rating_count');
            $table->unsignedInteger('google_rating_count')->default(0)->after('google_rating');
            $table->timestamp('google_ratings_fetched_at')->nullable()->after('ratings_fetched_at');
            $table->timestamp('google_reviews_fetched_at')->nullable()->after('reviews_fetched_at');
        });

        // Migrate data back
        DB::table('apps')
            ->where('platform', 'ios')
            ->update(['apple_id' => DB::raw('store_id')]);

        DB::table('apps')
            ->where('platform', 'android')
            ->update([
                'google_play_id' => DB::raw('store_id'),
                'google_icon_url' => DB::raw('icon_url'),
                'google_rating' => DB::raw('rating'),
                'google_rating_count' => DB::raw('rating_count'),
                'google_ratings_fetched_at' => DB::raw('ratings_fetched_at'),
                'google_reviews_fetched_at' => DB::raw('reviews_fetched_at'),
            ]);

        // Drop new columns
        Schema::table('apps', function (Blueprint $table) {
            $table->dropColumn(['platform', 'store_id']);
        });

        // Restore unique constraints
        Schema::table('apps', function (Blueprint $table) {
            $table->unique(['user_id', 'apple_id'], 'apps_user_id_apple_id_unique');
            $table->unique(['user_id', 'google_play_id'], 'apps_user_google_unique');
        });
    }
};
