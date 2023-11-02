//speed = gspeed
image_angle = point_direction(x,y,mouse_x,mouse_y);
direction = image_angle;


// Calculate the scaled distance
var scaled_distance = point_distance(x,y,mouse_x, mouse_y) //* image_xscale;




// Check if the distance is within the annular region
if (point_in_circle(mouse_x,mouse_y,x,y,outer_radius) and !point_in_circle(mouse_x,mouse_y,x,y,inner_radius))
{
    // Map the distance to a value between 0 and 1
    normalized_value = (scaled_distance - inner_radius) / (outer_radius - inner_radius);
    
    // Adjust the value to peak at 0.5 and then drop
    normalized_value = 4 * normalized_value * (1 - normalized_value);
}
else
{
    normalized_value = lerp(normalized_value,0,0.5)
}


x = lerp(x, serverX, 0.3)
y = lerp(y, serverY, 0.3)



image_xscale =1+0.1*score

image_yscale = image_xscale


outer_radius = max(view_hport[0], view_wport[0])/2
inner_radius = min(view_hport[0], view_wport[0])/4.5//32*image_xscale

//SHOOT
if(mouse_check_button(mb_left)){
	//create bullet
	var Buffer = buffer_create(1, buffer_grow, 1)
	//WHAT DATA 
	var data = ds_map_create();
	//whatever data you want to send as key value pairs

	ds_map_add(data,"eventName","create_bullet");
	ds_map_add(data, "clientId", global.clientId)

	
	buffer_write(Buffer, buffer_text, json_encode(data))
	network_send_raw(oController.socket, Buffer, buffer_tell(Buffer),network_send_text)
	buffer_delete(Buffer)
	ds_map_destroy(data)
	
}



maxSpeed = max(speed, maxSpeed)
maxTailLength = image_xscale
// Assuming 'speed' is the current speed of the player and 'direction' is the facing direction
var speedFactor = lengthdir_x(speed, image_angle); // This extracts the horizontal speed component
var tailLength = map(speedFactor, minSpeed, maxSpeed, minTailLength, maxTailLength); // Tail length based on speed

// Emission rate based on speed
var emissionRate = lerp(minEmissionRate, maxEmissionRate, tailLength / maxTailLength);


// Now emit particles if the emitter exists
if (instance_exists(oParticleSystem) && instance_exists(thrustEmitter)) {
    // Set emitter region based on player's position and direction
    part_emitter_region(oParticleSystem.partSystem, thrustEmitter, x, x, y, y, pt_shape_pixel, ps_distr_linear);
    
   
    // Emit particles
    part_emitter_stream(oParticleSystem.partSystem, thrustEmitter, oParticleSystem.partFireThrust, emissionRate);
}


audio_sound_gain(thrustSound, normalized_value,0)