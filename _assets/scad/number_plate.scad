// Copyright 2024 Martin Scheidt (Attribution 4.0 International, CC-BY 4.0)
//
// You are free to copy and redistribute the material in any medium or format.
// You are free to remix, transform, and build upon the material for any purpose, even commercially.
// You must give appropriate credit, provide a link to the license, and indicate if changes were made.
// You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.
// No warranties are given.

include<config.scad>

module frame(){
    difference(){
        cube([frame_width,frame_depth,2], center = true);
        cube([frame_width-1,frame_depth-1,3], center = true);
    }
}

module piece_number(number) {
    translate([0,0,number_height]) rotate([180,0,0]) linear_extrude(height = number_height) text(str(number), 7.5, halign="center", valign="center");
}

module number_plate(number){
    difference(){
        cylinder(d=np_diameter, h=np_height);
        piece_number(number);
    }
    translate([0,0,np_height]) cylinder(h= np_pin_height, d= np_pin_diameter);
}

module plate_collection(){
    /* counter = 0;
    for(x = [-(frame_width/2-np_diameter/2-1): np_diameter+2*move_tolerance: (frame_width/2-np_diameter/2-1)]){
        for(y= [-(frame_depth/2-np_diameter/2-1): np_diameter+2*move_tolerance: (frame_depth/2-np_diameter/2-1)]){
            translate([x,y,0])number_plate(counter);
            counter = counter + 1;
        }
    } */
    // generated with number_plates_creation.jl
    // still slow with rendering.
    translate([x_start+0*step_size,y_start+0.0*step_size,0])number_plate(1);
    translate([x_start+0*step_size,y_start+1.0*step_size,0])number_plate(2);
    translate([x_start+0*step_size,y_start+2.0*step_size,0])number_plate(3);
    translate([x_start+0*step_size,y_start+3.0*step_size,0])number_plate(4);
    translate([x_start+0*step_size,y_start+4.0*step_size,0])number_plate(5);
    translate([x_start+1*step_size,y_start+0.0*step_size,0])number_plate(6);
    translate([x_start+1*step_size,y_start+1.0*step_size,0])number_plate(7);
    translate([x_start+1*step_size,y_start+2.0*step_size,0])number_plate(8);
    translate([x_start+1*step_size,y_start+3.0*step_size,0])number_plate(9);
    translate([x_start+1*step_size,y_start+4.0*step_size,0])number_plate(10);
    translate([x_start+2*step_size,y_start+0.0*step_size,0])number_plate(11);
    translate([x_start+2*step_size,y_start+1.0*step_size,0])number_plate(12);
    translate([x_start+2*step_size,y_start+2.0*step_size,0])number_plate(13);
    translate([x_start+2*step_size,y_start+3.0*step_size,0])number_plate(14);
    translate([x_start+2*step_size,y_start+4.0*step_size,0])number_plate(15);
    translate([x_start+3*step_size,y_start+0.0*step_size,0])number_plate(16);
    translate([x_start+3*step_size,y_start+1.0*step_size,0])number_plate(17);
    translate([x_start+3*step_size,y_start+2.0*step_size,0])number_plate(18);
    translate([x_start+3*step_size,y_start+3.0*step_size,0])number_plate(19);
    translate([x_start+3*step_size,y_start+4.0*step_size,0])number_plate(20);
    translate([x_start+4*step_size,y_start+0.0*step_size,0])number_plate(21);
    translate([x_start+4*step_size,y_start+1.0*step_size,0])number_plate(22);
    translate([x_start+4*step_size,y_start+2.0*step_size,0])number_plate(23);
    translate([x_start+4*step_size,y_start+3.0*step_size,0])number_plate(24);
    translate([x_start+4*step_size,y_start+4.0*step_size,0])number_plate(25);
    translate([x_start+5*step_size,y_start+0.0*step_size,0])number_plate(26);
    translate([x_start+5*step_size,y_start+1.0*step_size,0])number_plate(27);
    translate([x_start+5*step_size,y_start+2.0*step_size,0])number_plate(28);
    translate([x_start+5*step_size,y_start+3.0*step_size,0])number_plate(29);
    translate([x_start+5*step_size,y_start+4.0*step_size,0])number_plate(30);
    translate([x_start+6*step_size,y_start+0.0*step_size,0])number_plate(31);
    translate([x_start+6*step_size,y_start+1.0*step_size,0])number_plate(32);
    translate([x_start+6*step_size,y_start+2.0*step_size,0])number_plate(33);
    translate([x_start+6*step_size,y_start+3.0*step_size,0])number_plate(34);
    translate([x_start+6*step_size,y_start+4.0*step_size,0])number_plate(35);
    translate([x_start+7*step_size,y_start+0.0*step_size,0])number_plate(36);
    translate([x_start+7*step_size,y_start+1.0*step_size,0])number_plate(37);
    translate([x_start+7*step_size,y_start+2.0*step_size,0])number_plate(38);
    translate([x_start+7*step_size,y_start+3.0*step_size,0])number_plate(39);
    translate([x_start+7*step_size,y_start+4.0*step_size,0])number_plate(40);
    translate([x_start+8*step_size,y_start+0.0*step_size,0])number_plate(41);
    translate([x_start+8*step_size,y_start+1.0*step_size,0])number_plate(42);
    translate([x_start+8*step_size,y_start+2.0*step_size,0])number_plate(43);
    translate([x_start+8*step_size,y_start+3.0*step_size,0])number_plate(44);
    translate([x_start+8*step_size,y_start+4.0*step_size,0])number_plate(45);
    translate([x_start+9*step_size,y_start+0.0*step_size,0])number_plate(46);
    translate([x_start+9*step_size,y_start+1.0*step_size,0])number_plate(47);
    translate([x_start+9*step_size,y_start+2.0*step_size,0])number_plate(48);
    translate([x_start+9*step_size,y_start+3.0*step_size,0])number_plate(49);
    translate([x_start+9*step_size,y_start+4.0*step_size,0])number_plate(50);
    translate([x_start+10*step_size,y_start+0.0*step_size,0])number_plate(51);
    translate([x_start+10*step_size,y_start+1.0*step_size,0])number_plate(52);
    translate([x_start+10*step_size,y_start+2.0*step_size,0])number_plate(53);
    translate([x_start+10*step_size,y_start+3.0*step_size,0])number_plate(54);
    translate([x_start+10*step_size,y_start+4.0*step_size,0])number_plate(55);
    translate([x_start+11*step_size,y_start+0.0*step_size,0])number_plate(56);
    translate([x_start+11*step_size,y_start+1.0*step_size,0])number_plate(57);
    translate([x_start+11*step_size,y_start+2.0*step_size,0])number_plate(58);
    translate([x_start+11*step_size,y_start+3.0*step_size,0])number_plate(59);
    translate([x_start+11*step_size,y_start+4.0*step_size,0])number_plate(60);
}

