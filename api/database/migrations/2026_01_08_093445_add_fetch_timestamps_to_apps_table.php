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
        Schema::table('apps', function (Blueprint $table) {
            $table->timestamp('ratings_fetched_at')->nullable()->after('updated_at');
            $table->timestamp('reviews_fetched_at')->nullable()->after('ratings_fetched_at');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('apps', function (Blueprint $table) {
            $table->dropColumn(['ratings_fetched_at', 'reviews_fetched_at']);
        });
    }
};
