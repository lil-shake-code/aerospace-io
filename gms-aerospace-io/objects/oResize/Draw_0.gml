browserw = browser_width
browserh = browser_height
/*
if(browserw/browserh<(16/9))
{
	window_set_size(browserw, browserw*9/16);
}
else window_set_size(browserh*16/9, browserh);
*/
if(room ==Room_World)and(!mouse_check_button_pressed(mb_right))
{
if(instance_exists(oPlayer))
{
	var scale =1+(oPlayer.image_xscale-1)/2;
}else scale =1;
view_wport[0] = 1080*scale;
view_hport[0] = view_wport[0]*browserh/browserw;
camera_set_view_size(view_camera[0], view_wport[0], view_hport[0]);
window_set_size(browserw, browserh);
}
else
{
window_set_size(browserw, browserh);
}




