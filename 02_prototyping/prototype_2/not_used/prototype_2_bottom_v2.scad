base_plate_width = 0;
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
translate ([0,-rd-0.1,-0.1]) cube([rd+0.1,rd*2+0.2,he+0.2]);
} // df
} // mod
cylinder_radius = 15;
cylinder_height = 5;

translate([50,0,0])
rotate([0,270,0])
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
	cube([base_plate_width+5, base_plate_length+10, base_plate_height+50]);	
	translate([35,-10,30])
	color("purple")
	rotate([270,90,0])
	cylinder(h=70, r=4.5);
	
	union(){
	translate([10,25,25])
	rotate([0,270,0])
	color("black")
	halfcylinder(15, 20);
	
	color("green")
	translate([-2,5.2,24])
	cube([10,39.6,20]);
	}
};


translate([50,0,0])
rotate([0,270,0])
difference(){
		translate([12,base_plate_length/2-1,5])
		rotate([270,90,0])
		color("pink")
		halfcylinder(2,5);
		
		translate([12, base_plate_length/2, 6])
		rotate([90,90,0])
		cylinder(d = 4, h=10 + 5, center = true);		
};

