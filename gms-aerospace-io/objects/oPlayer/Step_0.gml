//speed = gspeed
image_angle = point_direction(x,y,mouse_x,mouse_y);
direction = image_angle;


// Calculate the scaled distance
var scaled_distance = distance_to_point(mouse_x, mouse_y) * image_xscale;



// Check if the distance is within the annular region
if (scaled_distance > inner_radius && scaled_distance < outer_radius)
{
    // Map the distance to a value between 0 and 1
     normalized_value = (scaled_distance - inner_radius) / (outer_radius - inner_radius);
    
    // Connect this value to the speed
   // speed = 1 * log2(normalized_value * (outer_radius - inner_radius) + inner_radius);
}
else
{
	normalized_value = 0
    //speed *= 0.7;
}

x = lerp(x, serverX, 0.5)
y = lerp(y, serverY, 0.5)



image_xscale =1+0.1*score

image_yscale = image_xscale


//SHOOT
if(mouse_check_button_pressed(mb_left)){
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


