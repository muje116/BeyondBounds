<?php namespace BeyondBounds\Clinic;
use Backend;
use System\Classes\PluginBase;
class Plugin extends PluginBase {
  public function pluginDetails(){ return ['name'=>'Beyond Bounds Clinic','description'=>'Clinic content','author'=>'Beyond Bounds','icon'=>'icon-heartbeat']; }
  public function registerComponents(){ return [
    'BeyondBounds\Clinic\Components\Services'=>'clinicServices',
    'BeyondBounds\Clinic\Components\Features'=>'clinicFeatures',
    'BeyondBounds\Clinic\Components\TeamMembers'=>'teamMembers',
    'BeyondBounds\Clinic\Components\Packages'=>'orgPackages',
    'BeyondBounds\Clinic\Components\SiteSettings'=>'siteSettings',
    'BeyondBounds\Clinic\Components\ViteAssets'=>'viteAssets',
    'BeyondBounds\Clinic\Components\BookingForm'=>'bookingForm',
    'BeyondBounds\Clinic\Components\ContactForm'=>'contactForm',
    'BeyondBounds\Clinic\Components\Testimonials'=>'testimonials',
  ]; }
  public function registerPermissions(){ return ['beyondbounds.clinic.*'=>['tab'=>'Clinic','label'=>'Manage clinic']]; }
  public function registerSettings()
  {
    return [
      'settings' => [
        'label' => 'Site Settings',
        'description' => 'Global website content (contact info, vision, mission, social links).',
        'category' => 'Clinic',
        'icon' => 'icon-cog',
        'class' => 'BeyondBounds\Clinic\Models\Settings',
        'keywords' => 'beyond bounds clinic website settings contact vision mission',
        'permissions' => ['beyondbounds.clinic.*'],
        'order' => 10,
      ],
    ];
  }
  public function registerNavigation(){ return ['clinic'=>[
    'label'=>'Clinic',
    'url'=>Backend::url('beyondbounds/clinic/services'),
    'icon'=>'icon-heartbeat',
    'permissions'=>['beyondbounds.clinic.*'],
    'order'=>500,
    'sideMenu'=>[
      'services'=>['label'=>'Services','icon'=>'icon-stethoscope','url'=>Backend::url('beyondbounds/clinic/services')],
      'features'=>['label'=>'Features','icon'=>'icon-star','url'=>Backend::url('beyondbounds/clinic/features')],
      'team'=>['label'=>'Team','icon'=>'icon-users','url'=>Backend::url('beyondbounds/clinic/team')],
      'packages'=>['label'=>'Packages','icon'=>'icon-suitcase','url'=>Backend::url('beyondbounds/clinic/packages')],
      'testimonials'=>['label'=>'Testimonials','icon'=>'icon-quote-left','url'=>Backend::url('beyondbounds/clinic/testimonials')],
      'bookings'=>['label'=>'Bookings','icon'=>'icon-calendar','url'=>Backend::url('beyondbounds/clinic/bookings')],
      'contacts'=>['label'=>'Contacts','icon'=>'icon-envelope','url'=>Backend::url('beyondbounds/clinic/contacts')]
    ]
  ]]; }
}
