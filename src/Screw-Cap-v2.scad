use <ISOThread_revised2.scad>

/*
    Copyright (C) 2023 Timothy Grocott <http://www.grocottlab.com>

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

$res        = 100; //500;
lidD        = 35;
lidH        = 8;
lidT        = 2.2;
baseD       = lidD;
baseH       = 5;
baseT       = lidT;
appertureD  = 20;
coverglassD = 32;
coverglassH = 0.13;     // No. 1 cover glass = 0.13 mm thick
coverrecessD = 33;
coverrecessH = 0.1;
clearance   = 0.1;
threadquality = 100;
plate_W = 85.48;
plate_L = 127.76;
plate_H = lidH;
well_H = 25;
corner_R = 5;
offset_x = plate_L / 6;
offset_y = plate_W / 4;
x_spacing = 46;
y_spacing = 50;

// Screw dimensions
screw_diameter = 4;
head_diameter = 7.8;
head_depth = 3;



screw_cap();


module thread(male) {
    
    if (male == true) {
        difference() {
            // Make male thread
            thread_out(baseD-(baseT*2), lidH*1.7, threadquality);
            // Trim apex
            difference() {
                cylinder(d=2*baseD, h=lidH*1.7, $fn=$res);
                cylinder(d=baseD-5, h=lidH*2, $fn=$res);
            }
        }
    } else {
        difference() {
            // Make female thread
            thread_in(baseD-(baseT*2), lidH*2, threadquality);
            // Trim apex
            cylinder(d=baseD-6.8, h=lidH*2, $fn=$res);
        }
    }
}


module screw_cap() {
    translate([0,0,-0.5*lidH]) {
        difference() {
            union() {
                difference() {
                    union() {
                        // Base
                        translate([0,0,-0.01-lidH/2])
                        difference() {
                            cylinder(d=baseD-3,h=baseH,$fn=$res,center=true);
                            // Subtract knurls
                            knurlcount = 26;
                            for (i = [0 : 360/knurlcount : 360]) {
                                rotate([0,0,i])
                                translate([(baseD-3)/2,0,0])
                                cylinder(d=2.0,h=lidH*2,$fn=50,center=true);
                            }
                        }
                        // Add threaded Section
                        cylinder(d=(baseD-7.5)-clearance/2,h=baseH+lidH,$fn=$res,center=true);
                        
                        // Add screw thread
                        difference() {
                            translate([0,0,-3.5])
                            thread(male=true);
                            // Trim top of screw thread
                            translate([0,0,-0.01+baseH+lidH/2])
                            cylinder(d=baseD,h=baseH,$fn=$res,center=true);
                        }
                    }
                    // Subtract reservoir overhang
                    translate([0,0,+baseT-(lidH+baseH)/2])
                    difference() {
                        rotate_extrude($fn=100)
                        polygon( points=[ [0,0],[0,2],[(appertureD+5)/2,lidH+baseH-baseT*1.5],[(appertureD+5)/2,0] ] );
                        translate([0,0,+11.5]) cube([300,300,5], center=true);
                    }
                    translate([0,0,-baseT*1.25])
                    rotate_extrude($fn=100)
                    polygon( points=[ [0,0],[0,2],[(appertureD+5)/2,lidH+baseH-baseT*1.5],[0,lidH+baseH-baseT*1.5] ] );
                    // Subtract bottom hole
                    translate([0,0,+baseT])
                    cylinder(d=appertureD-4,h=baseH+lidH,$fn=$res,center=true);
                }
                // Stent wall
                translate([0,+(appertureD+2)/2+0.2,-baseH/2-0.01-lidH/2]) cylinder(d = 3, h=baseH*1.0, $fn=50);
                translate([0,-(appertureD+2)/2-0.2,-baseH/2-0.01-lidH/2]) cylinder(d = 3, h=baseH*1.0, $fn=50);
            }
            // Subtract stent lumen
            translate([0,+(appertureD+2)/2+0.2,-baseH/2-0.1-lidH/2]) cylinder(d = 1, h=baseH*1.5, $fn=50);
            translate([0,-(appertureD+2)/2-0.2,-baseH/2-0.1-lidH/2]) cylinder(d = 1, h=baseH*1.5, $fn=50);
        }
    }
}
