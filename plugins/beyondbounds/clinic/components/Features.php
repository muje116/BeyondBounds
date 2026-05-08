<?php namespace BeyondBounds\Clinic\Components;

use Cms\Classes\ComponentBase;
use BeyondBounds\Clinic\Models\Feature;

class Features extends ComponentBase
{
    public function componentDetails()
    {
        return ['name' => 'Clinic Features', 'description' => 'Lists visual feature blocks'];
    }

    public function defineProperties()
    {
        return [
            'page_scope' => ['type' => 'string', 'default' => 'home'],
            'featured_only' => ['type' => 'checkbox', 'default' => false],
            'limit' => ['type' => 'string', 'default' => '0'],
        ];
    }

    public function onRun()
    {
        $q = Feature::where('is_active', 1)->orderBy('sort_order');

        if ($scope = trim((string) $this->property('page_scope'))) {
            $q->where('page_scope', $scope);
        }

        if ($this->property('featured_only')) {
            $q->where('is_featured', 1);
        }

        $limit = (int) $this->property('limit');
        if ($limit > 0) {
            $q->limit($limit);
        }

        $this->page['features'] = $q->get();
    }
}

