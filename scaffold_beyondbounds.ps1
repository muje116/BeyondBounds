$ErrorActionPreference = "Stop"

$dirs = @(
  "plugins/beyondbounds/clinic/components",
  "plugins/beyondbounds/clinic/models",
  "plugins/beyondbounds/clinic/updates",
  "plugins/beyondbounds/clinic/views/mail",
  "themes/beyondbounds/layouts",
  "themes/beyondbounds/pages",
  "themes/beyondbounds/partials/nav",
  "themes/beyondbounds/assets/css",
  "themes/beyondbounds/assets/js"
)
$dirs | ForEach-Object { New-Item -ItemType Directory -Force -Path $_ | Out-Null }

@'
<?php namespace BeyondBounds\Clinic;
use Backend;
use System\Classes\PluginBase;
class Plugin extends PluginBase {
  public function pluginDetails(){ return ['name'=>'Beyond Bounds Clinic','description'=>'Clinic content','author'=>'Beyond Bounds','icon'=>'icon-heartbeat']; }
  public function registerComponents(){ return [
    'BeyondBounds\Clinic\Components\Services'=>'clinicServices',
    'BeyondBounds\Clinic\Components\TeamMembers'=>'teamMembers',
    'BeyondBounds\Clinic\Components\Packages'=>'orgPackages',
    'BeyondBounds\Clinic\Components\BookingForm'=>'bookingForm',
    'BeyondBounds\Clinic\Components\ContactForm'=>'contactForm',
    'BeyondBounds\Clinic\Components\Testimonials'=>'testimonials',
  ]; }
  public function registerPermissions(){ return ['beyondbounds.clinic.*'=>['tab'=>'Clinic','label'=>'Manage clinic']]; }
  public function registerNavigation(){ return ['clinic'=>['label'=>'Clinic','url'=>Backend::url('beyondbounds/clinic/services'),'icon'=>'icon-heartbeat','permissions'=>['beyondbounds.clinic.*'],'order'=>500]]; }
}
'@ | Set-Content plugins/beyondbounds/clinic/Plugin.php

@'
1.0.1:
    - Init clinic plugin
    - create_services_table.php
    - create_team_table.php
    - create_packages_table.php
    - create_testimonials_table.php
    - create_bookings_table.php
    - create_contacts_table.php
'@ | Set-Content plugins/beyondbounds/clinic/updates/version.yaml

@'
<?php
use October\Rain\Database\Schema\Blueprint;
use October\Rain\Database\Updates\Migration;
use Schema;
class CreateServicesTable extends Migration {
  public function up(){ Schema::create('beyondbounds_clinic_services', function (Blueprint $table) { $table->id(); $table->string('name'); $table->string('slug')->unique(); $table->text('short_description'); $table->string('category'); $table->boolean('is_featured')->default(false); $table->integer('sort_order')->default(0); $table->boolean('is_active')->default(true); $table->timestamps();});}
  public function down(){ Schema::dropIfExists('beyondbounds_clinic_services');}
}
'@ | Set-Content plugins/beyondbounds/clinic/updates/create_services_table.php

@'
<?php use October\Rain\Database\Schema\Blueprint; use October\Rain\Database\Updates\Migration; use Schema;
class CreateTeamTable extends Migration { public function up(){ Schema::create('beyondbounds_clinic_team', function (Blueprint $table){ $table->id(); $table->string('name'); $table->string('title'); $table->text('bio')->nullable(); $table->string('qualifications')->nullable(); $table->string('specializations')->nullable(); $table->integer('sort_order')->default(0); $table->boolean('is_active')->default(true); $table->timestamps();}); } public function down(){ Schema::dropIfExists('beyondbounds_clinic_team');}}
'@ | Set-Content plugins/beyondbounds/clinic/updates/create_team_table.php

