bw = 1366
bh = 768



var left = mouse_check_button_pressed(mb_left);
var mouse_on_next_sprite = false;
if (mouse_x>bw*0.45)and(mouse_x<bw*0.55)
{
if (mouse_y>bh*0.55)and(mouse_y<bh*0.65)
{
	mouse_on_next_sprite = true;
}

}

if(left and mouse_on_next_sprite )
{
	global.skin++;
	if(global.skin>4) global.skin=0;
}