var bw = browser_width
var bh = browser_height
var sc = bw/1300
if(!instance_exists(oPlayer) and room = Room_World){
	draw_set_color(c_white)
	draw_roundrect_ext(bw*0.3,bh*0.3,bw*0.7,bh*0.7,80,80, false)
	
	draw_set_color(c_black)
	draw_set_font(fMenu80)
	draw_set_halign(fa_center)
	draw_set_valign(fa_center)
	
	draw_text_transformed(bw*0.5, bh*0.37,"Player Stats",0.7,0.7,0)
	
	draw_text_transformed(bw*0.5, bh*0.48,"Kills : "+string(score),0.7,0.7,0)
	
	draw_text_transformed(bw*0.5, bh*0.58,"Player "+myKiller+" took you down!"+string(score),0.2,0.2,0)
	
	draw_set_color(c_red)
	draw_text_transformed(bw*0.5, bh*0.65,"Click to Respawn!",0.4,0.4,0)
	
	
}