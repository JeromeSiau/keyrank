<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('apps', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->string('apple_id', 20);
            $table->string('bundle_id')->nullable();
            $table->string('name');
            $table->string('icon_url', 500)->nullable();
            $table->string('developer')->nullable();
            $table->decimal('rating', 2, 1)->nullable();
            $table->unsignedInteger('rating_count')->default(0);
            $table->timestamps();

            $table->unique(['user_id', 'apple_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('apps');
    }
};
