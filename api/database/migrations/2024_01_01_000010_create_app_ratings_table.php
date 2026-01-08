<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('app_ratings', function (Blueprint $table) {
            $table->id();
            $table->foreignId('app_id')->constrained()->cascadeOnDelete();
            $table->string('country', 5); // Country code (us, fr, gb, etc.)
            $table->decimal('rating', 3, 2)->nullable(); // Average rating (0.00 - 5.00)
            $table->unsignedInteger('rating_count')->default(0); // Number of ratings
            $table->timestamp('recorded_at');

            $table->unique(['app_id', 'country', 'recorded_at']);
            $table->index(['app_id', 'country']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('app_ratings');
    }
};
