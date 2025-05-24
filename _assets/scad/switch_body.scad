// Copyright 2020,2024 Martin Scheidt (Attribution 4.0 International, CC-BY 4.0)
//
// You are free to copy and redistribute the material in any medium or format.
// You are free to remix, transform, and build upon the material for any purpose, even commercially.
// You must give appropriate credit, provide a link to the license, and indicate if changes were made.
// You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.
// No warranties are given.

include<config.scad>
use <trains/tracklib.scad>; // Import tracklib from dependency dotscad/trains.git
use<./switch_blade.scad>

// Length of the straight track, or auto to use the best fit for the requested curve radius.
straight_size = straight_length; //145; // [auto:auto, 51:xsmall, 102:small, 152:medium, 203:large, 254:xlarge, 305:xxlarge]

// Curve radius -> inner radius.  Sizes provided are standard.
radius = curve_inner_radius; //182; // [87.5:small, 180:large]

// Angle of track to render.  45 is standard.
angle = curve_angle;//45; // [1:360]

/* ******************************************************************************
 * Main module code below:
 * ****************************************************************************** */

/*
 * @param string base              Connector to place on the base end of the piece.
 * @param string left              Render a curve to the left with the requested connector, or none for no curve.
 * @param string straight          Render a straight center track with the requested connector, or none for no straight track.
 * @param string right             Render a curve to the left with the requested connector, or none for no curve.
 * @param string|int straight_size Length of the straight track, or auto to use the best fit for the requested curve radius.
 * @param float radius             Curve radius (usually 87.5 or 180)
 * @param float angle              Angle of track to render.  45 is standard
 * @param boolean double_sided_rails    True: Wheel Wells on both sides of the track
 */
//render_track("male","none","none","female",true);
module render_track(base,left,straight,right,double_sided_rails) {
    straight_length = (
        straight_size == "auto"
        ? ((left == "none" && right == "none")
            ? -1 // Wish we could throw an exception in OpenSCAD
            : ((radius ==  87.5)
                ? 102
                : 152
            )
        )
        : straight_size
    );
    if (straight_length == -1) {
        echo("ERROR: When using straight_size==auto, you must render a right or left curve.");
    }
    else {
        translate([-radius,0,0]) difference() {
            union() {
                if (straight != "none") {
                    translate([radius+wood_width(),0,0])
                        rotate([0,0,90])
                        wood_track(straight_length, false);
                    if (straight == "male") {
                        translate([radius+wood_width()/2,straight_length,0])
                            rotate([0,0,90])
                            wood_plug();
                    }
                }
                if (left != "none") {
                    wood_track_arc(radius, angle, false);
                    if (left == "male") {
                        rotate([0,0,angle])
                            translate([radius+wood_width()/2,0,0])
                            rotate([0,0,90])
                            wood_plug();
                    }
                }
                if (right != "none") {
                    translate([radius*2+wood_width(),0,0])
                        rotate([0,0,180-angle])
                        wood_track_arc(radius, angle, false);
                    if (right == "male") {
                        translate([radius*2+wood_width(),0,0]) rotate([0,0,180-angle])
                            translate([radius+wood_width()/2,0,0])
                            rotate([0,0,-90])
                            wood_plug();
                    }
                }
                if (base == "male") {
                    translate([radius+wood_width()/2,0,0])
                        rotate([0,0,-90])
                        wood_plug();
                }
            }
            // Subtract any requested female connector regions
            if (straight == "female") {
                translate([radius+wood_width()/2,straight_length,0])
                    rotate([0,0,-90])
                    wood_cutout();
            }
            if (left == "female") {
                rotate([0,0,angle])
                    translate([radius+wood_width()/2,0,0])
                    rotate([0,0,-90])
                    wood_cutout();
            }
            if (right == "female") {
                translate([radius*2+wood_width(),0,0]) rotate([0,0,180-angle])
                    translate([radius+wood_width()/2,0,0])
                    rotate([0,0,90])
                    wood_cutout();
            }
            if (base == "female") {
                translate([radius+wood_width()/2,0,0])
                    rotate([0,0,90])
                    wood_cutout();
            }
            // Now we can subtract the "rails"
            if (straight != "none") {
                translate([radius+wood_width(),0,0]) rotate([0,0,90]) wood_rails(straight_length);
                if (double_sided_rails){
                    echo("straight != none")
                    translate([radius,0,wood_height()]) rotate([180,0,90]) wood_rails(straight_length);
                }
            }
            if (left != "none") {
                wood_rails_arc(radius, angle);
                if (double_sided_rails){
                    echo("left != none")
                    rotate([180,0,angle])translate([0,0,-wood_height()])wood_rails_arc(radius, angle);
                }
            }
            if (right != "none") {
                translate([radius*2+wood_width(),0,0]) rotate([0,0,180-angle]) wood_rails_arc(radius, angle);
                if (double_sided_rails){
                    echo("right != none")
                    translate([radius*2+wood_width(),0,wood_height()])rotate([180,0,180])wood_rails_arc(radius, angle);
                }
            }
        }
    }
}

