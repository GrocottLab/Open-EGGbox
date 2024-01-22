use <text_on.scad>; // https://github.com/brodykenrick/text_on_OpenSCAD

/*
    Copyright (C) 2017 Timothy Grocott <http://www.grocottlab.com>

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

innerD = 29; // Large enough to hold a 50 ml centrifuge tube
outerD = 50;
height = 25;

difference() {
    
    cylinder(d=outerD, h=height, $fn=1000, center=true);
    cylinder(d=innerD, h=height*2, $fn=500, center=true);
    translate([0,0,(height/2)-5])
    hull() {
        translate([0,0,+5])
        cylinder(d=(innerD+outerD)/2, h=0.01, $fn=500, center=true);
        translate([0,0,0])
        cylinder(d=innerD, h=0.01, $fn=500, center=true);
    }
    // Branding
    text_on_cylinder(t="www.grocottlab.com",r1=outerD/2,r2=outerD/2,h=-15,font="Liberation Mono:style=Bold", direction="ttb", size=5);
    rotate([0,0,-14])
    text_on_cylinder(t="Open EGGbox",r1=outerD/2,r2=outerD/2,h=1, font="Liberation Mono:style=Bold", direction="ttb", size=10);
}    
