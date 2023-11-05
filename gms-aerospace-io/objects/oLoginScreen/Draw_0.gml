var x2 = mouse_x
var y2 = mouse_y
part_emitter_region(oParticleSystem.partSystem, seleniumEmitter, x2-6, x2+6, y2-6, y2+6, ps_shape_ellipse, ps_distr_linear);
part_emitter_stream(oParticleSystem.partSystem, seleniumEmitter, oParticleSystem.partSeleniumShine,1);
