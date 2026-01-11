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
        Schema::create('app_analytics_summaries', function (Blueprint $table) {
            $table->id();
            $table->foreignId('app_id')->constrained()->onDelete('cascade');
            $table->enum('period', ['7d', '30d', '90d', 'ytd', 'all']);
            $table->unsignedBigInteger('total_downloads')->default(0);
            $table->decimal('total_revenue', 12, 2)->default(0);
            $table->decimal('total_proceeds', 12, 2)->default(0);
            $table->unsignedInteger('active_subscribers')->default(0);
            $table->decimal('downloads_change_pct', 8, 2)->nullable();
            $table->decimal('revenue_change_pct', 8, 2)->nullable();
            $table->decimal('subscribers_change_pct', 8, 2)->nullable();
            $table->timestamp('computed_at');
            $table->timestamps();

            $table->unique(['app_id', 'period']);
            $table->index('computed_at');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('app_analytics_summaries');
    }
};
