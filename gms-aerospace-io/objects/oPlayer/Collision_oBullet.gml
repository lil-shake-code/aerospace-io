with(other)//full thing is under with so obullet that instance!
{
	pflash = 24 ;
	if(fired_by!=undefined) 
	{
		global.last_bullet_fired_by = fired_by;
	
		if(fired_by!=("client_"+global.username))
		{
			switch(speed)
			{
				case 22 : damage = 20;break;
				case 23 : damage = 20;break;
				case 32 : damage = 10;break;
				case 33 : damage = 7;break;
				case 24 : damage = 23;break;
				case 25 : damage = 30;break;
				case 27 : damage = 40;break;
				case 35 : damage = 80;break;
				case 10 : damage = 100;break;
		
			}
			health-=damage;
			instance_destroy();
		}
	
	}
}