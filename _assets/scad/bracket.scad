// Copyright 2020 Martin Scheidt (Attribution 4.0 International, CC-BY 4.0)
//
// You are free to copy and redistribute the material in any medium or format.
// You are free to remix, transform, and build upon the material for any purpose, even commercially.
// You must give appropriate credit, provide a link to the license, and indicate if changes were made.
// You may not apply legal terms or technological measures that legally restrict others from doing anything the license permits.
// No warranties are given.

// Fillet function (c) Andrew Plumb aka clothbot
//https://github.com/clothbot/ClothBotCreations/blob/master/utilities/fillet.scad

module fillet(r=1.0,steps=3,include=true) {
  if(include) for (k=[0:$children-1]) {
	children(k);
  }
  for (i=[0:$children-2] ) {
    for(j=[i+1:$children-1] ) {
	fillet_two(r=r,steps=steps) {
	  children(i);
	  children(j);
	  intersection() {
		children(i);
		children(j);
	  }
	}
    }
  }
}

module fillet_two(r=1.0,steps=3) {
  for(step=[1:steps]) {
	hull() {
	  render() intersection() {
		children(0);
		offset_3d(r=r*step/steps) children(2);
	  }
	  render() intersection() {
		children(1);
		offset_3d(r=r*(steps-step+1)/steps) children(2);
	  }
	}
  }
}

module offset_3d(r=1.0) {
  for(k=[0:$children-1]) minkowski() {
	children(k);
	sphere(r=r,$fn=8);
  }
}

// End Fillet function

fissure = 0.5;
pin_length = 10;
pin_width = 4;

difference(){
    union(){
        fillet(r=pin_width/4,steps=10) {
            cylinder(h = pin_width/2, d = pin_length);
            cylinder(h = 8, d = pin_width);
        }
        translate([0,0,8]) sphere(d = pin_width);
    }
    translate([-pin_length/2,-fissure/2,pin_width/2]) cube([pin_length,fissure,pin_length]);
}
