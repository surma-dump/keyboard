// PCB measurements
width = 244.5;
height = 77.75;
// Thickness of case material
d = 3;
// Lenght of a notch
notch = 5;
notch_offset = 0;
// Gab between ground and bottom plate
bottom_gap = d;
// Height of the case
case_height = 19 + bottom_gap;

// MiniUSB receptacle
// Pure measurements of the receptacle
miniusb_rec_width = 7.7;
miniusb_rec_height = 11.45;
miniusb_rec_depth = 5.7;
// Space buffer on each side
miniusb_buffer = 2;
miniusb_width = miniusb_rec_width + 2*miniusb_buffer;
miniusb_height = miniusb_rec_height + miniusb_buffer;

// Crystal
crystal_width = 13 + 2;
crystal_height = 5 + 2;
crystal_top_y = 0;
crystal_left_x = width/2 - crystal_width ;

// Reset
reset_width = 7;
reset_height = 7;
reset_left_x = 0;
reset_top_y = height - 54.3;

// Positions
miniusb_center_x = width - 30.4;
miniusb_top_y = height - miniusb_height;

buffer = 2*notch;
gap_closer = 1e-3;

function rem(n, d) = floor(n / d) * d;

module bottom_plate() {
    difference() {
        union() {
            translate([d, d, bottom_gap])
                cube([width, height, d]);
            notch_line([buffer + d, 0, bottom_gap], [1, 0, 0], d, notch, width - 2*buffer);
            notch_line([buffer + d, height + d, bottom_gap], [1, 0, 0], d, notch, width - 2*buffer);
            notch_line([0, buffer + d, bottom_gap], [0, 1, 0], d, notch, height - 2*buffer);
            notch_line([width + d, buffer + d, bottom_gap], [0, 1, 0], d, notch, height - 2*buffer);
        }
        crystal_cutout();
        usb_cutout();
        reset_cutout();
    }
}

module notch_line(origin, dir, d, notch, length, inverted = false) {
    translate(origin)
        intersection() {
            difference() {
                if(inverted)
                    cube(d * ([1, 1, 1] - dir) + dir * length);
                for(i = [0:floor(length/(2*notch))]) {
                    translate(dir * (2*notch*i + -2*notch + notch_offset))
                        cube(dir * notch + ([1, 1, 1] - dir) * d);
                }
            }
            cube(d * ([1, 1, 1] - dir) + dir * length);
        }

}

module north_plate() {
    difference() {
        translate([d, height + d, 0])
            cube([width, d, case_height]);
        bottom_plate();
    }
    notch_line([0, height + d, 0], [0, 0, 1], d, notch, case_height, true);
    notch_line([width + d, height + d, 0], [0, 0, 1], d, notch, case_height, true);
}

module east_plate() {
    difference() {
        translate([width + d, d, 0])
            cube([d, height, case_height]);
        bottom_plate();
    }
    notch_line([width + d, 0, 0], [0, 0, 1], d, notch, case_height);
    notch_line([width + d, height + d, 0], [0, 0, 1], d, notch, case_height);
}

module south_plate() {
    difference() {
        translate([d, 0, 0])
            cube([width, d, case_height]);
        bottom_plate();
    }
    notch_line([0, 0, 0], [0, 0, 1], d, notch, case_height, true);
    notch_line([width + d, 0, 0], [0, 0, 1], d, notch, case_height, true);
}


module west_plate() {
    difference() {
        translate([0, d, 0])
            cube([d, height, case_height]);
        bottom_plate();
    }
    notch_line([0, 0, 0], [0, 0, 1], d, notch, case_height);
    notch_line([0, height + d, 0], [0, 0, 1], d, notch, case_height);
}

// Checkk if I actually need the +d on the translate X coordinate
module usb_cutout() {
    translate([miniusb_center_x - miniusb_width / 2 + d, miniusb_top_y + 2*d, bottom_gap])
        cube([miniusb_width, miniusb_height + d, miniusb_rec_depth + miniusb_buffer]);
}

module crystal_cutout() {
    translate([crystal_left_x + d, crystal_top_y, d])
        cube([crystal_width, crystal_height + d, d]);
}

module reset_cutout() {
    translate([reset_left_x, reset_top_y + d, d])
        cube([reset_width + d, reset_height, d]);
}

module show_case() {
    difference() {
        union() {
            north_plate();
            east_plate();
            south_plate();
            west_plate();
            bottom_plate();
        }
        usb_cutout();
    }
}

module project_bottom_plate() {
    projection(false)
        difference() {
            bottom_plate();
            usb_cutout();
        }
}

module project_north_plate() {
    projection(false)
        rotate([-90, 0, 0])
            difference() {
                north_plate();
                usb_cutout();
            }
}

module project_south_plate() {
    projection(false)
        rotate([-90, 0, 0])
            south_plate();
}

module project_east_plate() {
    rotate([0, 0, 90])
        projection(false)
            rotate([0, 90, 0])
                east_plate();
}

module project_west_plate() {
    rotate([0, 0, 90])
        projection(false)
            rotate([0, 90, 0])
                west_plate();
}

module pieces(gap) {
    project_bottom_plate();
    translate([0, -case_height - gap])
        project_north_plate();
    translate([height + 2*d, 3 * (-case_height - gap)])
        project_east_plate();
    translate([0, 2*(-case_height - gap)])
        project_south_plate();
    translate([2 * (height + 2*d) + gap, 3 * (-case_height - gap)])
        project_west_plate();
}

pieces(d);
// show_case();
