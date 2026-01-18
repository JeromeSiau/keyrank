<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        // Add source_url to revenue_apps
        Schema::table('revenue_apps', function (Blueprint $table) {
            $table->string('source_url', 500)->nullable()->after('source_id');
            $table->index('source_url');
        });

        // Table for URLs we've checked but aren't mobile apps
        Schema::create('revenue_skipped_urls', function (Blueprint $table) {
            $table->id();
            $table->string('source', 50);
            $table->string('url', 500);
            $table->string('reason', 100)->default('not_mobile_app');
            $table->timestamp('checked_at');
            $table->timestamps();

            $table->unique(['source', 'url']);
            $table->index('source');
        });
    }

    public function down(): void
    {
        Schema::table('revenue_apps', function (Blueprint $table) {
            $table->dropIndex(['source_url']);
            $table->dropColumn('source_url');
        });

        Schema::dropIfExists('revenue_skipped_urls');
    }
};
