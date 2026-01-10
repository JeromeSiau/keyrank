<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->string('timezone', 50)->default('UTC')->after('locale');
            $table->string('fcm_token', 255)->nullable()->after('timezone');
            $table->time('quiet_hours_start')->default('22:00:00')->after('fcm_token');
            $table->time('quiet_hours_end')->default('08:00:00')->after('quiet_hours_start');
        });
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn(['timezone', 'fcm_token', 'quiet_hours_start', 'quiet_hours_end']);
        });
    }
};
