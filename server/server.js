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
          username: realData.username,
          ws: ws,
        };

        players[player.clientId] = player;
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
