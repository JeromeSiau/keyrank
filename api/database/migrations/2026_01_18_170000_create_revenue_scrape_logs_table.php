<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('revenue_scrape_logs', function (Blueprint $table) {
            $table->id();
            $table->string('source', 50);
            $table->timestamp('started_at');
            $table->timestamp('completed_at')->nullable();
            $table->enum('status', ['running', 'success', 'failed'])->default('running');
            $table->integer('listings_found')->default(0);
            $table->integer('listings_new')->default(0);
            $table->integer('listings_updated')->default(0);
            $table->integer('listings_skipped')->default(0);
            $table->text('error_message')->nullable();
            $table->timestamps();

            $table->index('source');
            $table->index('status');
            $table->index('started_at');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('revenue_scrape_logs');
    }
};