/* **TODO**
1. the double sided rail isn't working for all configurations.
2. (optional: die kurve ist ca. 2mm zu kurz) -> wahrscheinlich zum fräsen nicht wichtig
*/


module rail_chamfer(){
    translate([0,0,sbs_height/2]) cube([1.1,1.1,sbs_height], center = true);
}
//switchblade_space("female","female","none");
module switchblade_space(left,straight,right){ 
//    sbs_width = 40;
//    sbs_radius = blade_length+7;
//    sbs_height = wood_height()-wood_well_height();
//    sbs_xpos = wood_width()-width-wood_well_width();
//    sbs_ypos = 22;
    //pivot_center_x = wood_width()/2;
    
    module curved_boundery(){
        radius2 = curve_inner_radius+wood_well_width()+wood_well_rim()/2;
        rotate_extrude(angle=360) square([radius2,sbs_height]);
    }
    module top_boundery(){
        radius = sbs_radius;
        cylinder(h=sbs_height, r=radius);
    }
    if(left != "none" && straight != "none" && right == "none"){
        intersection(){
            difference(){
                translate([sbs_xpos,sbs_ypos,0]) cube([sbs_width,sbs_radius,sbs_height]);
                translate([-radius,0,0]) curved_boundery();
            }
            translate([pivot_center_x,sbs_ypos,0])top_boundery();
        }
        //translate([wood_well_width()+wood_well_rim(),sbs_ypos,0]) rotate([0,0,45]) rail_chamfer();
        //translate([wood_well_width()+wood_well_rim()-1.22+rail_well_spacing,sbs_ypos,0]) rotate([0,0,-45]) rail_chamfer();
    }
    if(left == "none" && straight != "none" && right != "none"){
        intersection(){
            difference(){
                translate([wood_well_width(),sbs_ypos,0]) cube([sbs_width,sbs_radius,sbs_height]);
                translate([radius+wood_width(),0,0]) curved_boundery();
            }
            translate([pivot_center_x,sbs_ypos,0])top_boundery();
        }
        //translate([wood_well_width()+wood_well_rim()+1.22,sbs_ypos,0]) rotate([0,0,45]) rail_chamfer();
        //translate([wood_well_width()+wood_well_rim()+rail_well_spacing,sbs_ypos,0]) rotate([0,0,-45]) rail_chamfer();
    }
    if(left != "none" && right != "none"){
        intersection(){
            union(){
                difference(){
                    translate([sbs_xpos,sbs_ypos,0]) cube([sbs_width,sbs_radius,sbs_height]);
                    translate([-radius,0,0]) curved_boundery();
                }
                difference(){
                    translate([wood_well_width(),sbs_ypos,0]) cube([sbs_width,sbs_radius,sbs_height]);
                    translate([radius+wood_width(),0,0]) curved_boundery();
                }
            }
            translate([pivot_center_x,sbs_ypos,0])top_boundery();
        }
        //translate([wood_well_width()+wood_well_rim()-1.22+rail_well_spacing,sbs_ypos,0]) rotate([0,0,-45]) rail_chamfer();
        //translate([wood_well_width()+wood_well_rim()+1.22,sbs_ypos,0]) rotate([0,0,45]) rail_chamfer();
    }
    
}

//switchblade_space("female","female","none");
//holes_for_blade("female","female","none");
//holes_for_blade("none","female","female");
module holes_for_blade(left,straight,right){
    h = wood_height();
//    pivot_center_x = wood_width()/2;
//    pivot_center_y=30;
    
    module pivot_hole(){
    translate([pivot_center_x,pivot_center_y,0]) cylinder(h=wood_height(), d=pin_female_diameter+1);
    }
    
    //pivot_area
    module area_length(){
        a=70;
        outer_r = lever_anchor_posY+3;
        inner_r = y_pos_second_pin-(pin_female_diameter-2);
        difference(){ 
            translate([pivot_center_x,pivot_center_y-pin_diameter,0]) rotate([0,0,90-35]) rotate_extrude(angle=a) square([outer_r,h]);
            translate([pivot_center_x,pivot_center_y-pin_diameter,0]) rotate([0,0,90-35-0.1]) rotate_extrude(angle=a+0.2) square([inner_r,h]); // 0.1 and 0.2 because of a rendering bug
        }
    }
    module curved_boundery(){
        radius1 = curve_inner_radius+5+wood_well_spacing(); // to get a 3D object
        radius2 = curve_inner_radius+wood_well_width()+wood_well_rim()+lever_anchor_posX;
        difference(){
            rotate_extrude(angle=360) square([radius1,h]);
            rotate_extrude(angle=360) square([radius2,h]);
        }
    }
    module straight_boundery(left,right){
        x_size=14;
        y_size=140;
        if(left!="none"){
            xpos =wood_width()-x_size-wood_well_width()-wood_well_rim()-lever_anchor_posX-0.5; 
            translate([xpos,0,0]) cube([x_size,y_size,h]);
        }
        if(right != "none"){
            xpos = wood_well_width()+wood_well_rim()+lever_anchor_posX+0.5;
            translate([xpos,0,0]) cube([x_size,y_size,h]);
        }
        if(left != "none" && right != "none"){
            xpos = wood_well_width()+wood_well_rim()+lever_anchor_posX+0.5;
            translate([xpos,0,0]) cube([x_size,y_size,h]);
        }
    }
    
