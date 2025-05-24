
include<config.scad>
use <BOSL2/std.scad> // Import std from dependency BelfrySCAD/BOSL2.git
use <BOSL2/joiners.scad> // Import joiners from dependency BelfrySCAD/BOSL2.git


/*[Track Settings]*/
//length of track piece, in mm
length = straight_length+2.5; //[30:10:400] //inklusive the male pin


//only one preset... for now
//track_type = 0; //[1:brio,0:custom]

//in order to print perfectly, set your printers extrusion width
extrusion_width = .4; //[.1:.05:1]

//track line thickness, in multiples of extrusion width
thin_line = 4; //[2:2:10]

//spacing between male and female connectors, in mm
connector_tolerance = .3; //[.1:.05:1]

//// pin specifications
//om_pin_height = 5;
//om_pin_diameter = 4.5;
//om_pin_y_pos = 25;

//// track guidance
//om_track_guidance_width = 0.8;
//om_track_guidance_height = 2.5;

////dovetail connector specifications
//om_dovetail_width = 10;
//om_dovetail_depth = 5;


/*[Custom Dimensions]*/
use_custom_settings = 1; //[0:No,1:Yes]
custom_width_base = rail_well_spacing+2*om_track_guidance_width+move_tolerance;
custom_width_middle = custom_width_base;
custom_height_base = om_thickness;
custom_height_middle = om_thickness;
custom_connector_length =0; //17.5;

/*[Hidden]*/
track_type = use_custom_settings ? 0 : 1;


/***************/
/*     CODE    */
/***************/
module endproduct(){
translate([-track_type_params()[track_type][1] / 2,0])
intersection(convexity = 20) {
    rotate([-90,0,0])
        linear_extrude(height = length, convexity = 20)
            scale([1,-1])
                track_profile_2D(
                    track_type_params()[track_type][1],
                    track_type_params()[track_type][2],
                    track_type_params()[track_type][3],
                    track_type_params()[track_type][4],
                    1
                );

    linear_extrude(height = track_type_params()[track_type][4], convexity = 20)
        union() {
            translate([0, track_type_params()[track_type][5] + thin_line * extrusion_width]) {
                translate([track_type_params()[track_type][1] / 2, length - track_type_params()[track_type][5] * 2 - thin_line * extrusion_width * 2])
                        brio_male_2D();
                
                flex_track_pattern_2D(
                    length - track_type_params()[track_type][5] * 2 - thin_line * extrusion_width * 2,
                    track_type_params()[track_type][1],
                    track_type_params()[track_type][2],
                    thin_line * extrusion_width,
                    thin_line * extrusion_width,
                    thin_line * extrusion_width, //this defines the gap_thickness
                    true
                );
            }
            translate([track_type_params()[track_type][1] / 2, track_type_params()[track_type][5] + thin_line * extrusion_width])
                scale([1, -1])
                    brio_female_2D();
        }
}
//track guidance
translate([-custom_width_middle/2,track_type_params()[track_type][5] + thin_line * extrusion_width,-om_track_guidance_height])
    linear_extrude(height = om_track_guidance_height, convexity = 20)
        flex_track_pattern_2D(
                length - track_type_params()[track_type][5] * 2 - thin_line * extrusion_width * 2,
                track_type_params()[track_type][1],
                track_type_params()[track_type][2],
                thin_line * extrusion_width,
                om_track_guidance_width,
                thin_line * extrusion_width, //this defines the gap_thickness
                false
            );

/***pin***/
//middle pin
//translate([0,(length+om_dovetail_depth)/2-0.1,0]) pin(track_type_params()[track_type][2]-2*thin_line * extrusion_width,
//    4*thin_line * extrusion_width,
//    track_type_params()[track_type][3]);
//male side pin
translate([0,om_pin_y_pos,0]) pin(track_type_params()[track_type][2]-2*thin_line * extrusion_width,
    4*thin_line * extrusion_width -1,
    track_type_params()[track_type][3]);
// female side pin
translate([0,length+om_dovetail_depth-(om_pin_y_pos),0]) pin(track_type_params()[track_type][2]-2*thin_line * extrusion_width,
    4*thin_line * extrusion_width -1,
    track_type_params()[track_type][3]);
/***connectors***/
    translate([0,0,custom_height_middle/2])rotate([90,0,0]) dovetail("male", w=om_dovetail_width, h=om_dovetail_depth, slide=custom_height_middle);
translate([0,length,0])difference(){
    translate([-custom_width_middle/2,0,0]) cube([custom_width_middle,om_dovetail_depth,custom_height_middle]);
    translate([0,om_dovetail_depth,custom_height_middle/2]) rotate([-90,0,0]) dovetail("female", w=om_dovetail_width, h=om_dovetail_depth, slide=custom_height_middle);
}
}

/***************/
/*  FUNCTIONS  */
/***************/

function track_type_params() = 
[   
    [   //[0] template
        "custom",   //[0] name
        custom_width_base,         //[1] width base
        custom_width_middle,         //[2] width middle
        custom_height_base,         //[3] height base
        custom_height_middle,         //[4] height middle
        custom_connector_length
    ], 
    [   //[1] brio
        "brio",     //[0] name
        40,         //[1] width base
        20,         //[2] width middle
        8.9,        //[3] height base
        12,         //[4] height middle
        17.5        //[5] connector length
    ], 
];

