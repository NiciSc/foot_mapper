base_plate_width = 100;
base_plate_length = 70;
base_plate_height = 3;
base_plate_dimensions = [base_plate_width,base_plate_length,base_plate_height];

up_plate_width = 5;
up_plate_length = 70;
up_plate_height = 30;
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






base2_plate_width = 102;
base2_plate_length = 69;
base2_plate_height = 5;
base2_plate_dimensions = [base2_plate_width,base2_plate_length,base2_plate_height];


cylinder2_radius = 16;
cylinder2_height = 4;

/*

translate([0,70,55])
rotate([180,0,0])
difference(){
	union(){
		
		translate([0,0,50])
		cube(base2_plate_dimensions);
		
		
		rotate([270,270,0])
		translate([50,35,base2_plate_length-4])
		halfcylinder(cylinder2_height,cylinder2_radius);

		
		rotate([270,270,0])
		translate([50,35,0])
		halfcylinder(cylinder2_height,cylinder2_radius);
		
		translate([16, base2_plate_length/2+1, 50])		
		difference(){	
			
			rotate([90,270,0])
			//color("red")
			halfcylinder(2,5);
			
			translate([0,0,-0.5])
			rotate([90,90,0])
			//color("black")
			cylinder(d = 5, h=20, center = true);	
			}
	}	
	
	translate([35,-10,cylinder2_radius*2+10])
	//color("black")
	rotate([270,90,0])
	cylinder(h=120, r=3);
}

*/
// das sind die eigenlrichen einstellungen
//translate([0,01,-16.5])
//rotate([180,0,0])


rotate([180,0,0])
//translate([0,0,-42.5])
translate([0,-69,-42.5])
difference(){
	union(){
		
		translate([0,0,37.5])
		cube(base2_plate_dimensions);
		
		translate([19,4.5,37])
		//color("white")
		cube([cylinder2_radius*2, cylinder2_height, 16]);
		
		rotate([270,270,0])
		translate([38,35,base2_plate_length-8.5])
		halfcylinder(cylinder2_height,cylinder2_radius);

		translate([19,base2_plate_length-8.5,37])
		//color("black")
		cube([cylinder2_radius*2, cylinder2_height, 16]);
		
		rotate([270,270,0])
		translate([38,35,4.5])
		halfcylinder(cylinder2_height,cylinder2_radius);
		
		translate([16, base2_plate_length/2+1, 37.5])		
		difference(){	
			
			rotate([90,270,0])
			//color("black")
			halfcylinder(2,5);
			
			translate([0,0,-0.5])
			rotate([90,90,0])
			cylinder(d = 5, h=20, center = true);	
			}
	}	
	
	translate([35,-10,cylinder2_radius*2-2.5])
	color("transparent")
	rotate([270,90,0])
	cylinder(h=120, r=3);
}



