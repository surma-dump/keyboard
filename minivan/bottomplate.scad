width=244.5;
height=77.75;

// MiniUSB receptacle
miniusb_center_x = width - 30.4;
miniusb_top_y = 0;
miniusb_buffer_x = 2;
miniusb_buffer_y = 2;

// Crystal
crystal_width = 13 + 2;
crystal_height = 5 + 1;
crystal_top_y = height - crystal_height;
crystal_left_x = width/2 - crystal_width;

// Reset
reset_width = 5;
reset_height = 10;
reset_left_x = 0;
reset_top_y = 48.3;

// Constants
miniusb_rec_width = 7.7;
miniusb_rec_height = 8.45;

// Calculations
miniusb_width = miniusb_rec_width + 2*miniusb_buffer_x;
miniusb_height = miniusb_rec_height + miniusb_buffer_y;

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