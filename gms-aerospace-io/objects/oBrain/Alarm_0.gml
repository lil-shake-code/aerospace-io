/// @description Entity Sharing
try{
	with(oMyEntity){
	
		
		if(variable_instance_exists(oBrain,"socket")){
	
		//format for sending info to server 
		var Buffer = buffer_create(1, buffer_grow, 1)
	
		//WHAT DATA 
		var data = ds_map_create();
		data[? "serverId"] = global.SERVERID;
		//whatever data you want to send as key value pairs

		data[? "clientId"] = global.clientId;
		data[?"entityId"] = entityId
		data[?"entityP"] = json_stringify(entityProperties)
		if(variable_instance_exists(oBrain,"socket")){
		ds_map_add(data,"eventName","entity_state_update");
		buffer_write(Buffer, buffer_text, json_encode(data))
		network_send_raw(oBrain.socket, Buffer, buffer_tell(Buffer),network_send_binary)
		buffer_delete(Buffer)
		ds_map_destroy(data)
		}

	}
	
	
	}
	
}catch(e){
	show_debug_message("Error in updating some entity. If this persists, check your code. The error is being printed now.")
	show_debug_message(e)
}
	
	
alarm[0] =global.entitySharingFrequency;