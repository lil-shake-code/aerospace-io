/// @description Insert description here
// You can write your code in this editor
browserw = browser_width
browserh = browser_height


if(room ==Room_World)
{
	show_debug_message("resize happening nwo")
	if(true){//oldw!= browserw or oldh!=browserh
		if(instance_exists(oPlayer))
		{
			var scale =1+(oPlayer.image_xscale-1)/2;
		}else scale =1;
	
		view_wport[0] = 1080*scale;
		view_hport[0] = view_wport[0]*browserh/browserw;
		camera_set_view_size(view_camera[0], view_wport[0], view_hport[0]);
		window_set_size(browserw, browserh);
		oldw = browserw
		oldh = browserh
	}
}
else
{
	window_set_size(browserw, browserh);
}

alarm[0] = 10