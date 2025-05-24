// Copyright 2020,2024 Martin Scheidt (Attribution 4.0 International, CC-BY 4.0)
//
// You are free to copy and redistribute the material in any medium or format.
// You are free to remix, transform, and build upon the material for any purpose, even commercially.
// You must give appropriate credit, provide a link to the license, and indicate if changes were made.
// You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.
// No warranties are given.


include<config.scad>
use<./basis_component-roundedBox.scad>
use<./locking_pin.scad> // used in visualize_colorBlock_in_body("main", "y");


module equ_triangle(side_length,corner_radius,signal_triangle_height){
    // copy from https://www.youtube.com/watch?v=5hDB8Nsd688
    translate([0,corner_radius]){
    hull(){
        cylinder(r=corner_radius,h=signal_triangle_height);
     rotate([0,0,60])translate([side_length-corner_radius*2,0,0])cylinder(r=corner_radius,h=signal_triangle_height);   
         rotate([0,0,120])translate([side_length-corner_radius*2,0,0])cylinder(r=corner_radius,h=signal_triangle_height);
        };
};
};

module attach_arrow(){
    hull() {
        cyl_d = 0.4;
        translate([cyl_d/2,(attach_arrow_depth-cyl_d)/2,0]) cylinder(d=cyl_d, h=attach_arrow_height);
        translate([cyl_d/2,-(attach_arrow_depth-cyl_d)/2,0]) cylinder(d=cyl_d, h=attach_arrow_height);
        translate([attach_arrow_depth-cyl_d/2,0,0]) cylinder(d=cyl_d, h=attach_arrow_height);

    }
}

module driving_direction_arrow(){
    translate([attach_arrow_depth/2,0,0]) rotate([0,0,-90])attach_arrow();
    translate([(attach_arrow_depth-1.2)/2,0,0]) cube([1.2,attach_arrow_depth, attach_arrow_height]);
}


//symbol_main();
module symbol_main(){
    difference(){
        cube([signal_symbol_size, signal_symbol_size, engraving_height]);
        translate([engraving_thickness,engraving_thickness,0]) cube([signal_symbol_size-2*engraving_thickness, signal_symbol_size-2*engraving_thickness, engraving_height]);
    }
}
//symbol_distant();
module symbol_distant(){
    // symbol_distant = sb
    cylinder_diameter = 0.4;
    sb_beta = atan(1/2);
    sb_gamma = 180-90-sb_beta;
    sb_theta = 90-sb_gamma;
    top_cyl_ydif = engraving_thickness/sin(sb_beta);
    bottom_cyl_xdif = engraving_thickness/sin(sb_gamma) + tan(sb_theta)*engraving_thickness;

    difference(){
        hull(){
            translate([signal_symbol_size/2,cylinder_diameter/2,0])cylinder(d=cylinder_diameter, h=engraving_height);
            translate([cylinder_diameter/2, signal_symbol_size-cylinder_diameter/2,0]) cylinder(d=cylinder_diameter, h=engraving_height);
            translate([signal_symbol_size-cylinder_diameter/2, signal_symbol_size-cylinder_diameter/2,0])cylinder(d=cylinder_diameter, h=engraving_height);
        }
        hull(){
            translate([signal_symbol_size/2,top_cyl_ydif+cylinder_diameter/2,0])cylinder(d=cylinder_diameter, h=engraving_height);
            translate([bottom_cyl_xdif+cylinder_diameter/2, signal_symbol_size-engraving_thickness-cylinder_diameter/2,0]) cylinder(d=cylinder_diameter, h=engraving_height);
            translate([signal_symbol_size-bottom_cyl_xdif-cylinder_diameter/2, signal_symbol_size-engraving_thickness-cylinder_diameter/2,0])cylinder(d=cylinder_diameter, h=engraving_height);
        }
    } 
}

module cavity_cube(){
    translate([wall_thickness_x,wall_thickness_y,wall_thickness_z]) cube([body_width-2*wall_thickness_x, body_depth-2*wall_thickness_y, body_height-wall_thickness_z]);
}
module handle_space_cubes(){
    translate([wall_thickness_x,0,z_pos_axis-(handle_height)/2-move_tolerance]) cube([body_width-2*wall_thickness_x,wall_thickness_y,body_height]); //z=wall_thickness_z+(block_height-handle_height)/2
    translate([wall_thickness_x,body_depth-wall_thickness_y,z_pos_axis-(handle_height)/2-move_tolerance]) cube([body_width-2*wall_thickness_x,wall_thickness_y,body_height]);
}

module space_locking_pin(){
    translate([0, body_depth/2 - magnet_distance_to_middle - magnet_diameter - 2*move_tolerance - lock_lever_depth, body_height - lock_lever_height])cube([wall_thickness_x-lock_lever_thickness, lock_lever_depth+move_tolerance, lock_lever_height]);
}
//body("main");

