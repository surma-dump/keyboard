width = 244.5;
height = 77.75;
d = 3;
notch = 5;
bottom_gap = d;
case_height = 19 + bottom_gap;

buffer = 2*notch;

gap_closer = 1e-3;

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


module bottom_plate() {
    union() {
        square([width, height]);
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

module north_plate() {
    union() {
        difference() {
            square([width, case_height]);
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
                north_plate();
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
