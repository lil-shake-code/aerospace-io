var bw = browser_width;
var bh = browser_height;
var sc = bw/1300;
if(!instance_exists(oPlayer) and room = Room_World){
	draw_set_color(c_white);
	draw_roundrect_ext(bw*0.3, bh*0.3, bw*0.7, bh*0.7, 80, 80, false);
	
	draw_set_color(c_black);
	draw_set_font(fMenu80);
	draw_set_halign(fa_center);
	draw_set_valign(fa_center);
	
	draw_text_transformed(bw*0.5, bh*0.37, "Player Stats", 0.7*sc, 0.7*sc, 0);
	
	draw_text_transformed(bw*0.5, bh*0.48, "Kills : "+string(score), 0.7*sc, 0.7*sc, 0);
	
	draw_text_transformed(bw*0.5, bh*0.58, "Player "+myKiller+" took you down!"+string(score), 0.2*sc, 0.2*sc, 0);
	
	draw_set_color(c_red);
	draw_text_transformed(bw*0.5, bh*0.65, "Click to Respawn!", 0.4*sc, 0.4*sc, 0);
	
	if(mouse_check_button_pressed(mb_left)){
		room_restart();
		
		view_wport[0] = 1080*sc;
		view_hport[0] = view_wport[0]*bh/bw;
		camera_set_view_size(view_camera[0], view_wport[0], view_hport[0]);
		window_set_size(bw, bh);
	}
}


if( room = Room_World){
	
	//top left stuff

	draw_set_color(c_white);
	draw_set_font(fMenu80);
	draw_set_halign(fa_left);
	draw_text_transformed(0,bh*0.1," Score : "+string(score),0.5*sc,0.5*sc,0);
	
	
	
	draw_set_color(c_yellow);
	draw_set_font(ftArial);
	
	draw_text_transformed(0,bh*0.02," FPS : "+string(fps),0.1*sc,0.1*sc,0);
	draw_text_transformed(0,bh*0.05," CONNECTED to  : server",0.1*sc,0.1*sc,0);
	draw_text_transformed(0,bh*0.08," PING : ",0.1*sc,0.1*sc,0);
	draw_text_transformed(0,bh*0.11," Players in this World : "+string(instance_exists(oPlayer) + instance_number(oOtherPlayer)),0.1*sc,0.1*sc,0);
	
	
	
	
	

}

