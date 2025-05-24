/* RailEduKit/InteractiveSignallingLaboratory © 2025 by Martin Scheidt and contributor
 * License: CC-BY 4.0 - https://creativecommons.org/licenses/by/4.0/
 * Project description: The Interactive Signalling Laboratory is a tool for training in Rail
 * Applications to enhance the knowledge of control and signalling principles for rail transport systems.
 *
 * Module: clearing_point
 * Description: Clearing point component for the Interactive Signalling Laboratory.
 * It is used to create a clearing point with a route and block symbol.
 */

// Include configuration file
include <config.scad>

// include common components
include <components/magnet_hole.scad>
include <components/driving_direction_arrow.scad>

module route_clearing_symbol(){
    union(){
        difference(){
            cylinder(h=engraving_height, d=cp_symbol_size);
            cylinder(h=engraving_height, d=cp_symbol_size-2*engraving_thickness);
        }   
    }
}

module block_clearing_symbol(){
    translate([0,0,engraving_height/2]) union(){    
        difference(){
            cube([cp_symbol_size,cp_symbol_size,engraving_height], center=true);
            cube([cp_symbol_size-2*engraving_thickness,cp_symbol_size-2*engraving_thickness,engraving_height], center=true);
        }
    }
}

module clearing_point(type){
    difference(){
        cube([zs_with,zs_depth,zs_height]);
        //Magnet holes
        translate([zs_with/2-magnet_distance_to_middle,magnet_thickness+move_tolerance,magnet_z]) rotate([90,0,0]) magnet_hole();
        translate([zs_with/2+magnet_distance_to_middle,magnet_thickness+move_tolerance,magnet_z]) rotate([90,0,0]) magnet_hole();
        translate([zs_with/2-magnet_distance_to_middle,zs_depth,magnet_z]) rotate([90,0,0]) magnet_hole();
        translate([zs_with/2+magnet_distance_to_middle,zs_depth,magnet_z]) rotate([90,0,0]) magnet_hole();
    }
    translate([zs_with*(4/5),(zs_depth-attach_arrow_depth)/2,zs_height]) rotate([0,0,90]) driving_direction_arrow();
    //symbols
    if(type == "route"){
            translate([zs_with/2,zs_depth/2,zs_height]) route_clearing_symbol();
    }
    if(type == "block"){
            translate([zs_with/2,zs_depth/2,zs_height]) block_clearing_symbol();
    }
}

clearing_point("block");
translate([0,20,0]) clearing_point("route");
