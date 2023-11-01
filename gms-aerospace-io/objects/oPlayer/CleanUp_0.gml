/// @description Insert description here
// You can write your code in this editor
// Destroy the emitter if it exists
if (instance_exists(oParticleSystem) && instance_exists(thrustEmitter)) {
    part_emitter_destroy(oParticleSystem.partSystem, thrustEmitter);
}
