<?php
use October\Rain\Database\Updates\Seeder;
use BeyondBounds\Clinic\Models\Service;
use BeyondBounds\Clinic\Models\TeamMember;
use BeyondBounds\Clinic\Models\OrgPackage;
use BeyondBounds\Clinic\Models\Feature;
class SeedDefaultData extends Seeder {
  public function run(){
    $services=[['Back Pain Treatment','musculoskeletal',true],['Sports Injury Rehabilitation','sports',true],['Post-Fracture Rehabilitation','musculoskeletal',false],['Burns Rehabilitation','rehabilitation',false],['Hip Replacement Recovery','rehabilitation',true],['Stroke Rehabilitation','neurological',true],['Spinal Cord Injury Therapy','neurological',false],['Muscle Pain Management','musculoskeletal',false],['Sprains & Strains Treatment','sports',false],['Joint Pain Therapy','musculoskeletal',false],['Post-Surgery Rehabilitation','rehabilitation',true],['Ergonomics Assessment','wellness',true],['Aerobics Classes','wellness',false],['Pilates Sessions','wellness',false]];
    foreach($services as $i=>$s){ Service::updateOrCreate(['slug'=>\Str::slug($s[0])],['name'=>$s[0],'short_description'=>$s[0].' with personalized physiotherapy care.','category'=>$s[1],'is_featured'=>$s[2],'sort_order'=>$i,'is_active'=>1]); }
    $team=[['Kumbiro Mlowoka','Executive Director'],['Yvonne Muonja Chabvi','Executive Director'],['Paul Kwengwere','Operations Director'],['Scholastica Mgwadira','Physiotherapist'],['Yankho Mhango','Physiotherapist']];
    foreach($team as $i=>$m){ TeamMember::updateOrCreate(['name'=>$m[0]],['title'=>$m[1],'sort_order'=>$i,'is_active'=>1]); }
    $packages=[['Standard - 30','standard',['Health Talk','Physical Health Assessment'],'Up to 30 individuals','1 Month'],['Standard - 60','standard',['Health Talk','Physical Health Assessment'],'Up to 60 individuals','1 Month'],['Standard - 100','standard',['Health Talk','Physical Health Assessment'],'Up to 100 individuals','1 Month'],['Premium - 30','premium',['Health Talk','Physical Health Assessment','Ergonomic Assessment','Exercise Program'],'Up to 30 individuals','1 Month'],['Premium - 60','premium',['Health Talk','Physical Health Assessment','Ergonomic Assessment','Exercise Program'],'Up to 60 individuals','1 Month'],['Premium - 100','premium',['Health Talk','Physical Health Assessment','Ergonomic Assessment','Exercise Program'],'Up to 100 individuals','1 Month'],['Health Talks','standalone',['Health Talks'],'Up to 20 individuals','1 Month'],['Physical Health Assessment','standalone',['Physical Health Assessment'],'Up to 20 individuals','1 Week'],['Ergonomic Assessment','standalone',['Ergonomic Assessment'],'Up to 20 individuals','1 Week'],['Fitness and Exercise Program','standalone',['Fitness Program'],'Up to 20 individuals','1 Month']];
    foreach($packages as $i=>$p){ OrgPackage::updateOrCreate(['name'=>$p[0]],['tier'=>$p[1],'includes'=>$p[2],'org_size'=>$p[3],'duration'=>$p[4],'sort_order'=>$i,'is_active'=>1]); }
    $features=[
      ['Performance Biomechanics','home','bento','Movement assessment','A closer look at how you move, with practical guidance shaped around your goals and activity.','monitoring'],
      ['Cryo-Compression','home','card','Recovery support','Recovery support delivered with appropriate screening and guidance from our physiotherapy team.','ac_unit'],
      ['Laser Therapy','services','card','Treatment option','Treatment options discussed with your physiotherapist as part of an individual care plan.','light_mode'],
      ['Reduced Workplace Injuries','organizations','highlight','Workplace health','Practical workplace programs shaped around movement, ergonomics, and the needs of your team.','health_and_safety'],
      ['Employee Well-being','organizations','card','Everyday movement','Movement and wellbeing initiatives designed to support healthier working days.','groups'],
      ['Data-Driven Insights','organizations','card','Clear reporting','Clear reporting to help organisations understand participation and plan future support.','query_stats']
    ];
    foreach($features as $i=>$f){
      Feature::updateOrCreate(
        ['slug'=>\Str::slug($f[0])],
        ['title'=>$f[0],'page_scope'=>$f[1],'layout_variant'=>$f[2],'subtitle'=>$f[3],'description'=>$f[4],'icon_class'=>$f[5],'sort_order'=>$i,'is_featured'=>1,'is_active'=>1]
      );
    }
  }
}
