<?php namespace BeyondBounds\Clinic\Components;

use Cms\Classes\ComponentBase;
use BeyondBounds\Clinic\Models\Booking;
use BeyondBounds\Clinic\Models\Settings;
use Validator;
use ValidationException;

class BookingForm extends ComponentBase
{
    public function componentDetails()
    {
        return [
            'name' => 'Booking Form',
            'description' => 'Handles booking submissions',
        ];
    }

    public function onSubmitBooking()
    {
        $data = post();

        $validator = Validator::make($data, [
            'full_name' => 'required|string|max:255',
            'email' => 'required|email',
            'phone' => 'required|string|max:50',
            'service_requested' => 'required|string|max:255',
            'preferred_date' => 'required|date|after_or_equal:today',
            'preferred_time' => 'required|string|max:32',
        ]);

        if ($validator->fails()) {
            throw new ValidationException($validator);
        }

        $booking = new Booking();
        $booking->fill([
            'full_name' => $data['full_name'],
            'email' => $data['email'],
            'phone' => $data['phone'],
            'service_requested' => $data['service_requested'],
            'preferred_date' => $data['preferred_date'],
            'preferred_time' => $data['preferred_time'],
            'booking_type' => $data['booking_type'] ?? 'individual',
            'organization_name' => $data['organization_name'] ?? null,
            'org_size' => $data['org_size'] ?? null,
            'notes' => $data['notes'] ?? null,
            'status' => 'pending',
        ]);
        $booking->save();

        $adminEmail = Settings::get('primary_email') ?: 'beyondboundsclinic@gmail.com';

        try {
            \Mail::send('beyondbounds.clinic::mail.booking_confirmation', ['booking' => $booking], function ($m) use ($booking) {
                $m->to($booking->email, $booking->full_name);
                $m->subject('Booking Request Received - Beyond Bounds Physiotherapy');
            });
            \Mail::send('beyondbounds.clinic::mail.booking_admin', ['booking' => $booking], function ($m) use ($adminEmail, $booking) {
                $m->to($adminEmail, 'Beyond Bounds Admin');
                $m->replyTo($booking->email, $booking->full_name);
                $m->subject('New Booking Request');
            });
        } catch (\Throwable $e) {
            // Booking is saved even if mail is not configured locally.
        }

        \Flash::success('Thank you! We will confirm your booking shortly.');

        return [
            '#bookingFormResult' => $this->renderPartial('@result', [
                'message' => 'Thank you! We will confirm your booking shortly.',
            ]),
        ];
    }
}
