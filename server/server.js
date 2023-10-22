// Import necessary modules
import { createServer } from "http";
import { WebSocketServer } from "ws";

var players = {};
var clientId = 0;
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

//Game Loop
function gameLoop() {
  //update
  for (var i in players) {
    var player = players[i];
    //angle is in degrees
    player.x += player.N * Math.cos((player.A * Math.PI) / 180) * player.speed;
    player.y -= player.N * Math.sin((player.A * Math.PI) / 180) * player.speed;
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
    };
    console.log(sendThis);
    for (var j in players) {
      var otherPlayer = players[j];

      otherPlayer.ws.send(JSON.stringify(sendThis));
    }
  }
}
setInterval(globalStateUpdate, 1000 / 60);

// Set up an event listener for handling incoming WebSocket connections
wss.on("connection", (ws) => {
  console.log("Client connected!");

  // Set up event listeners for handling messages from clients
  ws.on("message", (message) => {
    console.log(`Received message: ${message}`);

    var realData = JSON.parse(message);

    switch (realData.eventName) {
      case "create_me":
        var player = {
          clientId: clientId++,
          x: 100,
          y: 100,
          A: 0,
          N: 0,
          speed: 15,
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
          eventName: "created_player",
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

        break;

      case "input_state_update":
        var player = players[realData.clientId];
        if (player) {
          player.A = realData.A;
          player.N = realData.N;
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