@'
<?php use October\Rain\Database\Schema\Blueprint; use October\Rain\Database\Updates\Migration; use Schema;
class CreatePackagesTable extends Migration { public function up(){ Schema::create('beyondbounds_clinic_packages', function (Blueprint $table){ $table->id(); $table->string('name'); $table->enum('tier',['standard','premium','standalone']); $table->json('includes')->nullable(); $table->string('org_size'); $table->string('duration'); $table->decimal('price_mwk',12,2)->nullable(); $table->text('description')->nullable(); $table->boolean('is_featured')->default(false); $table->integer('sort_order')->default(0); $table->boolean('is_active')->default(true); $table->timestamps();}); } public function down(){ Schema::dropIfExists('beyondbounds_clinic_packages');}}
'@ | Set-Content plugins/beyondbounds/clinic/updates/create_packages_table.php

@'
<?php use October\Rain\Database\Schema\Blueprint; use October\Rain\Database\Updates\Migration; use Schema;
class CreateTestimonialsTable extends Migration { public function up(){ Schema::create('beyondbounds_clinic_testimonials', function (Blueprint $table){ $table->id(); $table->string('client_name'); $table->text('quote'); $table->tinyInteger('rating')->default(5); $table->boolean('is_active')->default(true); $table->timestamps();}); } public function down(){ Schema::dropIfExists('beyondbounds_clinic_testimonials');}}
'@ | Set-Content plugins/beyondbounds/clinic/updates/create_testimonials_table.php

@'
<?php use October\Rain\Database\Schema\Blueprint; use October\Rain\Database\Updates\Migration; use Schema;
class CreateBookingsTable extends Migration { public function up(){ Schema::create('beyondbounds_clinic_bookings', function (Blueprint $table){ $table->id(); $table->string('full_name'); $table->string('email'); $table->string('phone'); $table->string('service_requested'); $table->date('preferred_date'); $table->string('preferred_time'); $table->enum('booking_type',['individual','organization'])->default('individual'); $table->string('organization_name')->nullable(); $table->integer('org_size')->nullable(); $table->text('notes')->nullable(); $table->enum('status',['pending','confirmed','cancelled','completed'])->default('pending'); $table->timestamps();}); } public function down(){ Schema::dropIfExists('beyondbounds_clinic_bookings');}}
'@ | Set-Content plugins/beyondbounds/clinic/updates/create_bookings_table.php

@'
<?php use October\Rain\Database\Schema\Blueprint; use October\Rain\Database\Updates\Migration; use Schema;
class CreateContactsTable extends Migration { public function up(){ Schema::create('beyondbounds_clinic_contacts', function (Blueprint $table){ $table->id(); $table->string('name'); $table->string('email'); $table->string('phone')->nullable(); $table->string('subject'); $table->text('message'); $table->boolean('is_read')->default(false); $table->timestamps();}); } public function down(){ Schema::dropIfExists('beyondbounds_clinic_contacts');}}
'@ | Set-Content plugins/beyondbounds/clinic/updates/create_contacts_table.php

@'
<?php namespace BeyondBounds\Clinic\Models; use Model;
class Service extends Model { use \October\Rain\Database\Traits\Validation; use \October\Rain\Database\Traits\Sortable; public $table='beyondbounds_clinic_services'; public $rules=['name'=>'required','slug'=>'required']; public $fillable=['name','slug','short_description','category','is_featured','sort_order','is_active']; public function beforeValidate(){ if(!$this->slug && $this->name){ $this->slug=\Str::slug($this->name);} } }
'@ | Set-Content plugins/beyondbounds/clinic/models/Service.php

@'
<?php namespace BeyondBounds\Clinic\Models; use Model;
class TeamMember extends Model { use \October\Rain\Database\Traits\Validation; use \October\Rain\Database\Traits\Sortable; public $table='beyondbounds_clinic_team'; public $rules=['name'=>'required','title'=>'required']; public $attachOne=['photo'=>\System\Models\File::class]; public $fillable=['name','title','bio','qualifications','specializations','sort_order','is_active'];}
'@ | Set-Content plugins/beyondbounds/clinic/models/TeamMember.php

@'
<?php namespace BeyondBounds\Clinic\Models; use Model;
class OrgPackage extends Model { use \October\Rain\Database\Traits\Validation; use \October\Rain\Database\Traits\Sortable; public $table='beyondbounds_clinic_packages'; public $rules=['name'=>'required','tier'=>'required']; protected $jsonable=['includes']; public $fillable=['name','tier','includes','org_size','duration','price_mwk','description','is_featured','sort_order','is_active'];}
'@ | Set-Content plugins/beyondbounds/clinic/models/OrgPackage.php

