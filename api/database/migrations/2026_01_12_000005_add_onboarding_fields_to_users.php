<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->string('onboarding_step', 20)->nullable()->after('remember_token');
            $table->timestamp('onboarding_completed_at')->nullable()->after('onboarding_step');
        });

        // Mark existing users with apps as onboarded
        DB::table('users')
            ->whereNull('onboarding_completed_at')
            ->whereExists(function ($query) {
                $query->select(DB::raw(1))
                    ->from('user_apps')
                    ->whereColumn('user_apps.user_id', 'users.id');
            })
            ->update([
                'onboarding_step' => 'completed',
                'onboarding_completed_at' => now(),
            ]);
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn(['onboarding_step', 'onboarding_completed_at']);
        });
    }
};
