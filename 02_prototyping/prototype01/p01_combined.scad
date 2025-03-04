// prototype pedal 
plate_width1 = 120;
plate_length1 = 100;
plate_height1 = 5;

platehole_width1 = 80;
platehole_length1 = 40;
platehole_height1 = 17;

plate_dimensions1 = [plate_width1,plate_length1,plate_height1];
hole_dimensions1 = [platehole_width1, platehole_length1, platehole_height1];

drillhole_gap1 = 10;
drillhole_diameter1 = 4.5;
drillhole_spring_diameter1 = 6.5;
edge_gap1 = drillhole_gap1 + drillhole_diameter1 / 2; 

drillholedistance_x1 = plate_dimensions1.x - 2*drillhole_gap1;
drillholedistance_y1 = plate_dimensions1.y - 2*drillhole_gap1;
drillhole_x1 = [drillhole_gap1 : drillholedistance_x1 : plate_dimensions1.x - drillhole_gap1];
drillhole_y1 = [drillhole_gap1 : drillholedistance_y1 : plate_dimensions1.y - drillhole_gap1];

angle_placement1 = ((plate_length1/2)-(platehole_length1/2))/2;

//https://www.reddit.com/r/openscad/comments/loask5/half_sphere_cropping_how_do_i_cut_things/
module halfcylinder(he,rd) {
difference(){
cylinder (h=he,r=rd);
translate ([0,-rd-0.1,-0.1]) cube([rd+0.1,rd*2+0.2,he+0.2]);
} // df
}

// mod
cylinder_radius1 = plate_width1 / 3;
cylinder_height1 = 16;

translate([-220,0,0])
union(){
//projection(){
	difference(){
	translate([plate_width1/2, angle_placement1+8, (plate_height1/2)])
	rotate([90,90,0])
	halfcylinder(cylinder_height1,cylinder_radius1);

	translate([plate_width1/2,angle_placement1+10,cylinder_radius1-10])
		rotate([90,90,0])
		//color("black")
		cylinder(d = drillhole_diameter1, h=cylinder_height1 + 8);
	}

	difference(){
	translate([plate_width1/2, plate_length1-angle_placement1+8,(plate_height1/2)])
	rotate([90,90,0])
	halfcylinder(cylinder_height1,cylinder_radius1);
	translate([plate_width1/2, plate_length1-angle_placement1+10,cylinder_radius1-10])
		rotate([90,90,0])
		//color("yellow")
		cylinder(d = drillhole_diameter1, h=cylinder_height1 + 8);
	}


	difference(){
	   
	   cube(plate_dimensions1);
	   
	   for(x = drillhole_x1, y = drillhole_y1)
	   translate([x,y, -1])
	   cylinder(d = drillhole_diameter1, h = plate_dimensions1.z +2);
	   
	   
		translate([
			(plate_width1 - platehole_width1)/2,
		(plate_length1 - platehole_length1)/2,
		-1])
	   
		cube(hole_dimensions1);  
	   
	   translate([(plate_width1-platehole_width1)/4,plate_length1/2, -1])
	   
	   //color("black")
		cylinder(d = drillhole_spring_diameter1, h=cylinder_height1 + 8);
	   
	   
	   translate([plate_width1-((plate_width1-platehole_width1)/4),plate_length1/2, -1])
		cylinder(d = drillhole_spring_diameter1, h=cylinder_height1 + 8);
	   
	   /*translate([1,-0,1])
	   rotate([90,0,0])
	   linear_extrude(5)
		text("nici - v1.0", size=2.5);*/

		//}


	}

}



// prototype pedal 
plate_width = 210;
plate_length = 100;
plate_height = 5;

helperplate_width = 30;
helperplate_length = 5;
helperplate_height = 8;

spring_point = 55;


helperhelper_width = 40;
helperhelper_length = 12; 
helperhelper_height = 5;


plate_dimensions = [
	plate_width,
	plate_length,
	plate_height];
	
helperplate_dimensions = [
	helperplate_width,
	helperplate_length,
	helperplate_height];
	
helperhelper_dimensions = [
	helperhelper_width,
	helperhelper_length, 
	helperhelper_height,
];
	
drillhole_gap = 10;
drillhole_diameter = 4.5;
drillhole_spring_diameter = 6.5;
edge_gap = drillhole_gap + drillhole_diameter / 2; 


