<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('tracked_keywords', function (Blueprint $table) {
            $table->unsignedTinyInteger('difficulty')->nullable()->after('favorited_at');
            $table->string('difficulty_label', 20)->nullable()->after('difficulty');
            $table->unsignedSmallInteger('competition')->nullable()->after('difficulty_label');
            $table->json('top_competitors')->nullable()->after('competition');
        });
    }

    public function down(): void
    {
        Schema::table('tracked_keywords', function (Blueprint $table) {
            $table->dropColumn(['difficulty', 'difficulty_label', 'competition', 'top_competitors']);
        });
    }
};
