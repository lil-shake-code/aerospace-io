// Import necessary modules
import { createServer } from "http";
import { WebSocketServer } from "ws";

var players = {};
var bullets = {};
var clientId = 0;
var bulletId = 0;
var MAX_BOTS = 12;

const GAME_WIDTH = 3000;
const GAME_HEIGHT = 3000;

const spawnPoints = [
  { x: 1458, y: 400 }, //ursa major
  { x: 1400, y: 700 }, //ursa minor
  { x: 870, y: 1000 }, //cassiopeia
  { x: 400, y: 1350 }, //aries
  { x: 964, y: 2421 }, //orion
  { x: 1542, y: 1542 }, //the summer triangle
  { x: 2012, y: 2012 }, //sirius
  { x: 2513, y: 866 }, //corona borealis
];

// Create an HTTP server
const server = createServer((req, res) => {
  res.writeHead(404, { "Content-Type": "text/plain" });
  res.end("Not Found");
});

// Create a WebSocket server by passing the HTTP server instance to `WebSocket.Server`
const wss = new WebSocketServer({
  port:
    //PROCESS ENV PORT
    process.env.PORT || 3000,
});

function distance(x1, y1, x2, y2) {
  return Math.sqrt((x1 - x2) ** 2 + (y1 - y2) ** 2);
}

function bestSpawnPoint(players, spawnPoints, roomId = "public") {
  let bestPoint = null;
  let bestDistance = -Infinity; // Initialize to a very small value

  for (let i = 0; i < spawnPoints.length; i++) {
    let currentPoint = spawnPoints[i];
    let minDist = Infinity; // Initialize to a very large value

    for (let clientId in players) {
      let player = players[clientId];

      if (player.roomId != roomId) {
        continue;
      }
      let d = distance(currentPoint.x, currentPoint.y, player.x, player.y);
      if (d < minDist) {
        minDist = d;
      }
    }

    if (minDist > bestDistance) {
      bestDistance = minDist;
      bestPoint = currentPoint;
    }
  }

  return bestPoint;
}

function outOfBounds(x, y) {
  //return {x,y} with corrected posiiton inside the game
  var outOfBounds = false;
  if (x < 0) {
    x = 0;
    outOfBounds = true;
  }
  if (x > GAME_WIDTH) {
    x = GAME_WIDTH;
    outOfBounds = true;
  }
  if (y < 0) {
    y = 0;
    outOfBounds = true;
  }
  if (y > GAME_HEIGHT) {
    y = GAME_HEIGHT;
    outOfBounds = true;
  }

  return { x: x, y: y, outOfBounds: outOfBounds };
}

function checkBulletCollision(bullet, player) {
  //check if bullet is colliding with player
  var d = distance(bullet.x, bullet.y, player.x, player.y);

  if (d < ((player.kills + 1) * 0.1 + 1) * 32) {
    return true;
  }
  return false;
}
function getShootingCharacteristics(level) {
  // Calculate damage
  let damage = Math.min(5 + level, 20);

  // Calculate bullet speed
  let bulletSpeed = Math.max(15 - level, 5);

  // Calculate recoil time using sine wave for oscillation
  let recoilTime = 40 + 20 * Math.sin((level * Math.PI) / 10); // Oscillates between 20 and 60 over 10 levels

  // Calculate spread - the number of bullets fired in 1 trigger
  let spread = Math.min(1 + Math.floor(level / 2), 5);

  return {
    damage: damage,
    bulletSpeed: bulletSpeed,
    recoilTime: recoilTime,
    spread: spread,
  };
}

