/* RailEduKit/InteractiveSignallingLaboratory © 2025 by Martin Scheidt and contributor
 * License: CC-BY 4.0 - https://creativecommons.org/licenses/by/4.0/
 * Project description: The Interactive Signalling Laboratory is a tool for training in Rail
 * Applications to enhance the knowledge of control and signalling principles for rail transport systems.
 *
 * Module: train_integrity
 * Description: Train integrity component is used to create a train integrity monitoring with a headlight and tail symbol.
 */

// Include configuration file
include <config.scad>

module triangle(){
    cylinder_diameter = 0.1;
    hull(){
        translate([cylinder_diameter/2,cylinder_diameter/2,0])cylinder(d=cylinder_diameter, h=number_height);
        translate([cylinder_diameter/2, shield_depth-cylinder_diameter/2,0]) cylinder(d=cylinder_diameter, h=number_height);
        translate([(shield_width-cylinder_diameter)/2, (shield_depth-cylinder_diameter)/2,0])cylinder(d=cylinder_diameter, h=number_height);
    }
}

module front_of_train_symbol(){
    translate([-shield_width/2,-(shield_depth)/2-coupling_radius+1,-shield_thickness]) union(){
        translate([(1/12)*shield_width+headlight_d/2,(shield_depth+(1/6)*shield_width+headlight_d)/2,0]) cylinder(d= headlight_d, h=number_height);
        translate([(11/12)*shield_width-headlight_d/2,(shield_depth+(1/6)*shield_width+headlight_d)/2,0]) cylinder(d= headlight_d, h=number_height);
        translate([(1/2)*shield_width,(shield_depth-(1/6)*shield_width-headlight_d)/2,0]) cylinder(d= headlight_d, h=number_height);
    }

}

module end_of_train_symbol(){
    translate([-shield_width/2,-(shield_depth)/2-coupling_radius+1,-shield_thickness]) triangle();
    translate([shield_width/2,-(shield_depth)/2-coupling_radius+1,-shield_thickness+number_height]) rotate([0,180,0]) triangle();
}

module train_integrity(position){
    difference(){ // coupling
        // outer ring
        cylinder(h = coupling_depth, r = coupling_radius + move_tolerance/2 + coupler_thickness);
        // inner ring
        translate([0,0,-coupler_thickness/2]) cylinder(h = coupling_depth + coupler_thickness, r = coupling_radius + move_tolerance/2);
        // cutting the lower edge
        translate([-coupling_radius*1.3,coupling_cut_pos,-coupler_thickness/2]) cube([coupling_radius*2.6,coupling_radius*1.2,coupling_depth + coupler_thickness]);
    }

    union(){// upper board
        // beam
        translate([-boogie_width/2,-(coupling_radius + coupler_thickness + move_tolerance/2),0]) cube([boogie_width,coupler_thickness,coupling_depth]);
        // lipp
        hull(){
            translate([-boogie_width/2,-(coupling_radius + move_tolerance/2 + coupler_thickness - lipp_width),coupling_depth]) cube([boogie_width,thinnest_layer,lipp_height/4]);
            translate([-boogie_width/2,-(coupling_radius + move_tolerance/2 + coupler_thickness),coupling_depth]) cube([boogie_width,thinnest_layer,lipp_height]);
        }
    }

    difference(){ // front shield
        translate([-shield_width/2,-(shield_depth)/2-coupling_radius+1,-shield_thickness]) cube([shield_width, shield_depth, shield_thickness]);
        translate([0,0,-inlay_thickness]) cylinder(h = inlay_thickness*1.1, r = inlay_radius);
        if (position == "rear"){
            end_of_train_symbol();
        }
        if (position == "front"){
           front_of_train_symbol(); 
        }
    }
}

train_integrity("rear");
translate([0,30,0]) train_integrity("front");
