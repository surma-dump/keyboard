width = 244.5;
height = 77.75;
d = 3;
notch = 5;
case_height = 19;

buffer = 2*notch;

module box_joints(w, h, n = 100) {
    for (i = [0:n]) {
        translate([i * 2 * w, 0]) {
            square([w, h]);
        }
    }    
}

module bottom_plate_south_joints() {
    // Bottom box joints
    translate([buffer, -d+1e-4])
        intersection() {
            square([width - 2*buffer, d]);
            box_joints(notch, d);
        }
}

module bottom_plate_north_joints() {
    translate([width, height + d])
        mirror([-1, 0, 0])
            translate([buffer, -d])
                intersection() {
                    square([width - 2*buffer, d]);
                    box_joints(notch, d);
                }
}

module bottom_plate_west_joints() {
    translate([-d, buffer])
        intersection() {
            square([d, height - 2*buffer]);
            translate([0, height - 2*buffer])
                rotate([0, 0, -90])
                    box_joints(notch, d);
        }
}

module bottom_plate_east_joints() {
    translate([width, height - buffer])
    mirror([0, 1, 0])
        intersection() {
            square([d, height - 2*buffer]);
            translate([0, height - 2*buffer])
                rotate([0, 0, -90])
                    box_joints(notch, d);
        }
}

module bottom_plate() {
    union() {
        square([width, height]);
        bottom_plate_south_joints();
        bottom_plate_north_joints();
        bottom_plate_east_joints();
        bottom_plate_west_joints();
    }
}

module north_plate() {
    union() {
        difference() {
            square([width, case_height]);
            translate([0, -height])
                bottom_plate();
        }
        intersection() {
            translate([0, 0])
                rotate([0, 0, 90])
                    box_joints(notch, d);
            translate([-d, 0])
                square([d, case_height]);
        }
        translate([width + d, 0])
            intersection() {
                translate([0, notch])
                    rotate([0, 0, 90])
                        box_joints(notch, d);
                translate([-d, 0])
                    square([d, case_height]);
            }
    }
}

module south_plate() {
    union() {
        difference() {
            square([width, case_height]);
            translate([0, case_height])
                bottom_plate();
        }
         intersection() {
            translate([0, 0])
                rotate([0, 0, 90])
                    box_joints(notch, d);
            translate([-d, 0])
                square([d, case_height]);
        }
        translate([width + d, 0])
            intersection() {
                translate([0, notch])
                    rotate([0, 0, 90])
                        box_joints(notch, d);
                translate([-d, 0])
                    square([d, case_height]);
            }
    }
}

module east_plate() {
    union() {
        difference() {
            square([case_height, height]);
            translate([-width, 0])
                bottom_plate();
        }
        intersection() {
            translate([0, height])
                box_joints(notch, d);
            translate([0, height])
                square([case_height, d]);
        }
        translate([0, -d])
            intersection() {
                translate([notch, 0])
                    box_joints(notch, d);
                translate([0, 0])
                    square([case_height, d]);
            }
    }
}

module west_plate() {
    union() {
        difference() {
            square([case_height, height]);
            translate([case_height, 0])
                bottom_plate();
        }
        intersection() {
            translate([0, height])
                box_joints(notch, d);
            translate([0, height])
                square([case_height, d]);
        }
        translate([0, -d])
            intersection() {
                translate([notch, 0])
                    box_joints(notch, d);
                translate([0, 0])
                    square([case_height, d]);
            }
    }
}



bottom_plate();
translate([0, height + buffer])
    north_plate();
translate([0, -case_height - buffer])
    south_plate();
translate([width + buffer, 0])
    east_plate();
translate([-case_height - buffer, 0])
    west_plate();