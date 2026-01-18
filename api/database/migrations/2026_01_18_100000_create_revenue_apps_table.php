<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('revenue_apps', function (Blueprint $table) {
            $table->id();
            $table->string('source', 50)->index();
            $table->string('source_id')->index();
            $table->string('app_name');

            // Revenue data (stored in cents to avoid float issues)
            $table->bigInteger('mrr_cents')->nullable();
            $table->bigInteger('monthly_revenue_cents')->nullable();
            $table->bigInteger('arr_cents')->nullable();

            // Subscriber metrics
            $table->integer('active_subscribers')->nullable();
            $table->integer('active_trials')->nullable();
            $table->integer('monthly_downloads')->nullable();
            $table->integer('new_customers')->nullable();

            // Store identifiers
            $table->string('apple_id', 20)->nullable()->index();
            $table->string('bundle_id', 255)->nullable()->index();
            $table->string('app_store_url', 500)->nullable();
            $table->string('play_store_url', 500)->nullable();

            // Platform and business info
            $table->enum('platform', ['ios', 'android', 'both'])->default('ios');
            $table->string('credential_type', 50)->default('unknown');
            $table->enum('business_model', ['subscription', 'one_time', 'freemium', 'free', 'unknown'])->default('unknown');

            // Additional metadata
            $table->boolean('is_for_sale')->default(false);
            $table->bigInteger('asking_price_cents')->nullable();
            $table->boolean('revenue_verified')->default(false);
            $table->decimal('ios_rating', 2, 1)->nullable();
            $table->decimal('android_rating', 2, 1)->nullable();
            $table->string('logo_url', 500)->nullable();
            $table->text('description')->nullable();

            // Tracking
            $table->timestamp('scraped_at')->nullable();
            $table->timestamps();

            // Unique constraint: one entry per source + source_id
            $table->unique(['source', 'source_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('revenue_apps');
    }
};
