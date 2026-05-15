<?php namespace BeyondBounds\Clinic\Components;
use Cms\Classes\ComponentBase; use BeyondBounds\Clinic\Models\Contact;
class ContactForm extends ComponentBase {
  public function componentDetails(){ return ['name'=>'Contact Form','description'=>'Handles contact submissions']; }
  public function onSubmitContact(){
    $d=post(); $v=\Validator::make($d,['name'=>'required|string|max:255','email'=>'required|email','subject'=>'required|string|max:255','message'=>'required|string']);
    if($v->fails()) throw new \ValidationException($v);
    $c=new Contact(); $c->fill($d); $c->save();
    \Mail::send('beyondbounds.clinic::mail.contact_admin',['contact'=>$c],function($m){$m->to('beyondboundsclinic@gmail.com','Beyond Bounds Admin');$m->subject('New Contact Message');});
    return ['success'=>true,'message'=>'Thank you! Your message has been sent.'];
  }
}
