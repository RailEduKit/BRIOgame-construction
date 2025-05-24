// Copyright 2020,2024 Martin Scheidt (Attribution 4.0 International, CC-BY 4.0)
//
// You are free to copy and redistribute the material in any medium or format.
// You are free to remix, transform, and build upon the material for any purpose, even commercially.
// You must give appropriate credit, provide a link to the license, and indicate if changes were made.
// You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.
// No warranties are given.

// preview[view:west, tilt:top]

/*************** resolution ***************/
// number of fragments; default 0;
//When this variable has a value greater than zero, the two variables $fa and $fs are ignored
$fn = $preview ? 32 : 128;

// $fa = 12;// minimum angle for a fragment; default 12; minimum allowed value is 0.01
// $fs = 2;// minimum size of a fragment; default 2; minimum allowed value is 0.01

/*****
To have the dimensions of all components at one place
*******/

/*******
TODO
- standard on which part the move tolerance is substracted?
******/
// ATTENTION: Note the general move_tolerance of 0.5

move_tolerance = 0.5;

{/***************wood rail specification***************/
    // rail instead of wood to prevent duplicate variables with tracklib.scad file
    rail_height = 12;
    rail_width = 40;
    rail_thickness_track = 6;
    rail_well_height = 9; // copy from tracklib
    rail_well_width = 5.7; // copy from tracklib
    rail_well_spacing = 19.25; // copy from tracklib

    straight_length = 144;

    curve_inner_radius = 180; // 182; // inner radius
    curve_middle_radius = curve_inner_radius+rail_width/2;
    curve_outer_radius = curve_inner_radius+rail_width;
    curve_angle = 45.7; // degree
}
{/***************magnet specifications***************/
    magnet_thickness = 3;
    magnet_diameter = 5;
    magnet_distance_to_middle = 7.5;
    magnet_z = 5.75;
}
{/***************engraving specifications***************/
    engraving_height = 2;//(block_height-handle_height)/2;
    engraving_thickness = 1.5;
    
  
    fine_line = 0.2;
    thin_line = 0.8;
    regular_line = 1;
}



{/***************basis_component-roundedBox***************/
    body_width = 30;
    body_depth = 50;
    body_height = 13.5; 
    track_arc_inner_radius = 182;
    sagitta = 0.43; //DE: Pfeilhöhe -> 25mm Straighten round edge in the middle
}


{/***************overlap_measure***************/
    // overlap measure -> om
    om_thickness = 2;
    // pin specifications
    om_pin_height = 5;
    om_pin_diameter = 4.5;
    om_pin_y_pos = 25;
    
    // track guidance
    om_track_guidance_width = 0.8;
    om_track_guidance_height = 2.5;
    
    //dovetail connector specifications
    om_dovetail_width = 10;
    om_dovetail_depth = 5;
    
    
}

{/***************straight***************/
    //straight = s
    // pin hole 1 = ph1
    s_ph_xpos = rail_width/2;
    s_ph1_ypos = 30;
    s_ph2_ypos = straight_length/2;
    s_ph3_ypos = straight_length-s_ph1_ypos;
    
    // magnet hole = mh
    s_mh_xpos = rail_width;
    s_mh_zpos = rail_height/2;
    s_mh_ypos1 = 7.5;
    s_mh_ypos2 = straight_length-s_mh_ypos1;
    
    
}

{/***************curve***************/
    

    // curve = c
    // pin hole 1 = ph1
    c_alpha = (s_ph1_ypos * 360)/(2*PI*curve_middle_radius);
    c_ph1_ypos = sin(c_alpha) * curve_middle_radius;
    c_ph1_xpos = curve_outer_radius - cos(c_alpha) * curve_middle_radius;
    // pin hole 2 = ph2
    c_beta = curve_angle/2;
    c_ph2_ypos = sin(c_beta) * curve_middle_radius;
    c_ph2_xpos = curve_outer_radius - cos(c_beta) * curve_middle_radius;
    // pin hole 3 = ph3
    c_gamma = curve_angle - c_alpha;
    c_ph3_ypos = sin(c_gamma) * curve_middle_radius;
    c_ph3_xpos = curve_outer_radius - cos(c_gamma) * curve_middle_radius;

    echo("  ");
    echo("c_ph1_ypos", c_ph1_ypos);
    echo("c_ph1_xpos", c_ph1_xpos);
    echo("  ");
    echo("c_ph2_ypos", c_ph2_ypos);
    echo("c_ph2_xpos", c_ph2_xpos);
    echo("  ");
    echo("c_ph3_ypos", c_ph3_ypos);
    echo("c_ph3_xpos", c_ph3_xpos);
    echo("  ");

    c_mh_zpos = rail_height/2;
    // magnet hole 4 = mh1
    c_mh4_xpos = 0.1;
    c_mh4_ypos = 7.7;
    c_mh4_zrot = -2;
    // magnet hole 5 = mh1
    c_mh5_xpos = 40.3;
    c_mh5_ypos = 7.5;
    c_mh5_zrot = -2.4;
    // magnet hole 6 = mh1
    c_mh6_xpos = 61;
    c_mh6_ypos = 152;
    c_mh6_zrot = -43.7;
    // magnet hole 7 = mh1
    c_mh7_xpos = 89.05;
    c_mh7_ypos = 123.35;
    c_mh7_zrot = -43.3;
    
}



