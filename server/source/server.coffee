PORT = 1337
config = require './config.js'
io = require("socket.io").listen(PORT)
io.sockets.on "connection", (socket) ->
  socket.emit "settings", config

console.log "listening to port #{PORT}"
