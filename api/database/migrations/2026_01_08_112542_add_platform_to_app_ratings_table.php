<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('app_ratings', function (Blueprint $table) {
            $table->enum('platform', ['ios', 'android'])->default('ios')->after('app_id');

            // Update unique constraint to include platform
            $table->dropUnique(['app_id', 'country', 'recorded_at']);
            $table->unique(['app_id', 'platform', 'country', 'recorded_at']);
        });
    }

    public function down(): void
    {
        Schema::table('app_ratings', function (Blueprint $table) {
            $table->dropUnique(['app_id', 'platform', 'country', 'recorded_at']);
            $table->unique(['app_id', 'country', 'recorded_at']);
            $table->dropColumn('platform');
        });
    }
};
