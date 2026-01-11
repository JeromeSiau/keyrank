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
        // App Rankings - add indexes for common queries
        // Note: unique index on (app_id, keyword_id, recorded_at) already exists
        Schema::table('app_rankings', function (Blueprint $table) {
            // Index for date range queries
            if (! $this->hasIndex('app_rankings', 'rankings_date_app')) {
                $table->index(['recorded_at', 'app_id'], 'rankings_date_app');
            }
            // Index for platform filtering if column exists
            if (Schema::hasColumn('app_rankings', 'platform')) {
                $table->index(['app_id', 'platform', 'recorded_at'], 'rankings_app_platform_date');
            }
        });

        // App Ratings
        Schema::table('app_ratings', function (Blueprint $table) {
            if (Schema::hasColumn('app_ratings', 'country')) {
                $table->index(['app_id', 'country', 'recorded_at'], 'ratings_app_country_date');
            }
            $table->index(['recorded_at', 'app_id'], 'ratings_date_app');
        });

        // App Reviews
        Schema::table('app_reviews', function (Blueprint $table) {
            if (Schema::hasColumn('app_reviews', 'country')) {
                $table->index(['app_id', 'country', 'created_at'], 'reviews_app_country_date');
            }
            $table->index(['app_id', 'rating', 'created_at'], 'reviews_app_rating_date');
        });

        // Tracked Keywords
        Schema::table('tracked_keywords', function (Blueprint $table) {
            $table->index(['user_id', 'app_id'], 'tracked_user_app');
        });

        // Notifications
        Schema::table('notifications', function (Blueprint $table) {
            $table->index(['user_id', 'is_read', 'created_at'], 'notifications_user_read_date');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('app_rankings', function (Blueprint $table) {
            if ($this->hasIndex('app_rankings', 'rankings_date_app')) {
                $table->dropIndex('rankings_date_app');
            }
            if ($this->hasIndex('app_rankings', 'rankings_app_platform_date')) {
                $table->dropIndex('rankings_app_platform_date');
            }
        });

        Schema::table('app_ratings', function (Blueprint $table) {
            if ($this->hasIndex('app_ratings', 'ratings_app_country_date')) {
                $table->dropIndex('ratings_app_country_date');
            }
            if ($this->hasIndex('app_ratings', 'ratings_date_app')) {
                $table->dropIndex('ratings_date_app');
            }
        });

        Schema::table('app_reviews', function (Blueprint $table) {
            if ($this->hasIndex('app_reviews', 'reviews_app_country_date')) {
                $table->dropIndex('reviews_app_country_date');
            }
            if ($this->hasIndex('app_reviews', 'reviews_app_rating_date')) {
                $table->dropIndex('reviews_app_rating_date');
            }
        });

        Schema::table('tracked_keywords', function (Blueprint $table) {
            if ($this->hasIndex('tracked_keywords', 'tracked_user_app')) {
                $table->dropIndex('tracked_user_app');
            }
        });

        Schema::table('notifications', function (Blueprint $table) {
            if ($this->hasIndex('notifications', 'notifications_user_read_date')) {
                $table->dropIndex('notifications_user_read_date');
            }
        });
    }

    private function hasIndex(string $table, string $indexName): bool
    {
        $indexes = Schema::getIndexes($table);
        foreach ($indexes as $index) {
            if ($index['name'] === $indexName) {
                return true;
            }
        }
        return false;
    }
};
