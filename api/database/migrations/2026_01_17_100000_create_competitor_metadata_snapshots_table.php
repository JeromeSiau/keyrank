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
        Schema::create('competitor_metadata_snapshots', function (Blueprint $table) {
            $table->id();
            $table->foreignId('app_id')->constrained('apps')->onDelete('cascade');
            $table->string('locale', 10)->default('en-US');

            // Metadata fields
            $table->string('title', 100)->nullable();
            $table->string('subtitle', 100)->nullable(); // iOS only
            $table->text('short_description')->nullable(); // Android only
            $table->text('description')->nullable();
            $table->string('keywords', 500)->nullable(); // iOS keywords field (if we can scrape it)
            $table->text('whats_new')->nullable();
            $table->string('version', 50)->nullable();

            // Change tracking
            $table->boolean('has_changes')->default(false);
            $table->json('changed_fields')->nullable(); // ['title', 'description', ...]

            $table->timestamp('scraped_at');
            $table->timestamps();

            // Index for efficient queries
            $table->index(['app_id', 'locale', 'scraped_at']);
            $table->index(['app_id', 'has_changes']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('competitor_metadata_snapshots');
    }
};
