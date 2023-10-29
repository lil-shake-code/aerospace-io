import logo from "./logo.svg";
import "./App.css";
import { Button, Typography } from "@material-ui/core";
import { useEffect, useState } from "react";

const serverURL = "http://localhost:3000";

function App() {
  const [players, setPlayers] = useState([]);

  const [realPlayerCount, setRealPlayerCount] = useState(0);
  const [botPlayerCount, setBotPlayerCount] = useState(0);

  const [currentSeleniums, setCurrentSeleniums] = useState(0);

  useEffect(() => {
    //set interval to fetch players every 5 seconds
    const interval = setInterval(() => {
      fetch(`${serverURL}/admin`)
        .then((res) => res.json())
        .then((data) => {
          // alert(JSON.stringify(data));
          var playersArray = [];
          var realPlayerCount = 0;
          var botPlayerCount = 0;
          for (let clientId in data.players) {
            playersArray.push(data.players[clientId]);

            if (data.players[clientId].bot) {
              botPlayerCount++;
            } else {
              realPlayerCount++;
            }
          }

          setRealPlayerCount(realPlayerCount);
          setBotPlayerCount(botPlayerCount);

          setPlayers(playersArray);

          //seleniums

          var seleniums = 0;
          for (let clientId in data.seleniums) {
            seleniums++;
          }

          setCurrentSeleniums(seleniums);
        });
    }, 1000);
  }, []);

  return (
    <div
      style={{
        display: "flex",
        flexDirection: "column",
        justifyContent: "center",
        alignItems: "center",
        height: "100vh",
      }}
    >
      <Typography variant="h1">This is the admin panel</Typography>
      <Typography variant="h2">Total players : {players.length} </Typography>
      <Typography variant="h2">Real players : {realPlayerCount} </Typography>
      <Typography variant="h2">Bot players : {botPlayerCount} </Typography>
      <Typography variant="h2">
        Current seleniums : {currentSeleniums}{" "}
      </Typography>
      <Button
        variant="contained"
        color="primary"
        onClick={() => {
          var maxSeleniums = prompt("Enter max seleniums");
          if (maxSeleniums) {
            fetch(`${serverURL}/admin/setMaxSeleniums`, {
              method: "POST",
              headers: {
                "Content-Type": "application/json",
              },
              body: JSON.stringify({ maxSeleniums }),
            });
          }
        }}
      >
        Set max seleniums
      </Button>
    </div>
  );
}

export default App;
