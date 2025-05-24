// Copyrigengraving_heightt 2020,2024 Martin Scengraving_heighteidt (Attribution 4.0 International, CC-BY 4.0)
//
// You are free to copy and redistribute tengraving_heighte material in any medium or format.
// You are free to remix, transform, and build upon tengraving_heighte material for any purpose, even commercially.
// You must give appropriate credit, provide a link to tengraving_heighte license, and indicate if cengraving_heightanges were made.
// You may not apply legal terms or tecengraving_heightnological measures tengraving_heightat legally restrict otengraving_heighters from doing anytengraving_heighting tengraving_heighte license permits.
// No warranties are given.


include<config.scad>
use <BOSL2/std.scad> // Import std from dependency BelfrySCAD/BOSL2.git
use<./basis_component-roundedBox.scad>
use<./locking_pin.scad> // used in "visualize_arrowBlock_in_body"
//V_axis();
//T_axis();
//cavity_cube();
//visualize_onePiece_with_locker();
//onedirect_arrow();
arrow_block();
//visualize_arrowBlock_in_body("-yz");
translate([30,0,0]) direction_management_flipFlop();
//guide_cube();
//direction_management_onePiece();
//bidirectional_arrow();
module bidirectional_arrow(){
    translate([-arrowline_length/2,-engraving_thickness/2,0])cube([arrowline_length,engraving_thickness,engraving_height]);

    translate([arrow_depth*(3/8)+arrowline_length/2,0,0]) scale([3/4,(arrow_depth/(2*arrow_depth*sin(120))),1]) cylinder(engraving_height,arrow_depth,arrow_depth,$fn=3);
    
    rotate([0,0,180]) translate([arrow_depth*(3/8)+arrowline_length/2,0,0]) scale([3/4,(arrow_depth/(2*arrow_depth*sin(120))),1]) cylinder(engraving_height,arrow_depth,arrow_depth,$fn=3);
}

module onedirect_arrow(){
    translate([-arrowline_length,-3/2,0])cube([arrowline_length,3,engraving_height]);
    translate([arrow_depth*(3/8),0,0]) scale([3/4,(arrow_depth/(2*arrow_depth*sin(120))),1]) cylinder(engraving_height,arrow_depth,arrow_depth,$fn=3);
}

module guide_cube(){
    diff() cuboid([body_width-2*wall_thickness_x+0.1, arrow_block_depth + 2.5*move_tolerance, z_pos_axis - arrow_block_height/2 - move_tolerance - wall_thickness_z], anchor=BOTTOM+LEFT+FWD, rounding=2, edges=TOP+BACK){ // rounding = 2 because you can turn the block without neutral position with 3mm rounding
        //remove middle
        tag("remove") position(TOP) cuboid([8, arrow_block_depth+ 2.5*move_tolerance, z_pos_axis - arrow_block_height/2 - move_tolerance - wall_thickness_z], anchor=TOP);
        //add middle with rounding
        tag("keep") position(BOTTOM) cuboid([8, arrow_block_depth - engraving_height - move_tolerance, z_pos_axis - arrow_block_height/2 - move_tolerance - wall_thickness_z - engraving_height], anchor=BOTTOM, rounding =2, edges=TOP+BACK);
    }
}

module cavity_cube(){
    translate([wall_thickness_x,wall_thickness_y,wall_thickness_z]) difference(){
        cube([body_width-2*wall_thickness_x, body_depth-2*wall_thickness_y, body_height-wall_thickness_z]);
        guide_cube();
        translate([body_width-2*wall_thickness_x,body_depth-2*wall_thickness_y,0]) zrot(180) guide_cube();

    }
}

