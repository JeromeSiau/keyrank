<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // Search suggestions table (autocomplete data)
        Schema::create('search_suggestions', function (Blueprint $table) {
            $table->id();
            $table->string('platform', 10); // ios, android
            $table->string('country', 5);
            $table->string('seed_keyword'); // The keyword we searched for
            $table->string('suggestion'); // The autocomplete suggestion
            $table->unsignedTinyInteger('position')->default(1); // Position in autocomplete list
            $table->date('last_seen_at');
            $table->timestamps();

            $table->unique(['platform', 'country', 'seed_keyword', 'suggestion'], 'search_suggestion_unique');
            $table->index(['suggestion']);
            $table->index(['last_seen_at']);
        });

        // App metadata history table (track changes)
        Schema::create('app_metadata_history', function (Blueprint $table) {
            $table->id();
            $table->foreignId('app_id')->constrained()->onDelete('cascade');
            $table->string('field', 50); // version, price, size_bytes, screenshots, etc.
            $table->text('old_value')->nullable();
            $table->text('new_value')->nullable();
            $table->timestamp('changed_at');
            $table->timestamps();

            $table->index(['app_id', 'field', 'changed_at']);
            $table->index(['changed_at']);
            $table->index(['field', 'changed_at']);
        });

        // Add discovery and metadata tracking columns to apps table
        Schema::table('apps', function (Blueprint $table) {
            // Discovery tracking
            $table->foreignId('discovered_from_app_id')->nullable()->after('reviews_fetched_at');
            $table->string('discovery_source', 30)->nullable()->after('discovered_from_app_id'); // same_developer, related, top_charts, search

            // Metadata tracking for change detection
            $table->string('current_version', 50)->nullable()->after('discovery_source');
            $table->decimal('current_price', 10, 2)->nullable()->after('current_version');
            $table->bigInteger('current_size_bytes')->nullable()->after('current_price');
            $table->json('current_screenshots')->nullable()->after('current_size_bytes');
            $table->timestamp('metadata_checked_at')->nullable()->after('current_screenshots');
        });

        // Add source column to keywords table
        Schema::table('keywords', function (Blueprint $table) {
            $table->string('source', 30)->nullable()->after('storefront'); // manual, autocomplete, top_charts
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('search_suggestions');
        Schema::dropIfExists('app_metadata_history');

        Schema::table('apps', function (Blueprint $table) {
            $table->dropColumn([
                'discovered_from_app_id',
                'discovery_source',
                'current_version',
                'current_price',
                'current_size_bytes',
                'current_screenshots',
                'metadata_checked_at',
            ]);
        });

        Schema::table('keywords', function (Blueprint $table) {
            $table->dropColumn('source');
        });
    }
};
