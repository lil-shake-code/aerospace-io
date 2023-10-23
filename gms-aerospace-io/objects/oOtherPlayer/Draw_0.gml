 if(pflash>0)
{
	pflash--;
	shader_set(shWhite);
	draw_self();
	//shader_reset();
	
} else shader_reset(); draw_self();
if(old_health!=enemyHealth)
{
	old_health = enemyHealth;
	pflash = 7;
}


// Setting the color, font, and alignment for the text
draw_set_color(c_white);
draw_set_font(font_usernames);
draw_set_halign(fa_center);
draw_text(x, y-40, enemyUsername);

// Calculating the coordinates for the health bar
var xleft = oOtherPlayer.x - 15;
var xright = oOtherPlayer.x + 15;
var ytop = oOtherPlayer.y - 22;
var ybottom = oOtherPlayer.y - 22 + 2;

// Drawing the health bar using the calculated coordinates
draw_healthbar(xleft, ytop, xright, ybottom, enemyHealth, c_black, c_red, c_lime, 0, true, true);

draw_self()
