socket = network_create_socket(network_socket_ws)
connect = network_connect_raw_async(socket, "localhost",3000)

global.clientId = -1
global.roomId = "public"