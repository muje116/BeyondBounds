$ErrorActionPreference = "Stop"

$dirs = @(
  "plugins/beyondbounds/clinic/controllers/services",
  "plugins/beyondbounds/clinic/controllers/team",
  "plugins/beyondbounds/clinic/controllers/packages",
  "plugins/beyondbounds/clinic/controllers/testimonials",
  "plugins/beyondbounds/clinic/controllers/bookings",
  "plugins/beyondbounds/clinic/controllers/contacts"
)
$dirs | ForEach-Object { New-Item -ItemType Directory -Force $_ | Out-Null }

@'
1.0.1:
    - Initialize BeyondBounds Clinic plugin
    - create_services_table.php
    - create_team_table.php
    - create_packages_table.php
    - create_testimonials_table.php
    - create_bookings_table.php
    - create_contacts_table.php
1.0.2:
    - Seed default data
    - seed_default_data.php
'@ | Set-Content plugins/beyondbounds/clinic/updates/version.yaml

@'
<?php
use October\Rain\Database\Schema\Blueprint;
use October\Rain\Database\Updates\Migration;
use Schema;
class CreateServicesTable extends Migration {
  public function up(){ Schema::create('beyondbounds_clinic_services', function (Blueprint $table) {
    $table->id(); $table->string('name'); $table->string('slug')->unique(); $table->text('short_description');
    $table->longText('full_description')->nullable(); $table->string('icon_class')->nullable(); $table->string('category');
    $table->boolean('is_featured')->default(false); $table->integer('sort_order')->default(0); $table->boolean('is_active')->default(true); $table->timestamps();
  });}
  public function down(){ Schema::dropIfExists('beyondbounds_clinic_services');}
}
'@ | Set-Content plugins/beyondbounds/clinic/updates/create_services_table.php

@'
<?php
use October\Rain\Database\Updates\Seeder;
use BeyondBounds\Clinic\Models\Service;
use BeyondBounds\Clinic\Models\TeamMember;
use BeyondBounds\Clinic\Models\OrgPackage;
class SeedDefaultData extends Seeder {
  public function run(){
    $services=[['Back Pain Treatment','musculoskeletal',true],['Sports Injury Rehabilitation','sports',true],['Post-Fracture Rehabilitation','musculoskeletal',false],['Burns Rehabilitation','rehabilitation',false],['Hip Replacement Recovery','rehabilitation',true],['Stroke Rehabilitation','neurological',true],['Spinal Cord Injury Therapy','neurological',false],['Muscle Pain Management','musculoskeletal',false],['Sprains & Strains Treatment','sports',false],['Joint Pain Therapy','musculoskeletal',false],['Post-Surgery Rehabilitation','rehabilitation',true],['Ergonomics Assessment','wellness',true],['Aerobics Classes','wellness',false],['Pilates Sessions','wellness',false]];
    foreach($services as $i=>$s){ Service::updateOrCreate(['slug'=>\Str::slug($s[0])],['name'=>$s[0],'short_description'=>$s[0].' with personalized physiotherapy care.','category'=>$s[1],'is_featured'=>$s[2],'sort_order'=>$i,'is_active'=>1]); }
    $team=[['Kumbiro Mlowoka','Executive Director'],['Yvonne Muonja Chabvi','Executive Director'],['Paul Kwengwere','Operations Director'],['Scholastica Mgwadira','Physiotherapist'],['Yankho Mhango','Physiotherapist']];
    foreach($team as $i=>$m){ TeamMember::updateOrCreate(['name'=>$m[0]],['title'=>$m[1],'sort_order'=>$i,'is_active'=>1]); }
    $packages=[['Standard - 30','standard',['Health Talk','Physical Health Assessment'],'Up to 30 individuals','1 Month'],['Standard - 60','standard',['Health Talk','Physical Health Assessment'],'Up to 60 individuals','1 Month'],['Standard - 100','standard',['Health Talk','Physical Health Assessment'],'Up to 100 individuals','1 Month'],['Premium - 30','premium',['Health Talk','Physical Health Assessment','Ergonomic Assessment','Exercise Program'],'Up to 30 individuals','1 Month'],['Premium - 60','premium',['Health Talk','Physical Health Assessment','Ergonomic Assessment','Exercise Program'],'Up to 60 individuals','1 Month'],['Premium - 100','premium',['Health Talk','Physical Health Assessment','Ergonomic Assessment','Exercise Program'],'Up to 100 individuals','1 Month'],['Health Talks','standalone',['Health Talks'],'Up to 20 individuals','1 Month'],['Physical Health Assessment','standalone',['Physical Health Assessment'],'Up to 20 individuals','1 Week'],['Ergonomic Assessment','standalone',['Ergonomic Assessment'],'Up to 20 individuals','1 Week'],['Fitness and Exercise Program','standalone',['Fitness Program'],'Up to 20 individuals','1 Month']];
    foreach($packages as $i=>$p){ OrgPackage::updateOrCreate(['name'=>$p[0]],['tier'=>$p[1],'includes'=>$p[2],'org_size'=>$p[3],'duration'=>$p[4],'sort_order'=>$i,'is_active'=>1]); }
  }
}
'@ | Set-Content plugins/beyondbounds/clinic/updates/seed_default_data.php

