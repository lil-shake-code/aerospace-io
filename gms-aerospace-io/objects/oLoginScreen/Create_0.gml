global.skin = 0;
global.skins = 
[skin_basic,
skin_psychedelic,
skin_ifyouwanttolooklikeafool,
skin_deserteagle,
skin_greenie,
skin_cherry,
skin_blue_gold
]


global.roomId = "public"

if (instance_exists(oParticleSystem)) {
    seleniumEmitter = part_emitter_create(oParticleSystem.partSystem);
}
