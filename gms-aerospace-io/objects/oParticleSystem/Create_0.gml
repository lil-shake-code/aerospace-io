partSystem = part_system_create();

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
part_type_shape(partSeleniumShine, pt_shape_spark);
part_type_size(partSeleniumShine, 0.1, 0.5, 0.01, 0); 
part_type_colour3(partSeleniumShine, c_red, c_green, c_blue);  // Transition from red to green to blue
part_type_alpha3(partSeleniumShine, 1, 0.7, 0); 
part_type_speed(partSeleniumShine, 0, 0.2, 0.2, 0.5);  // Randomized speed between 0 and 1, with variation
part_type_direction(partSeleniumShine, 0, 360, -10, 10);  // Random direction with variation
part_type_gravity(partSeleniumShine, 0, 0);  
part_type_life(partSeleniumShine, 15, 30); 
part_type_blend(partSeleniumShine, true); 
