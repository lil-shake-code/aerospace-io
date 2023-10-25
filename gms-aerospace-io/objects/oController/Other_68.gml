/// @description Async ws Events. Do Not Tamper!
var type = async_load[? "type"]
if(type == network_type_non_blocking_connect){
	if( async_load[? "succeeded"] == false){
		show_debug_message("failed non blocking connection. Please check your internet connection and firewalls.")
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

	
		break;
		
		
		
		
		
		
		
		
		
		
		
		case "global_state_update":
	
		if(global.clientId==realData.clientId){
			oPlayer.serverX = real(realData.x)
			oPlayer.serverY = real(realData.y)
			health = real(realData.H) 
			score = real(realData.K) 
		}
		with(oOtherPlayer){
			if(clientId==real(realData.clientId)){
				serverX = real(realData.x)
				serverY = real(realData.y)
				image_angle = realData.A
				enemyHealth = real(realData.H) 
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
		
		}
		break;
		
		
	
		
		case "destroy_player":
		//show_message(buffer_processed)
		if(global.clientId == realData.clientId){
			instance_destroy(oPlayer)
			
		}else{
			with(oOtherPlayer){
				if(clientId==real(realData.clientId)){
					instance_destroy(id);
				
				}
			}
		}
		
		break;
		
		
		case "pong":
		global.ping = current_time - real(realData.ct)
		break;
		
		
		case "SMTC":
		callback_ReceivedMessage(  realData.message , realData.senderClientId);
		break;
	
	}
	
	
	buffer_delete(buffer_raw)
}

