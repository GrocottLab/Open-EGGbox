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

$res        = 500; //100;
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
threadquality = 100;//500;
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

EGGbox_D1();

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

module EGGbox_D1() {
    dip = true;
    echo(dip);
    union() {
        difference() {
            if (dip) {
                difference() {
                    translate([0,0,-plate_H/2])
                    cylinder(d=baseD,h=1.45*plate_H,$fn=$res);
                    translate([0,0,plate_H])
                    cylinder(d=coverglassD+0.5,h=plate_H,$fn=$res,center=true);
                }
            } else {
                difference() {
                    cylinder(d=baseD,h=1.00*plate_H,$fn=$res,center=true);
                    translate([0,0,plate_H/2])
                    difference() {
                            cylinder(d=coverglassD+0.5,h=0.5,$fn=$res,center=true);
                            cylinder(d=coverglassD,h=2,$fn=$res,center=true);
                    }
                }
            }
 
            // Apperture
            translate([0,0,0])
            cylinder(d=appertureD,h=lidH*2,$fn=$res,center=true);
            // Hollow
            translate([0,0,-lidT])
            cylinder(d=(lidD-4.5)+clearance/2,h=lidH,$fn=$res,center=true);
        }
        difference() {
           // Add screw thread
           translate([0,0,-lidH])
           thread(male=false);
           // Trim top/bottom of screw thread
           translate([0,0,lidH-1])
           cylinder(d=lidD+1,h=lidH,$fn=$res,center=true);
           translate([0,0,-lidH])
           cylinder(d=lidD+1,h=lidH,$fn=$res,center=true);
       }
    }
}
