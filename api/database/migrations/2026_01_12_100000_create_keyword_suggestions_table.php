<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('keyword_suggestions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('app_id')->constrained()->onDelete('cascade');
            $table->string('keyword');
            $table->string('source')->default('app_name'); // app_name, app_description
            $table->unsignedSmallInteger('position')->nullable(); // Current rank if any
            $table->unsignedSmallInteger('competition')->default(0); // Number of competing apps
            $table->unsignedTinyInteger('difficulty')->default(0); // 0-100 score
            $table->string('difficulty_label')->default('easy'); // easy, medium, hard, very_hard
            $table->json('top_competitors')->nullable(); // Top 3 competing apps
            $table->string('country', 2)->default('US');
            $table->timestamp('generated_at')->nullable();
            $table->timestamps();

            // Unique constraint: one suggestion per keyword per app per country
            $table->unique(['app_id', 'keyword', 'country']);

            // Index for fast lookups
            $table->index(['app_id', 'country']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('keyword_suggestions');
    }
};
