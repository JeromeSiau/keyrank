<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        // 1. Drop user_apps table (replaced by team_apps)
        Schema::dropIfExists('user_apps');

        // 2. tracked_keywords: add team_id, drop user_id
        Schema::table('tracked_keywords', function (Blueprint $table) {
            $table->foreignId('team_id')->nullable()->after('id')->constrained()->cascadeOnDelete();
        });
        Schema::table('tracked_keywords', function (Blueprint $table) {
            $table->dropForeign(['user_id']);
            $table->dropColumn('user_id');
        });
        // Update unique constraint
        DB::statement('DROP INDEX IF EXISTS tracked_keywords_user_app_keyword_unique ON tracked_keywords');
        Schema::table('tracked_keywords', function (Blueprint $table) {
            $table->unique(['team_id', 'app_id', 'keyword_id'], 'tracked_keywords_team_app_keyword_unique');
        });

        // 3. app_competitors: add team_id, drop user_id
        Schema::table('app_competitors', function (Blueprint $table) {
            $table->foreignId('team_id')->nullable()->after('id')->constrained()->cascadeOnDelete();
        });
        Schema::table('app_competitors', function (Blueprint $table) {
            $table->dropForeign(['user_id']);
            $table->dropColumn('user_id');
        });
        DB::statement('DROP INDEX IF EXISTS unique_competitor ON app_competitors');
        Schema::table('app_competitors', function (Blueprint $table) {
            $table->unique(['team_id', 'owner_app_id', 'competitor_app_id'], 'app_competitors_team_unique');
        });

        // 4. alert_rules: add team_id, drop user_id
        Schema::table('alert_rules', function (Blueprint $table) {
            $table->foreignId('team_id')->nullable()->after('id')->constrained()->cascadeOnDelete();
        });
        Schema::table('alert_rules', function (Blueprint $table) {
            $table->dropForeign(['user_id']);
            $table->dropIndex(['user_id', 'type', 'is_active']);
            $table->dropIndex(['user_id', 'scope_type', 'scope_id']);
            $table->dropColumn('user_id');
        });
        Schema::table('alert_rules', function (Blueprint $table) {
            $table->index(['team_id', 'type', 'is_active']);
            $table->index(['team_id', 'scope_type', 'scope_id']);
        });

        // 5. tags: add team_id, drop user_id
        Schema::table('tags', function (Blueprint $table) {
            $table->foreignId('team_id')->nullable()->after('id')->constrained()->cascadeOnDelete();
        });
        Schema::table('tags', function (Blueprint $table) {
            $table->dropForeign(['user_id']);
            $table->dropIndex(['user_id']);
            $table->dropUnique(['user_id', 'name']);
            $table->dropColumn('user_id');
        });
        Schema::table('tags', function (Blueprint $table) {
            $table->unique(['team_id', 'name']);
            $table->index('team_id');
        });

        // 6. app_voice_settings: add team_id, drop user_id
        Schema::table('app_voice_settings', function (Blueprint $table) {
            $table->foreignId('team_id')->nullable()->after('id')->constrained()->cascadeOnDelete();
        });
        Schema::table('app_voice_settings', function (Blueprint $table) {
            $table->dropForeign(['user_id']);
            $table->dropUnique(['app_id', 'user_id']);
            $table->dropColumn('user_id');
        });
        Schema::table('app_voice_settings', function (Blueprint $table) {
            $table->unique(['team_id', 'app_id']);
        });

        // 7. app_metadata_drafts: add team_id, drop user_id
        Schema::table('app_metadata_drafts', function (Blueprint $table) {
            $table->foreignId('team_id')->nullable()->after('id')->constrained()->cascadeOnDelete();
        });
        Schema::table('app_metadata_drafts', function (Blueprint $table) {
            $table->dropForeign(['user_id']);
            $table->dropUnique('app_user_locale_unique');
            $table->dropIndex(['user_id', 'status']);
            $table->dropColumn('user_id');
        });
        Schema::table('app_metadata_drafts', function (Blueprint $table) {
            $table->unique(['team_id', 'app_id', 'locale'], 'app_team_locale_unique');
            $table->index(['team_id', 'status']);
        });

        // 8. subscriptions: add team_id, drop user_id
        Schema::table('subscriptions', function (Blueprint $table) {
            $table->foreignId('team_id')->nullable()->after('id')->constrained()->cascadeOnDelete();
        });
        Schema::table('subscriptions', function (Blueprint $table) {
            $table->dropIndex(['user_id', 'stripe_status']);
            $table->dropColumn('user_id');
        });
        Schema::table('subscriptions', function (Blueprint $table) {
            $table->index(['team_id', 'stripe_status']);
        });
    }

    public function down(): void
    {
        // Not implementing down() - this is a destructive migration for dev only
        throw new \Exception('This migration cannot be reversed');
    }
};
