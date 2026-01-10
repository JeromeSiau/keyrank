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
        Schema::create('top_app_entries', function (Blueprint $table) {
            $table->id();
            $table->string('platform', 10)->index();
            $table->string('category_id', 50)->index();
            $table->string('collection', 20)->default('top_free');
            $table->string('country', 5)->default('us');
            $table->string('store_id');
            $table->string('name');
            $table->string('developer')->nullable();
            $table->string('icon_url', 500)->nullable();
            $table->decimal('rating', 2, 1)->nullable();
            $table->unsignedInteger('rating_count')->nullable();
            $table->unsignedSmallInteger('position');
            $table->date('recorded_at')->index();
            $table->timestamps();

            $table->unique([
                'platform', 'category_id', 'collection',
                'country', 'store_id', 'recorded_at'
            ], 'unique_top_entry');
            $table->index(['category_id', 'recorded_at']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('top_app_entries');
    }
};