module T_axis() {
    hull() {
        translate([0, -overlap_cube_depth, 0])cylinder(h=body_width, d=axis_diameter+move_tolerance);
        translate([0, overlap_cube_depth, 0])cylinder(h=body_width, d=axis_diameter+move_tolerance);
    }
    hull() {
        cylinder(h=body_width, d=axis_diameter+move_tolerance);
        translate([overlap_cube_depth-2*move_tolerance, 0, 0]) cylinder(h=body_width, d=axis_diameter+move_tolerance);
    }
}
module Y_axis() {
    hull(){
        fwd(overlap_cube_depth) cylinder(h=body_width, d=axis_diameter+move_tolerance);
        right(overlap_cube_depth/2) cylinder(h=body_width, d=axis_diameter+move_tolerance);
    }
    hull(){
        back(overlap_cube_depth) cylinder(h=body_width, d=axis_diameter+move_tolerance);
        right(overlap_cube_depth/2) cylinder(h=body_width, d=axis_diameter+move_tolerance);
    }
    hull() {
        right(overlap_cube_depth/2) cylinder(h=body_width, d=axis_diameter+move_tolerance);
        right((3/2)*overlap_cube_depth) cylinder(h=body_width, d=axis_diameter+move_tolerance);
    }
}

module V_axis() {
    hull(){
        fwd(overlap_cube_depth) cylinder(h=body_width, d=axis_diameter+move_tolerance);
        right((3/2)*overlap_cube_depth) cylinder(h=body_width, d=axis_diameter+move_tolerance);
    }
    hull(){
        back(overlap_cube_depth) cylinder(h=body_width, d=axis_diameter+move_tolerance);
        right((3/2)*overlap_cube_depth) cylinder(h=body_width, d=axis_diameter+move_tolerance);
    }
    right((1/6)*overlap_cube_depth+0.25) difference(){
        translate([(axis_diameter+move_tolerance)/2,0,body_width/2]) cube([(axis_diameter+move_tolerance),axis_diameter,body_width], center = true);
        down(0.1)cylinder(h=body_width+0.2, d=axis_diameter+move_tolerance);
    }
}

module handle_space_cubes(){
    translate([wall_thickness_x,0,z_pos_axis-(handle_height)/2-move_tolerance]) cube([body_width-2*wall_thickness_x,wall_thickness_y,body_height]); //z=wall_thickness_z+(arrow_block_height-handle_height)/2
    translate([wall_thickness_x,body_depth-wall_thickness_y,z_pos_axis-(handle_height)/2-move_tolerance]) cube([body_width-2*wall_thickness_x,wall_thickness_y,body_height]);
}

module direction_management_onePiece(){
    difference(){
        curvedBox(); // import from basis_component-roundedBox
        translate([body_width*(1/2),body_depth*(1/6),wall_thickness_z])cylinder(d=locker_width+move_tolerance, h=body_height-wall_thickness_z);
        translate([body_width*(1/2),body_depth*(5/6),wall_thickness_z])cylinder(d=locker_width+move_tolerance, h=body_height-wall_thickness_z);
    }
    translate([body_width/2, body_depth/2, body_height])rotate([0,0,90]) bidirectional_arrow();
}




module direction_management_flipFlop(){
    difference(){
        curvedBox(); // import from basis_component-roundedBox
        cavity_cube();
        //axis
        translate([0,body_depth/2,z_pos_axis]) rotate([0,90,0]) V_axis();//cylinder(h=body_width, d=axis_diameter+move_tolerance);
        // handle space
        handle_space_cubes();
        // locker pin hole
        difference(){
            translate([body_width/2,body_depth-wall_thickness_y/2,0]) cylinder(h=locker_height, d=locker_width+2*move_tolerance);
            translate([wall_thickness_x+move_tolerance,body_depth-wall_thickness_y,0])cube([block_width,locker_width,locker_height]);
            }
        difference(){
            translate([body_width/2,wall_thickness_y/2,0]) cylinder(h=locker_height, d=locker_width+2*move_tolerance);
            translate([wall_thickness_x+move_tolerance,-locker_width+wall_thickness_y,0])cube([block_width,locker_width,locker_height]);
        }
    }    
}

