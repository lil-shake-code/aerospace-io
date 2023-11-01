clientId = -1
serverX = 0
serverY = 0
_speed = 0
depth=0

enemyHealth = 100
enemyMaxHealth = 100
enemyUsername = ""
enemyKills = 0

pflash = 0
old_health = 100

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
maxTailLength = 2; 

// Minimum emission rate of particles (particles per step)
minEmissionRate = 5; 
// Maximum emission rate of particles (particles per step)
maxEmissionRate = 50; 