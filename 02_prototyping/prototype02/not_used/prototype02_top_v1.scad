base_plate_width = 100;
base_plate_length = 50;
base_plate_height = 5;
base_plate_dimensions = [base_plate_width,base_plate_length,base_plate_height];

up_plate_width = 5;
up_plate_length = 50;
up_plate_height = 50;
up_plate_dimensions = [up_plate_width,up_plate_length,up_plate_height];

wall_plate_width= 100;
wall_plate_length = 5;
wall_plate_height = 50;

wall_plate_dimensions = [wall_plate_width,wall_plate_length,wall_plate_height];


module halfcylinder(he,rd) {
	difference(){
		cylinder (h=he,r=rd);
		translate([0,-rd-0.1,-0.1]) cube([rd+0.1,rd*2+0.2,he+0.2]);
	} // df
} // mod


cylinder_radius = 15;
cylinder_height = 5;

/*
translate([0,0,0])
difference(){
	union(){
		cube(base_plate_dimensions);
		cube(up_plate_dimensions);
		cube(wall_plate_dimensions);
		
		translate([0,45,0])
		cube(wall_plate_dimensions);
	}
	
	translate([5,-1,50])
	rotate([0,-340,0])
	//color("orange")
	cube([base_plate_width+5, base_plate_length+10, base_plate_height+28]);	
	
	translate([35,-10,30])
	//color("purple")
	rotate([270,90,0])
	cylinder(h=120, r=4.5);
	
	union(){
	translate([10,25,25])
	rotate([0,270,0])
	//color("black")
	halfcylinder(15, 20);
	
	//color("green")
	translate([-2,5.2,24])
	cube([10,39.6,20]);
	}
	
		
	translate([7,5,25])
	halfcylinder(2,5);

}


*/

base2_plate_width = 92;
base2_plate_length = 39;
base2_plate_height = 5;
base2_plate_dimensions = [base2_plate_width,base2_plate_length,base2_plate_height];


up2_plate_width = 5;
up2_plate_length = 38;
up2_plate_height = 35;
up2_plate_dimensions = [up2_plate_width,up2_plate_length,up2_plate_height];

cylinder2_radius = 16;
cylinder2_height = 4;


// use this for 2D rendering
//projection(){
translate([-8,40,50])
rotate([90,0,0])
union(){
difference(){
	rotate([90,0,0])
	union(){
		
		translate([8,0,45])
		cube(base2_plate_dimensions);
		
		translate([19,0,37])
		//color("white")
		cube([cylinder2_radius*2, cylinder2_height, 11]);
		
		rotate([270,270,0])
		translate([38,35,base2_plate_length-4])
		halfcylinder(cylinder2_height,cylinder2_radius);

		translate([19,base2_plate_length-4,37])
		//color("black")
		cube([cylinder2_radius*2, cylinder2_height, 11]);
		
		rotate([270,270,0])
		translate([38,35,0])
		halfcylinder(cylinder2_height,cylinder2_radius);
	}	
	rotate([90,0,0])
	translate([35,-10,30])
	//color("purple")
	rotate([270,90,0])
	//rotate([180,00,90])
	cylinder(h=120, r=4.5);
}

rotate([90,0,0])
difference(){
		translate([14, base2_plate_length/2-1, 45])
		rotate([270,270,0])
		//color("pink")
		halfcylinder(2,5);
		
		translate([14, base2_plate_length/2-1, 44])
		rotate([90,90,0])
		cylinder(d = 4, h=10 + 5, center = true);		
//}
}

}