module number_collection(){
    translate([x_start+0*step_size,y_start+0.0*step_size,0])piece_number(1);
    translate([x_start+0*step_size,y_start+1.0*step_size,0])piece_number(2);
    translate([x_start+0*step_size,y_start+2.0*step_size,0])piece_number(3);
    translate([x_start+0*step_size,y_start+3.0*step_size,0])piece_number(4);
    translate([x_start+0*step_size,y_start+4.0*step_size,0])piece_number(5);
    translate([x_start+1*step_size,y_start+0.0*step_size,0])piece_number(6);
    translate([x_start+1*step_size,y_start+1.0*step_size,0])piece_number(7);
    translate([x_start+1*step_size,y_start+2.0*step_size,0])piece_number(8);
    translate([x_start+1*step_size,y_start+3.0*step_size,0])piece_number(9);
    translate([x_start+1*step_size,y_start+4.0*step_size,0])piece_number(10);
    translate([x_start+2*step_size,y_start+0.0*step_size,0])piece_number(11);
    translate([x_start+2*step_size,y_start+1.0*step_size,0])piece_number(12);
    translate([x_start+2*step_size,y_start+2.0*step_size,0])piece_number(13);
    translate([x_start+2*step_size,y_start+3.0*step_size,0])piece_number(14);
    translate([x_start+2*step_size,y_start+4.0*step_size,0])piece_number(15);
    translate([x_start+3*step_size,y_start+0.0*step_size,0])piece_number(16);
    translate([x_start+3*step_size,y_start+1.0*step_size,0])piece_number(17);
    translate([x_start+3*step_size,y_start+2.0*step_size,0])piece_number(18);
    translate([x_start+3*step_size,y_start+3.0*step_size,0])piece_number(19);
    translate([x_start+3*step_size,y_start+4.0*step_size,0])piece_number(20);
    translate([x_start+4*step_size,y_start+0.0*step_size,0])piece_number(21);
    translate([x_start+4*step_size,y_start+1.0*step_size,0])piece_number(22);
    translate([x_start+4*step_size,y_start+2.0*step_size,0])piece_number(23);
    translate([x_start+4*step_size,y_start+3.0*step_size,0])piece_number(24);
    translate([x_start+4*step_size,y_start+4.0*step_size,0])piece_number(25);
    translate([x_start+5*step_size,y_start+0.0*step_size,0])piece_number(26);
    translate([x_start+5*step_size,y_start+1.0*step_size,0])piece_number(27);
    translate([x_start+5*step_size,y_start+2.0*step_size,0])piece_number(28);
    translate([x_start+5*step_size,y_start+3.0*step_size,0])piece_number(29);
    translate([x_start+5*step_size,y_start+4.0*step_size,0])piece_number(30);
    translate([x_start+6*step_size,y_start+0.0*step_size,0])piece_number(31);
    translate([x_start+6*step_size,y_start+1.0*step_size,0])piece_number(32);
    translate([x_start+6*step_size,y_start+2.0*step_size,0])piece_number(33);
    translate([x_start+6*step_size,y_start+3.0*step_size,0])piece_number(34);
    translate([x_start+6*step_size,y_start+4.0*step_size,0])piece_number(35);
    translate([x_start+7*step_size,y_start+0.0*step_size,0])piece_number(36);
    translate([x_start+7*step_size,y_start+1.0*step_size,0])piece_number(37);
    translate([x_start+7*step_size,y_start+2.0*step_size,0])piece_number(38);
    translate([x_start+7*step_size,y_start+3.0*step_size,0])piece_number(39);
    translate([x_start+7*step_size,y_start+4.0*step_size,0])piece_number(40);
    translate([x_start+8*step_size,y_start+0.0*step_size,0])piece_number(41);
    translate([x_start+8*step_size,y_start+1.0*step_size,0])piece_number(42);
    translate([x_start+8*step_size,y_start+2.0*step_size,0])piece_number(43);
    translate([x_start+8*step_size,y_start+3.0*step_size,0])piece_number(44);
    translate([x_start+8*step_size,y_start+4.0*step_size,0])piece_number(45);
    translate([x_start+9*step_size,y_start+0.0*step_size,0])piece_number(46);
    translate([x_start+9*step_size,y_start+1.0*step_size,0])piece_number(47);
    translate([x_start+9*step_size,y_start+2.0*step_size,0])piece_number(48);
    translate([x_start+9*step_size,y_start+3.0*step_size,0])piece_number(49);
    translate([x_start+9*step_size,y_start+4.0*step_size,0])piece_number(50);
    translate([x_start+10*step_size,y_start+0.0*step_size,0])piece_number(51);
    translate([x_start+10*step_size,y_start+1.0*step_size,0])piece_number(52);
    translate([x_start+10*step_size,y_start+2.0*step_size,0])piece_number(53);
    translate([x_start+10*step_size,y_start+3.0*step_size,0])piece_number(54);
    translate([x_start+10*step_size,y_start+4.0*step_size,0])piece_number(55);
    translate([x_start+11*step_size,y_start+0.0*step_size,0])piece_number(56);
    translate([x_start+11*step_size,y_start+1.0*step_size,0])piece_number(57);
    translate([x_start+11*step_size,y_start+2.0*step_size,0])piece_number(58);
    translate([x_start+11*step_size,y_start+3.0*step_size,0])piece_number(59);
    translate([x_start+11*step_size,y_start+4.0*step_size,0])piece_number(60);
}

//frame();
plate_collection();
//number_collection();
//number_plate(34);
//piece_number(34);
//numberPlate_collection();