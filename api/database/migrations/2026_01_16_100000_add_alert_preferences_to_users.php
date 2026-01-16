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
        Schema::table('users', function (Blueprint $table) {
            // JSON column storing delivery preferences per alert type
            // Structure: { "position_change": {"push": true, "email": false, "digest": true}, ... }
            $table->json('alert_delivery_preferences')->nullable()->after('quiet_hours_end');

            // Digest scheduling
            $table->string('digest_time', 5)->default('09:00')->after('alert_delivery_preferences');
            $table->string('weekly_digest_day', 10)->default('monday')->after('digest_time');

            // Email notifications enabled (master switch)
            $table->boolean('email_notifications_enabled')->default(true)->after('weekly_digest_day');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn([
                'alert_delivery_preferences',
                'digest_time',
                'weekly_digest_day',
                'email_notifications_enabled',
            ]);
        });
    }
};
