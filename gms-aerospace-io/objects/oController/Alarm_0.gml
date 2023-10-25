/// @description PING
var Buffer = buffer_create(1, buffer_grow, 1)
//WHAT DATA 
var data = ds_map_create();
//whatever data you want to send as key value pairs

ds_map_add(data,"eventName","ping");
ds_map_add(data, "clientId", global.clientId)
ds_map_add(data, "T", current_time)

	
buffer_write(Buffer, buffer_text, json_encode(data))
network_send_raw(oController.socket, Buffer, buffer_tell(Buffer),network_send_text)
buffer_delete(Buffer)
ds_map_destroy(data)

alarm[0] = 10