/***************/
/*   MODULES   */
/***************/

module track_guidance2D(length = 100,
    width_base = 40,
    width_middle = 20,
    thin_line = 1.6,
    connector_thickness = 1.6,
    gap_thickness = 1.6
){
    
}


module track_profile_2D(
    width_base = 40,
    width_middle = 20,
    height_base = 10,
    height_middle = 15,
    bevel_radius = 1
){
    difference() {
        translate([bevel_radius, 0]) {
            union() {
                offset(d = bevel_radius) {
                    square(
                        [
                            width_base - bevel_radius * 2,
                            height_base - bevel_radius
                        ]
                    );
                }
                offset(d = bevel_radius) {
                    translate([(width_base - width_middle) / 2, bevel_radius])
                        square(
                            [
                                width_middle - bevel_radius * 2,
                                height_middle - bevel_radius * 2
                            ]
                        );
                }            
            }
        }
        translate([-width_base/2, -width_base*2])
            square(width_base * 2);
    }   
}
module flex_track_pattern_2D(
    length = 100,
    width_base = 40,
    width_middle = 20,
    thin_line = 1.6,
    connector_thickness = 1.6,
    gap_thickness = 1.6,
    inclusive_bars = true
){
    epsilon = .1;

    slice_thickness = thin_line + gap_thickness;
    slices = floor(length / slice_thickness);
    leftover = length - (slice_thickness * slices) + gap_thickness;

    module bars(even = true, odd = true, cutter = false) {
        for (i = [0:slices-1]) {
            if (even == true && !(i % 2)) {
                if(cutter == true) {
                    translate([-epsilon/2,slice_thickness * i]) {
                        square([width_base + epsilon,thin_line]);
                    }
                } else {
                    translate([0,slice_thickness * i]) {
                        square([width_base,thin_line]);
                    }
                }  
            }
            if (odd == true && (i % 2)) {
                if(cutter == true) {
                    translate([-epsilon/2,slice_thickness * i]) {
                        square([width_base + epsilon,thin_line]);
                    }
                } else {
                    translate([0,slice_thickness * i]) {
                        square([width_base,thin_line]);
                    }
                }  
            }
        }
    }

    module bars_holes(even = true, odd = true, cutter = true) {
        for (i = [0:slices-2]) {
            if (even == true && !(i % 2)) {
                if(cutter == true) {
                    translate([-epsilon/2,slice_thickness * i + thin_line]) {
                        square([width_base + epsilon, gap_thickness]);
                    }
                } else {
                    translate([0,slice_thickness * i + thin_line]) {
                        square([width_base, gap_thickness]);
                    }
                }  
            }
            if (odd == true && (i % 2)) {
                if(cutter == true) {
                    translate([-epsilon/2,slice_thickness * i + thin_line]) {
                        square([width_base + epsilon, gap_thickness]);
                    }
                } else {
                    translate([0,slice_thickness * i + thin_line]) {
                        square([width_base, gap_thickness]);
                    }
                }  
            }
        }
    }
    if (inclusive_bars==true){
        translate([0, leftover / 2])
            bars();
    }

    difference() {
        translate([(width_base - width_middle) / 2, 0])
            square([connector_thickness, length]);
        
        translate([0, leftover / 2])
            bars_holes(false, true);
    }

    difference() {
        translate([(width_base - width_middle) / 2 + width_middle - connector_thickness, 0])
            square([connector_thickness, length]);
        
        translate([0, leftover / 2])
            bars_holes(true, false);
    } 
}

module brio_male_2D() {
    stem_width = 6;
    stem_length = 11.5;
    post_radius = 6;

    translate([0, thin_line * extrusion_width/2])
        square([track_type_params()[1][1], thin_line * extrusion_width], center = true);
    
    translate([0, (stem_length + connector_tolerance) / 2 + thin_line * extrusion_width])
        square([stem_width - connector_tolerance * 2, stem_length + connector_tolerance], center = true);
    
    translate([0, stem_length + connector_tolerance + thin_line * extrusion_width])
        circle(r = post_radius - connector_tolerance, $fn = 32);
}

module brio_female_2D() {
    stem_width = 6.3;
    stem_length = 11.5;
    post_radius = 6.3;
    total_length = thin_line * extrusion_width + stem_length + post_radius;

    difference() {
        translate([0, (total_length)/2])
            square([track_type_params()[1][1], total_length], center = true);
        
        translate([0, total_length - stem_length / 2])
            square([stem_width, stem_length], center = true);
        
        translate([0, total_length - stem_length])
            circle(r = post_radius, $fn = 32);        
    }

}

module pin(base_width, base_depth, base_height){
    translate([0,0,base_height/2])cube([base_width, base_depth, base_height], center=true);
    translate([0,0,-om_pin_height])cylinder(h=om_pin_height, d=om_pin_diameter);
}
//track_profile_2D();
//flex_track_pattern_2D();
endproduct();

echo("custom_width_base", custom_width_base);
