<?php namespace BeyondBounds\Clinic\Models;

use Model;

class Settings extends Model
{
    public $implement = [\System\Behaviors\SettingsModel::class];

    public $settingsCode = 'beyondbounds_clinic_settings';

    public $settingsFields = 'fields.yaml';

    protected $jsonable = [
        'core_values',
        'social_links',
        'clinic_hours',
        'home_intro_bullets',
    ];
}

