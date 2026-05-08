<?php namespace BeyondBounds\Clinic\Components; use Cms\Classes\ComponentBase; use BeyondBounds\Clinic\Models\Testimonial;
class Testimonials extends ComponentBase { public function componentDetails(){return ['name'=>'Testimonials','description'=>'Lists testimonials'];} public function onRun(){ $this->page['testimonials']=Testimonial::where('is_active',1)->get(); } }
