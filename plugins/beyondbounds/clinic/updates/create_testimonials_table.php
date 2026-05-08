<?php use October\Rain\Database\Schema\Blueprint; use October\Rain\Database\Updates\Migration; class CreateTestimonialsTable extends Migration { public function up(){ \Schema::create('beyondbounds_clinic_testimonials', function (Blueprint $table){ $table->id(); $table->string('client_name'); $table->text('quote'); $table->tinyInteger('rating')->default(5); $table->boolean('is_active')->default(true); $table->timestamps();}); } public function down(){ \Schema::dropIfExists('beyondbounds_clinic_testimonials');}}