    if(left != "none" && straight != "none" && right == "none"){
        union(){
            pivot_hole();
            intersection(){
                area_length();
                translate([-radius,0,0]) curved_boundery();
            }
            intersection(){
                area_length();
                straight_boundery(left,right);
            }
        }
    }
    if(left == "none" && straight != "none" && right != "none"){
        union(){
            pivot_hole();
            intersection(){
                area_length();
                translate([radius+wood_width(),0,0])curved_boundery();
            }
            intersection(){
                area_length();
                straight_boundery(left,right);
            }
        }
    }
        if(left != "none" && right != "none"){
        union(){
            pivot_hole();
            intersection(){
                area_length();
                translate([-radius,0,0])curved_boundery();
            }
            intersection(){
                area_length();
                translate([radius+wood_width(),0,0])curved_boundery();
            }
            intersection(){
                area_length();
                straight_boundery(left,right);
            }
        }
    }
}

module drill_holes(left,straight,right){
    module pin_hole(){
        cylinder(h=rail_height, d=om_pin_diameter+move_tolerance);
    }
    module magnet_hole(){
    cylinder(h=magnet_thickness+move_tolerance, d=magnet_diameter);
    }
    if (right != "none" && straight != "none"){
        //translate([rail_width/2, straight_length/2,0]) pin_hole();
        translate([rail_width/2, straight_length-pivot_center_y,0]) pin_hole();
        //translate([-34.6+rail_width, 77, 0]) pin_hole();
        translate([c_ph3_xpos, c_ph3_ypos, 0]) pin_hole();
        translate([c_mh5_xpos, c_mh5_ypos, c_mh_zpos]) rotate([0,-90,c_mh5_zrot]) magnet_hole();
        translate([c_mh6_xpos, c_mh6_ypos, c_mh_zpos]) rotate([0,90,c_mh6_zrot]) magnet_hole();
        translate([c_mh7_xpos, c_mh7_ypos, c_mh_zpos]) rotate([0,-90,c_mh7_zrot]) magnet_hole();
        
}
}

/*********** modules for export/ visualization***************/
module modified_switch(base,left,straight,right,double_sided_rails,hole){    
    difference(){
        render_track(base,left,straight,right,double_sided_rails);
        if (double_sided_rails==true){
            switchblade_space(left,straight,right);
        }
        translate([0,0,wood_well_height()])switchblade_space(left,straight,right);
        if(hole==true){
            holes_for_blade(left,straight,right);
        }
        drill_holes(left,straight,right);
    }
}

 module mill_projections(base,left,straight,right,blade_space, axis_space, pin_holes){    
    projection(cut=true)union(){
     difference(){
        render_track(base,left,straight,right,false);
        if(blade_space==true){
            translate([0,0,0])switchblade_space(left,straight,right);
        }
        if(axis_space==true && blade_space==false){
            holes_for_blade(left,straight,right);
        }
        if(pin_holes==true){
            drill_holes(left,straight,right);
        }
    }
    if(axis_space==true && blade_space==true){
        holes_for_blade(left,straight,right);
    }
}   
}



module visualize_blade_in_switch(){
    translate([-pivot_center_x, -pivot_center_y,0]) modified_switch("female","none","female","female",true,true);
    translate([-pivot_center_x, -pivot_center_y,0]) switchblade_space("none","female","female");
    rotate([0,0,-16])translate([0,-y_pos_first_pin,rail_well_height+3])rotate([0,180,0])switch_female();
}

//mill_projections("male","none","male","male",true,true,true); //right
mill_projections("male", "male", "male", "none", true, false, false); //left

echo(pin_female_diameter);
//visualize_blade_in_switch();
//render_track("male","none","female","female",true);
//modified_switch("male","none","female","female",true,true);
//translate([100,0,0]) modified_switch("male","female","female","none",false,true);
//translate([150,0,0]) modified_switch("male","none","female","female",false,false);
//modified_switch("male","female","female","female",true,true);

//projection() modified_switch("male","female","female","none",false,true);
//projection(cut=true) translate([0,0,-9])modified_switch("male","female","female","none",false,true);
//projection(cut=true) translate([0,0,-9]) modified_switch("male","none","female","female",false,false);