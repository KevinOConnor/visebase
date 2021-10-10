// ViseBase - Base for panavise with inserts for 1/4" PT pipes
//
// Copyright (C) 2021  Kevin O'Connor <kevin@koconnor.net>
//
// This file may be distributed under the terms of the GNU GPLv3 license.

// Vise description:
//  inner base dia = 90mm, bolt dia = 109.5, outer base dia = 130
// Description of 1/4" PT thread taken from:
//  https://en.wikipedia.org/wiki/British_standard_pipe_thread

base_dia = 130;
base_height = 13;
base_leg_height = 9;
leg_width = 25;
vise_inner_dia = 90;
vise_bolt_dia = 109.5;
vise_screw_dia = 6;
hexnut_dia = 10.5;
hexnut_height = 5;
thread_slack = 0.25;
thread_length = 10;
slack = 1;
CUT = 0.01;
$fs = 0.5;

use <threads.scad>;

module visebase() {
    module base() {
        inner_d = vise_inner_dia + 2*slack;
        difference() {
            cylinder(d=base_dia, h=base_height, $fn=100);
            translate([0, 0, -CUT])
                cylinder(d=inner_d, h=base_height+2*CUT, $fn=100);
        }
    }
    module leg_cut() {
        module leg() {
            leg_x = base_dia/2 + CUT;
            leg_h = base_height - base_leg_height + CUT;
            translate([0, -leg_width/2, base_leg_height])
                cube([leg_x, leg_width, leg_h]);
        }
        module screw_hole() {
            translate([vise_bolt_dia/2, 0, -CUT])
                cylinder(d=vise_screw_dia, h=base_height+2*CUT);
        }
        module hexnut_hole() {
            translate([vise_bolt_dia/2, 0, -CUT])
                cylinder(d=hexnut_dia, h=hexnut_height+CUT, $fn=6);
            translate([vise_bolt_dia/2, 0, hexnut_height-CUT])
                cylinder(d1=hexnut_dia, d2=vise_screw_dia, h=2, $fn=6);
        }

        leg();
        screw_hole();
        hexnut_hole();
    }
    module pipe_thread() {
        d = 13.157 + thread_slack;
        l = thread_length + slack + CUT;
        metric_thread(length=l, diameter=d, pitch=1.337, taper=1/16, angle=55);
        //cylinder(d=d, h=l);
    }
    module pipe_hole() {
        translate([vise_bolt_dia/2, 0, base_height+CUT])
            rotate([0, 180, 0])
                pipe_thread();
    }

    difference() {
        base();
        leg_cut();
        for (a=[0, 120, 240])
            rotate([0, 0, a])
                leg_cut();
        for (a=[0, 120, 240])
            for (o=[30, 60, 90])
                render()
                    rotate([0, 0, a+o])
                        pipe_hole();
    }
}

visebase();
