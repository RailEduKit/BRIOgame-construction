// Copyright 2020,2024 Martin Scheidt (Attribution 4.0 International, CC-BY 4.0)
//
// You are free to copy and redistribute the material in any medium or format.
// You are free to remix, transform, and build upon the material for any purpose, even commercially.
// You must give appropriate credit, provide a link to the license, and indicate if changes were made.
// You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.
// No warranties are given.

/*****
To have the dimensions of all components at one place
*******/

/*******
TODO
- standardisation of move tolerance
- standard on which part the move tolerance is substracted?
******/
// ATTENTION: Note the general move_tolerance of 0.5

move_tolerance = 0.5;

/***************wood rail specification***************/
wood_thickness_middle = 11.5;
wood_thickness_rail = 5.5;

straight_length = 144.5;

curve_radius = 182; // inner radius
curve_angle = 45; // degree

/***************magnet specifications***************/
magnet_thickness = 3;
magnet_diameter = 5;
magnet_distance_to_middle_y = 7.5;
magnet_z = 5.75;


/***************switch_blade_optimized***************/

//blade specification
blade_thickness = 2.5;
blade_cover_thicknes = 0.6; //attention: female blade is thinner -> effect on lever_anchor pins?
blade_length = 45;
blade_width  = 19;

//lever anchor specification
lever_hole_size = 2.7;
lever_anchor_posX = blade_width*1/5;
lever_anchor_posY = blade_length*0.8111;

//pin specification
pin_diameter = 5;
pin_female_diameter = pin_diameter+1.5;
pin_height = wood_thickness_rail+2; //2mm move tolerance
y_pos_first_pin = pin_diameter;
y_pos_second_pin = (blade_length*2/3);
overlap = blade_thickness-blade_cover_thicknes; // height of pin_hole, otherwise the pin_hole doesn't stand on the blade -> bug?

/***************overlap_measure***************/
// ATTENTION: Note the general move_tolerance of 0.5

/***************locking_pin***************/
locker_width = 14;
locker_height = 20;
lever_height = 10;
lever_thickness_switch = 4;
rounding = 0.5;

/***************distant-main_signal***************/
block_width=undef;

// body specifications
axis_diameter = 2.5; //maybe use the same material as lever anchor
body_width = 30; // material constraint
body_depth = 60; // minimum, because of the lockpin diameter
body_height = 13.5; // material constraint
wall_thickness_x = (body_width-block_width)/2-move_tolerance;//5;
wall_thickness_y = lever_thickness_switch;
wall_thickness_z = 2;
track_arc_inner_radius = 182;
sagitta = 0.43; //DE: Pfeilhöhe -> 25mm Straighten round edge in the middle
z_pos_axis = 10; // the block_height=13.5 lies a bit heigher, previous: block_height/2+wall_thickness_z

// Locking Part specifications
lock_lever_depth = 9.5;
lock_lever_thickness = 2.5;
lock_lever_height = 10;
foot_width = 2.5;

// color_block specifications
block_width = 20; //material constraint //body_width-2*wall_thickness_x-move_tolerance;
block_depth = (body_depth-2*wall_thickness_y)/2-3*move_tolerance;
block_height = 13.5; // material constraint
//block_height =(body_height-wall_thickness_z)*1.4; //the heigher the value, the more color_block comes out of the body. BUT also: the higher will be the axis hole
overhang = block_height/2-2*move_tolerance; //the circle has to be flattend at one side with move_tolerance
handle_depth = 10+wall_thickness_y;
handle_height = 3;

//Symbol Specifications
symbol_side_space = 4;
symbol_height = 1.5;//(block_height-handle_height)/2;
symbol_thickness = 1.5;
symbol_size = block_width-2*symbol_side_space;
triangle_height = (sqrt(3)*symbol_size)/2;

