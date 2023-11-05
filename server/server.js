import express from "express";
import { createServer } from "http";
import { WebSocketServer } from "ws";
import cors from "cors";
import bodyParser from "body-parser";
import { getDatabase, ref, set, onValue, get, child } from "firebase/database";

//firebase admin init
import { initializeApp } from "firebase/app";
import { getAuth, signInWithCustomToken } from "firebase/auth";
import { getFirestore } from "firebase/firestore";
import { getAnalytics } from "firebase/analytics";

const firebaseConfig = {
  apiKey: "AIzaSyChg_UPZhxsf6uMXHNIXzDk-1b5qmodPBc",
  authDomain: "stellarclash-io.firebaseapp.com",
  projectId: "stellarclash-io",
  storageBucket: "stellarclash-io.appspot.com",
  messagingSenderId: "211010333586",
  appId: "1:211010333586:web:f9f18ed1f6d16210d22f4b",
  measurementId: "G-K4RE7HYH3M",
};

initializeApp(firebaseConfig);

const app = express();
const server = createServer(app);
const wss = new WebSocketServer({ server });

server.listen(process.env.PORT || 3000, () => {
  console.log("Server started on " + server.address().port);
});

// CORS configuration for allowing requests from your React frontend
app.use(
  cors({
    origin:
      //allow all
      "*",
  })
);

var players = {};
var bullets = {};
var seleniums = {};
var clientId = 0;
var bulletId = 0;
var seleniumId = 0;
var MAX_BOTS = 7;
var MAX_SELENIUMS = 30;
var realPlayerCount = 0;

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

const botNames = [
  "Amy",
  "Bob",
  "Cara",
  "Dino",
  "Ella",
  "Finn",
  "Gail",
  "Hugo",
  "Iris",
  "Jack",
  "Kara",
  "Liam",
  "Mila",
  "Noah",
  "Opal",
  "Pete",
  "Quinn",
  "Rhea",
  "Seth",
  "Tara",
  "Uma",
  "Vivi",
  "Walt",
  "Xena",
  "Yara",
  "Zane",
  "Elmo",
  "Brie",
  "Cleo",
  "Drake",
  "Eve",
  "Flint",
  "Grace",
  "Hank",
  "Ivy",
  "Jade",
  "Kobe",
  "Lana",
  "Mace",
  "Nina",
  "Orin",
  "Page",
  "Reed",
  "Sage",
  "Tess",
  "Ursa",
  "Vera",
  "Wade",
  "Xero",
  "Yves",
  "Zara",
  "Alto",
  "Bea",
  "Clay",
  "Drew",
  "Echo",
  "Faye",
  "Glenn",
  "Heidi",
  "Ina",
  "Joey",
  "Kai",
  "Lola",
  "Mack",
  "Nell",
  "Omar",
  "Pearl",
  "Rico",
  "Suki",
  "Tia",
  "Udon",
  "Vex",
  "Wolf",
  "Xyla",
  "Yogi",
  "Zoe",
  "Axel",
  "Blu",
  "Cruz",
  "Dawn",
  "Ed",
  "Fia",
  "Guy",
  "Hera",
  "Ian",
  "Jazz",
];
var currentBotName = 0;
//auth waiting
class authWaiter {
  constructor(ws, queueId) {
    this.ws = ws;
    this.queueId = queueId;
  }
}
var authQueue = [];
//EXPRESS STUFF
// Body parser middleware for parsing request body
app.use(bodyParser.json());

// Example API endpoint
app.get("/admin", (req, res) => {
  ///send the players dict
  res.json({
    players: players,
    seleniums: seleniums,
    maxSeleniums: MAX_SELENIUMS,
  });
});

app.post("/admin/setMaxSeleniums", (req, res) => {
  //get max seleniums from body
  var maxSeleniums = parseInt(req.body.maxSeleniums);

  if (maxSeleniums) {
    //IF ITS  A NUMBER
    if (typeof maxSeleniums == "number" && !isNaN(maxSeleniums)) {
      MAX_SELENIUMS = maxSeleniums;
    }
  }
});

app.use((req, res) => {
  // 404 handler for unmatched routes
  res.status(404).send("Not found");
});

