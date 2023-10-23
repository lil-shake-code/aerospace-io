// Import necessary modules
import { createServer } from "http";
import { WebSocketServer } from "ws";

var players = {};
var bullets = {};
var clientId = 0;
var bulletId = 0;
var MAX_BOTS = 10;

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

function bestSpawnPoint(players, spawnPoints) {
  let bestPoint = null;
  let bestDistance = -Infinity; // Initialize to a very small value

  for (let i = 0; i < spawnPoints.length; i++) {
    let currentPoint = spawnPoints[i];
    let minDist = Infinity; // Initialize to a very large value

    for (let clientId in players) {
      let player = players[clientId];
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

console.log(bestSpawnPoint(players, spawnPoints));

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
  if (d < 20) {
    return true;
  }
  return false;
}

//Game Loop
function gameLoop() {
  //update players
  for (var i in players) {
    var player = players[i];
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

        player.ws.send(JSON.stringify(sendThis));
      }
      continue;
    }

    //check if bullet is colliding with player
    for (var j in players) {
      var player = players[j];
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

            otherPlayer.ws.send(JSON.stringify(sendThis));
          }

          //reduce player health
          player.health -= 10;
          //IF PLAYER DIES
          if (player.health <= 0) {
            var sendThis = {
              eventName: "destroy_player",
              clientId: player.clientId,
            };

            for (var k in players) {
              var otherPlayer = players[k];

              otherPlayer.ws.send(JSON.stringify(sendThis));
            }

            //remove player from players
            delete players[player.clientId];

            //find the player who fired the bullet and add 1 to kills
            players[bullet.firedBy].kills += 1;
          }

          break;
        }
      }
    }
  }
}
setInterval(gameLoop, 1000 / 60);

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

      otherPlayer.ws.send(JSON.stringify(sendThis));
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
    };

    for (var j in players) {
      var player = players[j];

      player.ws.send(JSON.stringify(sendThis));
    }
  }
}
setInterval(bulletStateUpdate, 1000 / 60);

// Set up an event listener for handling incoming WebSocket connections
wss.on("connection", (ws) => {
  console.log("Client connected!");

  // Set up event listeners for handling messages from clients
  ws.on("message", (message) => {
    console.log(`Received message: ${message}`);

    var realData = JSON.parse(message);

    switch (realData.eventName) {
      case "create_me":
        var spawnPoint = bestSpawnPoint(players, spawnPoints);
        var player = {
          clientId: clientId++,
          x: spawnPoint.x,
          y: spawnPoint.y,
          A: 0,
          N: 0,
          speed: 10,
          health: 100,
          kills: 0,
          roomId: "public",
          username: realData.username,
          ws: ws,
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
        };

        for (var i in players) {
          var otherPlayer = players[i];

          if (otherPlayer.clientId != player.clientId) {
            otherPlayer.ws.send(JSON.stringify(sendThis));
          }
        }

        //now tell this guy about all the other players

        for (var i in players) {
          var otherPlayer = players[i];

          if (otherPlayer.clientId != player.clientId) {
            ws.send(
              JSON.stringify({
                eventName: "create_player",
                clientId: otherPlayer.clientId,
                roomId: otherPlayer.roomId,
                x: otherPlayer.x,
                y: otherPlayer.y,
                username: otherPlayer.username,
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
          var bullet = {
            x: player.x,
            y: player.y,
            A: player.A,
            speed: 15,
            firedBy: player.clientId,
          };
          bullets[bulletId++] = bullet;
        }
        break;
    }
  });

  // Send a welcome message to the client
  //   ws.send("Welcome to the WebSocket server!");
});

// Start the HTTP server on port 8080 (or any other port you prefer)
server.listen(8080, () => {
  console.log("HTTP Server started on " + server.address().port);
});

console.log("The WebSocket server is running on port ");
console.log(wss.options.port);
