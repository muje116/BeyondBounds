<?php namespace BeyondBounds\Clinic\Models;

use Model;

class Booking extends Model
{
    use \October\Rain\Database\Traits\Validation;

    public $table = 'beyondbounds_clinic_bookings';

    public $rules = [
        'full_name' => 'required',
        'email' => 'required|email',
        'service_requested' => 'required',
        'preferred_date' => 'required|date',
        'preferred_time' => 'required',
    ];

    public $fillable = [
        'full_name',
        'email',
        'phone',
        'service_requested',
        'preferred_date',
        'preferred_time',
        'booking_type',
        'organization_name',
        'org_size',
        'notes',
        'status',
    ];

    protected $dates = ['preferred_date'];
}