//EXPRESS STUFF
// Body parser middleware for parsing request body
app.use(bodyParser.json());

// Example API endpoint
app.get("/admin", (req, res) => {
  ///send the players dict
  res.json({
    players: players,
    seleniums: seleniums,
    maxSeleniums: MAX_SELENIUMS,
  });
});

app.post("/admin/setMaxSeleniums", (req, res) => {
  //get max seleniums from body
  var maxSeleniums = req.body.maxSeleniums;

  console.log(typeof maxSeleniums);

  if (maxSeleniums) {
    console.log(typeof maxSeleniums);
    //IF ITS  A NUMBER
    if (typeof maxSeleniums == "number") {
      console.log("I am setting max seleniums to " + maxSeleniums);
      MAX_SELENIUMS = maxSeleniums;
    }
  }
});

app.use((req, res) => {
  // 404 handler for unmatched routes
  res.status(404).send("Not found");
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
  var level = Math.floor(level);

  //Calculate player max health
  let maxHealth = 100 + level * 10;

  // Calculate damage
  let damage = Math.min(3 + level / 2, 40);

  // Calculate bullet speed

  let bulletSpeed = Math.max(15 - level * 2, 4);
  if (level == 0) {
    bulletSpeed = 15;
  }

  // Calculate recoil time
  let recoilTime = Math.min(8 * level, 20);

  if (level == 0) {
    recoilTime = 8;
  }

  // Calculate spread - the number of bullets fired in 1 trigger
  let spread = Math.min(1 + Math.floor(level / 3), 5);

  let thrustSpeed = Math.max(8 - level, 2);

  return {
    damage: damage,
    bulletSpeed: bulletSpeed,
    recoilTime: recoilTime,
    spread: spread,
    thrustSpeed: thrustSpeed,
    maxHealth: maxHealth,
  };
}

function balanceSeleniums() {
  //get length of seleniums
  var seleniumCount = 0;
  for (var i in seleniums) {
    if (seleniums[i].value > 0.5) {
      seleniumCount++;
    }
  }

  /// console.log("max seleniums is " + MAX_SELENIUMS);
  //if there are less than MAX_SELENIUMS, create a new selenium

  if (seleniumCount < MAX_SELENIUMS) {
    // console.log(
    //   `there are ${seleniumCount} sels  but  less than ${MAX_SELENIUMS}, create a new selenium`
    // );
    var selenium = {
      seleniumId: seleniumId++,
      x: Math.random() * GAME_WIDTH,
      y: Math.random() * GAME_HEIGHT,
      value: Math.floor(Math.random() * 10) / 10 + 0.5,
      roomId: "public", ///SELENIUMS WILL ONLY EXIST in public room
      lifetime: 0,
    };

    for (var i in players) {
      if (players[i].roomId == "public") {
        if (players[i].health <= 0) {
          continue;
        }

        if (checkBulletCollision(selenium, players[i])) {
        }
        continue;
      }
    }

    //add selenium to seleniums
    seleniums[selenium.seleniumId] = selenium;

    //tell other players we created this selenium
    var sendThis = {
      eventName: "create_selenium",
      seleniumId: selenium.seleniumId,
      x: selenium.x,
      y: selenium.y,
      value: selenium.value,
    };

    for (var j in players) {
      var otherPlayer = players[j];

      //check if same room
      if (otherPlayer.roomId != selenium.roomId) {
        continue;
      }

      if (otherPlayer.ws) {
        otherPlayer.ws.send(JSON.stringify(sendThis));
      }
    }
  }
}
function maxBotsSinusoidalValue() {
  // Get the current time in milliseconds since 1970
  let now = Date.now();

  // Convert 5 minutes to milliseconds for clarity
  let fiveMinutes = 5 * 60 * 1000;

  // Calculate a sinusoidal value between -1 and 1
  let sinValue = Math.sin((2 * Math.PI * now) / fiveMinutes);

  // Convert sinusoidal value to range between 1 and 5
  let result = 4 + 2 * sinValue;

  MAX_BOTS = Math.floor(result);
  ///console.log(MAX_BOTS);
}

//console.log(sinusoidalValue()); // This will give a value between 1 and 5, oscillating every 5 minutes

//Game Loop
function gameLoop() {
  maxBotsSinusoidalValue();

  //balance seleniums
  balanceSeleniums();

  //see if seleniums are colliding with players
  for (var i in seleniums) {
    //check bullet collision but instead of bullet, use selenium
    var selenium = seleniums[i];
    selenium.lifetime++;

    if (selenium.lifetime < 20) {
      continue;
    }
    //check if selenium is colliding with player
    for (var j in players) {
      // console.log("checking selenium collision with player");
      var player = players[j];
      //check if same room
      if (player.roomId != selenium.roomId) {
        console.log("not same room of selenium and player");
        continue;
      }
      //check if player health is more than 0
      if (player.health <= 0) {
        // console.log("player health is less than 0");
        continue;
      }
      if (checkBulletCollision(selenium, player)) {
        // console.log("selenium collision");
        //delete selenium
        delete seleniums[i];

        ///add to kills
        player.kills += selenium.value / 10;

        //tell players to delete this selenium
        var sendThis = {
          eventName: "destroy_selenium",
          seleniumId: i,
        };

        for (var k in players) {
          var otherPlayer = players[k];

          //check if same room
          if (otherPlayer.roomId != selenium.roomId) {
            continue;
          }

          if (otherPlayer.ws) {
            otherPlayer.ws.send(JSON.stringify(sendThis));
          }
        }
      }
    }
  }

  //update players

  if (realPlayerCount == 0) {
    //no real players at all
    return;
  }
  for (var i in players) {
    var player = players[i];

    if (player.health <= 0) {
      continue;
    }

    //reduce recoil
    if (player.recoil > 0) {
      player.recoil--;
    }

    //health regeneration
    if (player.health < player.maxHealth && player.health > 0) {
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

        //if health is 0, skip this player
        if (otherPlayer.health <= 0) {
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
        if (closestDistance < 100 + 5 * player.kills) {
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
                lifetime: 120,
                username: player.username,
              };
              bullets[bulletId++] = bullet;
            }

            //recoil
            player.bot.recoil = player.shootingCharacteristics.recoilTime * 2;
            player.recoil = player.shootingCharacteristics.recoilTime * 2;
          }
        } else {
          //just make the bot move in the direction of the player 5 pixels
          var fakeN = 0.2 + Math.abs(Math.sin(player.kills)) / 3;
          player.x += (dx / closestDistance) * player.speed * fakeN;
          player.y += (dy / closestDistance) * player.speed * fakeN;

          //rotate the bot to face the player
          var newA =
            Math.atan2(-dy, dx) * (180 / Math.PI) + 5 * Math.random() - 2.5;
          //lerp player.A to newA
          player.A = (player.A + newA) / 2;
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

    //reduce lifetime
    bullet.lifetime--;
    //if lifetime is 0, delete this bullet
    if (bullet.lifetime <= 0) {
      delete bullets[i];
      var sendThis = {
        eventName: "destroy_bullet",
        bulletId: i,
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

      continue;
    }

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

      ///health
      if (player.health <= 0) {
        continue;
      }
      if (bullet.firedBy != player.clientId) {
        if (checkBulletCollision(bullet, player)) {
          delete bullets[i];

          var killerName = "";

          if (bullet.username) {
            killerName = bullet.username;
          }

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
              killerName: killerName,
            };

            for (var k in players) {
              var otherPlayer = players[k];

              if (otherPlayer.ws) {
                otherPlayer.ws.send(JSON.stringify(sendThis));
              }
            }

            //make some selenium here
            //make 5 big seleniums randomly around the player

            for (var k = 0; k < 5; k++) {
              var selenium = {
                seleniumId: seleniumId++,
                x: player.x + Math.random() * 60 - 30,
                y: player.y + Math.random() * 60 - 30,
                value: player.kills / 7,
                roomId: player.roomId,
              };
              //add selenium to seleniums
              seleniums[selenium.seleniumId] = selenium;

              //tell other players we created this selenium
              var sendThis = {
                eventName: "create_selenium",
                seleniumId: selenium.seleniumId,
                x: selenium.x,
                y: selenium.y,
                value: selenium.value,
              };

              for (var l in players) {
                var otherPlayer = players[l];

                //check if same room
                if (otherPlayer.roomId != selenium.roomId) {
                  continue;
                }

                if (otherPlayer.ws) {
                  otherPlayer.ws.send(JSON.stringify(sendThis));
                }
              }
            }

            //remove player from players NO MORE BC WE WANT DEAD PLAYERS TO BE ABLE TO SEE THE GAME

            if (players[player.clientId].bot) {
              delete players[player.clientId];
            }

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
  realPlayerCount = 0;
  for (var i in players) {
    var player = players[i];
    if (player.bot) {
      botCount++;
    } else {
      if (player.health > 0) {
        realPlayerCount++;
      }
    }
  }

  if (botCount < MAX_BOTS && realPlayerCount < MAX_BOTS) {
    console.log("creating a new bot");
    var spawnPoint = bestSpawnPoint(players, spawnPoints, "public");
    //for the name of the bot, 30% chance use the name from the list, 70% chance use empty string
    var botName = "";
    if (Math.random() < 0.3) {
      botName = botNames[currentBotName++];
      if (currentBotName >= botNames.length) {
        currentBotName = 0;
      }
    }

    var player = {
      clientId: clientId++,
      x: spawnPoint.x,
      y: spawnPoint.y,
      A: 0,
      N: 0,
      speed: 10,
      health: 100,
      maxHealth: 100,
      kills: Math.floor(Math.random() * 4),
      roomId: "public", ///BOTS WILL ONLY EXIST in public room
      username: botName,
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

    player.speed = player.shootingCharacteristics.thrustSpeed;
    player.maxHealth = player.shootingCharacteristics.maxHealth;

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

    if (player.health <= 0) {
      continue;
    }
    var sendThis = {
      eventName: "global_state_update",
      clientId: player.clientId,
      x: player.x,
      y: player.y,
      A: player.A,
      H: player.health,
      mH: player.maxHealth,
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
      fB: bullet.firedBy,
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
  ws.on("message", async (message) => {
    // console.log(`Received message: ${message}`);

    var realData = JSON.parse(message);

    switch (realData.eventName) {
      case "admin_auth_push":
        var uuid = realData.uuid;
        var queueId = realData.queueId;
        //check if this location has data on firebase rtdb

        //check if this location has data on firebase rtdb without nesting, by specific search
        // get a reference to the database location
        const db1 = getDatabase();
        var databaseRef = ref(db1);

        // specify the UUID key to query

        var userRef = child(databaseRef, "users/" + uuid);

        // attach a listener to retrieve the user data
        onValue(userRef, async function (snapshot) {
          var userData = snapshot.val();
          console.log(userData);
          //if this is null, then the user does not exist
          if (userData == null) {
            console.log("user does not exist");

            set(ref(db1, "users/" + uuid), {
              username: "user",
              selenium: 0,
              skin: 0,
            });
          }

          //now do the login stuff under "authenticate_me"
          //remove from queue first
          var thisWS = null;
          console.log("auth queue is");
          console.log(authQueue);
          for (let i in authQueue) {
            if (authQueue[i].queueId == queueId) {
              console.log("found the guy in the queue");
              console.log(authQueue[i]);
              thisWS = authQueue[i].ws;
              authQueue.splice(i, 1);
            }
          }
          if (thisWS == null) {
            return;
          }

          clientId++;
          console.log("some guy is trying to get authenticated");

          var sendThis = null;
          const dbRef = ref(getDatabase());
          await get(child(dbRef, `users/${uuid}`))
            .then((snapshot) => {
              if (snapshot.exists()) {
                //(snapshot.val());
                console.log("This guy is a legit user!!");

                //get the username and selenium
                var serverUsername = snapshot.val().username;

                var serverSelenium = snapshot.val().selenium;

                var serverSkin = snapshot.val().skin;

                //TODO edit this to the player dict
                sendThis = {
                  eventName: "authenticated",
                  username: serverUsername,
                  selenium: serverSelenium,
                  skin: serverSkin,
                  uuid: uuid,
                };

                console.log(sendThis);
                //send this to the client
                thisWS.send(JSON.stringify(sendThis));

                //sending this to GMS CLient
              } else {
                console.log("No data available");
                //tell the player username does not exist
              }
            })
            .catch((error) => {
              console.error(error);
              //tell the player username does not exist
              sendThis = {
                eventName: "login_fail",
                description: "Unexpected Error Occured.",
              };

              console.log(sendThis);
            });
        });

        break;
      case "authentication_queue":
        console.log("someone is trying to get in the auth queue");
        console.log(realData.queueId);
        var newWaiter = new authWaiter(ws, realData.queueId);
        authQueue.push(newWaiter);
        console.log(authQueue);
        break;

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
          maxHealth: 100,
          kills: 0,
          roomId: realData.roomId,
          username: realData.username,
          ws: ws,
          bot: null,
          skin: realData.skin,
          lastHitTime: 0,
          shootingCharacteristics: getShootingCharacteristics(0),
          recoil: 0,
          uuid: realData.uuid,
        };
        console.log("player sub uuid is ");
        console.log(player.uuid);

        //if uuid is empty string, set it to null
        if (player.uuid == "") {
          player.uuid = null;
        } else {
          console.log("player sub uuid is ");
          console.log(player.uuid);
          //update it on firebse under users/uuid/username
          const db = getDatabase();
          //check if this location exists
          var databaseRef = ref(db);
          var userRef = child(databaseRef, "users/" + player.uuid);

          // attach a listener to retrieve the user data

          onValue(userRef, function (snapshot) {
            var userData = snapshot.val();
            console.log("snapshot is");
            console.log(snapshot);

            //if this is null, then the user does not exist
            if (userData == null) {
              console.log("user does not exist");
            } else {
              //if this user exists, then update the username
              set(
                ref(db, "users/" + player.uuid + "/username"),
                player.username
              );
            }
          });
        }

        players[player.clientId] = player;

        player.speed = player.shootingCharacteristics.thrustSpeed;
        player.maxHealth = player.shootingCharacteristics.maxHealth;

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

        //tell this player about all the existing seleniums
        for (var i in seleniums) {
          var selenium = seleniums[i];

          //check if same room
          if (selenium.roomId != player.roomId) {
            continue;
          }

          ws.send(
            JSON.stringify({
              eventName: "create_selenium",
              seleniumId: selenium.seleniumId,
              x: selenium.x,
              y: selenium.y,
              value: selenium.value,
            })
          );
        }

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

          //health check
          if (otherPlayer.health <= 0) {
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

          //if player health
          if (player.health <= 0) {
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
              lifetime: 120,
              username: player.username,
            };
            bullets[bulletId++] = bullet;
          }

          //recoil
          player.recoil = player.shootingCharacteristics.recoilTime;

          //tell this player about the recoil state
          ws.send(
            JSON.stringify({
              eventName: "recoil_state_update",
              recoil: player.recoil,
              maxRecoil: player.shootingCharacteristics.recoilTime,
            })
          );
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

  //ws on close
  ws.on("close", () => {
    //go to players and check if there is a player with this ws and remove it if health is 0

    for (var i in players) {
      var player = players[i];

      if (player.ws == ws) {
        //if health is 0, remove this player
        if (player.health <= 0) {
          //get players uuid if it exists
          var uuid = player.uuid;
          //update users/uuid/selenium to += player.kills

          if (uuid != null) {
            const db = getDatabase();
            //check if this location exists
            var databaseRef = ref(db);
            var userRef = child(databaseRef, "users/" + uuid);

            // attach a listener to retrieve the user data

            onValue(userRef, function (snapshot) {
              var userData = snapshot.val();
              console.log("snapshot is");
              console.log(snapshot);

              //if this is null, then the user does not exist
              if (userData == null) {
                console.log("user does not exist");
              } else {
                //if this user exists, then update the username
                set(
                  ref(db, "users/" + uuid + "/selenium"),
                  userData.selenium + player.kills
                );
              }
            });
          }

          delete players[i];

          //tell other players to remove this player
          var sendThis = {
            eventName: "destroy_player",
            clientId: player.clientId,
          };

          for (var j in players) {
            var otherPlayer = players[j];

            if (otherPlayer.ws) {
              otherPlayer.ws.send(JSON.stringify(sendThis));
            }
          }
        }
      }
    }
  });
});