//Game Loop
function gameLoop() {
  //update players
  for (var i in players) {
    var player = players[i];

    //reduce recoil
    if (player.recoil > 0) {
      player.recoil--;
    }

    //health regeneration
    if (player.health < 100) {
      if (Date.now() - player.lastHitTime > 10000) {
        player.health += 0.2;
      }
    }

    if (player.bot) {
      player.bot.lifetime++;
      //recoil
      if (player.bot.recoil > 0) {
        player.bot.recoil--;
      }
      //bot logic
      //try to chase the player closest to this bot and once you are close enough, shoot

      var closestPlayer = null;
      var closestDistance = Infinity;

      for (var j in players) {
        var otherPlayer = players[j];
        //if roomId is different, skip this player
        if (otherPlayer.roomId != player.roomId) {
          continue;
        }
        if (otherPlayer.clientId != player.clientId) {
          var d = distance(player.x, player.y, otherPlayer.x, otherPlayer.y);
          if (d < closestDistance) {
            closestDistance = d;
            closestPlayer = otherPlayer;
          }
        }
      }

      if (closestPlayer) {
        //chase this player
        var dx = closestPlayer.x - player.x;
        var dy = closestPlayer.y - player.y;

        //if the player is close enough, shoot
        if (closestDistance < 100) {
          if (player.bot.recoil <= 0) {
            //rotate the bot to face the player
            player.A = Math.atan2(-dy, dx) * (180 / Math.PI);

            ///repeat x times

            for (var k = 0; k < player.shootingCharacteristics.spread; k++) {
              var bullet = {
                x: player.x,
                y: player.y,
                A: player.A + Math.random() * 10 - 5,
                speed: player.shootingCharacteristics.bulletSpeed,
                damage: player.shootingCharacteristics.damage,
                firedBy: player.clientId,
                roomId: player.roomId,
              };
              bullets[bulletId++] = bullet;
            }

            //recoil
            player.bot.recoil = player.shootingCharacteristics.recoilTime;
            player.recoil = player.shootingCharacteristics.recoilTime;
          }
        } else {
          //just make the bot move in the direction of the player 5 pixels
          player.x += (dx / closestDistance) * player.speed * 0.2;
          player.y += (dy / closestDistance) * player.speed * 0.2;

          //rotate the bot to face the player
          player.A = Math.atan2(-dy, dx) * (180 / Math.PI);
        }
        //check if player is out of bounds
        var correctedPosition = outOfBounds(player.x, player.y);
        player.x = correctedPosition.x;
        player.y = correctedPosition.y;
        continue;
      }
    }
    //angle is in degrees
    player.x += player.N * Math.cos((player.A * Math.PI) / 180) * player.speed;
    player.y -= player.N * Math.sin((player.A * Math.PI) / 180) * player.speed;

    //check if player is out of bounds
    var correctedPosition = outOfBounds(player.x, player.y);
    player.x = correctedPosition.x;
    player.y = correctedPosition.y;
  }

  //update bullets
  for (var i in bullets) {
    var bullet = bullets[i];
    bullet.x += Math.cos((bullet.A * Math.PI) / 180) * bullet.speed;
    bullet.y -= Math.sin((bullet.A * Math.PI) / 180) * bullet.speed;

    //check if bullet is out of bounds
    if (outOfBounds(bullet.x, bullet.y).outOfBounds) {
      delete bullets[i];

      //tell players to delete this bullet
      var sendThis = {
        eventName: "destroy_bullet",
        bulletId: i,
      };

      for (var j in players) {
        var player = players[j];
        //chek same room
        if (player.roomId != bullet.roomId) {
          continue;
        }
        if (player.ws) {
          player.ws.send(JSON.stringify(sendThis));
        }
      }
      continue;
    }

    //check if bullet is colliding with player
    for (var j in players) {
      var player = players[j];
      //check if same room
      if (player.roomId != bullet.roomId) {
        continue;
      }
      if (bullet.firedBy != player.clientId) {
        if (checkBulletCollision(bullet, player)) {
          delete bullets[i];

          //tell players to delete this bullet
          var sendThis = {
            eventName: "destroy_bullet",
            bulletId: i,
          };

          for (var k in players) {
            var otherPlayer = players[k];

            //check if same room
            if (otherPlayer.roomId != bullet.roomId) {
              continue;
            }

            if (otherPlayer.ws) {
              otherPlayer.ws.send(JSON.stringify(sendThis));
            }
          }

          //reduce player health
          player.health -= 10;
          //set the last hit time to now
          player.lastHitTime = Date.now();
          //IF PLAYER DIES
          if (player.health <= 0) {
            var sendThis = {
              eventName: "destroy_player",
              clientId: player.clientId,
            };

            for (var k in players) {
              var otherPlayer = players[k];

              if (otherPlayer.ws) {
                otherPlayer.ws.send(JSON.stringify(sendThis));
              }
            }

            //remove player from players
            delete players[player.clientId];

            //find the player who fired the bullet and add 1 to kills
            try {
              players[bullet.firedBy].kills += 1;

              //shooting characteristics

              players[bullet.firedBy].shootingCharacteristics =
                getShootingCharacteristics(players[bullet.firedBy].kills);
            } catch (e) {
              console.log(
                "Error in adding a kill to player, most likely the player is dead"
              );
            }
          }

          break;
        }
      }
    }
  }
}
setInterval(gameLoop, 1000 / 60);

