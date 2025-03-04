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


//projection(){
translate([0,0,0])
rotate([0,0,0])
difference(){

	union(){
		cube(base_plate_dimensions);
		cube(up_plate_dimensions);
		cube(wall_plate_dimensions);
		
		
		translate([0,base_plate_length-wall_plate_length,0])
		//color("white")
		cube(wall_plate_dimensions);
		 
	// backwall strebe oben
	//color("blue")
	translate([0,0,40])
	cube([5,70,10]);
			
	
		// spring hook
		translate([16, base_plate_length/2-1,3 ])	
		difference(){	
			rotate([90,90,0])
			//color("black")
			halfcylinder(2,5);
			
			// wahrscheinlich hook loch
			rotate([90,90,0])
			translate([-1,0,0])
			//color("yellow")
			cylinder(d = 4, h=20, center = true);	
			}
	}
	
	
	//angles
	translate([5,-1,50])
	rotate([0,-340,0])
	//color("blue")
	cube([base_plate_width+5, base_plate_length+10, base_plate_height+30]);	
	
	// angle holes
	translate([35,-10,30])
	//color("purple")
	rotate([270,90,0])
	cylinder(h=120, r=3);
	
	// backwall hole
	union(){
	translate([6,35,33])
	rotate([0,270,0])
	//color("black")
	halfcylinder(15, 30);
	
		

	}
	
//}
}

// top plate

base2_plate_width = 102;
base2_plate_length = 59;
base2_plate_height = 5;
base2_plate_dimensions = [base2_plate_width,base2_plate_length,base2_plate_height];


cylinder2_radius = 16;
cylinder2_height = 4;


//projection(){
//translate([0,70,55])
//rotate([180,0,0])

translate([150,59,55])
rotate([180,0,0])
difference(){
	union(){
		// base plate
		translate([0,0,50])
		cube(base2_plate_dimensions);
		
		//angle
		translate([19,0,37])
		//color("white")
		cube([cylinder2_radius*2, cylinder2_height, 16]);
		
		// angle
		rotate([270,270,0])
		translate([38,35,base2_plate_length-4])
		halfcylinder(cylinder2_height,cylinder2_radius);

		// angle
		translate([19,base2_plate_length-4,37])
		//color("black")
		cube([cylinder2_radius*2, cylinder2_height, 16]);
		
		// angle
		rotate([270,270,0])
		translate([38,35,0])
		halfcylinder(cylinder2_height,cylinder2_radius);
		
		// hook
		
		translate([16, base2_plate_length/2+1, 50])		
		difference(){	
			
			rotate([90,270,0])
			//color("black")
			halfcylinder(2,5);
			
			translate([0,0,-0.5])
			rotate([90,90,0])
			cylinder(d = 5, h=20, center = true);	
			} 
	}	
	
	translate([35,-10,30])
	//color("purple")
	rotate([270,90,0])
	cylinder(h=120, r=3);
//}
}

