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
        Schema::table('notifications', function (Blueprint $table) {
            // Track when individual email was sent
            $table->timestamp('email_sent_at')->nullable()->after('sent_at');

            // Track when included in a digest email
            $table->timestamp('digest_sent_at')->nullable()->after('email_sent_at');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('notifications', function (Blueprint $table) {
            $table->dropColumn(['email_sent_at', 'digest_sent_at']);
        });
    }
};
