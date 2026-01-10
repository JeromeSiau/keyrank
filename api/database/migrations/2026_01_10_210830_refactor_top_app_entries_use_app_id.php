<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // Step 1: Add app_id column
        Schema::table('top_app_entries', function (Blueprint $table) {
            $table->foreignId('app_id')->nullable()->after('id')->constrained()->cascadeOnDelete();
        });

        // Step 2: Populate app_id from existing data
        DB::statement('
            UPDATE top_app_entries
            SET app_id = (
                SELECT apps.id FROM apps
                WHERE apps.platform = top_app_entries.platform
                AND apps.store_id = top_app_entries.store_id
                LIMIT 1
            )
        ');

        // Step 3: Delete orphaned entries (no matching app)
        DB::table('top_app_entries')->whereNull('app_id')->delete();

        // Step 4: Make app_id required and drop old columns
        Schema::table('top_app_entries', function (Blueprint $table) {
            // Drop old unique constraint
            $table->dropUnique('unique_top_entry');
            $table->dropIndex(['platform']);
            $table->dropIndex(['category_id', 'recorded_at']);
        });

        // Recreate table without duplicate columns (SQLite compatible)
        Schema::create('top_app_entries_new', function (Blueprint $table) {
            $table->id();
            $table->foreignId('app_id')->constrained()->cascadeOnDelete();
            $table->string('category_id', 50)->index();
            $table->string('collection', 20)->default('top_free');
            $table->string('country', 5)->default('us');
            $table->unsignedSmallInteger('position');
            $table->date('recorded_at')->index();
            $table->timestamps();

            $table->unique(['app_id', 'category_id', 'collection', 'country', 'recorded_at'], 'unique_top_entry');
            $table->index(['category_id', 'collection', 'country', 'recorded_at'], 'top_entries_listing');
        });

        // Copy data
        DB::statement('
            INSERT INTO top_app_entries_new (id, app_id, category_id, collection, country, position, recorded_at, created_at, updated_at)
            SELECT id, app_id, category_id, collection, country, position, recorded_at, created_at, updated_at
            FROM top_app_entries
            WHERE app_id IS NOT NULL
        ');

        Schema::drop('top_app_entries');
        Schema::rename('top_app_entries_new', 'top_app_entries');
    }

    public function down(): void
    {
        // Recreate original structure
        Schema::create('top_app_entries_old', function (Blueprint $table) {
            $table->id();
            $table->string('platform', 10)->index();
            $table->string('category_id', 50)->index();
            $table->string('collection', 20)->default('top_free');
            $table->string('country', 5)->default('us');
            $table->string('store_id');
            $table->string('name');
            $table->string('developer')->nullable();
            $table->string('icon_url', 500)->nullable();
            $table->decimal('rating', 2, 1)->nullable();
            $table->unsignedInteger('rating_count')->nullable();
            $table->unsignedSmallInteger('position');
            $table->date('recorded_at')->index();
            $table->timestamps();

            $table->unique([
                'platform', 'category_id', 'collection',
                'country', 'store_id', 'recorded_at'
            ], 'unique_top_entry');
            $table->index(['category_id', 'recorded_at']);
        });

        // Copy data back with app info
        DB::statement('
            INSERT INTO top_app_entries_old (id, platform, category_id, collection, country, store_id, name, developer, icon_url, rating, rating_count, position, recorded_at, created_at, updated_at)
            SELECT t.id, a.platform, t.category_id, t.collection, t.country, a.store_id, a.name, a.developer, a.icon_url, a.rating, a.rating_count, t.position, t.recorded_at, t.created_at, t.updated_at
            FROM top_app_entries t
            JOIN apps a ON a.id = t.app_id
        ');

        Schema::drop('top_app_entries');
        Schema::rename('top_app_entries_old', 'top_app_entries');
    }
};