@'
<?php namespace BeyondBounds\Clinic\Models; use Model; class Testimonial extends Model { use \October\Rain\Database\Traits\Validation; public $table='beyondbounds_clinic_testimonials'; public $rules=['client_name'=>'required','quote'=>'required']; public $fillable=['client_name','quote','rating','is_active'];}
'@ | Set-Content plugins/beyondbounds/clinic/models/Testimonial.php
@'
<?php namespace BeyondBounds\Clinic\Models; use Model; class Booking extends Model { use \October\Rain\Database\Traits\Validation; public $table='beyondbounds_clinic_bookings'; public $rules=['full_name'=>'required','email'=>'required|email']; public $fillable=['full_name','email','phone','service_requested','preferred_date','preferred_time','booking_type','organization_name','org_size','notes','status'];}
'@ | Set-Content plugins/beyondbounds/clinic/models/Booking.php
@'
<?php namespace BeyondBounds\Clinic\Models; use Model; class Contact extends Model { use \October\Rain\Database\Traits\Validation; public $table='beyondbounds_clinic_contacts'; public $rules=['name'=>'required','email'=>'required|email','subject'=>'required','message'=>'required']; public $fillable=['name','email','phone','subject','message','is_read'];}
'@ | Set-Content plugins/beyondbounds/clinic/models/Contact.php

@'
<?php namespace BeyondBounds\Clinic\Components; use Cms\Classes\ComponentBase; use BeyondBounds\Clinic\Models\Service;
class Services extends ComponentBase { public function componentDetails(){return ['name'=>'Clinic Services','description'=>'Lists services'];} public function defineProperties(){return ['featured_only'=>['type'=>'checkbox','default'=>false],'category'=>['type'=>'string','default'=>'']];} public function onRun(){ $q=Service::where('is_active',1)->orderBy('sort_order'); if($this->property('featured_only')) $q->where('is_featured',1); if($c=$this->property('category')) $q->where('category',$c); $this->page['services']=$q->get(); } }
'@ | Set-Content plugins/beyondbounds/clinic/components/Services.php
@'
<?php namespace BeyondBounds\Clinic\Components; use Cms\Classes\ComponentBase; use BeyondBounds\Clinic\Models\TeamMember;
class TeamMembers extends ComponentBase { public function componentDetails(){return ['name'=>'Team Members','description'=>'Lists team'];} public function onRun(){ $this->page['team']=TeamMember::where('is_active',1)->orderBy('sort_order')->get(); } }
'@ | Set-Content plugins/beyondbounds/clinic/components/TeamMembers.php
@'
<?php namespace BeyondBounds\Clinic\Components; use Cms\Classes\ComponentBase; use BeyondBounds\Clinic\Models\OrgPackage;
class Packages extends ComponentBase { public function componentDetails(){return ['name'=>'Packages','description'=>'Lists packages'];} public function onRun(){ $this->page['packages']=OrgPackage::where('is_active',1)->orderBy('sort_order')->get(); } }
'@ | Set-Content plugins/beyondbounds/clinic/components/Packages.php
@'
<?php namespace BeyondBounds\Clinic\Components; use Cms\Classes\ComponentBase; use BeyondBounds\Clinic\Models\Testimonial;
class Testimonials extends ComponentBase { public function componentDetails(){return ['name'=>'Testimonials','description'=>'Lists testimonials'];} public function onRun(){ $this->page['testimonials']=Testimonial::where('is_active',1)->get(); } }
'@ | Set-Content plugins/beyondbounds/clinic/components/Testimonials.php
@'
<?php namespace BeyondBounds\Clinic\Components; use Cms\Classes\ComponentBase; use BeyondBounds\Clinic\Models\Booking;
class BookingForm extends ComponentBase { public function componentDetails(){return ['name'=>'Booking Form','description'=>'Submits bookings'];}
public function onSubmitBooking(){ $d=post(); $v=\Validator::make($d,['full_name'=>'required|string|max:255','email'=>'required|email','phone'=>'required','service_requested'=>'required','preferred_date'=>'required|date|after:today','preferred_time'=>'required']); if($v->fails()) throw new \ValidationException($v); $b=new Booking(); $b->fill($d); $b->save(); \Mail::send('beyondbounds.clinic::mail.booking_confirmation',['booking'=>$b],function($m) use($b){$m->to($b->email,$b->full_name); $m->subject('Booking Request Received — Beyond Bounds Physiotherapy');}); return ['success'=>true,'message'=>'Thank you! We will confirm your booking shortly.']; } }
'@ | Set-Content plugins/beyondbounds/clinic/components/BookingForm.php
@'
<?php namespace BeyondBounds\Clinic\Components; use Cms\Classes\ComponentBase; use BeyondBounds\Clinic\Models\Contact;
class ContactForm extends ComponentBase { public function componentDetails(){return ['name'=>'Contact Form','description'=>'Submits contacts'];}
public function onSubmitContact(){ $d=post(); $v=\Validator::make($d,['name'=>'required','email'=>'required|email','subject'=>'required','message'=>'required']); if($v->fails()) throw new \ValidationException($v); $c=new Contact(); $c->fill($d); $c->save(); return ['success'=>true,'message'=>'Message sent']; } }
'@ | Set-Content plugins/beyondbounds/clinic/components/ContactForm.php

