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
			data[? "serverId"] = global.SERVERID;
			//whatever data you want to send as key value pairs

			ds_map_add(data,"eventName","join_server");
			buffer_write(Buffer, buffer_text, json_encode(data))
			network_send_raw(oBrain.socket, Buffer, buffer_tell(Buffer),network_send_text)
			buffer_delete(Buffer)
			ds_map_destroy(data)
			
			
			
			
	}
	
}
if(type == network_type_data){
	var buffer_raw = async_load[? "buffer"];
	var buffer_processed = buffer_read(buffer_raw , buffer_text);
	//var realData = json_decode(buffer_processed);
	var realData = json_parse(buffer_processed)
	if(variable_struct_exists(realData , "eventName")){
		//show_message(buffer_processed)
	}
	var eventName = variable_struct_get(realData,"eventName")
	
	
	
	
	switch(eventName){
		case "created_you":
			global.clientId = realData.clientId
			global.roomId = string(global.clientId)
			alarm[2] = 1;
			callback_ConnectToServer();
		break;
		
		
		
		case "state_update":
		//show_message(buffer_processed)
		var found = false;
		with(oOtherPlayer){
			if(clientId==real(realData.clientId)){
				sharedProperties = realData.SP;
				found = true;
				show_debug_message("found this player")
				//Now also update the entities for this player
				entities =(realData.entities);
				
				
				
				
				
				
			}
		}
		if(!found and real(realData.clientId!=global.clientId)){
			show_debug_message("creating a new player")
			var new_enemy = instance_create_layer(0,0,global.OtherPlayersLayerName,oOtherPlayer);
			new_enemy.clientId = real(realData.clientId);
			new_enemy.roomId = realData.roomId;
			new_enemy.sharedProperties = realData.SP;
		
		}
		break;
		
		
	
		
		case "destroy_player":
		//show_message(buffer_processed)
		with(oOtherPlayer){
			if(clientId==real(realData.clientId)){
				instance_destroy(id);
				show_message("found player to destroy")
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

