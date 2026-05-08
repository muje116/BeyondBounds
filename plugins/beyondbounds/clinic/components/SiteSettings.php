<?php namespace BeyondBounds\Clinic\Components;

use Cms\Classes\ComponentBase;
use BeyondBounds\Clinic\Models\Settings;

class SiteSettings extends ComponentBase
{
    public function componentDetails()
    {
        return [
            'name' => 'Site Settings',
            'description' => 'Exposes global site settings to pages/layouts.',
        ];
    }

    public function onRun()
    {
        $settings = Settings::instance();

        $this->page['siteSettings'] = $settings;
        $this->page['siteBrandName'] = trim((string) ($settings->brand_name ?: 'Beyond Bounds'));
        $this->page['siteTagline'] = trim((string) ($settings->tagline ?: 'Bringing Health to You'));
        $this->page['siteMapQuery'] = trim((string) ($settings->map_query ?: 'Area 47, Lilongwe, Malawi'));
    }
}

