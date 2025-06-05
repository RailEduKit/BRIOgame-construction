+++
title = "3D Printing Guide"
+++

# 3D Printing Guide for SigLab Components

This guide provides detailed instructions for 3D printing the components of the wooden version of SigLab. All STL files are available in the `_assets/stl-files` directory.

## Printer Requirements

* FDM (Fused Deposition Modeling) printer
* Recommended build volume: 200x200x200mm or larger
* Recommended materials: PLA or PETG
* Layer height: 0.2mm for most parts, 0.1mm for detailed parts

## Component List

### Track Components
* `drill_template_straight.stl` - Template for straight track sections
* `drill_template_curve.stl` - Template for curved track sections
* `drill_template_switch.stl` - Template for switch sections

### Signal Components
* `signal_body-main.stl` - Main signal body
* `signal_body-distant.stl` - Distant signal body
* `color_block-main.stl` - Main signal color block
* `color_block-distant.stl` - Distant signal color block
* `routeSignal.stl` - Route signal component
* `route_clearing_point.stl` - Route clearing point indicator

### Train Components
* `train_headlight_coupler.stl` - Train front coupler with headlight
* `train_tail_coupler.stl` - Train rear coupler
* `train_headlight_symbol.stl` - Headlight symbol
* `train_tail_symbol.stl` - Tail symbol

### Switch Components
* `switch_blade.stl` - Switch blade mechanism
* `locking_pin.stl` - Switch locking mechanism

### Additional Components
* `magnet_rod_round.stl` - Round magnet rod
* `magnet_rod_oval.stl` - Oval magnet rod
* `number_plate_$fn25.stl` - Number plate base
* `number_plate_numbers_$fn25.stl` - Number plate digits

## Printing Instructions

### General Settings
* Infill: 20-30%
* Wall thickness: 2-3 perimeters
* Support: Where necessary (especially for overhangs)
* Bed adhesion: Brim or raft recommended

### Specific Component Settings

#### Signal Bodies
* Layer height: 0.2mm
* Support: Yes
* Orientation: Upright
* Infill: 25%

#### Track Templates
* Layer height: 0.2mm
* Support: No
* Orientation: Flat
* Infill: 30%

#### Train Components
* Layer height: 0.1mm for detailed parts
* Support: Yes for couplers
* Orientation: As per STL file
* Infill: 30%

## Post-Processing

1. Remove support material carefully
2. Sand smooth any rough edges
3. Clean up any stringing
4. Test fit components before assembly

## Quality Control

Before proceeding to assembly, ensure:
* All components fit together properly
* Moving parts move freely
* No warping or significant defects
* Proper layer adhesion

## Next Steps

After printing all components:
1. Proceed to the [Assembly Guide](assembly.md)
2. Review the [Materials List](materials.md)
3. Begin the construction process

## Troubleshooting

Common issues and solutions:
* Warping: Use proper bed adhesion and temperature settings
* Layer separation: Check filament quality and temperature
* Poor detail: Reduce layer height and print speed
* Support removal: Use proper support settings and tools