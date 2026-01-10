<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('apps', function (Blueprint $table) {
            $table->text('description')->nullable()->after('developer');
            $table->json('screenshots')->nullable()->after('description');
            $table->string('version', 50)->nullable()->after('screenshots');
            $table->date('release_date')->nullable()->after('version');
            $table->timestamp('updated_date')->nullable()->after('release_date');
            $table->bigInteger('size_bytes')->nullable()->after('updated_date');
            $table->string('minimum_os', 20)->nullable()->after('size_bytes');
            $table->string('store_url', 500)->nullable()->after('minimum_os');
            $table->decimal('price', 8, 2)->nullable()->after('store_url');
            $table->string('currency', 3)->nullable()->after('price');
        });
    }

    public function down(): void
    {
        Schema::table('apps', function (Blueprint $table) {
            $table->dropColumn([
                'description',
                'screenshots',
                'version',
                'release_date',
                'updated_date',
                'size_bytes',
                'minimum_os',
                'store_url',
                'price',
                'currency',
            ]);
        });
    }
};
