// Copyright 2024 Martin Scheidt (Attribution 4.0 International, CC-BY 4.0)
//
// You are free to copy and redistribute the material in any medium or format.
// You are free to remix, transform, and build upon the material for any purpose, even commercially.
// You must give appropriate credit, provide a link to the license, and indicate if changes were made.
// You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.
// No warranties are given.

include<config.scad>

module diagonal_cutout(){
    translate([0,0,4])rotate([0,-20,0]) union(){
        cube([150, dsb_depth, 60]);
        // chamfer
        translate([155/2+2.6,dsc_y_pos,0])rotate([45,0,0])cube([150, 3, 3], center=true);
        translate([155/2+2.6,dsc_y_pos+dsc_depth,0])rotate([45,0,0])cube([150, 3, 3], center=true);
    }
}

module connector_space(){
difference(){
    cube([dsc_connector_width, dsb_depth, dsb_height]);
    translate([0,dsc_y_pos, dsc_connector_z_pos]) cube([dsc_connector_width,dsc_depth, dsc_connector_height]);
    translate([0, dsc_y_pos+(dsc_depth-thin_line)/2, dsb_height-thin_line]) cube([dsc_connector_width,thin_line,thin_line]);
}
}
module template_straight(){
difference(){
    cube([straight_length, dsb_depth, dsb_height]);
    //straight
    translate([0,dsc_y_pos,dsg_thickness]) cube([straight_length, dsc_depth, dsb_height]);
    // ground holes
    for (x=[straight_length-3*dsg_hole_depth : -10 : 5]){
        translate([x,dsc_y_pos,0]) cube([dsg_hole_depth,dsc_depth,dsg_thickness]);
    }
    diagonal_cutout();
   
    
    // hole position lines
    translate([straight_length-2*dsg_hole_depth, dsc_y_pos+(dsc_depth-thin_line)/2, dsg_thickness-thin_line]) cube([dsg_hole_depth,thin_line,thin_line]);
    translate([straight_length-dsh_x_pos-thin_line/2, dsc_y_pos, dsg_thickness-thin_line])cube([thin_line, dsc_depth, thin_line]);
    translate([straight_length-dsh_x_pos-thin_line/2, dsc_y_pos-dsc_depth, dsb_height-thin_line])cube([thin_line, dsc_depth, thin_line]);
    translate([straight_length-dsh_x_pos-thin_line/2, dsc_y_pos+dsc_depth, dsb_height-thin_line])cube([thin_line, dsc_depth, thin_line]);
    translate([straight_length-dsh_x_pos-thin_line/2, dsc_y_pos-thin_line, dsg_thickness-thin_line]) cube([thin_line, thin_line, dsb_height]);
    translate([straight_length-dsh_x_pos-thin_line/2, dsc_y_pos+dsc_depth, dsg_thickness-thin_line]) cube([thin_line, thin_line, dsb_height]);
    
}
//connector
translate([straight_length,0, 0]) connector_space();
//translate([-dsc_supporting_surface_width, dsc_y_pos, 0]) cube([dsc_supporting_surface_width, rail_height+move_tolerance, dsg_thickness]);
}

module test_print(){
    difference(){
        template_straight();
        cube([straight_length-30,50,50]);
    }
}

template_straight();
//diagonal_cutout();
//connector_space();
//test_print();