{/***************switch_blade_optimized***************/
    //blade specification
    blade_thickness = 2.5;
    blade_cover_thicknes = 0.6; //attention: female blade is thinner -> effect on lever_anchor pins?
    blade_length = 42;
    blade_width  = 19;

    //lever anchor specification
    lever_hole_size = 2.6;
    lever_anchor_posX = blade_width*1/5;
    lever_anchor_posY = blade_length*0.8111;

    //pin specification
    wall_thickness = 1.5;
    pin_diameter = om_pin_diameter+move_tolerance+wall_thickness;
    pin_female_diameter = pin_diameter+move_tolerance+wall_thickness;
    pin_height = rail_thickness_track+move_tolerance;
    y_pos_first_pin = pin_female_diameter/2+1;
    y_pos_second_pin = (blade_length*2/3);
    overlap = blade_thickness-blade_cover_thicknes; // height of pin_hole, otherwise the pin_hole doesn't stand on the blade -> bug?
}
{/***************switch_body***************/
    //holes_for_blade
    pivot_center_x = rail_width/2;
    pivot_center_y= s_ph1_ypos;
    
    //switchblade_space -> sbs
    sbs_gap_to_wood = 1.5;
    sbs_width = rail_width;
    sbs_radius = blade_length+2*sbs_gap_to_wood;
    sbs_height = rail_height-rail_well_height;
    sbs_xpos = -rail_well_width-2;
    sbs_ypos = pivot_center_y - y_pos_first_pin-sbs_gap_to_wood;
}

{/***************locking_pin***************/
    locker_width = 14;
    locker_height = 25;
    lever_height = 10;
    lever_thickness_switch = 4;
    rounding = 0.5;
}
{/***************distant-main_signal***************/
    block_width=undef;

    // body specifications
    axis_diameter = 2; //maybe use the same material as lever anchor
    wall_thickness_x = (body_width-block_width)/2-move_tolerance;//5;
    wall_thickness_y = lever_thickness_switch;
    wall_thickness_z = 2;
    z_pos_axis = 10; // the block_height=13.5 lies a bit heigher, previous: block_height/2+wall_thickness_z
    attach_arrow_wall_distance = 0.8;
    attach_arrow_depth = wall_thickness_x-2*attach_arrow_wall_distance;
    attach_arrow_height = 1.2;

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
    signal_symbol_side_space = 4;
    signal_symbol_size = block_width-2*signal_symbol_side_space;
    signal_triangle_height = (sqrt(3)*signal_symbol_size)/2;
}
{/***************clearing_point***************/
    zs_with = 25;
    zs_depth = 10;
    zs_height = 15;

    cp_symbol_side_space = 2;
    cp_symbol_size = zs_depth-2*cp_symbol_side_space;
}

{/***************drill_template_straight***************/
    drill_move_tolerance = 0.3;
    // drill straight ground
    dsg_thickness = 5;
    dsg_hole_depth = 5;
    // drill straight cutout = dsc
    dsc_connector_width = 15;
    dsc_connector_height = 15;
    dsc_y_pos = 12;
    dsc_depth = rail_height+drill_move_tolerance;

    dsc_connector_z_pos = dsg_thickness+12;
    dsc_supporting_surface_width = 50;

    // drill straight hole
    dsh_y_pos = dsc_depth/2;
    dsh_x_pos = 7.5;

    // drill straigth base = dsb
    dsb_depth = 2*dsc_y_pos+dsc_depth;
    dsb_height = dsg_thickness+rail_width;//27;
}