@'
<p>Dear {{ booking.full_name }},</p>
<p>Thank you for booking with Beyond Bounds Physiotherapy Clinic. We have received your request and will confirm your appointment shortly.</p>
<table>
<tr><td><strong>Service:</strong></td><td>{{ booking.service_requested }}</td></tr>
<tr><td><strong>Preferred Date:</strong></td><td>{{ booking.preferred_date }}</td></tr>
<tr><td><strong>Preferred Time:</strong></td><td>{{ booking.preferred_time }}</td></tr>
</table>
'@ | Set-Content plugins/beyondbounds/clinic/views/mail/booking_confirmation.htm

@'
name: Beyond Bounds Physiotherapy
description: Official theme for Beyond Bounds Physiotherapy Clinic
author: Beyond Bounds
homepage: https://beyondboundsclinic.com
code: beyondbounds
'@ | Set-Content themes/beyondbounds/theme.yaml

@'
description = "Default layout"
==
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{% if this.page.title %}{{ this.page.title }} — {% endif %}Beyond Bounds Physiotherapy</title>
  <link rel="stylesheet" href="{{ 'assets/css/app.css'|theme }}">
</head>
<body>
  {% partial 'nav/header' %}
  <main>{% page %}</main>
  {% partial 'nav/footer' %}
  <script type="module" src="{{ 'assets/js/app.js'|theme }}"></script>
</body>
</html>
'@ | Set-Content themes/beyondbounds/layouts/default.htm

@'
<nav class="fixed top-0 left-0 right-0 bg-brand-navy text-white z-40">
  <div class="max-w-7xl mx-auto px-4 h-20 flex items-center justify-between">
    <a href="/" class="font-display font-bold">Beyond Bounds</a>
    <div class="hidden md:flex gap-6">
      <a href="/" class="nav-link">Home</a><a href="/about" class="nav-link">About</a><a href="/services" class="nav-link">Services</a><a href="/for-organizations" class="nav-link">For Organizations</a><a href="/team" class="nav-link">Team</a><a href="/blog" class="nav-link">Blog</a><a href="/contact" class="nav-link">Contact</a>
    </div>
    <a href="/book" class="btn-primary hidden md:inline-flex">Book a Session</a>
  </div>
</nav>
'@ | Set-Content themes/beyondbounds/partials/nav/header.htm

@'
<footer class="bg-brand-navy text-white mt-20"><div class="max-w-7xl mx-auto px-4 py-12"><p class="font-display text-xl">Beyond Bounds Physiotherapy Clinic</p><p class="text-white/70">Bringing Health To You</p></div></footer>
'@ | Set-Content themes/beyondbounds/partials/nav/footer.htm

