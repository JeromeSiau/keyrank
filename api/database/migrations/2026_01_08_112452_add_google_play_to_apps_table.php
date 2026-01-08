<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('apps', function (Blueprint $table) {
            $table->string('google_play_id', 150)->nullable()->after('apple_id');
            $table->string('google_icon_url', 500)->nullable()->after('icon_url');
            $table->decimal('google_rating', 2, 1)->nullable()->after('rating_count');
            $table->unsignedInteger('google_rating_count')->default(0)->after('google_rating');
            $table->timestamp('google_ratings_fetched_at')->nullable()->after('ratings_fetched_at');
            $table->timestamp('google_reviews_fetched_at')->nullable()->after('reviews_fetched_at');

            // Make apple_id nullable (app can be Android-only)
            $table->string('apple_id', 20)->nullable()->change();

            // Add unique constraint for Google Play apps
            $table->unique(['user_id', 'google_play_id'], 'apps_user_google_unique');
        });
    }

    public function down(): void
    {
        Schema::table('apps', function (Blueprint $table) {
            $table->dropUnique('apps_user_google_unique');
            $table->dropColumn([
                'google_play_id',
                'google_icon_url',
                'google_rating',
                'google_rating_count',
                'google_ratings_fetched_at',
                'google_reviews_fetched_at',
            ]);
            $table->string('apple_id', 20)->nullable(false)->change();
        });
    }
};
