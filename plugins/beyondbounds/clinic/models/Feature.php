<?php namespace BeyondBounds\Clinic\Models;

use Model;

class Feature extends Model
{
    use \October\Rain\Database\Traits\Validation;
    use \October\Rain\Database\Traits\Sortable;

    public $table = 'beyondbounds_clinic_features';

    public $rules = [
        'title' => 'required',
        'slug' => 'required',
        'page_scope' => 'required',
    ];

    public $fillable = [
        'title',
        'slug',
        'subtitle',
        'description',
        'icon_class',
        'page_scope',
        'layout_variant',
        'is_featured',
        'is_active',
        'sort_order',
    ];

    public $attachOne = [
        'image' => \System\Models\File::class,
    ];

    public function beforeValidate()
    {
        if (!$this->slug && $this->title) {
            $this->slug = \Str::slug($this->title);
        }
    }
}

