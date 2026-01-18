<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('revenue_apps', function (Blueprint $table) {
            // Unit economics (stored in cents)
            $table->bigInteger('ltv_cents')->nullable()->after('monthly_downloads');
            $table->bigInteger('arpu_cents')->nullable()->after('ltv_cents');

            // Growth metrics (as percentages, e.g., 0.85 for 0.85%)
            $table->decimal('churn_rate', 5, 2)->nullable()->after('arpu_cents');
            $table->decimal('growth_rate_mom', 6, 2)->nullable()->after('churn_rate');

            // Additional metrics
            $table->bigInteger('total_downloads')->nullable()->after('monthly_downloads');
            $table->integer('active_users')->nullable()->after('active_subscribers');

            // Financial
            $table->bigInteger('monthly_profit_cents')->nullable()->after('arr_cents');
            $table->bigInteger('annual_revenue_cents')->nullable()->after('arr_cents');

            // Metadata
            $table->string('category', 100)->nullable()->after('business_model');

            // Linking to our apps table
            $table->foreignId('matched_app_id')
                ->nullable()
                ->after('id')
                ->constrained('apps')
                ->nullOnDelete();
        });
    }

    public function down(): void
    {
        Schema::table('revenue_apps', function (Blueprint $table) {
            $table->dropForeign(['matched_app_id']);
            $table->dropColumn([
                'ltv_cents',
                'arpu_cents',
                'churn_rate',
                'growth_rate_mom',
                'total_downloads',
                'active_users',
                'monthly_profit_cents',
                'annual_revenue_cents',
                'category',
                'matched_app_id',
            ]);
        });
    }
};
