//set up camera
if(room = Room_World){
	currentScale = lerp(currentScale, targetScale, 0.3)
    cam = view_camera[0];
    follow = global.follow; //returns id of first insatnce of oplayer
    view_w_half = camera_get_view_width(cam)*0.5;
    view_h_half = camera_get_view_height(cam)*0.5;
    xTo = xstart;
    yTo = ystart;

    //check whatever object it is stalking
    if (instance_exists(follow)) {
        xTo = follow.x;
        yTo = follow.y;
        xOld = follow.x
        yOld = follow.y;
    } else {
        xTo = xOld;
        yTo = yOld;
    }

    // Calculate the desired camera position with smooooooothness
    var q = (instance_exists(oPlayer)) ? 3 : 25;
    var desiredX = x + (xTo-x)/q;
    var desiredY = y + (yTo-y)/q;

    // Clamp the desired position
    desiredX = clamp(desiredX, view_w_half, room_width - view_w_half);
    desiredY = clamp(desiredY, view_h_half, room_height - view_h_half);

    // Update the object position with the clamped values
    x = desiredX;
    y = desiredY;
	
	audio_listener_position(x,y,0)
	

    //setting the camera to this objects x and y
    camera_set_view_pos(cam, x-view_w_half, y-view_h_half);

    if(layer_exists("Random_Stars")) {
        layer_x("Random_Stars", x/3 - 500);
        layer_y("Random_Stars", y/3 - 100);
    }
}
