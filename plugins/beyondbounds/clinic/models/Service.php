<?php namespace BeyondBounds\Clinic\Models; use Model;
class Service extends Model {
  use \October\Rain\Database\Traits\Validation;
  use \October\Rain\Database\Traits\Sortable;

  public $table='beyondbounds_clinic_services';
  public $rules=['name'=>'required','slug'=>'required'];
  public $fillable=['name','slug','short_description','full_description','icon_class','category','is_featured','sort_order','is_active'];
  public $attachOne=['image'=>\System\Models\File::class];

  public function beforeValidate(){
    if(!$this->slug && $this->name){
      $this->slug=\Str::slug($this->name);
    }
  }
}