{/***************drill_template_curve***************/
    // drill template curve = dtc
    dtc_cutout_middle_angle = 45+5;

    dtc_cutout_z_pos = 12;
    dtc_cutout_height = dsc_depth;
    dtc_outer_radius = curve_inner_radius+rail_width;
    dtc_side_radius = curve_inner_radius + 28;
    dtc_middle_radius = curve_inner_radius + 12;
    dtc_inner_radius = curve_inner_radius;

    dtc_height = 2*dtc_cutout_z_pos+dtc_cutout_height;

    // drill template curve hole
    dtch_z_pos = dsc_depth/2;
    dtch_y_pos = 7.5;

    dtc_switch_hole_y_pos = straight_length-dtch_y_pos;
    
    // horizontal template = ht
    origin_shift = 10;
    ht_scope = 0.1;
    ht_male_connector_angle = 1.8; //6mm
    ht_height = rail_height/2;
    ht_beta = curve_angle+ht_male_connector_angle;
    male_connector_space_xpos = (curve_outer_radius)-cos(ht_beta)*curve_middle_radius;
    male_connector_space_ypos = sin(ht_beta)*curve_middle_radius;
    
    grip_hole_left_xpos = (curve_outer_radius)-cos(ht_beta/2)*curve_outer_radius;
    grip_hole_left_ypos = sin(ht_beta/2)*curve_outer_radius;
    grip_hole_right_xpos = (curve_outer_radius)-cos(ht_beta/2)*curve_inner_radius;
    grip_hole_right_ypos = sin(ht_beta/2)*curve_inner_radius;
}
{/***************drill_template_switch***************/
    // all needed values in "drill_template_curve" and "drill_template_straight"
}

{/***************magnet_rod***************/
    //magnet rod = mr
    mr_diameter = 20;
    mr_height = 100;
    
}



{/***************roadCheckbox***************/
    // used "basis_component-roundedBox" and "locking_pin"
    //road Checkbox -> rc
    rc_symbol_side_space = 2;
    rc_symbol_size = body_width*(2/3)-locker_width/2-2*rc_symbol_side_space;
    echo("rc_symbol_size: ", rc_symbol_size);
    rc_symbol_xpos = body_width - (body_width - (body_width*(1/3)+locker_width/2))/2;
    straight_thickness = 0.8;
    rc_arrow_depth = 4;
    rc_arrowline_length = 4;
    slash_angle = 45; // 53,13
    
    junction_r=11.5;
}

{/***************direction_management***************/
    arrow_depth = 6.5; //5 for onePiece
    arrowline_length = 6.5; //5 for onePiece
    
    
    arrow_block_height = 9-engraving_height;
    overlap_cube_depth = arrow_block_height/2;
    arrow_block_depth = block_depth - overlap_cube_depth;
    
}

{/***************number_plate***************/
    // number_plate = np
    np_diameter = rail_well_spacing-2*3;
    np_height = 1;
    number_height = 0.6;
    np_pin_diameter = om_pin_diameter;
    np_pin_height = om_pin_height;
    frame_width = 180;
    frame_depth = 180;
    step_size = np_diameter+2*move_tolerance;
    x_start = -(frame_width/2-np_diameter/2-1);
    y_start = -(frame_depth/2-np_diameter/2-1);
}

{/***************balise***************/
    balise_width = rail_well_spacing-2*3;
    balise_depth = 2* balise_width;
    balise_height = np_height;
    
    balise_pin_diameter = om_pin_diameter;
    balise_pin_height = om_pin_height;

}

{/***************coupler***************/
    thinnest_layer     = 0.2;
    
    coupling_radius    = 13/2;
    coupling_depth     = 8;
    coupling_curvature = 2;
    coupling_cut_pos   = coupling_radius*1/2;
    boogie_width       = 20;
    coupler_thickness          = 1.5;
    lipp_height        = 4;
    lipp_width         = coupler_thickness - move_tolerance;
    shield_width       = 20;
    shield_depth        = 25;
    shield_thickness   = 2;
    inlay_thickness    = 0.45;
    inlay_radius       = 10.5/2;

    headlight_d = (1/3)*shield_width;
}

echo("signal_symbol_size: ", signal_symbol_size);




