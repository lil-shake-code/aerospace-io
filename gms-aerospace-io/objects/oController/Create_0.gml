global.PRODUCTION = false
if(!variable_global_exists("uuid")){
	global.uuid = ""

}
global.savedSelenium = 0

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



///audio
audio_falloff_set_model(audio_falloff_exponent_distance);
audio_listener_position(x,y,0)
audio_listener_orientation(0, -1, 0, 0, 1, 0);


global.upgrades = {
	tS: 0,
	mH: 100,
	hR: 0.2,
	D: 10,
	rT: 10,
	sp: 1,
	bS: 1,
	uS:0,

}