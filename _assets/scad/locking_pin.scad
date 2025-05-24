// Copyright 2024 Martin Scheidt (Attribution 4.0 International, CC-BY 4.0)
//
// You are free to copy and redistribute the material in any medium or format.
// You are free to remix, transform, and build upon the material for any purpose, even commercially.
// You must give appropriate credit, provide a link to the license, and indicate if changes were made.
// You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.
// No warranties are given.

include<config.scad>

locking_pin();

module grip_ring(){
    height = 1.2;
    depth = 1.2;
    difference(){
        cylinder(h=height, d=locker_width);
        cylinder(h=height, d=locker_width-depth);
    }
}
module locking_pin(){
    difference(){
    minkowski() {
        difference(){
            cylinder(d = locker_width-2*rounding, h = locker_height-2*rounding);
            rotate([0,0,90]) translate([(-locker_width/2),(-(lever_thickness_switch+move_tolerance)/2-rounding),(locker_height-lever_height)])cube([(locker_width),(lever_thickness_switch+2*rounding+move_tolerance),(lever_height+2*rounding)]);
        };
        sphere(rounding);
    }
    translate([0,0,1]) grip_ring();
    }
}

echo("lever_height+2*rounding: ",lever_height+2*rounding);
echo("z_pos_axis-handle_height/2+move_tolerance+2*rounding: ", z_pos_axis-handle_height/2+move_tolerance+2*rounding);

//signal_locker();
