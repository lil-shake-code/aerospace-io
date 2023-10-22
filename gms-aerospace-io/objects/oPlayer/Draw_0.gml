 if(pflash>0)
{
	pflash--;
	shader_set(shWhite);
	draw_self();
	//shader_reset();
	
} else shader_reset(); draw_self();
if(old_health!=health)
{
	old_health = health;
	pflash = 7;
}

draw_set_color(c_white);
draw_set_font(font_usernames);
draw_set_halign(fa_center);
draw_text(x,y-40,global.username);


var xleft = oPlayer.x-15;
var xright = oPlayer.x+15;
var ytop = oPlayer.y-22 ; 
var ybottom = oPlayer.y-22+2 ; 
draw_healthbar(xleft, ytop, xright, ybottom, health, c_black, c_red, c_lime, 0, true, true);
//dont

draw_set_color(c_white)
	draw_circle(x,y,outer_radius, true)