function createBots() {
  //go through the players and count how many are bots
  var botCount = 0;
  for (var i in players) {
    var player = players[i];
    if (player.bot) {
      botCount++;
    }
  }

  //if there are less than MAX_BOTS, create a new bot
  if (botCount < MAX_BOTS) {
    var spawnPoint = bestSpawnPoint(players, spawnPoints, "public");
    var player = {
      clientId: clientId++,
      x: spawnPoint.x,
      y: spawnPoint.y,
      A: 0,
      N: 0,
      speed: 10,
      health: 100,
      kills: Math.floor(Math.random() * 10),
      roomId: "public", ///BOTS WILL ONLY EXIST in public room
      username: "bot",
      ws: null,
      bot: {
        recoil: 0,
        lifetime: 0,
      },
      skin: Math.floor(Math.random() * 7), //0-6
      lastHitTime: 0,
      recoil: 0,
    };
    player.shootingCharacteristics = getShootingCharacteristics(player.kills);

    players[player.clientId] = player;

    //tell other players we created this guy
    var sendThis = {
      eventName: "create_player",
      clientId: player.clientId,
      roomId: player.roomId,
      x: player.x,
      y: player.y,
      username: player.username,
      skin: player.skin,
    };

    for (var j in players) {
      var otherPlayer = players[j];

      //check if same room
      if (otherPlayer.roomId != player.roomId) {
        continue;
      }

      if (otherPlayer.clientId != player.clientId) {
        //if ws is not null
        if (otherPlayer.ws) {
          otherPlayer.ws.send(JSON.stringify(sendThis));
        }
      }
    }
  }
}
setInterval(createBots, 1000);

//Global state update
function globalStateUpdate() {
  for (var i in players) {
    var player = players[i];
    var sendThis = {
      eventName: "global_state_update",
      clientId: player.clientId,
      x: player.x,
      y: player.y,
      A: player.A,
      H: player.health,
      K: player.kills,
    };

    for (var j in players) {
      var otherPlayer = players[j];
      //check if same room
      if (otherPlayer.roomId != player.roomId) {
        continue;
      }

      if (otherPlayer.ws) {
        otherPlayer.ws.send(JSON.stringify(sendThis));
      }
    }
  }
}
setInterval(globalStateUpdate, 1000 / 60);

//Bullet state update
function bulletStateUpdate() {
  for (var i in bullets) {
    var bullet = bullets[i];
    var sendThis = {
      eventName: "bullet_state_update",
      bulletId: i,
      x: bullet.x,
      y: bullet.y,
      A: bullet.A,
      D: bullet.damage,
    };

    for (var j in players) {
      var player = players[j];
      //check if same room
      if (player.roomId != bullet.roomId) {
        continue;
      }

      if (player.ws) {
        player.ws.send(JSON.stringify(sendThis));
      }
    }
  }
}
setInterval(bulletStateUpdate, 1000 / 60);

