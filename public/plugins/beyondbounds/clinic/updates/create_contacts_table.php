<?php use October\Rain\Database\Schema\Blueprint; use October\Rain\Database\Updates\Migration; class CreateContactsTable extends Migration { public function up(){ \Schema::create('beyondbounds_clinic_contacts', function (Blueprint $table){ $table->id(); $table->string('name'); $table->string('email'); $table->string('phone')->nullable(); $table->string('subject'); $table->text('message'); $table->boolean('is_read')->default(false); $table->timestamps();}); } public function down(){ \Schema::dropIfExists('beyondbounds_clinic_contacts');}}


