// Copyright 2024 Martin Scheidt (Attribution 4.0 International, CC-BY 4.0)
//
// You are free to copy and redistribute the material in any medium or format.
// You are free to remix, transform, and build upon the material for any purpose, even commercially.
// You must give appropriate credit, provide a link to the license, and indicate if changes were made.
// You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.
// No warranties are given.

include<config.scad>
use<./curve.scad>


module connector_cutout(){
    translate([0,0,dtc_cutout_z_pos]) difference(){
        rotate_extrude(angle = dtc_cutout_middle_angle) square([dtc_side_radius+1, dtc_cutout_height]);
        rotate_extrude(angle = dtc_cutout_middle_angle) square([dtc_middle_radius,dtc_cutout_height]);
    }
}

module inner_curve_cutout(){
    translate([0,0,dtc_cutout_z_pos]) difference(){
        rotate_extrude(angle = curve_angle+0.05) square([dtc_outer_radius, dtc_cutout_height]); //0.05 to get 0.2mm move-tolerance
        rotate_extrude(angle = curve_angle+0.05) square([dtc_inner_radius,dtc_cutout_height]);        
    }
}

module outer_curve_cutout(){
    translate([dtc_outer_radius+dsg_thickness,0,dtc_cutout_z_pos])rotate([0,0,180-curve_angle])rotate_extrude(angle = curve_angle) square([dtc_outer_radius, dtc_cutout_height]);
}