// Set up an event listener for handling incoming WebSocket connections
wss.on("connection", (ws) => {
  console.log("Client connected!");

  // Set up event listeners for handling messages from clients
  ws.on("message", (message) => {
    // console.log(`Received message: ${message}`);

    var realData = JSON.parse(message);

    switch (realData.eventName) {
      case "create_me":
        if (!realData.roomId) {
          realData.roomId = "public";
        }
        //if type is not string, set it to public
        if (typeof realData.roomId != "string") {
          realData.roomId = "public";
        }
        var spawnPoint = bestSpawnPoint(players, spawnPoints, realData.roomId);
        var player = {
          clientId: clientId++,
          x: spawnPoint.x,
          y: spawnPoint.y,
          A: 0,
          N: 0,
          speed: 10,
          health: 100,
          kills: 0,
          roomId: realData.roomId,
          username: realData.username,
          ws: ws,
          bot: null,
          skin: realData.skin,
          lastHitTime: 0,
          shootingCharacteristics: getShootingCharacteristics(0),
          recoil: 0,
        };

        players[player.clientId] = player;

        //tell the player we created you
        ws.send(
          JSON.stringify({
            eventName: "created_you",
            clientId: player.clientId,
            roomId: player.roomId,
            x: player.x,
            y: player.y,
          })
        );

        //tell other players we created this guy
        var sendThis = {
          eventName: "create_player",
          clientId: player.clientId,
          roomId: player.roomId,
          x: player.x,
          y: player.y,
          username: player.username,
          skin: player.skin,
        };

        for (var i in players) {
          var otherPlayer = players[i];

          //check if same room
          if (otherPlayer.roomId != player.roomId) {
            continue;
          }

          if (otherPlayer.clientId != player.clientId) {
            if (otherPlayer.ws) {
              otherPlayer.ws.send(JSON.stringify(sendThis));
            }
          }
        }

        //now tell this guy about all the other players

        for (var i in players) {
          var otherPlayer = players[i];

          //check if same room
          if (otherPlayer.roomId != player.roomId) {
            continue;
          }

          if (otherPlayer.clientId != player.clientId) {
            ws.send(
              JSON.stringify({
                eventName: "create_player",
                clientId: otherPlayer.clientId,
                roomId: otherPlayer.roomId,
                x: otherPlayer.x,
                y: otherPlayer.y,
                username: otherPlayer.username,
                skin: otherPlayer.skin,
              })
            );
          }
        }

        break;

      case "input_state_update":
        var player = players[realData.clientId];
        if (player) {
          player.A = realData.A;
          player.N = realData.N;
        }
        break;

      case "create_bullet":
        var player = players[realData.clientId];
        if (player) {
          //recoil
          if (player.recoil > 0) {
            break;
          }

          //repeat x times
          for (var i = 0; i < player.shootingCharacteristics.spread; i++) {
            var bullet = {
              x: player.x,
              y: player.y,
              A: player.A + Math.random() * 10 - 5,
              speed: player.shootingCharacteristics.bulletSpeed,
              damage: player.shootingCharacteristics.damage,
              firedBy: player.clientId,
              roomId: player.roomId,
            };
            bullets[bulletId++] = bullet;
          }

          //recoil
          player.recoil = player.shootingCharacteristics.recoilTime;
        }
        break;

      case "ping":
        ws.send(
          JSON.stringify({
            eventName: "pong",
            T: realData.T,
          })
        );
        break;
    }
  });
});

// Start the HTTP server on port 8080 (or any other port you prefer)
server.listen(8080, () => {
  console.log("HTTP Server started on " + server.address().port);
});

console.log("The WebSocket server is running on port ");
console.log(wss.options.port);
