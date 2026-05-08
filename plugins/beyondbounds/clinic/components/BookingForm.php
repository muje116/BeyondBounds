<?php namespace BeyondBounds\Clinic\Components;
use Cms\Classes\ComponentBase; use BeyondBounds\Clinic\Models\Booking;
class BookingForm extends ComponentBase {
  public function componentDetails(){ return ['name'=>'Booking Form','description'=>'Handles booking submissions']; }
  public function onSubmitBooking(){
    $d=post(); $v=\Validator::make($d,['full_name'=>'required|string|max:255','email'=>'required|email','phone'=>'required|string','service_requested'=>'required|string','preferred_date'=>'required|date|after:today','preferred_time'=>'required|string']);
    if($v->fails()) throw new \ValidationException($v);
    $b=new Booking(); $b->fill($d); $b->save();
    \Mail::send('beyondbounds.clinic::mail.booking_confirmation',['booking'=>$b],function($m) use($b){$m->to($b->email,$b->full_name);$m->subject('Booking Request Received - Beyond Bounds Physiotherapy');});
    \Mail::send('beyondbounds.clinic::mail.booking_admin',['booking'=>$b],function($m){$m->to('beyondboundsclinic@gmail.com','Beyond Bounds Admin');$m->subject('New Booking Request');});
    return ['success'=>true,'message'=>'Thank you! We will confirm your booking shortly.'];
  }
}
