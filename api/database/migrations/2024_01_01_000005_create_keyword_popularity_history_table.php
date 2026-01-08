<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('keyword_popularity_history', function (Blueprint $table) {
            $table->id();
            $table->foreignId('keyword_id')->constrained()->cascadeOnDelete();
            $table->unsignedTinyInteger('popularity');
            $table->date('recorded_at');

            $table->unique(['keyword_id', 'recorded_at']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('keyword_popularity_history');
    }
};