module template_outer_curve(){

translate([-(dtc_inner_radius-65),0,0])union(){
difference(){ 
difference(){
    union(){
        rotate_extrude(angle = 90) square([dtc_middle_radius, dtc_height]);
        // stabilisation pillar
        cube([dtc_outer_radius,15,dtc_cutout_z_pos]);
        translate([0,0,dtc_cutout_z_pos+dtc_cutout_height]) cube([dtc_outer_radius,15,dtc_cutout_z_pos]);
        translate([0,dtc_switch_hole_y_pos-15/2,0]) cube([dtc_outer_radius,15,dtc_cutout_z_pos]);
        translate([0,dtc_switch_hole_y_pos-15/2,dtc_cutout_z_pos+dtc_cutout_height]) cube([dtc_outer_radius,15,dtc_cutout_z_pos]);
    }
    inner_curve_cutout();
}
    connector_cutout();
    //ground holes
    translate([0,115,dtc_cutout_z_pos]) cube([dtc_inner_radius, dsg_hole_depth, dtc_cutout_height]);
    translate([0,65,dtc_cutout_z_pos]) cube([dtc_inner_radius, dsg_hole_depth, dtc_cutout_height]);
    translate([0,10,dtc_cutout_z_pos]) cube([dtc_inner_radius, dsg_hole_depth, dtc_cutout_height]);
    
    // trim template to relevant size
    cube([dtc_inner_radius-65, dtc_middle_radius, dtc_height+0.1]); // +0.1 otherwise a small layer left
    translate([dtc_inner_radius-65,144,0])cube([50, 50, dtc_height]);
    
    // hole position lines
    translate([dtc_outer_radius-2*thin_line, dtch_y_pos-thin_line/2, dtc_cutout_z_pos+dtc_cutout_height])cube([2*thin_line, thin_line, dtc_cutout_height]);
    translate([dtc_outer_radius-2*thin_line, dtch_y_pos-thin_line/2, dtc_cutout_z_pos-dtc_cutout_height])cube([2*thin_line, thin_line, dtc_cutout_height]);
    translate([dtc_inner_radius-2*thin_line, dtch_y_pos-thin_line/2, dtc_cutout_z_pos])cube([2*thin_line, thin_line, dtc_cutout_height]);
    translate([dtc_inner_radius-2*thin_line, 5,dtc_cutout_z_pos+dtch_z_pos-thin_line/2]) cube([2*thin_line, 5, thin_line]);
    translate([dtc_inner_radius-2*thin_line,dtch_y_pos-thin_line/2, dtc_cutout_z_pos-thin_line]) cube([rail_width, thin_line, thin_line]);
    translate([dtc_inner_radius-2*thin_line,dtch_y_pos-thin_line/2, dtc_cutout_z_pos+dtc_cutout_height]) cube([rail_width, thin_line, thin_line]);

    // hole position lines for switch hole (straight junction)
    translate([dtc_outer_radius-2*thin_line, dtc_switch_hole_y_pos-thin_line/2, dtc_cutout_z_pos+dtc_cutout_height])cube([2*thin_line, thin_line, dtc_cutout_height]);
    translate([dtc_outer_radius-2*thin_line, dtc_switch_hole_y_pos-thin_line/2, dtc_cutout_z_pos-dtc_cutout_height])cube([2*thin_line, thin_line, dtc_cutout_height]);
    translate([dtc_inner_radius-2*thin_line-46, dtc_switch_hole_y_pos-thin_line/2, dtc_cutout_z_pos])cube([2*thin_line, thin_line, dtc_cutout_height]);
    translate([dtc_inner_radius-2*thin_line-46, dtc_switch_hole_y_pos-dtc_cutout_height/2,dtc_cutout_z_pos+dtch_z_pos-thin_line/2]) cube([4*thin_line, dtc_cutout_height, thin_line]);
    translate([dtc_inner_radius-2*thin_line-46,dtc_switch_hole_y_pos-thin_line/2, dtc_cutout_z_pos-thin_line]) cube([dtc_outer_radius, thin_line, thin_line]);
    translate([dtc_inner_radius-2*thin_line-46,dtc_switch_hole_y_pos-thin_line/2, dtc_cutout_z_pos+dtc_cutout_height]) cube([dtc_outer_radius, thin_line, thin_line]);
    
    // chamfer
    translate([dtc_outer_radius,15/2,dtc_cutout_z_pos]) rotate([0,45,0]) cube([2,15,2],center=true);
    translate([dtc_outer_radius,15/2,dtc_cutout_z_pos+dtc_cutout_height]) rotate([0,45,0]) cube([2,15,2],center=true);
    translate([dtc_outer_radius,dtc_switch_hole_y_pos,dtc_cutout_z_pos+dtc_cutout_height]) rotate([0,45,0]) cube([2,15,2],center=true);
    translate([dtc_outer_radius,dtc_switch_hole_y_pos,dtc_cutout_z_pos]) rotate([0,45,0]) cube([2,15,2],center=true);
}
// connector space
difference(){
    translate([0,-dsc_connector_width/2,0])cube([dtc_outer_radius,dsc_connector_width/2,2*dtc_cutout_z_pos+dtc_cutout_height]);
    #translate([dtc_inner_radius+12,-dsc_connector_width, dtc_cutout_z_pos]) cube([dsc_connector_height ,dsc_connector_width, dsc_depth]);
    translate([dtc_outer_radius-1, -dsc_connector_width, dtc_cutout_z_pos+dtch_z_pos]) cube([2*thin_line, dsc_connector_width, thin_line]);
    // trim template to relevant size
    translate([0,-dsc_connector_width,0])cube([dtc_inner_radius-65, dsc_connector_width, dtc_height]);
}
// connector space switch
translate([0,144,0]) difference(){
    cube([dtc_outer_radius,40,2*dtc_cutout_z_pos+dtc_cutout_height]);
    // connector space
    translate([dtc_inner_radius-65+dsg_thickness,0,dtc_cutout_z_pos]) cube([dtc_inner_radius,40-5,dtc_cutout_height]);
    // position line
    translate([dtc_outer_radius-1, 40-5, dtc_cutout_z_pos+dtch_z_pos]) cube([2*thin_line, 5, thin_line]);
    // chamfer
    translate([dtc_outer_radius,35/2,dtc_cutout_z_pos+dtc_cutout_height]) rotate([0,45,0]) cube([2,35,2],center=true);
    translate([dtc_outer_radius,35/2,dtc_cutout_z_pos]) rotate([0,45,0]) cube([2,35,2],center=true);
    // trim template to relevant size
    translate([0,0,0])cube([dtc_inner_radius-65, 40, dtc_height]);
}
}
//translate([0,-5,0]) cube([65+12,5,dtc_height]);
}

module template_inner_curve(){
    difference(){
        cube([70, 130, 2*dtc_cutout_z_pos+dtc_cutout_height]);
        outer_curve_cutout();
        // curved sides
        translate([dtc_outer_radius+dsg_thickness,0,dtc_cutout_z_pos+dtc_cutout_height])rotate([0,0,180-curve_angle+0.2])rotate_extrude(angle = curve_angle) square([dtc_side_radius, dtc_cutout_z_pos]);
        translate([dtc_outer_radius+dsg_thickness,0,0])rotate([0,0,180-curve_angle+0.2])rotate_extrude(angle = curve_angle) square([dtc_side_radius, dtc_cutout_z_pos]);

        
        // ground holes
        translate([0,10,dtc_cutout_z_pos])cube([70, dsg_hole_depth, dtc_cutout_height]);
        translate([0,70,dtc_cutout_z_pos])cube([70, dsg_hole_depth, dtc_cutout_height]);
        
        // hole position lines
        translate([4, dtch_y_pos-thin_line/2, dtc_cutout_z_pos]) cube([2*thin_line, thin_line, dtc_cutout_height]);
        translate([4, dtch_y_pos-5/2, dtc_cutout_z_pos+dtch_z_pos]) cube([2*thin_line, 5, thin_line]);
        translate([4, dtch_y_pos-thin_line/2,dtc_cutout_z_pos-thin_line])cube([30, thin_line, thin_line]);
        translate([4, dtch_y_pos-thin_line/2,dtc_cutout_z_pos+dtc_cutout_height])cube([30, thin_line, thin_line]);
    }

