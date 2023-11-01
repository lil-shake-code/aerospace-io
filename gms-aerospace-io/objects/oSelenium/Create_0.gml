seleniumId = -1

if (instance_exists(oParticleSystem)) {
    seleniumEmitter = part_emitter_create(oParticleSystem.partSystem);
    part_emitter_region(oParticleSystem.partSystem, seleniumEmitter, x-6, x+6, y-6, y+6, ps_shape_ellipse, ps_distr_linear);
    part_emitter_stream(oParticleSystem.partSystem, seleniumEmitter, oParticleSystem.partSeleniumShine,1);
}
