<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // Modify sentiment enum to add 'mixed' option
        // For MySQL, we need to alter the column definition
        if (DB::getDriverName() === 'mysql') {
            DB::statement("ALTER TABLE app_reviews MODIFY COLUMN sentiment ENUM('positive', 'negative', 'neutral', 'mixed') NULL");
        }

        Schema::table('app_reviews', function (Blueprint $table) {
            $table->decimal('sentiment_score', 3, 2)->nullable()->after('sentiment'); // -1.00 to 1.00
            $table->json('themes')->nullable()->after('sentiment_score');
            $table->string('language', 10)->nullable()->after('themes');
            $table->timestamp('enriched_at')->nullable()->after('language');
        });

        // Add composite index for common query patterns
        Schema::table('app_reviews', function (Blueprint $table) {
            $table->index(['app_id', 'sentiment', 'reviewed_at'], 'reviews_sentiment_date_idx');
        });
    }

    public function down(): void
    {
        Schema::table('app_reviews', function (Blueprint $table) {
            $table->dropIndex('reviews_sentiment_date_idx');
            $table->dropColumn(['sentiment_score', 'themes', 'language', 'enriched_at']);
        });

        // Revert sentiment enum
        if (DB::getDriverName() === 'mysql') {
            DB::statement("ALTER TABLE app_reviews MODIFY COLUMN sentiment ENUM('positive', 'negative', 'neutral') NULL");
        }
    }
};
