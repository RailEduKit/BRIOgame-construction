// Copyright 2024 Martin Scheidt (Attribution 4.0 International, CC-BY 4.0)
//
// You are free to copy and redistribute the material in any medium or format.
// You are free to remix, transform, and build upon the material for any purpose, even commercially.
// You must give appropriate credit, provide a link to the license, and indicate if changes were made.
// You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.
// No warranties are given.

include<config.scad>

curvedBox();

module magnet_hole(){
    cylinder(h=magnet_thickness+move_tolerance, d=magnet_diameter+move_tolerance);
}

module curvedBox(){
    module box(){
        difference(){
            cube([body_width, body_depth, body_height]);
        }
    }
    module round_edge(){
        cylinder(h=body_height, r=track_arc_inner_radius);
    }
    difference(){
        intersection(){
            intersection(){
                translate([0,0,0])box();
                translate([track_arc_inner_radius-sagitta,body_depth/2,0])round_edge();
            }
            intersection(){
                translate([0,0,0])box();
                translate([body_width-track_arc_inner_radius+sagitta,body_depth/2,0])round_edge();
            }
        }
        //magnet holes
        translate([0,body_depth/2 - magnet_distance_to_middle, magnet_z])rotate([0,90,0])magnet_hole();
        translate([0,body_depth/2 + magnet_distance_to_middle, magnet_z])rotate([0,90,0])magnet_hole();
        translate([body_width-magnet_thickness-0.5,body_depth/2 - magnet_distance_to_middle, magnet_z])rotate([0,90,0])magnet_hole();
        translate([body_width-magnet_thickness-0.5,body_depth/2 + magnet_distance_to_middle, magnet_z])rotate([0,90,0])magnet_hole();
        
    }
}


