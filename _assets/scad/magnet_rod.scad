// Copyright 2024 Martin Scheidt (Attribution 4.0 International, CC-BY 4.0)
//
// You are free to copy and redistribute the material in any medium or format.
// You are free to remix, transform, and build upon the material for any purpose, even commercially.
// You must give appropriate credit, provide a link to the license, and indicate if changes were made.
// You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.
// No warranties are given.

include<config.scad>

magnet_rod();

module magnet_hole(){
    cylinder(h=magnet_thickness, d=magnet_diameter);
}

module color_line(){
    difference(){
            cylinder(d=mr_diameter, h=fine_line);
            cylinder(d=mr_diameter-fine_line, h=fine_line);
        }
}

module magnet_rod(){
    difference(){
        scale([1,1,1]) cylinder(d=mr_diameter, h=mr_height);
        magnet_hole();
        translate([0,0,mr_height-(magnet_thickness-move_tolerance)])magnet_hole();
        // color border line
        scale([1,0.5,1])translate([0,0,25-fine_line]) color_line();
        scale([1,0.5,1])translate([0,0,mr_height-25]) color_line();
    }
}