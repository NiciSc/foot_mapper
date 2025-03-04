// prototype pedal 
plate_width1 = 102;
plate_length1 = 69;
plate_height1 = 5;

helperplate_width1 = 30;
helperplate_length1 = 5;
helperplate_height1 = 8;

spring_point1 = 55;

plate_hole_width1 = 60;
plate_hole_length1 = 50;
plate_hole_height1 = 8;


plate_dimensions1 = [
	plate_width1,
	plate_length1,
	plate_height1];

hole_dimensions1 = [
	plate_hole_width1,
	plate_hole_length1,
	plate_hole_height1];
	
drillhole_gap1 = 10;
drillhole_diameter1 = 4.5;
drillhole_spring_diameter1 = 6.5;
edge_gap1 = drillhole_gap1 + drillhole_diameter1 / 2; 


//https://www.reddit.com/r/openscad/comments/loask5/half_sphere_cropping_how_do_i_cut_things/
module halfcylinder(he,rd) {
difference(){
cylinder (h=he,r=rd);
translate ([0,-rd-0.1,-0.1]) cube([rd+0.1,rd*2+0.2,he+0.2]);
} // df
} // mod
cylinder_radius1 = 16;
cylinder_height1 = 5;

// use this command to get 2D redering -> deswegen auch alles rotiert
//projection(){

translate([-150,0,0])
union(){

//linker Bügel
//rotate([90,0,0])
difference(){
    union(){
	translate([19,0,0])	
		cube([16,5,21]);

        translate([35, 0, 5])
        rotate([270,90,0])
        //color("blue")
        halfcylinder(cylinder_height1,cylinder_radius1);
    };
	
	translate([35, 0, 12])
    rotate([90,90,0])
	//color("black")
    cylinder(d = drillhole_diameter1, h=cylinder_height1 + 60, center = true);
}


//rechte Bügel
//rotate([90,0,0])
difference(){
    union(){
        translate([19,64,0])	
		cube([16,5,21]);
		
        translate([35, plate_length1-5, 5])
        rotate([270,90,0])
        //color("green")
        halfcylinder(cylinder_height1,cylinder_radius1);
		
    };
	
	translate([35, plate_length1-5, 12])
		rotate([90,90,0])
		//color("black")
		cylinder(d = drillhole_diameter1, h=cylinder_height1 + 60, center = true);
	
	translate([plate_width1/2, plate_length1-23-cylinder_height1, 15])
    rotate([90,90,0])
	//color("white")
    cylinder(d = drillhole_diameter1, h=cylinder_height1 + 5, center = true);
}

//haken nupsi
rotate([00,-30,0])
translate([13,0,-6])
difference(){
		translate([plate_width1/2-spring_point1, plate_length1/2-3/2, plate_height1])
		rotate([270,90,0])
			//color("yellow")
		halfcylinder(3,5);
		
		translate([plate_width1/2-spring_point1, plate_length1/2, plate_height1+1])
		rotate([90,90,0])
		cylinder(d = drillhole_diameter1, h=cylinder_height1 + 5, center = true);		
}



//hier ziehen wir sachen von anderen sachen ab
//rotate([90,0,0])
difference(){
   	
	cube(plate_dimensions1);
	translate([15,9,-2])
	cube(hole_dimensions1);
	}
	
	
//}

}



//--------------------------------------------




// prototype pedal 
plate_width = 102;
plate_length = 69;
plate_height = 5;

helperplate_width = 30;
helperplate_length = 5;
helperplate_height = 8;

spring_point = 55;


plate_dimensions = [
	plate_width,
	plate_length,
	plate_height];

	
drillhole_gap = 10;
drillhole_diameter = 4.5;
drillhole_spring_diameter = 6.5;
edge_gap = drillhole_gap + drillhole_diameter / 2; 


//https://www.reddit.com/r/openscad/comments/loask5/half_sphere_cropping_how_do_i_cut_things/
module halfcylinder(he,rd) {
difference(){
cylinder (h=he,r=rd);
translate ([0,-rd-0.1,-0.1]) cube([rd+0.1,rd*2+0.2,he+0.2]);
} // df
} // mod
cylinder_radius = 16;
cylinder_height = 5;

// use this command to get 2D redering -> deswegen auch alles rotiert
//projection(){
union(){

//linker Bügel
//rotate([90,0,0])
difference(){
    union(){ 
        translate([35, 7, 5])
        rotate([270,90,0])
        //color("blue")
        halfcylinder(cylinder_height,cylinder_radius);
    };
	
	translate([35, 0, 12])
    rotate([90,90,0])
	//color("black")
    cylinder(d = drillhole_diameter, h=cylinder_height + 60, center = true);
}


//rechte Bügel
//rotate([90,0,0])
difference(){
    union(){
        
        translate([35, plate_length-12, 5])
        rotate([270,90,0])
        //color("green")
        halfcylinder(cylinder_height,cylinder_radius);
		
    };
	
	translate([35, plate_length-5, 12])
		rotate([90,90,0])
		//color("black")
		cylinder(d = drillhole_diameter, h=cylinder_height + 60, center = true);
	
	translate([plate_width/2, plate_length-23-cylinder_height, 15])
    rotate([90,90,0])
	//color("white")
    cylinder(d = drillhole_diameter, h=cylinder_height + 5, center = true);
}

//haken nupsi
rotate([00,-30,0])
translate([13,0,-6])
difference(){
		translate([plate_width/2-spring_point, plate_length/2-3/2, plate_height])
		rotate([270,90,0])
			//color("yellow")
		halfcylinder(3,5);
		
		translate([plate_width/2-spring_point, plate_length/2, plate_height+1])
		rotate([90,90,0])
		cylinder(d = drillhole_diameter, h=cylinder_height + 5, center = true);		
}



//hier ziehen wir sachen von anderen sachen ab
//rotate([90,0,0])
union(){
   	
	cube(plate_dimensions);

	}
	
	
//}

}
