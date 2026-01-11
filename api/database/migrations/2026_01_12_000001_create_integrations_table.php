<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('integrations', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->enum('type', [
                'app_store_connect',
                'google_play_console',
                'apple_search_ads',
                'stripe',
                'slack',
                'webhook'
            ]);
            $table->enum('status', ['pending', 'active', 'error', 'revoked'])->default('pending');
            $table->text('credentials')->nullable(); // Encrypted JSON
            $table->json('metadata')->nullable();
            $table->timestamp('last_sync_at')->nullable();
            $table->text('error_message')->nullable();
            $table->timestamps();

            $table->unique(['user_id', 'type']);
            $table->index(['user_id', 'status']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('integrations');
    }
};
