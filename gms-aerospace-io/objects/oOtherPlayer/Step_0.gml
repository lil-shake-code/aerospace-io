
_speed = lerp(_speed,point_distance(x,y,serverX,serverY)*60, 0.5)
maxSpeed = max(maxSpeed,_speed)

x = lerp(x, serverX, 0.3)
y = lerp(y, serverY, 0.3)





image_xscale =1+0.1*enemyKills

image_yscale = image_xscale
maxTailLength = image_xscale


// Assuming 'speed' is the current speed of the player and 'direction' is the facing direction
var speedFactor = lengthdir_x(_speed, image_angle); // This extracts the horizontal speed component
var tailLength = map(speedFactor, minSpeed, maxSpeed, minTailLength, maxTailLength); // Tail length based on speed

// Emission rate based on speed
var emissionRate = lerp(minEmissionRate, maxEmissionRate, tailLength / maxTailLength);

// Now emit particles if the emitter exists
if (instance_exists(oParticleSystem) ) {
	
	
    // Set emitter region based on player's position and direction
    part_emitter_region(oParticleSystem.partSystem, thrustEmitter, x, x, y, y, pt_shape_pixel, ps_distr_linear);
    
    // Adjust the particle's properties based on the tail length or emission rate
   /// part_type_scale(oParticleSystem.partFireThrust, 1 - (tailLength / maxTailLength), 1 - (tailLength / maxTailLength)); // Example of adjusting size

    // Emit particles
    part_emitter_stream(oParticleSystem.partSystem, thrustEmitter, oParticleSystem.partFireThrust, emissionRate);
}




// Calculate the distance from the camera to this plane
var distance = point_distance(oCamera.x, oCamera.y, x, y);

// Define the maximum distance at which the sound should be audible and the volume range
var half_volume_distance = 300; // The distance at which the volume will be half
var max_distance = 2000;        // The distance at which the sound will be nearly inaudible
var min_volume = 0;             // Minimum volume at max distance
var max_volume = tailLength;        // Maximum volume is controlled by this.N

// Calculate the volume based on the distance with an exponential falloff
var volume;
if (distance >= max_distance) {
    volume = min_volume; // The sound is too far away to be heard
} else {
    // Using an exponential decay function for volume falloff
    var factor = ln(0.5) / half_volume_distance; // Calculate the decay factor based on half-volume distance
    volume = max_volume * exp(factor * distance);
}

// Clamp the volume to make sure it's within the 0-1 range
volume = clamp(volume, min_volume, max_volume);

// Set the gain of the engine sound based on the calculated volume
audio_sound_gain(thrustSound, volume, 0);