@'
@tailwind base;
@tailwind components;
@tailwind utilities;
@layer base { body{@apply font-sans text-gray-800;} }
@layer components {
  .btn-primary{@apply inline-flex items-center gap-2 px-6 py-3 bg-brand-teal text-white rounded-lg hover:bg-brand-teal-dark;}
  .nav-link{@apply text-white/80 hover:text-white;}
  .section-heading{@apply font-display text-3xl md:text-4xl font-bold text-brand-navy;}
  .service-card{@apply bg-white rounded-2xl p-6 shadow-sm border border-gray-100;}
}
'@ | Set-Content themes/beyondbounds/assets/css/app.css

@'
import Alpine from 'alpinejs';
window.Alpine = Alpine;
Alpine.start();
'@ | Set-Content themes/beyondbounds/assets/js/app.js

@'
title = "Home — Beyond Bounds Physiotherapy"
url = "/"
layout = "default"
[clinicServices]
featured_only = 1
==
<section class="pt-28 pb-20 bg-brand-navy text-white"><div class="max-w-7xl mx-auto px-4"><h1 class="font-display text-5xl">Bringing Health To You</h1><p class="mt-4 text-white/80">Expert physiotherapy services in Lilongwe, Malawi.</p><a href="/book" class="btn-primary mt-8">Book a Session</a></div></section>
<section class="py-20"><div class="max-w-7xl mx-auto px-4"><h2 class="section-heading">Conditions We Specialise In</h2><div class="grid md:grid-cols-3 gap-6 mt-8">{% for service in services %}<div class="service-card"><h3 class="font-semibold text-brand-navy">{{ service.name }}</h3><p class="text-gray-500 text-sm mt-2">{{ service.short_description }}</p></div>{% endfor %}</div></div></section>
'@ | Set-Content themes/beyondbounds/pages/index.htm

@'
title = "About"
url = "/about"
layout = "default"
==
<section class="pt-28 pb-20"><div class="max-w-5xl mx-auto px-4"><h1 class="section-heading">About Beyond Bounds</h1><p class="mt-6 text-gray-600">Founded November 2020 in Area 47, Lilongwe, Malawi.</p></div></section>
'@ | Set-Content themes/beyondbounds/pages/about.htm

@'
title = "Services"
url = "/services"
layout = "default"
[clinicServices]
==
<section class="pt-28 pb-20"><div class="max-w-7xl mx-auto px-4"><h1 class="section-heading">Our Services</h1><div class="grid md:grid-cols-2 lg:grid-cols-3 gap-6 mt-8">{% for s in services %}<article id="{{ s.slug }}" class="service-card"><h3 class="font-semibold text-brand-navy">{{ s.name }}</h3><p class="text-gray-600 mt-2">{{ s.short_description }}</p></article>{% endfor %}</div></div></section>
'@ | Set-Content themes/beyondbounds/pages/services.htm

@'
title = "For Organizations"
url = "/for-organizations"
layout = "default"
[orgPackages]
==
<section class="pt-28 pb-20 bg-brand-navy text-white"><div class="max-w-7xl mx-auto px-4"><h1 class="font-display text-4xl">Corporate Wellness Packages</h1></div></section>
<section class="py-16"><div class="max-w-7xl mx-auto px-4"><table class="min-w-full"><thead><tr><th class="text-left p-3">Name</th><th class="text-left p-3">Tier</th><th class="text-left p-3">Size</th><th class="text-left p-3">Duration</th></tr></thead><tbody>{% for p in packages %}<tr class="border-t"><td class="p-3">{{ p.name }}</td><td class="p-3">{{ p.tier }}</td><td class="p-3">{{ p.org_size }}</td><td class="p-3">{{ p.duration }}</td></tr>{% endfor %}</tbody></table></div></section>
'@ | Set-Content themes/beyondbounds/pages/for-organizations.htm

@'
title = "Team"
url = "/team"
layout = "default"
[teamMembers]
==
<section class="pt-28 pb-20"><div class="max-w-7xl mx-auto px-4"><h1 class="section-heading">Our Team</h1><div class="grid md:grid-cols-3 gap-8 mt-8">{% for m in team %}<div class="service-card"><h3 class="font-semibold text-brand-navy">{{ m.name }}</h3><p class="text-brand-teal">{{ m.title }}</p></div>{% endfor %}</div></div></section>
'@ | Set-Content themes/beyondbounds/pages/team.htm

