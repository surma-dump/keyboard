width = 244.5;
height = 77.75;
d = 3;
notch = 5;
bottom_gap = d;
case_height = 19 + bottom_gap;

buffer = 2*notch;

gap_closer = 1e-3;

use <./bottomplate.scad>;

module box_joints(l, vertical = false) {
    num_notches = floor(l / (2*notch));
    intersection() {
        for (i = [0:num_notches]) {
            translate(vertical ? [0, i*2*notch] : [i*2*notch, 0] )
                square(vertical ? [d, notch] : [notch, d]);
        }
        square(vertical ? [d, l] : [l, d]);
    }
}

module bottom_plate_with_cutouts() {
    // MiniUSB receptacle
    miniusb_rec_width = 7.7;
    miniusb_rec_height = 8.45;
    miniusb_buffer_x = 2;
    miniusb_buffer_y = 2;
    miniusb_width = miniusb_rec_width + 2*miniusb_buffer_x;
    miniusb_height = miniusb_rec_height + miniusb_buffer_y;

    miniusb_center_x = width - 30.4;
    miniusb_top_y = height - miniusb_height;

    // Crystal
    crystal_width = 13 + 2;
    crystal_height = 5 + 1;
    crystal_top_y = 0;
    crystal_left_x = width/2 - crystal_width + 2;

    // Reset
    reset_width = 7;
    reset_height = 7;
    reset_left_x = 0;
    reset_top_y = height - 48.3;

    difference() {
        square([width, height]);
        translate([
            miniusb_center_x - miniusb_width / 2,
            miniusb_top_y
        ]) {
            square([miniusb_width, miniusb_height]);
        }
        translate([
            crystal_left_x,
            crystal_top_y
        ]) {
            square([crystal_width, crystal_height]);
        }
        translate([
            reset_left_x,
            reset_top_y
        ]) {
            square([reset_width, reset_height]);
        }
    }
}

module bottom_plate() {
    union() {
        //square([width, height]);
        bottom_plate_with_cutouts(width, height);
        // south
        translate([buffer, -d + gap_closer])
            box_joints(width - 2*buffer, false);
        // north
        translate([buffer, height - gap_closer])
            box_joints(width - 2*buffer, false);
        // west
        translate([-d + gap_closer, buffer])
            box_joints(height - 2*buffer, true);
        // east
        translate([width - gap_closer, buffer])
            box_joints(height - 2*buffer, true);

    }
}

module north_plate(cutouts = true) {
    union() {
        difference() {
            square([width, case_height]);
            if(cutouts)
                translate([buffer, bottom_gap])
                box_joints(width - 2*buffer, false);
        }
        translate([-d, 0])
            box_joints(case_height, true);
        translate([width, 0])
            difference() {
                square([d, case_height]);
                box_joints(case_height, true);
            }
    }
}

module south_plate() {
    translate([width, case_height])
        mirror([1, 0, 0])
            mirror([0, 1, 0])
                north_plate(false);
}

module east_plate() {
    union() {
        difference() {
            square([case_height, height]);
            translate([bottom_gap, buffer])
               box_joints(height - 2*buffer, true);
        }
        translate([0, height])
            box_joints(case_height, false);
        translate([0, -d])
            difference() {
                square([case_height, d]);
                box_joints(case_height, false);
            }

    }
}

module west_plate() {
    translate([case_height, height])
        mirror([0, 1, 0])
            mirror([1, 0, 0])
                east_plate();
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
