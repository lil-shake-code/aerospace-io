/// @description Async ws Events. Do Not Tamper!
var type = async_load[? "type"]
if(type == network_type_non_blocking_connect){
	
	
	if( async_load[? "succeeded"] == false){
		show_debug_message("failed non blocking connection. Please check your internet connection and firewalls.")
		if(instance_exists(oPlayer)){
		instance_destroy(oPlayer)
	}
	}
	if( async_load[? "succeeded"] == true){
		show_debug_message("Succeeded non blocking conection. ")
		non_blocking_success_yet = true;
		
			//code to join server
			var Buffer = buffer_create(1, buffer_grow, 1)
			//WHAT DATA 
			var data = ds_map_create();
			//whatever data you want to send as key value pairs

			ds_map_add(data,"eventName","create_me");
			ds_map_add(data, "username", global.username)
			ds_map_add(data, "skin", global.skin)
			
			ds_map_add(data, "roomId", global.roomId)
			buffer_write(Buffer, buffer_text, json_encode(data))
			network_send_raw(oController.socket, Buffer, buffer_tell(Buffer),network_send_text)
			buffer_delete(Buffer)
			ds_map_destroy(data)
			
			
			
			
	}
	
}

if(type == network_type_data){
	var buffer_raw = async_load[? "buffer"];
	var buffer_processed = buffer_read(buffer_raw , buffer_text);
	//show_message(buffer_processed)
	//var realData = json_decode(buffer_processed);
	var realData = json_parse(buffer_processed)
	if(variable_struct_exists(realData , "eventName")){
		//show_message(buffer_processed)
	}
	var eventName = variable_struct_get(realData,"eventName")
	
	
	
	
	switch(eventName){
		case "created_you":
		

			global.clientId = realData.clientId
			global.roomId = realData.roomId
			
			oPlayer.x = realData.x;
			oPlayer.y = realData.y;
			oPlayer.serverX = oPlayer.x
			oPlayer.serverY = oPlayer.y
			
			
		break;
		
		
		
		
		
		case "create_player":
		
		var enemy = instance_create_layer(realData.x,realData.y,"Instances",oOtherPlayer)
		enemy.clientId = real(realData.clientId)
		enemy.enemyUsername = realData.username
		enemy.serverX = realData.x
		enemy.serverY = realData.y
		enemy.sprite_index = global.skins[realData.skin]

	
		break;
		
		
		
		
		case "create_selenium":
		
		var selenium = instance_create_layer(realData.x,realData.y,"Instances",oSelenium)
		selenium.seleniumId = realData.seleniumId;
		selenium.image_xscale = realData.value
		selenium.image_yscale = selenium.image_xscale
	

	
		break;
		
		
		
		
		
		
		
		
		
		
		
		case "global_state_update":
	
		if(global.clientId==realData.clientId){
			oPlayer.serverX = real(realData.x)
			oPlayer.serverY = real(realData.y)
			health = real(realData.H) 
			maxHealth = real(realData.mH)
			
			
			if(score!= real(realData.K)){
				score = real(realData.K) 
				var soundGoodclick = audio_play_sound(soundGoodClick,1,false)
			}
		}
		with(oOtherPlayer){
			if(clientId==real(realData.clientId)){
				serverX = real(realData.x)
				serverY = real(realData.y)
				
			
				image_angle = realData.A
				enemyHealth = real(realData.H) 
				maxHealth = real(realData.mH)
				enemyKills = real(realData.K)  
				
	
			}
		}
	
		break;
		
		
		
		case "bullet_state_update":
		
		
		var found = false;
		with(oBullet){
			if(bulletId == realData.bulletId){
				found = true
				//update the x, y
				x = lerp(x,realData.x, 0.5);
				y = lerp(y,realData.y, 0.5);
			
			}
		}
		if(!found){
			var b = instance_create_layer(realData.x,realData.y,"Instances",oBullet);
		
			b.bulletId = realData.bulletId
			b.direction = realData.A
			b.image_angle = b.direction
			b.image_blend = make_color_hsv(irandom(255) , irandom(80),255)
			b.image_xscale = realData.D/5
			b.image_yscale = b.image_xscale
			if(realData.fB==global.clientId and instance_exists(oPlayer)){
				var soundBu = audio_play_sound(soundBullet, 1, false)
			}
			if(realData.fB!=global.clientId){
				
				// Calculate the distance between the camera and the bullet
var distance = point_distance(oCamera.x, oCamera.y, b.x, b.y);

// Define the maximum distance at which the sound should be audible and the volume range
var half_volume_distance = 300; // The distance at which the volume will be half
var max_distance = 2000; // The distance at which the sound will be nearly inaudible
var min_volume = 0;     // Minimum volume at max distance
var max_volume = 1;     // Maximum volume at zero distance

// Calculate the volume based on the distance with an exponential falloff
var volume;
if (distance >= max_distance) {
    volume = min_volume; // The sound is too far away to be heard
} else {
    // Using an exponential decay function for volume falloff
    var factor = ln(0.5)/half_volume_distance // Calculate the decay factor based on half-volume distance
    volume = max_volume * exp(factor * distance);
}

// Clamp the volume to make sure it's within the 0-1 range
volume = clamp(volume, min_volume, max_volume);

// Play the sound and set its initial gain
var sound_id = audio_play_sound(soundBullet, 100, false); // 100 is the priority
audio_sound_gain(sound_id, volume, 0); // Immediately set the volume based on the calculated distance

			
			}
		
		}
		break;
		
		
		
		
		case "recoil_state_update":
		
			if(instance_exists(oPlayer)){
				oPlayer.recoil = realData.recoil;
				oPlayer.maxRecoil = realData.maxRecoil
			}
		
		break;
		
		
	
		
		case "destroy_player":
		//show_message(buffer_processed)
		if(global.clientId == realData.clientId){
			instance_destroy(oPlayer)
			
			//find your killers name...
			oCamera.myKiller = realData.killerName
			
		}else{
			with(oOtherPlayer){
				if(clientId==real(realData.clientId)){
					part_emitter_clear(oParticleSystem.partSystem, thrustEmitter)
				part_emitter_destroy(oParticleSystem.partSystem, thrustEmitter);
					instance_destroy(id);
				
				}
			}
		}
		
		break;
		
		
		
		case "destroy_bullet":
		with(oBullet){
			if(bulletId== realData.bulletId){
				part_emitter_clear(oParticleSystem.partSystem, emitter)
				part_emitter_destroy(oParticleSystem.partSystem, emitter);
				instance_destroy(id)
			}
		}
		
		break;
		
		
		
		case "destroy_selenium":
		with(oSelenium){
			if(seleniumId== realData.seleniumId){
			
				instance_destroy(id)
			}
		}
		
		break;
		
		
		case "pong":
		global.ping = current_time - real(realData.T)
		break;
		
		
		case "SMTC":
		callback_ReceivedMessage(  realData.message , realData.senderClientId);
		break;
	
	}
	
	
	buffer_delete(buffer_raw)
}
	
	
	
if(type == network_type_disconnect){
	show_message("disconnected")
}


