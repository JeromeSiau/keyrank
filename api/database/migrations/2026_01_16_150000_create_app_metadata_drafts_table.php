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
        Schema::create('app_metadata_drafts', function (Blueprint $table) {
            $table->id();
            $table->foreignId('app_id')->constrained()->onDelete('cascade');
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->string('locale', 20); // e.g., en-US, fr-FR

            // Editable fields (iOS + Android)
            $table->string('title', 50)->nullable(); // 30 chars iOS, 50 Android
            $table->string('subtitle', 50)->nullable(); // iOS only, 30 chars
            $table->string('keywords', 200)->nullable(); // iOS only, 100 chars comma-separated
            $table->text('description')->nullable(); // 4000 chars iOS, 4000 Android
            $table->text('promotional_text')->nullable(); // iOS only, 170 chars
            $table->text('whats_new')->nullable(); // Release notes, 4000 chars

            // Metadata status
            $table->enum('status', ['draft', 'pending_review', 'published', 'rejected'])->default('draft');
            $table->timestamp('last_published_at')->nullable();
            $table->timestamp('submitted_at')->nullable();

            // Track what's changed from live version
            $table->json('changed_fields')->nullable();

            $table->timestamps();

            // Unique constraint: one draft per app/user/locale
            $table->unique(['app_id', 'user_id', 'locale'], 'app_user_locale_unique');

            // Index for quick lookups
            $table->index(['app_id', 'locale']);
            $table->index(['user_id', 'status']);
        });

        // Table to store the live metadata fetched from ASC for comparison
        Schema::create('app_metadata_locales', function (Blueprint $table) {
            $table->id();
            $table->foreignId('app_id')->constrained()->onDelete('cascade');
            $table->string('locale', 20);

            // Current live values from store
            $table->string('title', 50)->nullable();
            $table->string('subtitle', 50)->nullable();
            $table->string('keywords', 200)->nullable();
            $table->text('description')->nullable();
            $table->text('promotional_text')->nullable();
            $table->text('whats_new')->nullable();

            // ASC-specific IDs for API calls
            $table->string('asc_app_info_id')->nullable();
            $table->string('asc_localization_id')->nullable();

            $table->timestamp('fetched_at')->nullable();
            $table->timestamps();

            $table->unique(['app_id', 'locale'], 'app_locale_unique');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('app_metadata_drafts');
        Schema::dropIfExists('app_metadata_locales');
    }
};
