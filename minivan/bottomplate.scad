
module rounded_square(size, radius_corner) {
    translate([radius_corner, radius_corner])
        minkowski() {
            square([size[0]-2*radius_corner, size[1]-2*radius_corner]);
            circle(radius_corner);
        }
}