@'
<?php namespace BeyondBounds\Clinic\Components;
use Cms\Classes\ComponentBase; use BeyondBounds\Clinic\Models\Booking;
class BookingForm extends ComponentBase {
  public function componentDetails(){ return ['name'=>'Booking Form','description'=>'Handles booking submissions']; }
  public function onSubmitBooking(){
    $d=post(); $v=\Validator::make($d,['full_name'=>'required|string|max:255','email'=>'required|email','phone'=>'required|string','service_requested'=>'required|string','preferred_date'=>'required|date|after:today','preferred_time'=>'required|string']);
    if($v->fails()) throw new \ValidationException($v);
    $b=new Booking(); $b->fill($d); $b->save();
    \Mail::send('beyondbounds.clinic::mail.booking_confirmation',['booking'=>$b],function($m) use($b){$m->to($b->email,$b->full_name);$m->subject('Booking Request Received - Beyond Bounds Physiotherapy');});
    \Mail::send('beyondbounds.clinic::mail.booking_admin',['booking'=>$b],function($m){$m->to('beyondboundsclinic@gmail.com','Beyond Bounds Admin');$m->subject('New Booking Request');});
    return ['success'=>true,'message'=>'Thank you! We will confirm your booking shortly.'];
  }
}
'@ | Set-Content plugins/beyondbounds/clinic/components/BookingForm.php

@'
<?php namespace BeyondBounds\Clinic\Components;
use Cms\Classes\ComponentBase; use BeyondBounds\Clinic\Models\Contact;
class ContactForm extends ComponentBase {
  public function componentDetails(){ return ['name'=>'Contact Form','description'=>'Handles contact submissions']; }
  public function onSubmitContact(){
    $d=post(); $v=\Validator::make($d,['name'=>'required|string|max:255','email'=>'required|email','subject'=>'required|string|max:255','message'=>'required|string']);
    if($v->fails()) throw new \ValidationException($v);
    $c=new Contact(); $c->fill($d); $c->save();
    \Mail::send('beyondbounds.clinic::mail.contact_admin',['contact'=>$c],function($m){$m->to('beyondboundsclinic@gmail.com','Beyond Bounds Admin');$m->subject('New Contact Message');});
    return ['success'=>true,'message'=>'Thank you! Your message has been sent.'];
  }
}
'@ | Set-Content plugins/beyondbounds/clinic/components/ContactForm.php

@'
<p>New booking request has been submitted.</p>
<p><strong>Name:</strong> {{ booking.full_name }}</p>
<p><strong>Email:</strong> {{ booking.email }}</p>
<p><strong>Phone:</strong> {{ booking.phone }}</p>
'@ | Set-Content plugins/beyondbounds/clinic/views/mail/booking_admin.htm

