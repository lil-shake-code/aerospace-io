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
draw_text_transformed(bw/2, bh*0.68, "Click on skin to change",sc,sc,0);;
