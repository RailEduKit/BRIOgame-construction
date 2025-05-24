// Copyright 2020,2024 Martin Scheidt (Attribution 4.0 International, CC-BY 4.0)
//
// You are free to copy and redistribute the material in any medium or format.
// You are free to remix, transform, and build upon the material for any purpose, even commercially.
// You must give appropriate credit, provide a link to the license, and indicate if changes were made.
// You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.
// No warranties are given.

include<config.scad>

module switch_blade(thickness){ union(){
    difference(){
        intersection(){
            cylinder(r = blade_length, h = thickness);
            translate([-blade_width/2,0,0]) cube([blade_width,blade_length,thickness]); //why pin diameter in translate?
        };
        // flank left
        translate([-blade_width/2,-4,-thickness/4]) rotate(a=[0,0,6]) cube([3,blade_length,thickness*2]);
        // flank right
        translate([blade_width/3,-4,-thickness/4]) rotate(a=[0,0,-6]) cube([3,blade_length,thickness*2]);
    };
};
};

module lever_anchor(){
    cylinder(d = lever_hole_size, h = blade_thickness);
};

module cap_notch(male=true){
    if(male==true){
        cube([2,y_pos_second_pin-3*pin_diameter,blade_thickness/2+blade_cover_thicknes]);
    };
    if(male==false){
        cube([2+move_tolerance,y_pos_second_pin-3*pin_diameter+move_tolerance,blade_thickness]);
    };
};

module hole_for_om_pin(){
    cylinder(d=om_pin_diameter+move_tolerance, h=pin_height+overlap);
}

module pin(){
    difference(){
        cylinder(d = pin_diameter, h = pin_height);
        hole_for_om_pin();
    }
};


module pin_hole(){ union(){
    difference(){
        cylinder(d = pin_female_diameter, h = pin_height+overlap); //pin_diameter*1.3
        cylinder(d = pin_diameter, h = pin_height+overlap);
    };
};
};

module base_rounding(){
    difference(){
        translate([-blade_width/2,-blade_width/2,0]) cube([blade_width,blade_width,blade_thickness]);
        translate([0,blade_width/2,0]) cylinder(h=blade_thickness, d=blade_width);
//        translate([-blade_width/2,-(blade_width-y_pos_first_pin),0]) cube([blade_width,blade_width,blade_thickness]);
//        scale([1.5,1,1]) translate([0,y_pos_first_pin,0]) cylinder(h=blade_thickness, r=y_pos_first_pin);
    }
}

module switch_male(){ union(){
    difference(){
        switch_blade(blade_thickness);
        // lever_anchor
        translate([lever_anchor_posX,lever_anchor_posY, blade_cover_thicknes]) lever_anchor();
        translate([-lever_anchor_posX,lever_anchor_posY, blade_cover_thicknes]) lever_anchor();
        translate([0,y_pos_first_pin,0]) hole_for_om_pin();
    };
    translate([0,y_pos_first_pin,blade_thickness]) pin();
    translate([0,y_pos_second_pin,blade_thickness]) pin();
    
};
};

module switch_female(){ union(){
    difference(){
        switch_blade(blade_thickness-blade_cover_thicknes);
        //cap notch
        translate([-1,2*pin_diameter,0]) cap_notch(male=false);
        // lever_anchor
        translate([lever_anchor_posX,lever_anchor_posY,0]) lever_anchor();
        translate([-lever_anchor_posX,lever_anchor_posY,0]) lever_anchor();
        translate([0,y_pos_first_pin,0]) hole_for_om_pin();
        base_rounding();
    };
    translate([0,y_pos_first_pin,0]) pin_hole(); //Theoretically, the hole should be seen at the bottom
    translate([0,y_pos_second_pin,0]) pin_hole(); 
};
};

module cap(){ union(){
    difference(){union(){
    switch_blade(blade_cover_thicknes);
    translate([-1,2*pin_diameter,0]) cap_notch(male=true);
    }
    translate([0,y_pos_first_pin,0]) hole_for_om_pin();
    }
};
};

module print_to_console(){
    echo("pin_diameter*0.3", pin_diameter*0.3);
}
print_to_console();

//base_rounding();
switch_female();
//color("LightBlue") translate([(blade_width+2)/2,15,0]) rotate(a=[0,0,180]) switch_male();
//color("LightGreen") translate([-(blade_width+2)/2,-15,0]) switch_female();
//color("green") translate([-(blade_width+2)*1.5,15,0]) rotate(a=[0,0,180]) cap();



//pin();
//lever_anchor();
//switch_blade();