<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('app_reviews', function (Blueprint $table) {
            $table->enum('platform', ['ios', 'android'])->default('ios')->after('app_id');

            $table->index(['app_id', 'platform', 'country']);
        });
    }

    public function down(): void
    {
        Schema::table('app_reviews', function (Blueprint $table) {
            $table->dropIndex(['app_id', 'platform', 'country']);
            $table->dropColumn('platform');
        });
    }
};
