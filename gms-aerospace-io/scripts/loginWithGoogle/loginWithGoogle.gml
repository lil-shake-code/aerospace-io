// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function loginWithGoogle(){
	
		//telling the server tp put us in an authentication queue
		var Buffer = buffer_create(1, buffer_grow ,1);
		var data = ds_map_create();
		data[?"eventName"] = "authentication_queue"	
		randomise()
		var q = floor(100000*random(x))
		data[?"queueId"] = q
		
	
		
	
		buffer_write(Buffer , buffer_text  , json_encode(data));
		network_send_raw(oController.socket , Buffer , buffer_tell(Buffer));
		ds_map_destroy(data);
		buffer_delete(Buffer)	
		
		
		//Now telling middleware
		url_open_ext("https://us-central1-stellarclash-io.cloudfunctions.net/app/login?q="+string(q),"_blank")  ///the firebase login index
		

}