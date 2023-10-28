image_alpha-=(1/240)


if instance_exists(oParticleSystem) {
    part_emitter_region(oParticleSystem.partSystem, emitter, x, x, y, y, ps_shape_ellipse, ps_distr_linear);
}

if(image_alpha<0){
	if instance_exists(oParticleSystem) {
		part_emitter_destroy(oParticleSystem.partSystem, emitter);
	}

	instance_destroy()
}