    difference(){
        union(){
            // stabilisation pillar
            cube([dsg_thickness+rail_width,15,dtc_cutout_z_pos]);
            translate([0,0,dtc_cutout_z_pos+dtc_cutout_height])cube([dsg_thickness+rail_width,15,dtc_cutout_z_pos]);
            translate([0,115,0])cube([70,15,dtc_cutout_z_pos]);
            translate([0,115,dtc_cutout_z_pos+dtc_cutout_height])cube([70,15,dtc_cutout_z_pos]);
        }
        // hole position lines
        translate([dsg_thickness+rail_width-1, dtch_y_pos-thin_line/2, dtc_cutout_z_pos-dtc_cutout_height]) cube([2*thin_line, thin_line, dtc_cutout_height]);
        translate([dsg_thickness+rail_width-1, dtch_y_pos-thin_line/2, dtc_cutout_z_pos+dtc_cutout_height]) cube([2*thin_line, thin_line, dtc_cutout_height]);
        translate([4, dtch_y_pos-thin_line/2,dtc_cutout_z_pos-thin_line])cube([dsb_height, thin_line, thin_line]);
        translate([4, dtch_y_pos-thin_line/2,dtc_cutout_z_pos+dtc_cutout_height])cube([dsb_height, thin_line, thin_line]);
        //chamfer
        translate([dsg_thickness+rail_width,15/2,dtc_cutout_z_pos]) rotate([0,45,0]) cube([2,15,2],center=true);
        translate([dsg_thickness+rail_width,15/2,dtc_cutout_z_pos+dtc_cutout_height]) rotate([0,45,0]) cube([2,15,2],center=true);
        translate([70,15/2+115,dtc_cutout_z_pos]) rotate([0,45,0]) cube([2,15,2],center=true);
        translate([70,15/2+115,dtc_cutout_z_pos+dtc_cutout_height]) rotate([0,45,0]) cube([2,15,2],center=true);
    }    
    // connector space
    difference(){
        translate([0,-dsc_connector_width/2,0])cube([dsb_height,dsc_connector_width/2,2*dtc_cutout_z_pos+dtc_cutout_height]);
        translate([dsg_thickness+12,-dsc_connector_width, dtc_cutout_z_pos]) cube([dsc_connector_height ,dsc_connector_width, dsc_depth]);
        translate([dsb_height-1, -dsc_connector_width, dtc_cutout_z_pos+dtch_z_pos]) cube([2*thin_line, dsc_connector_width, thin_line]);
    }
}

module curve_shape(){
    difference(){
        translate([curve_outer_radius+ht_scope,0,0]) rotate([0,0,180-(curve_angle+ht_male_connector_angle)])rotate_extrude(angle = curve_angle+ht_male_connector_angle) 
        difference(){
            square([curve_outer_radius+ht_scope, ht_height]);
            square([curve_inner_radius-ht_scope, ht_height]);
        }
        translate([(rail_width-3)/2,0,0])cube([3,3,ht_height]);
    }
    translate([male_connector_space_xpos,male_connector_space_ypos,ht_height/2])rotate([0,0,-(curve_angle+ht_male_connector_angle)])translate([0,12/2,0])cube([13,12,ht_height], center=true);
    translate([grip_hole_left_xpos,grip_hole_left_ypos,0]) cylinder(d=30, h = ht_height);
    translate([grip_hole_right_xpos,grip_hole_right_ypos,0]) cylinder(d=30, h = ht_height);
}

module horizontal_template(){
    difference(){
        cube([120,180,ht_height]);
        translate([origin_shift,origin_shift,0]) curve_shape();
        translate([origin_shift-regular_line,0,ht_height-regular_line]) cube([regular_line,79,regular_line]);
        translate([0,origin_shift-regular_line,ht_height-regular_line]) cube([79,regular_line,regular_line]);
        translate([11,81,ht_height-regular_line]) linear_extrude(height = regular_line) text("10 mm", size = 5, halign= "center");
        translate([81,8.5,ht_height-regular_line]) linear_extrude(height = regular_line) text("10 mm", size = 7);
    }
}

echo("dtc_outer_radius: ", dtc_outer_radius-(dtc_inner_radius-65));

//horizontal_template();
//translate([10+ht_scope, 10, 0]) curve_with_drill_holes();


//curve_shape();
template_outer_curve();


//translate([100,0,0]) template_outer_curve();
//template_inner_curve();



