<?php namespace BeyondBounds\Clinic\Components;

use Cms\Classes\ComponentBase;
use BeyondBounds\Clinic\Models\Contact;
use BeyondBounds\Clinic\Models\Settings;
use Validator;
use ValidationException;
use Flash;

class ContactForm extends ComponentBase
{
    public function componentDetails()
    {
        return [
            'name' => 'Contact Form',
            'description' => 'Handles contact submissions',
        ];
    }

    public function onSubmitContact()
    {
        $data = post();

        $validator = Validator::make($data, [
            'name' => 'required|string|max:255',
            'email' => 'required|email',
            'subject' => 'required|string|max:255',
            'message' => 'required|string',
            'phone' => 'nullable|string|max:50',
        ]);

        if ($validator->fails()) {
            throw new ValidationException($validator);
        }

        $contact = new Contact();
        $contact->fill([
            'name' => $data['name'],
            'email' => $data['email'],
            'phone' => $data['phone'] ?? null,
            'subject' => $data['subject'],
            'message' => $data['message'],
            'is_read' => false,
        ]);
        $contact->save();

        $adminEmail = Settings::get('primary_email') ?: 'beyondboundsclinic@gmail.com';

        try {
            \Mail::send('beyondbounds.clinic::mail.contact_admin', ['contact' => $contact], function ($message) use ($adminEmail, $contact) {
                $message->to($adminEmail, 'Beyond Bounds Admin');
                $message->replyTo($contact->email, $contact->name);
                $message->subject('New Contact Message');
            });

            \Mail::send('beyondbounds.clinic::mail.contact_confirmation', ['contact' => $contact], function ($message) use ($contact) {
                $message->to($contact->email, $contact->name);
                $message->subject('We received your message - Beyond Bounds');
            });
        } catch (\Throwable $e) {
            // Contact is saved even if outgoing mail is not configured.
        }

        Flash::success('Thanks! Your message has been sent. We will get back to you soon.');

        $target = $data['result_target'] ?? null;
        if ($target) {
            return [
                $target => '<p class="text-green-600 dark:text-green-300 font-semibold">Thanks! Your message has been sent. We will get back to you soon.</p>',
            ];
        }

        return [];
    }
}
