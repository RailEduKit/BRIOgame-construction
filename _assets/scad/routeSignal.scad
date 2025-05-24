// Copyright 2020,2024 Martin Scheidt (Attribution 4.0 International, CC-BY 4.0)
//
// You are free to copy and redistribute the material in any medium or format.
// You are free to remix, transform, and build upon the material for any purpose, even commercially.
// You must give appropriate credit, provide a link to the license, and indicate if changes were made.
// You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.
// No warranties are given.


include<config.scad>
use<./basis_component-roundedBox.scad>

routeSignal();

//overlap_symbol();
//turnout_locking_symbol();
//side_protection_symbol();

module bidirectional_arrow(){
    translate([-rc_arrowline_length/2,-1.2/2,0])cube([rc_arrowline_length,1.2,engraving_height]);

    translate([rc_arrow_depth*(3/8)+rc_arrowline_length/2,0,0]) scale([3/4,(rc_arrow_depth/(2*rc_arrow_depth*sin(120))),1]) cylinder(engraving_height,rc_arrow_depth,rc_arrow_depth,$fn=3);
    
    rotate([0,0,180]) translate([rc_arrow_depth*(3/8)+rc_arrowline_length/2,0,0]) scale([3/4,(rc_arrow_depth/(2*rc_arrow_depth*sin(120))),1]) cylinder(engraving_height,rc_arrow_depth,rc_arrow_depth,$fn=3);
}

module overlap_symbol(){
//    translate([0,0,engraving_height/2]) rotate([0,0,45]) cube([rc_symbol_size*(2/3), rc_symbol_size*(2/3), engraving_height], center=true);
    module overlap(){
        difference(){ union(){
            translate([-rc_symbol_size/2,-rc_symbol_size*(4/6),0])difference(){
                cube([rc_symbol_size, rc_symbol_size*(4/3), engraving_height]);
                for(i= [1:4:rc_symbol_size*(5/3)]){
                    translate([straight_thickness,i*straight_thickness,0]) cube([rc_symbol_size-straight_thickness, straight_thickness, engraving_height]);
                    echo(i);
                }
                for(i= [3:4:rc_symbol_size*(5/3)]){
                    translate([0,i*straight_thickness,0]) cube([rc_symbol_size-straight_thickness, straight_thickness, engraving_height]);
                }
            }
        }
            translate([-5.5,-1,engraving_height/2])rotate([0,0,53.13])cube([25,10,engraving_height],center=true);
        }
    }
    module slash(){
        translate([-0.1,-0.1,engraving_height/2])rotate([0,0,53.13])cube([15.5,1,engraving_height],center=true);
    }
    
    module arrow(){
        difference(){
            translate([-1, 1.8, 0]) rotate([0,0,53.13]) bidirectional_arrow();
            translate([3.7,-1.7,engraving_height/2]) rotate([0,0,53.13]) cube([15,10,engraving_height], center = true);
        }
//        difference(){
//            translate([-1, 1.8, 0]) rotate([0,0,53.13]) bidirectional_arrow();
//            translate([3.1,-1.1,engraving_height/2]) rotate([0,0,53.13]) cube([15,10,engraving_height], center = true);
//        }
        
    }
    overlap();
    slash();
    translate([-0.3,0,0]) arrow();
    //translate([0,-1,0]) arrow();
}
 
module turnout_locking_symbol(){
    module schematic_drawing(){
        translate([-rc_symbol_size/2,-2,0]) 
        linear_extrude(height = engraving_height) union(){
            polygon(points=[[0,0], [rc_symbol_size/2,0], [rc_symbol_size/2,rc_symbol_size/2]]);
            translate([1,0])square([rc_symbol_size-1, straight_thickness]);
            translate([1.15,0])rotate([0,0,45])square([rc_symbol_size, straight_thickness]);
        }
    }
    module junction_curve(){
        rotate_extrude(angle=50) difference(){
           square([junction_r,engraving_height]);
           square([junction_r-regular_line,engraving_height]);
        }
    }
    module junction(){
        translate([-regular_line/2,0,0])cube([regular_line,1,engraving_height]);
        translate([-(junction_r-regular_line/2),1,0])junction_curve();
        translate([junction_r-regular_line/2,1,engraving_height])rotate([0,180,0])junction_curve();
    }
    translate([0,-5,0]) junction();
}

module side_protection_symbol(){
    module buckler_half(){
        translate([rc_symbol_size*(2/3),0,0]) difference(){
            cylinder(d=3*rc_symbol_size, h=engraving_height);
            translate([-rc_symbol_size*(3/2), 0,0]) cube([6*rc_symbol_size, 6*rc_symbol_size, engraving_height]);
            translate([-rc_symbol_size*(2/3), -rc_symbol_size*(3/2),0]) cube([6*rc_symbol_size, 6*rc_symbol_size, engraving_height]);
        }
    }
    module buckler(){
        translate([0,6,0])difference(){
            scale([5/8,1,1])union(){
                buckler_half();
                mirror([1,0,0]) buckler_half();
            }
            scale([1,0.5,1])translate([0,rc_symbol_size*(6/7),0]) cylinder(d=2*rc_symbol_size, h=engraving_height);
            translate([0,-14,2])rotate([0,15,0])cube([rc_symbol_size,14,3]);
            translate([0,0,2])rotate([0,15,180]) cube([rc_symbol_size,14,3]);
        }
    }
    buckler();
    //buckler_half();
}


module routeSignal(){
    difference(){
        curvedBox(); // import from basis_component-roundedBox
        for (y=[body_depth*(1/6), body_depth/2, body_depth*(5/6)]){
            translate([body_width*(1/3),y,wall_thickness_z])cylinder(d=locker_width+move_tolerance, h=body_height-wall_thickness_z);
        }
    }
    translate([rc_symbol_xpos,body_depth*(1/6),body_height]) turnout_locking_symbol(); 
    translate([rc_symbol_xpos,body_depth*(3/6),body_height]) side_protection_symbol();
    translate([rc_symbol_xpos,body_depth*(5/6),body_height]) overlap_symbol();
}