@'
title = "Book"
url = "/book"
layout = "default"
[bookingForm]
[clinicServices]
==
<section class="pt-28 pb-20"><div class="max-w-3xl mx-auto px-4"><h1 class="section-heading">Book a Session</h1><form data-request="onSubmitBooking" class="grid gap-4 mt-8"><input name="full_name" placeholder="Full Name" required><input type="email" name="email" placeholder="Email" required><input name="phone" placeholder="Phone" required><select name="service_requested">{% for s in services %}<option>{{ s.name }}</option>{% endfor %}</select><input type="date" name="preferred_date" required><select name="preferred_time"><option>08:00</option><option>10:00</option><option>14:00</option></select><button class="btn-primary" type="submit">Submit Booking</button></form></div></section>
'@ | Set-Content themes/beyondbounds/pages/book.htm

@'
title = "Contact"
url = "/contact"
layout = "default"
[contactForm]
==
<section class="pt-28 pb-20"><div class="max-w-3xl mx-auto px-4"><h1 class="section-heading">Contact Us</h1><form data-request="onSubmitContact" class="grid gap-4 mt-8"><input name="name" placeholder="Name" required><input type="email" name="email" placeholder="Email" required><input name="subject" placeholder="Subject" required><textarea name="message" placeholder="Message"></textarea><button class="btn-primary" type="submit">Send Message</button></form></div></section>
'@ | Set-Content themes/beyondbounds/pages/contact.htm

@'
title = "Blog"
url = "/blog"
layout = "default"
[blogPosts]
postPage = "blog-post"
==
<section class="pt-28 pb-20"><div class="max-w-5xl mx-auto px-4"><h1 class="section-heading">Health Blog</h1><div class="mt-8 space-y-6">{% for post in blogPosts.posts %}<article><h3 class="text-xl font-semibold"><a href="{{ post.url }}">{{ post.title }}</a></h3><p class="text-gray-600">{{ post.summary }}</p></article>{% endfor %}</div></div></section>
'@ | Set-Content themes/beyondbounds/pages/blog.htm

@'
title = "Blog Post"
url = "/blog/:slug"
layout = "default"
[blogPost]
slug = "{{ :slug }}"
==
<section class="pt-28 pb-20"><div class="max-w-4xl mx-auto px-4">{% if blogPost.post %}<h1 class="section-heading">{{ blogPost.post.title }}</h1><div class="prose mt-8">{{ blogPost.post.content_html|raw }}</div>{% endif %}</div></section>
'@ | Set-Content themes/beyondbounds/pages/blog-post.htm

@'
import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';
export default defineConfig({
  plugins: [laravel({ input: ['themes/beyondbounds/assets/css/app.css','themes/beyondbounds/assets/js/app.js'], refresh: true })],
  server: { host: '0.0.0.0' }
});
'@ | Set-Content vite.config.js

@'
module.exports = {
  content: ['./themes/beyondbounds/**/*.htm','./themes/beyondbounds/**/*.html','./plugins/beyondbounds/**/*.htm'],
  theme: {
    extend: {
      colors: { brand: { teal:'#00B4D8','teal-dark':'#0077B6',magenta:'#D63384',navy:'#0D1B2A',cream:'#F8F9FA' } },
      fontFamily: { display:['"Playfair Display"','Georgia','serif'], sans:['"DM Sans"','system-ui','sans-serif'] }
    }
  },
  plugins: [require('@tailwindcss/forms'),require('@tailwindcss/typography'),require('@tailwindcss/aspect-ratio')]
}
'@ | Set-Content tailwind.config.js

$cms = Get-Content config/cms.php -Raw
$cms = $cms -replace "'activeTheme'\s*=>\s*'[^']*'","'activeTheme' => 'beyondbounds'"
$cms = $cms -replace "'backendUri'\s*=>\s*'[^']*'","'backendUri' => 'clinic-admin'"
Set-Content config/cms.php $cms
