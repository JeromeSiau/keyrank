<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('app_reviews', function (Blueprint $table) {
            $table->id();
            $table->foreignId('app_id')->constrained()->cascadeOnDelete();
            $table->string('country', 5);
            $table->string('review_id')->nullable(); // Apple's review ID
            $table->string('author');
            $table->string('title')->nullable();
            $table->text('content');
            $table->unsignedTinyInteger('rating'); // 1-5
            $table->string('version')->nullable(); // App version reviewed
            $table->timestamp('reviewed_at');
            $table->timestamps();

            $table->unique(['app_id', 'country', 'review_id']);
            $table->index(['app_id', 'country']);
            $table->index(['app_id', 'reviewed_at']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('app_reviews');
    }
};
