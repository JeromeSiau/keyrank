<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('app_reviews', function (Blueprint $table) {
            $table->enum('sentiment', ['positive', 'negative', 'neutral'])->nullable()->after('reviewed_at');
            $table->text('our_response')->nullable()->after('sentiment');
            $table->timestamp('responded_at')->nullable()->after('our_response');
            $table->string('store_response_id')->nullable()->after('responded_at');

            $table->index(['app_id', 'sentiment']);
            $table->index(['app_id', 'responded_at']);
        });
    }

    public function down(): void
    {
        Schema::table('app_reviews', function (Blueprint $table) {
            $table->dropColumn(['sentiment', 'our_response', 'responded_at', 'store_response_id']);
        });
    }
};
