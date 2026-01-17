<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('chat_actions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('message_id')->constrained('chat_messages')->cascadeOnDelete();
            $table->string('type'); // addKeyword, removeKeyword, createAlert, updateMetadata, addCompetitor, exportData, generateReport
            $table->json('parameters'); // Action-specific parameters
            $table->string('status')->default('proposed'); // proposed, confirmed, cancelled, executed, failed
            $table->text('explanation'); // Human-readable explanation of what the action will do
            $table->boolean('reversible')->default(true); // Whether the action can be undone
            $table->json('result')->nullable(); // Execution result (success data or error)
            $table->timestamps();

            $table->index('status');
            $table->index(['message_id', 'status']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('chat_actions');
    }
};
