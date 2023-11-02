
if (instance_exists(oParticleSystem) && instance_exists(thrustEmitter)) {
	part_emitter_clear(oParticleSystem.partSystem, thrustEmitter)
    part_emitter_destroy(oParticleSystem.partSystem, thrustEmitter);
}
audio_stop_sound(thrustSound)