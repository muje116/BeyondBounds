<?php namespace BeyondBounds\Clinic\Components; use Cms\Classes\ComponentBase; use BeyondBounds\Clinic\Models\TeamMember;
class TeamMembers extends ComponentBase { public function componentDetails(){return ['name'=>'Team Members','description'=>'Lists team'];} public function onRun(){ $this->page['team']=TeamMember::where('is_active',1)->orderBy('sort_order')->get(); } }
