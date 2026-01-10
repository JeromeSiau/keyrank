<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('alert_rules', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->string('name');
            $table->enum('type', [
                'position_change',
                'rating_change',
                'review_spike',
                'review_keyword',
                'new_competitor',
                'competitor_passed',
                'mass_movement',
                'keyword_popularity',
                'opportunity',
            ]);
            $table->enum('scope_type', ['global', 'app', 'category', 'keyword'])->default('global');
            $table->unsignedBigInteger('scope_id')->nullable();
            $table->json('conditions');
            $table->boolean('is_template')->default(false);
            $table->boolean('is_active')->default(true);
            $table->integer('priority')->default(0);
            $table->timestamps();

            $table->index(['user_id', 'type', 'is_active']);
            $table->index(['user_id', 'scope_type', 'scope_id']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('alert_rules');
    }
};
