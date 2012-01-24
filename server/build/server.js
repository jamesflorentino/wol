var PORT, config, io;

PORT = 1337;

config = require('./config.js');

io = require("socket.io").listen(PORT);

io.sockets.on("connection", function(socket) {
  return socket.emit("settings", config);
});

console.log("listening to port " + PORT);
