image_index = 0;
bulletId = -1


if instance_exists(oParticleSystem) {
    emitter = part_emitter_create(oParticleSystem.partSystem);
    part_emitter_region(oParticleSystem.partSystem, emitter, x, x, y, y, ps_shape_ellipse, ps_distr_linear);
    part_emitter_stream(oParticleSystem.partSystem, emitter, oParticleSystem.partBulletTrail, 2); // Emit 10 particles per step
}
