<?php namespace BeyondBounds\Clinic\Components; use Cms\Classes\ComponentBase; use BeyondBounds\Clinic\Models\OrgPackage;
class Packages extends ComponentBase { public function componentDetails(){return ['name'=>'Packages','description'=>'Lists packages'];} public function onRun(){ $this->page['packages']=OrgPackage::where('is_active',1)->orderBy('sort_order')->get(); } }