@'
<p>New contact message received.</p>
<p><strong>Name:</strong> {{ contact.name }}</p>
<p><strong>Email:</strong> {{ contact.email }}</p>
<p><strong>Subject:</strong> {{ contact.subject }}</p>
<p>{{ contact.message }}</p>
'@ | Set-Content plugins/beyondbounds/clinic/views/mail/contact_admin.htm

@'
modelClass: BeyondBounds\Clinic\Models\Service
title: Services
recordUrl: beyondbounds/clinic/services/update/:id
toolbar:
    buttons: list_toolbar
columns:
    name: { label: Name, searchable: true }
    category: { label: Category }
    is_featured: { label: Featured, type: switch }
    is_active: { label: Active, type: switch }
    sort_order: { label: Order }
'@ | Set-Content plugins/beyondbounds/clinic/controllers/services/config_list.yaml

@'
name: Service
modelClass: BeyondBounds\Clinic\Models\Service
form:
    fields:
        name: { label: Service Name, type: text, required: true }
        slug:
            label: URL Slug
            type: text
            preset: { field: name, type: slug }
        category:
            label: Category
            type: dropdown
            options:
                musculoskeletal: Musculoskeletal
                neurological: Neurological
                sports: Sports Injuries
                rehabilitation: Rehabilitation
                wellness: Wellness and Fitness
        short_description: { label: Short Description, type: textarea, size: small }
        full_description: { label: Full Description, type: richeditor }
        icon_class: { label: Icon Class, type: text }
        is_featured: { label: Featured on Homepage, type: switch }
        is_active: { label: Active, type: switch }
        sort_order: { label: Sort Order, type: number }
        image: { label: Service Image, type: fileupload, mode: image }
'@ | Set-Content plugins/beyondbounds/clinic/controllers/services/config_form.yaml

@'
title: Reorder Services
modelClass: BeyondBounds\Clinic\Models\Service
nameFrom: name
'@ | Set-Content plugins/beyondbounds/clinic/controllers/services/config_reorder.yaml

@'
<div data-control="toolbar"><a href="<?= Backend::url($this->action . "/create") ?>" class="btn btn-primary oc-icon-plus">Create</a></div>
'@ | Set-Content plugins/beyondbounds/clinic/controllers/services/_list_toolbar.htm

$controllers = @("Team","Packages","Testimonials","Bookings","Contacts")
foreach($controller in $controllers){
  $folder = "plugins/beyondbounds/clinic/controllers/" + $controller.ToLower()
  $model = if($controller -eq "Team"){"TeamMember"}elseif($controller -eq "Packages"){"OrgPackage"}elseif($controller -eq "Testimonials"){"Testimonial"}elseif($controller -eq "Bookings"){"Booking"}else{"Contact"}
  $field = if($controller -eq "Testimonials"){"client_name"}elseif($controller -eq "Bookings"){"full_name"}else{"name"}
  @"
modelClass: BeyondBounds\Clinic\Models\$model
title: $model
recordUrl: beyondbounds/clinic/$($controller.ToLower())/update/:id
toolbar:
    buttons: list_toolbar
columns:
    ${field}: { label: Name, searchable: true }
"@ | Set-Content "$folder/config_list.yaml"
  @"
name: $model
modelClass: BeyondBounds\Clinic\Models\$model
form:
    fields:
        ${field}: { label: Name, type: text, required: true }
"@ | Set-Content "$folder/config_form.yaml"
  @"
title: Reorder $model
modelClass: BeyondBounds\Clinic\Models\$model
nameFrom: $field
"@ | Set-Content "$folder/config_reorder.yaml"
  @'
<div data-control="toolbar"><a href="<?= Backend::url($this->action . "/create") ?>" class="btn btn-primary oc-icon-plus">Create</a></div>
'@ | Set-Content "$folder/_list_toolbar.htm"
}

$cms = Get-Content config/cms.php -Raw
$cms = $cms -replace "'activeTheme'\s*=>\s*'[^']*'", "'activeTheme' => 'beyondbounds'"
$cms = $cms -replace "'backendUri'\s*=>\s*'[^']*'", "'backendUri' => '/clinic-admin'"
Set-Content config/cms.php $cms
