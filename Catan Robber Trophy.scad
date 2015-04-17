/*
   Settlers of Catan robber game piece trophy.
   Sizes are represented as mm.
*/

$fn = 60;

module robberBase(radius, height) {
	rotate_extrude(convexity = 10, $fn = 100)
		polygon(points = [[0,0],[radius,0],[radius, height*0.75],[radius*0.90, height],[0, height]]);
}

/*
   Parameters:
   - height represents the height from the underside of the base to the top of the head.
   - radius determins the size of the largest part of the body/base.
*/
module robber(radius, height) {
	headSize = radius*0.75;
	letterSize = radius;

	difference() {
		union() {
			translate([0, 0, height - headSize]) {
				sphere(r = headSize);
			}

			translate([0, 0, (height - headSize)/2]) {
				resize([0, 0, height - headSize]) {
					sphere(r = radius);
				}
			}

			robberBase(radius, height*0.10);
		}
	}
}

/*
   Parameters:
   - length determines the extrude length which results in the length increasing the x-axis with respect to the catan lettering
   - width determines the depth of the base with respect to the catan lettering
   - height determines the base height with respect to the positive z-axis
*/
module trophyBase(length, width, height) {
	textAngle = 90 - atan((height*0.90)/(width*0.25)); // Determines the angle of the lettering to match that of the size dimenstions.

	// Remove cylinders from base to create an inverse bevelled look.
	difference() {
		// Add text to base.
		union() {
			linear_extrude(height = length, center = true) {
				polygon([[0,0],[width,0],[width,height*0.10],[width*0.75,height],[0,height]]);
			}

			translate([length*0.90, height*0.15, 0]) {
				rotate([0, 90, textAngle]) {
					linear_extrude(3) text("CATAN", font = "Georgia:sltyle=Bold",
							size = 6, halign = "center");
				}
			}
		}

		translate([0, height, 0])
			cylinder(length, r = height*0.25, center = true);

		translate([width/2, height, length/2])
			rotate([0, 90, 0]) cylinder(width, r = height*0.25, center = true);

		translate([width/2, height, -(length/2)])
			rotate([0, 90, 0]) cylinder(width, r = height*0.25, center = true);
	}
}

/*
   Final object which creates the trophy.
   Parameters:
   - baseLength determines the x-axis with respect to the catan lettering.
   - baseWidth determines the depth with respect to the catan lettering
   - baseHeight determines the z-axis height of the base, used to shift the robber to top of base
   - robberRadius determines how round to make the robber, if the robber is too round compared to the height the robber will not show up
   - robberHeight determines the height of the robber in the z-axis
 */
module trophy(baseLength, baseWidth, baseHeight, robberRadius, robberHeight) {
	union() {
		translate([0, 0, baseHeight]) robber(robberRadius, robberHeight);

		translate([-(baseWidth*0.375 + baseHeight*0.125), 0, 0])
			rotate([90, 0, 0]) trophyBase(baseLength, baseWidth, baseHeight);
	}
}

trophy(30, 30, 10, 6.5, 30); // Draws the trophy.