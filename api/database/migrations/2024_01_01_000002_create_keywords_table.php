<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('keywords', function (Blueprint $table) {
            $table->id();
            $table->string('keyword');
            $table->string('storefront', 5)->default('US');
            $table->unsignedTinyInteger('popularity')->nullable(); // 1-100 from Apple (future)
            $table->timestamp('popularity_updated_at')->nullable();
            $table->timestamp('created_at')->nullable();

            $table->unique(['keyword', 'storefront']);
            $table->index('popularity');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('keywords');
    }
};
