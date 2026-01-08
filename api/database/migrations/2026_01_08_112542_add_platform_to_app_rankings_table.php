<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('app_rankings', function (Blueprint $table) {
            $table->enum('platform', ['ios', 'android'])->default('ios')->after('app_id');

            // Update unique constraint
            $table->dropUnique(['app_id', 'keyword_id', 'recorded_at']);
            $table->unique(['app_id', 'platform', 'keyword_id', 'recorded_at']);
        });
    }

    public function down(): void
    {
        Schema::table('app_rankings', function (Blueprint $table) {
            $table->dropUnique(['app_id', 'platform', 'keyword_id', 'recorded_at']);
            $table->unique(['app_id', 'keyword_id', 'recorded_at']);
            $table->dropColumn('platform');
        });
    }
};
