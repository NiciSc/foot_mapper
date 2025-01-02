base_plate_width = 100;
base_plate_length = 80;
base_plate_height = 3;
base_plate_dimensions = [base_plate_width,base_plate_length,base_plate_height];

loch_bodenplatte_width = 60;
loch_bodenplatte_length = 50;
loch_bodenplatte_height = 10;
loch_bodenplatte_dimensions = [loch_bodenplatte_width, loch_bodenplatte_length, loch_bodenplatte_height];

up_plate_width = 5;
up_plate_length = 70;
up_plate_height = 30;
up_plate_dimensions = [up_plate_width,up_plate_length,up_plate_height];

wall_plate_width= 100;
wall_plate_length = 5;
wall_plate_height = 50;
wall_plate_dimensions = [wall_plate_width,wall_plate_length,wall_plate_height];


cylinder_radius = 15;
cylinder_height = 5;
base2_plate_width = 102;
base2_plate_length = 69;
base2_plate_height = 5;
base2_plate_dimensions = [base2_plate_width,base2_plate_length,base2_plate_height];


cylinder2_radius = 16;
cylinder2_height = 4;



module halfcylinder(he,rd) {
	difference(){
		cylinder (h=he,r=rd);
		translate([0,-rd-0.1,-0.1]) cube([rd+0.1,rd*2+0.2,he+0.2]);
	} // df
} // mod

t=1000;
$vpt=[t*$t,t*$t,t*$t];
r=1000;
$vpr=[r*$t,r*$t,r*$t];
d=10;
$vpd=200+d*$t;
echo(d=d,"$vpr=",$vpr,"$vpd=",$vpd,"$vpt=",$vpt);

/*


//projection(){

translate([0,70,55])
rotate([180,0,0])
difference(){
	union(){
		
		translate([0,0,50])
		difference(){
			cube(base2_plate_dimensions);
			
			translate([20, 10, -3])
			cube(loch_bodenplatte_dimensions);
		}
		translate([19.5,0,34])
		//color("green")
		cube([15, 4, 12]);
		
		translate([19.5,65,34])
		//color("green")
		cube([15, 4, 12]);
		
		
		translate([19,0,37])
		color("white")
		cube([cylinder2_radius*2, cylinder2_height, 16]);
		
		rotate([270,270,0])
		translate([50,35,base2_plate_length-4])
		halfcylinder(cylinder2_height,cylinder2_radius);

		translate([19,base2_plate_length-4,37])
		color("black")
		cube([cylinder2_radius*2, cylinder2_height, 16]);
		
		rotate([270,270,0])
		translate([50,35,0])
		halfcylinder(cylinder2_height,cylinder2_radius);
		
		translate([8, base2_plate_length/2, 51])		
		difference(){	
			
			rotate([90,-45,180])
		//	color("red")
			halfcylinder(2,4);
			
			translate([0,0,-0.5])
			rotate([90,90,0])
		//	color("black")
			cylinder(d = 5, h=20, center = true);	
			}
	}	
	
	difference(){
		translate([35,-10,cylinder2_radius*2+10])
		//color("blue")
		rotate([270,90,0])
		cylinder(h=120, r=3);
		
	}
	
	
//}
}*/




//projection(){
//translate([0,0,-16.5])
rotate([180,0,0])
translate([0, -70,-42.5])
	//rotate([90,0,0])
difference(){
	union(){
		
		translate([0,0,37.5])
		cube(base2_plate_dimensions);
		
		
		
		rotate([270,270,0])
		translate([38,35,base2_plate_length-8.5])
		halfcylinder(cylinder2_height,cylinder2_radius);

		
		
		rotate([270,270,0])
		translate([38,35,4.5])
		halfcylinder(cylinder2_height,cylinder2_radius);
		
		translate([8, base2_plate_length/2, 38])		
		difference(){	
			
			rotate([90,-45,180])
			//color("blue")
			halfcylinder(2,4);
			
			translate([0,0,-0.5])
			rotate([90,90,0])
			cylinder(d = 5, h=20, center = true);	
			}
	}	
	
	translate([35,-10,cylinder2_radius*2-2.5])
	color("yellow")
	rotate([270,90,0])
	cylinder(h=120, r=3);
	
	/*translate([19,4.5,37])
		color("white")
		cube([cylinder2_radius*2, cylinder2_height, 16]);
	
	
		translate([19,base2_plate_length-8.5,37])
		color("black")
		cube([cylinder2_radius*2, cylinder2_height, 16]);*/
//}


}
