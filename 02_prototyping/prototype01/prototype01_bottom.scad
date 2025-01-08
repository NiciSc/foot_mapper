// prototype pedal 
plate_width = 120;
plate_length = 100;
plate_height = 5;

platehole_width = 80;
platehole_length = 40;
platehole_height = 17;

plate_dimensions = [plate_width,plate_length,plate_height];
hole_dimensions = [platehole_width, platehole_length, platehole_height];

drillhole_gap = 10;
drillhole_diameter = 4.5;
drillhole_spring_diameter = 6.5;
edge_gap = drillhole_gap + drillhole_diameter / 2; 

drillholedistance_x = plate_dimensions.x - 2*drillhole_gap;
drillholedistance_y = plate_dimensions.y - 2*drillhole_gap;
drillhole_x = [drillhole_gap : drillholedistance_x : plate_dimensions.x - drillhole_gap];
drillhole_y = [drillhole_gap : drillholedistance_y : plate_dimensions.y - drillhole_gap];

angle_placement = ((plate_length/2)-(platehole_length/2))/2;

//https://www.reddit.com/r/openscad/comments/loask5/half_sphere_cropping_how_do_i_cut_things/
module halfcylinder(he,rd) {
difference(){
cylinder (h=he,r=rd);
translate ([0,-rd-0.1,-0.1]) cube([rd+0.1,rd*2+0.2,he+0.2]);
} // df
}

// mod
cylinder_radius = plate_width / 3;
cylinder_height = 16;

//projection(){
difference(){
translate([plate_width/2, angle_placement+8, (plate_height/2)])
rotate([90,90,0])
halfcylinder(cylinder_height,cylinder_radius);

translate([plate_width/2,angle_placement+10,cylinder_radius-10])
    rotate([90,90,0])
	//color("black")
    cylinder(d = drillhole_diameter, h=cylinder_height + 8);
}

difference(){
translate([plate_width/2, plate_length-angle_placement+8,(plate_height/2)])
rotate([90,90,0])
halfcylinder(cylinder_height,cylinder_radius);
translate([plate_width/2, plate_length-angle_placement+10,cylinder_radius-10])
    rotate([90,90,0])
	//color("yellow")
    cylinder(d = drillhole_diameter, h=cylinder_height + 8);
}


difference(){
   
   cube(plate_dimensions);
   
   for(x = drillhole_x, y = drillhole_y)
   translate([x,y, -1])
   cylinder(d = drillhole_diameter, h = plate_dimensions.z +2);
   
   
    translate([
        (plate_width - platehole_width)/2,
    (plate_length - platehole_length)/2,
    -1])
   
    cube(hole_dimensions);  
   
   translate([(plate_width-platehole_width)/4,plate_length/2, -1])
   
   //color("black")
    cylinder(d = drillhole_spring_diameter, h=cylinder_height + 8);
   
   
   translate([plate_width-((plate_width-platehole_width)/4),plate_length/2, -1])
    cylinder(d = drillhole_spring_diameter, h=cylinder_height + 8);
   
   /*translate([1,-0,1])
   rotate([90,0,0])
   linear_extrude(5)
    text("nici - v1.0", size=2.5);*/

	//}


}

