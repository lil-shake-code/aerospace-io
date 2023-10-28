
global.leaderboard = [];
if(room==Room_World){
	// Add the main player's score
	global.leaderboard[0] = [global.username, score, global.clientId];  // Assuming global.score contains the player's score

	// Add other players' scores
	var count = 1;  // Start from 1 since we've already added the main player
	with (oOtherPlayer)
	{
	    global.leaderboard[count] = [enemyUsername, enemyKills, clientId];  // Assuming each oOtherPlayer has a 'name' variable
	    count++;
	}

	// Bubble Sort Algorithm
	var n = array_length(global.leaderboard);

	for (var i = 0; i < n-1; i++) {
	    for (var j = 0; j < n-i-1; j++) {
	        // Compare the number of kills for consecutive players
	        if (global.leaderboard[j][1] < global.leaderboard[j+1][1]) {
	            // Swap the leaderboard entries
	            var temp = global.leaderboard[j];
	            global.leaderboard[j] = global.leaderboard[j+1];
	            global.leaderboard[j+1] = temp;
	        }
	    }
	}
}


alarm[1] = 10