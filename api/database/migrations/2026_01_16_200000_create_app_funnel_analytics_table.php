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
        Schema::create('app_funnel_analytics', function (Blueprint $table) {
            $table->id();
            $table->foreignId('app_id')->constrained()->onDelete('cascade');
            $table->date('date');
            $table->string('country_code', 2)->default('WW');
            $table->string('source', 50)->default('total'); // search, browse, referral, app_referrer, web_referrer, total
            $table->unsignedInteger('impressions')->default(0);
            $table->unsignedInteger('impressions_unique')->default(0);
            $table->unsignedInteger('page_views')->default(0);
            $table->unsignedInteger('page_views_unique')->default(0);
            $table->unsignedInteger('downloads')->default(0);
            $table->unsignedInteger('first_time_downloads')->default(0);
            $table->unsignedInteger('redownloads')->default(0);
            $table->decimal('conversion_rate', 5, 2)->nullable(); // impressions to downloads %
            $table->timestamps();

            $table->unique(['app_id', 'date', 'country_code', 'source'], 'app_funnel_unique');
            $table->index(['app_id', 'date'], 'app_funnel_app_date');
            $table->index(['app_id', 'source'], 'app_funnel_app_source');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('app_funnel_analytics');
    }
};
