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



