<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('user_apps', function (Blueprint $table) {
            $table->string('ownership_type', 20)->default('watched')->after('is_owner');
            $table->unsignedBigInteger('integration_id')->nullable()->after('ownership_type');
            $table->string('tag', 50)->nullable()->after('integration_id');
        });

        // Add index for integration_id (MySQL will also use this for FK)
        Schema::table('user_apps', function (Blueprint $table) {
            $table->index('integration_id');
        });

        // Add foreign key constraint for MySQL only (SQLite doesn't support adding FK to existing table)
        if (DB::getDriverName() === 'mysql') {
            Schema::table('user_apps', function (Blueprint $table) {
                $table->foreign('integration_id')
                    ->references('id')
                    ->on('integrations')
                    ->nullOnDelete();
            });
        }

        // Migrate existing is_owner data to ownership_type
        DB::table('user_apps')
            ->where('is_owner', true)
            ->update(['ownership_type' => 'owned']);

        DB::table('user_apps')
            ->where('is_owner', false)
            ->orWhereNull('is_owner')
            ->update(['ownership_type' => 'watched']);
    }

    public function down(): void
    {
        if (DB::getDriverName() === 'mysql') {
            Schema::table('user_apps', function (Blueprint $table) {
                $table->dropForeign(['integration_id']);
            });
        }

        Schema::table('user_apps', function (Blueprint $table) {
            $table->dropIndex(['integration_id']);
            $table->dropColumn(['ownership_type', 'integration_id', 'tag']);
        });
    }
};
