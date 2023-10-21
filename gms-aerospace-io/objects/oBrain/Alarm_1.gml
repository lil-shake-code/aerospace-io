/// @description Ping
//format for sending info to server 
if(variable_instance_exists(oBrain,"socket")){
		var Buffer = buffer_create(1, buffer_grow, 1)
	
		//WHAT DATA 
		var data = ds_map_create();
		data[? "ct"] = current_time;
	
		
		ds_map_add(data,"eventName","ping");
		buffer_write(Buffer, buffer_text, json_encode(data))
		network_send_raw(oBrain.socket, Buffer, buffer_tell(Buffer),network_send_binary)
		buffer_delete(Buffer)
		ds_map_destroy(data)
}
alarm[1] = 25

