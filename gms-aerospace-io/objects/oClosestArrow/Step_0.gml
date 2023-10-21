bw = browser_width;
bh = browser_height;
if(instance_exists(oOtherPlayer)and (instance_exists(oPlayer)))
{
	closest_enemy = oOtherPlayer;
	var closestDistance = point_distance(oPlayer.x,oPlayer.y,closest_enemy.x,closest_enemy.y);
	for (var i = 0; i < instance_number(oEnemy); ++i;)
	{
		var enemy_object_id = instance_find(oEnemy,i);
		var thisDistance = point_distance(oPlayer.x,oPlayer.y,enemy_object_id.x,enemy_object_id.y);
		if(thisDistance<closestDistance)
		{
			closest_enemy = enemy_object_id;
		}
	}
	visible = true
}else closest_enemy=undefined; visible = false;



if(closest_enemy!=undefined)
{
	if(instance_exists(oPlayer))
	{
		if(closestDistance > min((view_wport[0])/2,view_hport[0]/2)        )
		{
		visible = true
		image_xscale = 0.3;
		image_yscale = 0.3;
		var rad = (200+20*sin(real(current_time)/150));
		image_angle = point_direction(oPlayer.x,oPlayer.y,closest_enemy.x,closest_enemy.y);
		x= oPlayer.x+rad*cos((image_angle+15)*pi/180)
		y= oPlayer.y-rad*sin((image_angle-15)*pi/180)
		}else visible = false;
		
	}
}