 if(pflash>0)
{
	pflash--;
	shader_set(shWhite);
	// Draw event of the main object
	
	draw_self()
	
} else{ shader_reset(); 
	
	
	// Draw event of the main object



	draw_self(); // Draw the main sprite
	
	
	
	
	
	
	
}
if(old_health>health)
{
	old_health = health;
	pflash = 7;
}

draw_set_color(c_white);
draw_set_font(font_usernames);
draw_set_halign(fa_center);
draw_text(x,y-50,global.username);


var xleft = oPlayer.x-15 ;
var xright = oPlayer.x+15
var ytop = oPlayer.y-22 ; 
var ybottom = oPlayer.y-22+2 +score*0.5
draw_healthbar(xleft - maxHealth/10, ytop, xright+ maxHealth/10, ybottom, 100*health/maxHealth, c_black, c_red, c_lime, 0, true, true);

//recoil bar
recoil--;
if(recoil<0){ recoil = 0}
draw_healthbar(xleft - score, ytop-10, xright + score, ybottom-10,100- 100*recoil/maxRecoil, c_black, c_aqua, c_aqua, false, true, true)


draw_set_color(c_white)
draw_circle(x,y,outer_radius, true)
draw_circle(x,y,inner_radius, true)
