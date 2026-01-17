<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('app_reviews', function (Blueprint $table) {
            $table->timestamp('insights_extracted_at')->nullable()->after('enriched_at');
            $table->index('insights_extracted_at');
        });
    }

    public function down(): void
    {
        Schema::table('app_reviews', function (Blueprint $table) {
            $table->dropIndex(['insights_extracted_at']);
            $table->dropColumn('insights_extracted_at');
        });
    }
};
