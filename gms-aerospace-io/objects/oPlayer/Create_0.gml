
health = 100;
maxHealth = 100
score=0;

pflash = 0;

depth=0


old_health = health;
sprite_index = global.skins[global.skin];

// Define annular region boundaries
 inner_radius = 32;
 outer_radius = 100;
 
 normalized_value = 0
 
 serverX = x
 serverY = y
 
 recoil = 0
maxRecoil = 100
oCamera.deadFor = 0


// Check if the particle system object exists
if (instance_exists(oParticleSystem)) {
    // Create the emitter and store it as an instance variable
    thrustEmitter = part_emitter_create(oParticleSystem.partSystem);
}
// These would be defined in the Create Event of oPlayer
// Speed at which the player starts to have a visible trail
minSpeed = 0; 
// Speed at which the trail is at its maximum length
maxSpeed = 5; 

// Minimum length of the tail, when at minimum speed
minTailLength = 0; 
// Maximum length of the tail, when at maximum speed
maxTailLength = 1; 

// Minimum emission rate of particles (particles per step)
minEmissionRate = 5; 
// Maximum emission rate of particles (particles per step)
maxEmissionRate = 30; 
