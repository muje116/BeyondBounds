<?php

use October\Rain\Database\Schema\Blueprint;
use October\Rain\Database\Updates\Migration;

class CreateFeaturesTable extends Migration
{
    public function up()
    {
        \Schema::create('beyondbounds_clinic_features', function (Blueprint $table) {
            $table->id();
            $table->string('title');
            $table->string('slug')->unique();
            $table->string('subtitle')->nullable();
            $table->text('description')->nullable();
            $table->string('icon_class')->nullable();
            $table->string('page_scope')->default('home');
            $table->string('layout_variant')->default('card');
            $table->boolean('is_featured')->default(false);
            $table->integer('sort_order')->default(0);
            $table->boolean('is_active')->default(true);
            $table->timestamps();
        });
    }

    public function down()
    {
        \Schema::dropIfExists('beyondbounds_clinic_features');
    }
}

