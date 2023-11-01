

x = lerp(x, serverX, 0.3)
y = lerp(y, serverY, 0.3)


var _speed = point_distance(x,x,serverX,serverY)*fps


image_xscale =1+0.1*enemyKills

image_yscale = image_xscale


// Assuming 'speed' is the current speed of the player and 'direction' is the facing direction
var speedFactor = lengthdir_x(_speed, image_angle); // This extracts the horizontal speed component
var tailLength = map(speedFactor, minSpeed, maxSpeed, minTailLength, maxTailLength); // Tail length based on speed

// Emission rate based on speed
var emissionRate = lerp(minEmissionRate, maxEmissionRate, tailLength / maxTailLength);

// Now emit particles if the emitter exists
if (instance_exists(oParticleSystem) && instance_exists(thrustEmitter)) {
    // Set emitter region based on player's position and direction
    part_emitter_region(oParticleSystem.partSystem, thrustEmitter, x, x, y, y, pt_shape_pixel, ps_distr_linear);
    
    // Adjust the particle's properties based on the tail length or emission rate
    part_type_scale(oParticleSystem.partFireThrust, 1 - (tailLength / maxTailLength) , 1 - (tailLength / maxTailLength)); // Example of adjusting size

    // Emit particles
    part_emitter_stream(oParticleSystem.partSystem, thrustEmitter, oParticleSystem.partFireThrust, emissionRate);
}
