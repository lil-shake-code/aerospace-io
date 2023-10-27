bw = browser_width
bh = browser_height
sc = 0.7*bw/1920;
var mx = device_mouse_x_to_gui(0)
var my = device_mouse_y_to_gui(0)
draw_set_color(c_white);
draw_roundrect_ext(bw*.4,bh*.2,bw*.6,bh*.5,100,100,false);


draw_set_font(fMenu);
draw_set_halign(fa_middle);
draw_set_valign(fa_middle);


draw_set_color(c_green)
draw_roundrect(bw*0.45, bh*0.76, bw*0.55, bh*0.84,false)
draw_set_color(c_white);
draw_text_transformed(bw/2, bh*.8, "PLAY ",sc,sc,0);
if(mouse_check_button_pressed(mb_left)){
	if(point_in_rectangle(mx,my,bw*0.45, bh*0.75, bw*0.55, bh*0.85)){
		room_goto(Room_World)
		
		
		view_wport[0] = 1080*sc;
		view_hport[0] = view_wport[0]*bh/bw;
		camera_set_view_size(view_camera[0], view_wport[0], view_hport[0]);
		window_set_size(bw, bh);
	}

}

//play private
draw_set_color(c_red)
draw_roundrect(bw*0.43, bh*0.86, bw*0.57, bh*0.94,false)
draw_set_color(c_white);
draw_text_transformed(bw/2, bh*.9, "PLAY PRIVATE ",sc,sc,0);
if(mouse_check_button_pressed(mb_left)){
	if(point_in_rectangle(mx,my,bw*0.43, bh*0.86, bw*0.57, bh*0.94)){
		
		global.roomId = get_string("Tell the name of the room you want to join or create","public")
		room_goto(Room_World)
		
		
		view_wport[0] = 1080*sc;
		view_hport[0] = view_wport[0]*bh/bw;
		camera_set_view_size(view_camera[0], view_wport[0], view_hport[0]);
		window_set_size(bw, bh);
	}

}





draw_set_font(fMenu);
draw_set_halign(fa_middle);
draw_set_valign(fa_middle);
draw_set_color(c_black);
draw_text_transformed(bw/2, bh/2-bh/10, keyboard_string,sc,sc,0);

if( string_length(keyboard_string)>13)
	{
		var c = string_delete(keyboard_string, 13, 1);
		keyboard_string = c;
		
		
	}
global.username = keyboard_string
draw_text_transformed(bw/2, bh*.35, "My name is...",sc*.9,sc*.9,0);
draw_text_transformed(bw/2, bh*0.27, "Aerospace.io",sc*1.3,sc*1.3,0);
	


var spr = global.skins[global.skin]
draw_sprite_ext(spr,0,bw*0.5,bh*0.6,sc*2,sc*2,
point_direction(bw*0.5,bh*0.6,mx,my)
,c_white,1)
draw_set_color(c_white)
draw_text_transformed(bw/2, bh*0.68, "Click on skin to change",sc,sc,0);



///IOGAMES.FORUM PLUG
draw_text_transformed(bw*0.8, bh*0.4, "Join the Largest IO Community!",sc,sc,0);
var c = make_color_hsv(255*abs(sin(current_time*0.003)),255,255)
draw_sprite_ext(iogamesforum,0,bw*0.8, bh*0.55 , sc*0.7,0.7*sc,0,c,1) //
var x1 = 577

var y1 = 286
draw_rectangle(bw*0.8 - x1/2*sc*0.7 , 
bh*0.55 - y1/2*sc*0.7,
bw*0.8 + x1/2*sc*0.7 , 
bh*0.55 + y1/2*sc*0.7,true)
if(point_in_rectangle(mx,my,
bw*0.8 - x1/2*sc*0.7 , 
bh*0.55 - y1/2*sc*0.7,
bw*0.8 + x1/2*sc*0.7 , 
bh*0.55 + y1/2*sc*0.7,
) and mouse_check_button_pressed(mb_left)){
	
	url_open_ext("http://iogames.forum", "_blank");


	
}


///Twitter Plug
///IOGAMES.FORUM PLUG
draw_set_color(c_white)
draw_text_transformed(bw*0.2, bh*0.3, "Latest Tweets",sc,sc,0);

draw_sprite_ext(sSampleTweeet,0,bw*0.2, bh*0.55 , sc*0.07,0.07*sc,0,c_white,1) //
var x2 = 8860

var y2 = 8470
draw_rectangle(bw*0.2 - x2/2*sc*0.07 , 
bh*0.55 - y2/2*sc*0.07,
bw*0.2 + x2/2*sc*0.07 , 
bh*0.55 + y2/2*sc*0.07,true)
if(point_in_rectangle(mx,my,
bw*0.2 - x2/2*sc*0.07 , 
bh*0.55 - y2/2*sc*0.07,
bw*0.2 + x2/2*sc*0.07 , 
bh*0.55 + y2/2*sc*0.07,
) and mouse_check_button_pressed(mb_left)){
	
	url_open_ext("https://twitter.com/lilshake139", "_blank");


	
}