module lochplatte( groesse, loch_dm, loch_abst, anzahl = [12,6] ) {

	difference() {

		cube( plate_dimensions );

		randabstand   = loch_abst + loch_dm/2;
		x_lochdistanz = (groesse.x - 2*randabstand) / (anzahl.x - 1);
		y_lochdistanz = (groesse.y - 2*randabstand) / (anzahl.y - 1);
		x_werte       = [randabstand : x_lochdistanz : groesse.x - randabstand + 0.1];
		y_werte       = [randabstand : y_lochdistanz : groesse.y - randabstand + 0.1];

	
		// Bohrlöcher
		for (x = x_werte, y = y_werte)
	    translate( [x, y, -1] )
	    //color( "red" )
	    cylinder( d = loch_dm, h = groesse.z + 2);

	}

}

//https://www.reddit.com/r/openscad/comments/loask5/half_sphere_cropping_how_do_i_cut_things/
module halfcylinder(he,rd) {
difference(){
cylinder (h=he,r=rd);
translate ([0,-rd-0.1,-0.1]) cube([rd+0.1,rd*2+0.2,he+0.2]);
} // df
} // mod
cylinder_radius = 15;
cylinder_height = 5;

// use this command to get 2D redering -> deswegen auch alles rotiert
//projection(){
union(){

//linker Bügel
//rotate([90,0,0])
difference(){
    union(){
        translate([
			plate_width/2-helperplate_width/2, 
			plate_length/2-24,
			(cylinder_radius/2)-plate_height-2])
        //color("black")
        cube(helperplate_dimensions);
        
        translate([plate_width/2, plate_length/2-24, 8])
        rotate([270,90,0])
        //color("blue")
        halfcylinder(cylinder_height,cylinder_radius);
    };
	
	translate([plate_width/2, plate_length/2-20, 15])
    rotate([90,90,0])
	//color("black")
    cylinder(d = drillhole_diameter, h=cylinder_height + 5, center = true);
}


//rechte Bügel
//rotate([90,0,0])
difference(){
    union(){
        translate([
			plate_width/2-helperplate_width/2, 
			//plate_length-21-cylinder_height,
			plate_length/2+24-5,
			(cylinder_radius/2)-plate_height-2])
        //color("black")
        cube(helperplate_dimensions);
        
        translate([plate_width/2, plate_length/2+19, 8])
        rotate([270,90,0])
        //color("green")
        halfcylinder(cylinder_height,cylinder_radius);
    };
	
	translate([plate_width/2, plate_length-23-cylinder_height, 15])
    rotate([90,90,0])
	//color("red")
    cylinder(d = drillhole_diameter, h=cylinder_height + 5, center = true);
}

//rotate([90,0,0])
difference(){
		translate([plate_width/2-spring_point, plate_length/2-3/2, plate_height])
		rotate([270,90,0])
		//color("pink")
		halfcylinder(3,5);
		
		translate([plate_width/2-spring_point, plate_length/2, plate_height+1])
		rotate([90,90,0])
		cylinder(d = drillhole_diameter, h=cylinder_height + 5, center = true);		
}

//rotate([90,0,0])
difference(){
		translate([plate_width/2+spring_point, plate_length/2-3/2, plate_height])
		rotate([270,90,0])
		//color("pink")
		halfcylinder(3,5);
		
		translate([plate_width/2+spring_point, plate_length/2, plate_height+1])
		rotate([90,90,0])
		cylinder(d = drillhole_diameter, h=cylinder_height + 5, center = true);		
}



//hier ziehen wir sachen von anderen sachen ab
//rotate([90,0,0])
union(){
   	translate([plate_width/2,plate_length-20-cylinder_height,plate_height/2])
	cube(helperhelper_dimensions, center = true);	
	
	translate([plate_width/2,(plate_length/2-20-cylinder_height),plate_height/2])
	cube(helperhelper_dimensions, center = true);	
	
	//lochplatte(groesse = plate_dimensions, loch_dm= 10, loch_abst = 4 );
	cube(plate_dimensions);
	translate([plate_width-2,0,3.5])
	rotate([90,180,0])
	text("nici - v1.0", size=2.5);
}
//}


}
