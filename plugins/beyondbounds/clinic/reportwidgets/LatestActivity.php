<?php namespace BeyondBounds\Clinic\ReportWidgets;

use Backend\Classes\ReportWidgetBase;
use BeyondBounds\Clinic\Models\Booking;
use BeyondBounds\Clinic\Models\Contact;

class LatestActivity extends ReportWidgetBase
{
    public function defineProperties()
    {
        return [
            'items' => [
                'title' => 'Items Per List',
                'default' => 5,
                'type' => 'string',
            ],
        ];
    }

    public function render()
    {
        $limit = (int) $this->property('items');
        $limit = $limit > 0 ? $limit : 5;

        $this->vars['bookings'] = Booking::query()->latest()->limit($limit)->get();
        $this->vars['contacts'] = Contact::query()->latest()->limit($limit)->get();

        return $this->makePartial('widget');
    }
}