module body(symbol_type){
    difference(){
        curvedBox(); // import from basis_component-roundedBox
        cavity_cube();
        //axis
        translate([0,body_depth/2,z_pos_axis]) rotate([0,90,0]) cylinder(h=body_width, d=axis_diameter);
        // handle space
        handle_space_cubes();
        // locker pin hole
        if(symbol_type=="main"){
            difference(){
                translate([body_width/2,body_depth-wall_thickness_y/2,0]) cylinder(h=locker_height, d=locker_width+2*move_tolerance);
                translate([wall_thickness_x+move_tolerance,body_depth-wall_thickness_y,0])cube([block_width,locker_width,locker_height]);
            }
        }
    }
    //translate([body_width-wall_thickness_x+attach_arrow_wall_distance,body_depth/2,body_height]) attach_arrow();
    translate([body_width-wall_thickness_x+attach_arrow_wall_distance,body_depth/2,body_height]) driving_direction_arrow();
    translate([attach_arrow_wall_distance,body_depth/2,body_height]) driving_direction_arrow();
    if(symbol_type=="main"){
        lock_block_width = 6;
        lock_block_depth = 2;
        lock_block_height = z_pos_axis-handle_height/2-move_tolerance+handle_height;
        translate([(body_width-lock_block_width)/2, wall_thickness_y,0])cube([lock_block_width,lock_block_depth,lock_block_height]);
    }
}

//color_block(("distant"));
module color_block(symbol_type){
    difference(){
        union(){
            cube([block_width, block_depth, block_height]);
            translate([0,block_depth,block_height/2]) scale([1,0.5,1]) rotate([0,90,0]) cylinder(h=block_width, r=block_height/2); // scale y: (overhang)/(block_height/2) // curve is flat, because the printer can't make that much overhang
            //handle
            translate([0,-handle_depth, (block_height-handle_height)/2]) cube([block_width, handle_depth, handle_height]);
        }
        //axis
        translate([0,block_depth,block_height/2]) rotate([0,90,0]) cylinder(h=block_width, d=axis_diameter+move_tolerance);
        // color border line
        //translate([0,0,(block_height-handle_height)/2-fine_line])cube([fine_line, 2*block_depth, fine_line]);
        //translate([0,0,(block_height+handle_height)/2])cube([fine_line, 2*block_depth, fine_line]);
        //symbol
        if(symbol_type == "main"){
            translate([signal_symbol_side_space, 4*(block_depth-signal_symbol_size)/5,0]) symbol_main();
            translate([signal_symbol_side_space,4*(block_depth-signal_symbol_size)/5,block_height-engraving_height]) symbol_main();
            // locker pin hole
            translate([block_width/2,-wall_thickness_y/2-3*move_tolerance,0]) cylinder(h=locker_height, d=locker_width+2*move_tolerance);
        }
        if (symbol_type == "distant"){
            translate([signal_symbol_size+signal_symbol_side_space,signal_symbol_size+4*(block_depth-signal_symbol_size)/5,0]) rotate([0,0,180]) symbol_distant();
            translate([signal_symbol_side_space,4*(block_depth-signal_symbol_size)/5,block_height-engraving_height]) symbol_distant();
        }
        
    }
}


module visualize_colorBlock_in_body(symbol_type, state){
    translate([0,-body_depth/2,-z_pos_axis]) body(symbol_type); //z=-block_height/2-wall_thickness_z
    if(state== "-y"){
        rotate([0,0,0]) translate([wall_thickness_x + move_tolerance, -body_depth/2 + wall_thickness_y+3*move_tolerance,-block_height/2-wall_thickness_z+wall_thickness_z]) color_block(symbol_type=symbol_type);
    }
    if(state== "y"){
        rotate([-180,0,0]) translate([wall_thickness_x + move_tolerance, -body_depth/2 + wall_thickness_y+3*move_tolerance,-block_height/2-wall_thickness_z+wall_thickness_z]) color_block(symbol_type=symbol_type);
        if(symbol_type=="main"){
            translate([body_width/2,(body_depth-wall_thickness_y)/2,locker_height-0.5-z_pos_axis]) rotate([180,0,90]) locking_pin();
        }
    }
}

module prove_moveability(){
    //move_tolerance space between bottom and color_block
    translate([0,-body_depth/2,-block_height/2]) cube([body_width,body_depth,2*move_tolerance]);
    //middle position
    rotate([-90,0,0]) translate([wall_thickness_x + move_tolerance, -body_depth/2 + wall_thickness_y+move_tolerance*2,-block_height/2-wall_thickness_z+wall_thickness_z]) color_block(symbol_type=symbol_type);
}

module print_components(symbol_type){
    body(symbol_type);
    translate([-30,handle_depth,0]) color_block(symbol_type=symbol_type);
}

