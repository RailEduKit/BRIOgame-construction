/* RailEduKit/InteractiveSignallingLaboratory © 2025 by Martin Scheidt and contributor
 * License: CC-BY 4.0 - https://creativecommons.org/licenses/by/4.0/
 * Project description: The Interactive Signalling Laboratory is a tool for training in Rail
 * Applications to enhance the knowledge of control and signalling principles for rail transport systems.
 *
 * Module: Balise
 * Description: Balise is a component that is used to detect the presence of a train.
 * It is used to control the train's speed and direction.
 * It is also used to detect the train's position.
 */

// Include configuration file
include <config.scad>

module balise(){
    translate([0,0,balise_height/2]) cube([balise_width, balise_depth, balise_height], center = true);
    translate([0,0,balise_height]) cylinder(d=balise_pin_diameter, h=balise_pin_height);
}

balise();
