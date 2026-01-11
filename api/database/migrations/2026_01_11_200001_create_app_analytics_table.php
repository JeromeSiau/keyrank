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
        Schema::create('app_analytics', function (Blueprint $table) {
            $table->id();
            $table->foreignId('app_id')->constrained()->onDelete('cascade');
            $table->date('date');
            $table->string('country_code', 3);
            $table->unsignedInteger('downloads')->default(0);
            $table->unsignedInteger('updates')->default(0);
            $table->decimal('revenue', 10, 2)->default(0);
            $table->decimal('proceeds', 10, 2)->default(0);
            $table->decimal('refunds', 10, 2)->default(0);
            $table->unsignedInteger('subscribers_new')->default(0);
            $table->unsignedInteger('subscribers_cancelled')->default(0);
            $table->unsignedInteger('subscribers_active')->default(0);
            $table->timestamps();

            $table->unique(['app_id', 'date', 'country_code']);
            $table->index(['app_id', 'date']);
            $table->index(['app_id', 'country_code', 'date']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('app_analytics');
    }
};