module unworked_color_block(){
    height = block_height;
    width = block_width;
    depth = block_depth+handle_depth+height/2;
    cube([width, depth, height]);
    
}


module mill_color_block_side() {
    projection(cut = true) rotate([0,90,0]) difference(){
        unworked_color_block(); 
        translate([0,handle_depth,0]) color_block("distant");
        
    }
//    %unworked_color_block();
//    translate([0,handle_depth,0]) color_block(symbol_type);
}

module mill_color_block_top(symbol_type){
    projection(cut=true)difference(){
        unworked_color_block();
        if(symbol_type == "main"){
            translate([signal_symbol_side_space,(block_depth-signal_symbol_size)/2 + handle_depth,0]) symbol_main();
        }
        if (symbol_type == "distant"){
            translate([block_width/2,(block_depth-signal_triangle_height)/2 + handle_depth,0]) symbol_distant();
        }
    }
    
}
module mill_color_block_bottom_distant() {
    projection(cut=true)difference(){
        unworked_color_block();
        translate([block_width/2,signal_triangle_height+(block_depth-signal_triangle_height)/2 + handle_depth,0]) rotate([0,0,180]) symbol_distant();
    }
}


module mill_signal_body_top_2(symbol_type){
    projection(cut=true) difference(){
            cube([body_width, body_depth, body_height]);
            body(symbol_type);
        }
        projection() handle_space_cubes();
    }
module mill_signal_body_top_1(symbol_type){
    projection(cut=true) difference(){
            cube([body_width, body_depth, body_height]);
            translate([0,0,-wall_thickness_z]) cavity_cube(); //has to be moved to the ground
            if (symbol_type == "main"){
                translate([0,0, -(body_height - lock_lever_height)]) space_locking_pin(); //has to be moved to the ground
                translate([body_width-(wall_thickness_x-lock_lever_thickness+move_tolerance),0,-(body_height - lock_lever_height)])space_locking_pin(); //has to be moved to the ground
                
            }
    }
}

module mill_signal_body_side(){
    // its always "distant" because the locking part shouldn't be visible at the side projection.
     projection(cut=true) translate([body_height,0,-(body_width-2)])rotate([0,-90,0])body("distant");
}
  
module values_to_console(){
    echo("handle space: ", (block_height-handle_height)/2);
    echo("axis height: ", block_height/2+wall_thickness_z);
    echo("wall_thickness_x: ", wall_thickness_x);
    echo("block_depth: ", block_depth);
    echo("y pos lockpin: ", body_depth/2 - magnet_distance_to_middle - magnet_diameter - move_tolerance*2 - lock_lever_depth);
    echo("(block_height-handle_height)/2: ",(block_height-handle_height)/2);
    echo("(block_height+handle_height)/2: ", (block_height+handle_height)/2);
}

module 2D_drawing_signal_body(symbol_type){
    translate([50, 50, 0]) union(){
        projection(cut = true) translate([0,0,-7])body(symbol_type);
        projection(cut = true) translate([50, 0, -body_width+1.5])rotate([0,-90,0]) body(symbol_type);
        projection(cut = true) translate([-20,0,1.5]) rotate([0,90,0]) body(symbol_type);
        projection(cut = true) translate([0,70,0]) rotate([90,0,0])body(symbol_type);
        projection(cut = true) translate([0,-20,0]) rotate([-90,0,0])body(symbol_type);
        projection(cut = true) translate([0,90,-body_depth/2]) rotate([90,0,0])body(symbol_type);
    }
}

module 2D_drawing_color_block(symbol_type){
     translate([50, 50, 0]) union(){
        mill_color_block_top(symbol_type);
        projection(cut=true) translate([30,handle_depth,block_width/2]) rotate([0,90,0]) color_block(symbol_type);
        projection(cut = true) translate([-20,handle_depth,0]) rotate([0,90,0]) color_block(symbol_type);
        projection(cut = true) translate([0, 60, -block_width-axis_diameter/2]) rotate([90,0,0]) color_block(symbol_type);
        if(symbol_type == "distant"){
           translate([50,0,0]) mill_color_block_bottom_distant();
        } 
    }
}
//visualize_colorBlock_in_body("distant", "y");
//print_components("main");

color_block("main");



//body("distant");
//symbol_distant();


/********************************
drawing
********************************/
//2D_drawing_signal_body("main");
//body("main");

//2D_drawing_signal_body("distant");
//body("distant");

//2D_drawing_color_block("main");
//color_block("main");

//2D_drawing_color_block("distant");
//color_block("distant");

/********************************
mill
**********************************/
//mill_color_block_side();
//mill_color_block_top("main");
//mill_color_block_bottom_distant();
//mill_signal_body_top_1("main");
//mill_signal_body_top_2("main");
//mill_signal_body_side();

values_to_console();


