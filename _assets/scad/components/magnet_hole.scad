/* RailEduKit/InteractiveSignallingLaboratory © 2025 by Martin Scheidt and contributor
 * License: CC-BY 4.0 - https://creativecommons.org/licenses/by/4.0/
 * Project description: The Interactive Signalling Laboratory is a tool for training in Rail
 * Applications to enhance the knowledge of control and signalling principles for rail transport systems.
 *
 * Module: component/magnet_hole
 * Description: Magnet hole component is used to create a magnet hole in other bodies.
 */

module magnet_hole(){
    cylinder(h=magnet_thickness+move_tolerance, d=magnet_diameter+move_tolerance);
}
