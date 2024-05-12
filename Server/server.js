const express = require("express");
const app = express();
const path = require("path");
const createserver = require("http");
const createServer = createserver.createServer;
const cookie = require("cookie-parser");
var jwt = require("jsonwebtoken");
const socket = require("socket.io");
const SocketServer = socket.Server;
const bodyParser = require("body-parser");
const dotenv = require("dotenv");
const connectDb = require("./config/database");
const cors = require("cors");
app.use(cookie());
dotenv.config();
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(express.json());
// app.use(cors({
//   origin: "*", // Allow requests from any origin
//   methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"], // Add all the request methods you want to allow
//   credentials: true
// }));
app.use(
  cors({
    origin: "http://localhost:3000",
    credentials: true,
  })
);
connectDb();
const server = createServer(app);
const io = new SocketServer(server, {
  cors: {
    origin: "http://localhost:3000",
    credentials: true,
  },
});
const userSockets = {};

io.on("connection", (socket) => {
  console.log("User Connected", socket.id);

  // Setup event: Join room and acknowledge connection
  socket.on("firstConnetction", (user) => {
    // Join room corresponding to user ID
    console.log("user",user);
    socket.join(user._id);
    // Store user ID and corresponding socket
    userSockets[user._id] = socket;
    // Send acknowledgement
    socket.emit("connected");
  });
  socket.on("sendMessage",sendData);
  socket.on("data",(data)=>{
     console.log("data is",data);
  })
  // Disconnect event: Remove user socket from storage
  socket.on("disconnect", () => {
    console.log("User Disconnected",socket.id);
    for (const userId in userSockets){
      if (userSockets[userId] === socket) {
        delete userSockets[userId];
        break;
      }
    }
  });
});

// Function to send data from one user to another
function sendData(senderId, receiverId, data){
    console.log("sendMessage",data);
  const receiverSocket = userSockets[receiverId];
  if (receiverSocket){
    receiverSocket.emit("data", { senderId, data });
  } else {
    console.log(`User ${receiverId} not found.`);
  }
}

//--------------------deployement------------------
const __dirname1 = path.resolve();
if (process.env.NODE_ENV === "production") {
  app.use(express.static(path.join(__dirname1, "frontend/build")));
  app.get("*", (req, res) => {
    res.sendFile(path.resolve(__dirname1, "frontend", "build", "index.html"));
  });
} else {
  app.get("/", (req, res) => {
    res.status(200).json({
      success: true,
      message: "Api Running SuccessFully",
    });
  });
}

//----------------------deployment--------------------
server.listen(process.env.PORT, () => {
  console.log("server is running on port " + process.env.PORT);
});
module.exports = app;
