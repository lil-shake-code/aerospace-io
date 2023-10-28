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
	
	draw_text_transformed(bw*0.5, bh*0.37, "Player Stats", 0.6*sc, 0.6*sc, 0);
	
	draw_text_transformed(bw*0.5, bh*0.48, "Kills : "+string(score), 0.5*sc, 0.5*sc, 0);
	
	draw_text_transformed(bw*0.5, bh*0.58, "Player "+myKiller+" took you down!", 0.2*sc, 0.2*sc, 0);
	
	if(deadFor>120){
		draw_set_color(c_red);
		draw_text_transformed(bw*0.5, bh*0.65, "Click to Respawn!", 0.4*sc, 0.4*sc, 0);
	}
	
	
	deadFor++;
	
	if(mouse_check_button_pressed(mb_left) and deadFor>120){
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
	draw_text_transformed(0,bh*0.15," Score : "+string(score),0.3*sc,0.3*sc,0);
	
	
	
	draw_set_color(c_yellow);
	
	
	draw_text_transformed(0,bh*0.02," FPS : "+string(fps),0.15*sc,0.15*sc,0);
	draw_text_transformed(0,bh*0.05," CONNECTED to  : "+global.roomId,0.15*sc,0.15*sc,0);
	draw_text_transformed(0,bh*0.08," PING : "+string(global.ping)+"ms",0.15*sc,0.15*sc,0);
	draw_text_transformed(0,bh*0.11," Players in this World : "+string(instance_exists(oPlayer) + instance_number(oOtherPlayer)),0.15*sc,0.15*sc,0);
	
	
	///leaderboard
	// Define the dimensions for the leaderboard
	var lbWidth = bw * 0.2;  // Adjust as necessary
	var lbHeight = bh * 0.4;  // Adjust as necessary
	var padding = bw * 0.01;  // Adjust as necessary

	// Define the position for the leaderboard (bottom left)
	var lbX = padding;
	var lbY = bh - lbHeight - padding;

	// Draw the background
	draw_set_alpha(0.5)
	draw_roundrect_color(lbX, lbY, lbX + lbWidth, lbY + lbHeight, c_black, c_black,false);
	draw_set_alpha(1)

	// Draw the title
	draw_set_color(c_white)
	draw_set_halign(fa_center)
	draw_text_transformed(lbX + padding + lbWidth/2, lbY + padding, "Leaderboard", sc*0.3, sc*0.3, 0);

	// Draw the top 5 players
	var maxEntries = min(5, array_length(global.leaderboard));  // Take the smaller of 5 or the number of entries in the leaderboard
	
	var foundMe = false
	var myRank = -1
	for (var i = 0; i < maxEntries; i++)
	{
	    var entry = global.leaderboard[i];  // Get the i-th entry
	    var playerName = entry[0];
	    var playerScore = string(entry[1]);
		
		var col = c_white
		
		if(entry[2] == global.clientId){
			col = c_fuchsia
			foundMe = true
		
		}
		
		draw_set_color(col)
	    draw_text_transformed(lbX + padding + lbWidth/2, 
		lbY + padding  + (i+1) * 35*sc, 
		string(i + 1) + ". " + playerName + " : " + playerScore, 
		sc*0.2,sc*0.2,0);  // Adjust positions and spacing as necessary
	}
	
	
	for(var i = 0; i < array_length(global.leaderboard); i++){
		if( global.leaderboard[i][2] == global.clientId){
			myRank = i+1
		}
	}
	
	if(!foundMe){
		
		draw_text_transformed(lbX + padding + lbWidth/2,
		lbY + padding + sc * (maxEntries+1) * 35,
		"...", 
		sc*0.2,sc*0.2,0);
		
		draw_set_color(c_fuchsia)
		draw_text_transformed(lbX + padding + lbWidth/2,
		lbY + padding + sc * (maxEntries+2) * 35,
		string(myRank) + ". " + global.username + " : " + string(score), 
		sc*0.2,sc*0.2,0);
		
	
	
	}
	
	
	if(instance_exists(oPlayer)){
		
		
		draw_sprite_ext(sSky,0, bw-1500*sc*0.07, bh-1500*sc*0.07,
		sc*0.07,sc*0.07,0,c_white,0.5
		)
		draw_set_color(c_white)
		draw_rectangle(bw-3000*sc*0.07, bh-3000*sc*0.07,bw-2,bh,true)
		
		with(oOtherPlayer){
			draw_sprite_ext(id.sprite_index,0,
			bw-3000*sc*0.07 + x/3000 * (3000*sc*0.07),
			bh-3000*sc*0.07 +  y/3000 * (3000*sc*0.07),
			0.5,0.5,
			id.image_angle,
			c_white,
			0.5
			)
		}
		
		with(oPlayer){
			
		draw_sprite_ext(id.sprite_index,0,
			bw-3000*sc*0.07 + x/3000 * (3000*sc*0.07),
			bh-3000*sc*0.07 +  y/3000 * (3000*sc*0.07),
			0.5,0.5,
			id.image_angle,
			c_white,
			0.5
			)
		
		
		}
		
		
		
		
	}

	
	

}