module arrow_block(){
    difference(){
        union(){
            cube([block_width, arrow_block_depth, arrow_block_height]);
            translate([0,arrow_block_depth,0])cube([block_width, overlap_cube_depth, arrow_block_height]);
            //translate([0,arrow_block_depth+overlap_cube_depth,arrow_block_height/2]) scale([1,0.5,1]) rotate([0,90,0]) cylinder(h=block_width, r=arrow_block_height/2); // scale y: (overhang)/(arrow_block_height/2) // curve is flat, because the printer can't make that much overhang
            //handle
            translate([0,-handle_depth, (arrow_block_height-handle_height)/2]) cube([block_width, handle_depth, handle_height]);
        }
        //axis
        translate([0,arrow_block_depth,arrow_block_height/2]) rotate([0,90,0]) cylinder(h=block_width, d=axis_diameter);
        // locker pin hole
        translate([block_width/2,-wall_thickness_y/2-3*move_tolerance,0]) cylinder(h=locker_height, d=locker_width+2*move_tolerance);        
    }
    // arrows
    translate([block_width/2,block_depth/2+(locker_width)/2-4.5,arrow_block_height]) rotate([0,0,-90])onedirect_arrow();
    translate([block_width/2,block_depth/2+(locker_width)/2-4.5,-engraving_height]) rotate([0,0,-90])onedirect_arrow();
}



module visualize_arrowBlock_in_body(state){
    difference(){
        union(){
            translate([0,-body_depth/2,-z_pos_axis]) direction_management_flipFlop(); //z=-arrow_block_height/2-wall_thickness_z
            if(state== "-y"){
                rotate([0,0,0]) translate([wall_thickness_x + move_tolerance, -(arrow_block_depth+overlap_cube_depth),-arrow_block_height/2-wall_thickness_z+wall_thickness_z]) arrow_block(); // translate y = -body_depth/2 + wall_thickness_y+3*move_tolerance
                translate([body_width/2,-(body_depth-wall_thickness_y)/2,locker_height-0.5-z_pos_axis]) rotate([180,0,90]) locking_pin();
            }
            if(state== "-yz"){
                translate([0,-overlap_cube_depth/2,-(overlap_cube_depth)/4]) rotate([-45,0,0]) translate([wall_thickness_x + move_tolerance, -arrow_block_depth,-arrow_block_height/2-wall_thickness_z+wall_thickness_z]) arrow_block();
                translate([body_width/2,-(body_depth-wall_thickness_y)/2,locker_height-0.5-z_pos_axis]) rotate([180,0,90]) locking_pin();
            }
            if(state == "z"){
                down(overlap_cube_depth/2) rotate([-90,0,0]) translate([wall_thickness_x + move_tolerance, -arrow_block_depth,-arrow_block_height/2-wall_thickness_z+wall_thickness_z]) arrow_block();
                translate([body_width/2,-(body_depth-wall_thickness_y)/2,locker_height-0.5-z_pos_axis]) rotate([180,0,90]) locking_pin();
            }
            if(state == "-z"){
                #down((3/2)*overlap_cube_depth) rotate([-90,0,0]) translate([wall_thickness_x + move_tolerance, -arrow_block_depth,-arrow_block_height/2-wall_thickness_z+wall_thickness_z]) arrow_block();
                translate([body_width/2,-(body_depth-wall_thickness_y)/2,locker_height-0.5-z_pos_axis]) rotate([180,0,90]) locking_pin();
            }
            if(state== "y"){
                rotate([-180,0,0]) translate([wall_thickness_x + move_tolerance, -body_depth/2 + wall_thickness_y+3*move_tolerance,-arrow_block_height/2-wall_thickness_z+wall_thickness_z]) arrow_block();
                translate([body_width/2,(body_depth-wall_thickness_y)/2,locker_height-0.5-z_pos_axis]) rotate([180,0,90]) locking_pin();
            }
        }
        //cut
        translate([15,-50,-25])cube([50,100,50]);
    }
}

module visualize_onePiece_with_locker(){
    direction_management_onePiece();
    translate([body_width*(1/2),body_depth*(1/6),locker_height-0.5+wall_thickness_z]) rotate([180,0,90]) locking_pin();
}



    