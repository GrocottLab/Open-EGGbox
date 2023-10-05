use <ISOThread_revised2.scad>

/*
    Copyright (C) 2017 Timothy Grocott <http://www.grocottlab.com> & Melissa Antoniou-Kourounioti 

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */


// All units in mm

// Electrode Dimensions
tolerance = 0.2;
platinum_length = 5;
platinum_width  = 5;
platinum_depth  = 0.55;
wire_length     = 35.0;
wire_diameter    = 0.45;

// Chamber Dimensions
reservoir_diameter = 40.0;
reservoir_depth    = 6.0; //4.0 v1
overhang = 0.5;
window_length = platinum_length - 2*overhang;
window_width  = platinum_width  - 2*overhang;
corner_radius = 0.5;
well_depth     = 5; //3.0 v1
well_angle = 40; // side angle in  degrees
well_diameter1 = 2.0;
well_diameter2 = well_diameter1 + (2 * ( well_depth / tan(well_angle) ));
chamber_length = 60.0;
chamber_width  = 60.0;
upper_depth    = reservoir_depth + well_depth + platinum_depth;
lower_depth    = 5.0;

// Screw dimensions
screw_diameter = 4;
head_diameter = 7.8;
head_depth = 3;


//upper_chamber(chamber_length, chamber_width, upper_depth);
lower_chamber(chamber_length, chamber_width, lower_depth);


module upper_chamber(length, width, depth) {
    
    difference() {
        translate([0,0,depth/2])
          cube([length,width,depth], center=true);
        union() {
          // Electrode cut-out
          translate([0,0,0])
            cube([tolerance + platinum_length, 
                  tolerance + platinum_width, 
                 (tolerance + platinum_depth) * 2], center=true);
          
          // Wire channel
          quarter_torus();
          // Reservoir cut-out
          translate([0,0,reservoir_depth + well_depth + platinum_depth])
            cylinder(h=reservoir_depth*2, d=reservoir_diameter, $fn=500, center=true);
          // Well cut-out
          translate([0,0,(well_depth/2)-1.25])
            well(window_length, window_width, well_depth, corner_radius, well_angle);
            window(window_length, window_width, 10, corner_radius);
          // Screw holes
          translate([-screw_diameter/2, 2+(reservoir_diameter/2), (depth/2)])
            rotate([-90,0,0])
              cylinder(h = (chamber_length-reservoir_diameter)/2, d = screw_diameter, $fn=500);
          for(i = [1 : 4]) {
              rotate([0,0,90*i])
              translate([(chamber_length/2)-10, (chamber_width/2)-10, -2])
                cylinder(h = depth, d = screw_diameter, $fn=500);
          }
        }
    }
    // Screw threads
    translate([-screw_diameter/2, 2+(reservoir_diameter/2), (depth/2)])
      rotate([-90,0,0])
        thread_in(screw_diameter, ((chamber_length-reservoir_diameter)/2)-2, 50);
    for (i = [1 : 4] ) {
       rotate([0,0,90*i])
        translate([(chamber_length/2)-10, (chamber_width/2)-10, 0]) 
         thread_in(screw_diameter, depth-2, 50);
    }
}

module quarter_torus() {

    diameter = (wire_diameter + tolerance);
    translate([0,(chamber_width/2)-(diameter*2.5),diameter*2.5])
    rotate([-90,0,-90])
    difference() {
        rotate_extrude(angle=360, $fn=100, convexity=20) {
            translate([3 * diameter,0,0]) union() {
                translate([diameter/2,0,0])
                square([diameter,diameter], center=true);
                circle(d=diameter, $fn=50);
            }
        }
        union() {
            translate([diameter*2,diameter*2,0]) cube([diameter*4,diameter*4,diameter*2], center=true);
            translate([diameter*2,-diameter*2,0]) cube([diameter*4.1,diameter*4.1,diameter*2], center=true);
            translate([-diameter*2,-diameter*2,0]) cube([diameter*4,diameter*4,diameter*2], center=true);
        }
    }
}


module well(length, width, depth, corner_radius, side_angle) {
    hull() {
      window(length, width, 0.1, corner_radius);
      translate([0,0,well_depth]) cylinder(d = (length + (2*(depth/tan(side_angle) )) ), h = well_depth, $fn = 500);
        
    }
}

module window(length, width, depth, corner_radius) {
    hull() {
        translate([+(length-corner_radius)/2,+(width-corner_radius)/2,0]) cylinder(h = depth, r = corner_radius, $fn = 500, center=true);
        translate([+(length-corner_radius)/2,-(width-corner_radius)/2,0]) cylinder(h = depth, r = corner_radius, $fn = 500, center=true);
        translate([-(length-corner_radius)/2,+(width-corner_radius)/2,0]) cylinder(h = depth, r = corner_radius, $fn = 500, center=true);
        translate([-(length-corner_radius)/2,-(width-corner_radius)/2,0]) cylinder(h = depth, r = corner_radius, $fn = 500, center=true);
    }
}

module lower_chamber(length, width, depth) {
    tolerance = 0.1;
    difference() {
        translate([0,0,-depth/2])
          cube([length,width,depth], center=true);
        union() {
          translate([0,((tolerance+wire_length)/2)-(tolerance+wire_diameter),-(tolerance+wire_diameter)/2])
            rotate([90,0,0]) {
              cylinder(h= wire_length, 
                       d= tolerance + wire_diameter, 
                       $fn=500, center=true);
              translate([-(tolerance+wire_diameter)/2,0,-wire_length/2])
                cube([tolerance + wire_diameter,tolerance + wire_diameter,wire_length]);
        
            }
            // Triangle
            translate([0,0.5,0])
            scale([1,2.25,1])
            rotate([0,0,90])
            cylinder(d=4*wire_diameter, h=2*(tolerance + wire_diameter), $fn=3, center=true);
          // Screw holes
          for(i = [1 : 4]) {
              rotate([0,0,90*i])
              translate([(chamber_length/2)-10, (chamber_width/2)-10, -depth*1.5])
                cylinder(h = depth * 2, d = screw_diameter, $fn=500);
          }
          // Counter sinks
          for(i = [1 : 4]) {
              rotate([0,0,90*i])
              //translate([0,0,-])
                hull() {
                    translate([(chamber_length/2)-10, (chamber_width/2)-10, -(depth-1)])
                      cylinder(h = head_depth, d1 = head_diameter, d2 = screw_diameter, $fn=500);
                    translate([(chamber_length/2)-10, (chamber_width/2)-10,-head_diameter*2])
                      cylinder(h = 0.1, d = head_diameter, $fn=500);
                }
              
          }
        }
    }
}

module electrode_negative(tolerance) {
    electrode(tolerance + platinum_length, 
              tolerance + platinum_width, 
              tolerance + platinum_depth, 
              tolerance + wire_length, 
              tolerance + wire_diameter);
}

module electrode(length, width, depth, lead, diameter) {
    translate([0,0,depth/2])
    union() {
        color([0.75,0.75,0.75])
          cube([length, width, depth], center=true);
        color("red")
          translate([0,(lead/2)-diameter,-(depth+diameter)/2])
            rotate([90,0,0])
            cylinder(h=lead, d=diameter, $fn=500, center=true);
    }
}