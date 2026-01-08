<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('app_rankings', function (Blueprint $table) {
            $table->id();
            $table->foreignId('app_id')->constrained()->cascadeOnDelete();
            $table->foreignId('keyword_id')->constrained()->cascadeOnDelete();
            $table->unsignedSmallInteger('position')->nullable(); // 1-200 or null if not ranked
            $table->date('recorded_at');

            $table->unique(['app_id', 'keyword_id', 'recorded_at']);
            $table->index(['app_id', 'recorded_at']);
            $table->index(['keyword_id', 'recorded_at']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('app_rankings');
    }
};
