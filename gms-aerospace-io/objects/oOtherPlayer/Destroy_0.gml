
if (instance_exists(oParticleSystem) && instance_exists(thrustEmitter)) {
    part_emitter_destroy(oParticleSystem.partSystem, thrustEmitter);
}
