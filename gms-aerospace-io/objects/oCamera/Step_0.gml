//set up camera
if(room = Room_World){
	cam = view_camera[0];
	follow = global.follow; //returns id of first insatnce of oplayer
	view_w_half = camera_get_view_width(cam)*0.5;
	view_h_half = camera_get_view_height(cam)*0.5;
	xTo = xstart;
	yTo = ystart;


	//check whatever object it is stalking
	if (instance_exists(follow))
	{
	
		xTo = follow.x;
		yTo = follow.y;
		xOld = follow.x
		yOld = follow.y;

	}
	else
	{
		xTo = xOld;
		yTo = yOld;
	
	}
		//update object position with smooooooothness
		var q = 3
		if(!instance_exists(oPlayer)) q = 25;
		x += (xTo-x)/q;
		y += (yTo-y)/q




	//clamps
	x = clamp(x,view_w_half,room_width-view_w_half);
	y = clamp(y,view_h_half,room_height-view_h_half);





	//setting the camera to this objects x and y
	camera_set_view_pos(cam,x-view_w_half,y-view_h_half);
	if(layer_exists("Random_Stars"))
	{
		layer_x("Random_Stars",x/3-500)
		layer_y("Random_Stars",y/3-100)
	
	}
}