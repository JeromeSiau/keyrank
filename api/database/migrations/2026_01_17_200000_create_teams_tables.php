<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // Teams table
        Schema::create('teams', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('slug')->unique();
            $table->text('description')->nullable();
            $table->foreignId('owner_id')->constrained('users')->cascadeOnDelete();
            $table->json('settings')->nullable();
            $table->timestamps();

            $table->index('owner_id');
        });

        // Team members pivot table
        Schema::create('team_members', function (Blueprint $table) {
            $table->id();
            $table->foreignId('team_id')->constrained()->cascadeOnDelete();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->enum('role', ['owner', 'admin', 'editor', 'viewer'])->default('viewer');
            $table->timestamps();

            $table->unique(['team_id', 'user_id']);
            $table->index(['user_id', 'role']);
        });

        // Team invitations table
        Schema::create('team_invitations', function (Blueprint $table) {
            $table->id();
            $table->foreignId('team_id')->constrained()->cascadeOnDelete();
            $table->foreignId('inviter_id')->constrained('users')->cascadeOnDelete();
            $table->string('email');
            $table->enum('role', ['admin', 'editor', 'viewer'])->default('viewer');
            $table->string('token', 64)->unique();
            $table->enum('status', ['pending', 'accepted', 'declined', 'expired'])->default('pending');
            $table->timestamp('expires_at');
            $table->timestamp('accepted_at')->nullable();
            $table->timestamps();

            $table->index(['email', 'status']);
            $table->index(['token', 'status']);
            $table->index(['team_id', 'status']);
        });

        // Team apps pivot table - links apps to teams
        Schema::create('team_apps', function (Blueprint $table) {
            $table->id();
            $table->foreignId('team_id')->constrained()->cascadeOnDelete();
            $table->foreignId('app_id')->constrained()->cascadeOnDelete();
            $table->foreignId('added_by')->nullable()->constrained('users')->nullOnDelete();
            // Columns migrated from user_apps
            $table->boolean('is_owner')->default(false);
            $table->string('ownership_type')->nullable(); // 'app_store_connect', 'play_console', etc.
            $table->foreignId('integration_id')->nullable()->constrained()->nullOnDelete();
            $table->string('tag')->nullable();
            $table->boolean('is_favorite')->default(false);
            $table->timestamp('favorited_at')->nullable();
            $table->timestamps();

            $table->unique(['team_id', 'app_id']);
            $table->index(['team_id', 'is_favorite']);
        });

        // Add current_team_id to users for quick team context switching
        Schema::table('users', function (Blueprint $table) {
            $table->foreignId('current_team_id')->nullable()->after('id')->constrained('teams')->nullOnDelete();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropConstrainedForeignId('current_team_id');
        });

        Schema::dropIfExists('team_apps');
        Schema::dropIfExists('team_invitations');
        Schema::dropIfExists('team_members');
        Schema::dropIfExists('teams');
    }
};
