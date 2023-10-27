partSystem = part_system_create();

partBulletTrail = part_type_create();
part_type_shape(partBulletTrail, pt_shape_pixel);
part_type_size(partBulletTrail, 0.5, 1.5, 0, 0);
part_type_colour1(partBulletTrail, c_white);
part_type_alpha3(partBulletTrail, 1, 0.7, 0);
part_type_speed(partBulletTrail, 1, 3, 0, 0);
part_type_direction(partBulletTrail, 0, 360, 0, 0);
part_type_gravity(partBulletTrail, 0, 0);
part_type_life(partBulletTrail, 10, 20);



