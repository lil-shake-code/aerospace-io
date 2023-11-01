partSystem = part_system_create();

depth = 400

partBulletTrail = part_type_create();
part_type_shape(partBulletTrail, pt_shape_pixel);
part_type_size(partBulletTrail, 3, 4, -0.1, 0);
part_type_colour1(partBulletTrail, c_white);
part_type_alpha3(partBulletTrail, 0, 0.7, 0);
part_type_speed(partBulletTrail, 0.5, 2, 0, 0);
part_type_direction(partBulletTrail, -20, 20, 0, 0);
part_type_gravity(partBulletTrail, 0, 0);
part_type_life(partBulletTrail, 15, 30);
// Additive blending for a slight glow effect
part_type_blend(partBulletTrail, true);



partSeleniumShine = part_type_create();
part_type_shape(partSeleniumShine, pt_shape_disk);
part_type_size(partSeleniumShine, 0.1, 0.2, 0.01, 0); 
part_type_colour2(partSeleniumShine,  c_green, c_blue);  // Transition from red to green to blue
part_type_alpha3(partSeleniumShine, 0.9, 0.6, 0); 
part_type_speed(partSeleniumShine, 0, 0.1, 0.1, 0);  // Randomized speed between 0 and 1, with variation
part_type_direction(partSeleniumShine, 0, 360, -1, 10);  // Random direction with variation
part_type_gravity(partSeleniumShine, 0, 0);  
part_type_life(partSeleniumShine, 20, 40); 
part_type_blend(partSeleniumShine, true); 





partFireThrust = part_type_create();
part_type_shape(partFireThrust, pt_shape_smoke); // Or another appropriate shape
part_type_size(partFireThrust, 0.2, 0.3, -0.01, 0); // Larger size, with a slight decrease over time
part_type_colour2(partFireThrust, c_blue,c_teal); // Orange fire color
part_type_alpha2(partFireThrust, 0.8, 0); // Starts semi-transparent and fades out
part_type_speed(partFireThrust, 0.4, 0.8, 0, 0); // Increased speed
part_type_direction(partFireThrust, 180, 180, 0, 0); // Adjust if necessary
part_type_life(partFireThrust, 3, 7); // Longer life for a more extended trail
part_type_blend(partFireThrust, true); // Keep the glow effect
// Adjust other properties as needed...
