
browserw = browser_width
browserh = browser_height

aspectRatio = browserw/browserh


if(room ==Room_World)
{


		if(instance_exists(oPlayer))
		{
			var scale =1+(oPlayer.image_xscale-1)/2;
		}else {scale =1;}
		
		
		if(aspectRatio>1){
			//very landscapey
			view_wport[0] = 1080*scale;
			view_hport[0] = view_wport[0]*browserh/browserw;
			camera_set_view_size(view_camera[0], view_wport[0], view_hport[0]);
		
		}else{
			//more portraitey
			view_hport[0] = 1080*scale;
			view_wport[0] = view_hport[0]*browserw/browserh;
			camera_set_view_size(view_camera[0], view_wport[0], view_hport[0]);
			
		}
		
		
	
		
		window_set_size(browserw, browserh);
		oldw = browserw
		oldh = browserh
	
}
else
{
	window_set_size(browserw, browserh);
}

alarm[0] = 10