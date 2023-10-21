//speed = gspeed
image_angle = point_direction(x,y,mouse_x,mouse_y);
direction = image_angle;
if(distance_to_point(mouse_x,mouse_y)*image_xscale<200  and distance_to_point(mouse_x,mouse_y)*image_xscale>18)
{
	speed = 1*log2( distance_to_point(mouse_x,mouse_y));   
	
}else
{
	speed=speed*0.7;
}
image_xscale =1+0.1*score

image_yscale = image_xscale


//SHOOT
if(mouse_check_button_pressed(mb_left)){
	repeat(3){
		var b = instance_create_layer(x,y,"Instances",oBullet);
		b.speed = 10  + random_range(-3,3)
		b.direction = other.direction + random_range(-5,5)
		b.image_angle = other.image_angle
		b.image_blend = make_color_hsv(irandom(255) , irandom(80),255)
		
	}
	
}
//BE CAREFUL WITH LAYER NAMES HERE!

