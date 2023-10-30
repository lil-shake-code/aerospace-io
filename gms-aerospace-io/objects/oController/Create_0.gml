global.PRODUCTION = false

if(global.PRODUCTION){
	socket = network_create_socket(network_socket_wss)
	connect = network_connect_raw_async(socket, "launch-io-ca7e4f4a26e3.herokuapp.com/",443)
}else{
	socket = network_create_socket(network_socket_ws)
	connect = network_connect_raw_async(socket, "localhost",3000)
}

global.clientId = -1

global.ping = -1
window_set_cursor(cr_cross);

alarm[0] = 10