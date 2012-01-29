var PLAYER_MAX, PORT, Wol, grid, io, rooms, settings, units;

PORT = 1337;

Wol = require('./Wol.js');

io = require("socket.io").listen(PORT);

units = new Wol.GameUnits();

rooms = new Wol.Rooms();

settings = new Wol.Settings();

grid = new Wol.HexGrid();

PLAYER_MAX = 2;

io.set('log level', 1);

io.sockets.on("connection", function(socket) {
  var user;
  user = null;
  return socket.on('setPlayerData', function(data) {
    var ClientEvents, ServerAPI, room, roomId, roomName, userId, userName;
    room = rooms.getRoomByName(data.room);
    if (room === void 0) room = rooms.createRoom(data.room);
    if (room.users.length >= PLAYER_MAX) return;
    roomId = room.get('id');
    roomName = room.get('name');
    user = new Wol.User({
      socket: socket,
      name: data.name,
      race: data.race
    });
    userId = user.get('id');
    userName = user.get('name');
    room.addUser(user);
    grid.setMap(data.map);
    ServerAPI = {
      setPlayerData: function() {
        socket.emit('setId', {
          playerId: userId,
          message: "Your public ID is " + userId
        });
      },
      removeRoom: function() {
        rooms.deleteRoom(roomId);
      },
      spawnUnit: function(unit) {
        var player, playerId, playerName, unitName, unitStats, users;
        playerId = unit.get('playerId');
        player = room.find(playerId);
        playerName = player.get('name');
        unitName = unit.get('name');
        unitStats = unit.attributes;
        units.add(unit);
        users = room.users;
        users.forEach(function(player) {
          var playerSocket;
          playerSocket = player.get('socket');
          return playerSocket.emit('spawnUnit', {
            stats: unitStats,
            tileX: unitStats.tileX,
            tileY: unitStats.tileY
          });
        });
      },
      unitTurn: function(unit) {
        var unitId, unitName, users;
        unitId = unit.get('id');
        unitName = unit.get('name');
        users = room.users;
        users.forEach(function(player) {
          var playerSocket;
          playerSocket = player.get('socket');
          return playerSocket.emit('unitTurn', {
            id: unitId,
            message: "" + unitName + " is making his move"
          });
        });
      },
      playersReady: function() {
        var playerId, unit, users;
        users = room.users;
        users.forEach(function(player, i) {
          var playerId, playerRace, playerSocket, unitName;
          playerId = player.get('id');
          playerSocket = player.get('socket');
          playerRace = player.get('race');
          unitName = units.getDefaultUnitName(playerRace);
          return playerSocket.emit('playersReady', {
            message: "Players are ready"
          });
        });
        playerId = users[0].get('id');
        unit = units.createUnit('marine');
        unit.set({
          playerId: playerId,
          tileX: 0,
          tileY: 3
        });
        ServerAPI.spawnUnit(unit);
        playerId = users[1].get('id');
        unit = units.createUnit('marine');
        unit.set({
          playerId: playerId,
          tileX: 3,
          tileY: 3
        });
        ServerAPI.spawnUnit(unit);
        ServerAPI.unitTurn(unit);
      },
      playerJoin: function() {
        var users;
        users = room.users;
        users.forEach(function(player) {
          var playerId, playerName, playerSocket;
          playerSocket = player.get('socket');
          playerName = player.get('name');
          playerId = player.get('id');
          console.log('playerJoin', playerId);
          playerSocket.emit('playerJoin', {
            id: playerId,
            name: playerName,
            message: "" + userName + " has joined the game"
          });
          if (playerId !== userId) {
            socket.emit('playerJoin', {
              id: playerId,
              name: playerName,
              message: "" + playerName + " is waiting for battle."
            });
          }
        });
      }
    };
    ClientEvents = {
      disconnect: function() {
        var users;
        users = room.users;
        room.removeUser(user);
        users.forEach(function(player) {
          var playerSocket;
          playerSocket = player.get('socket');
          playerSocket.emit('playerLeave', {
            id: userId,
            name: userName,
            message: "" + userName + " has left the game."
          });
        });
        if (users.length === 0) ServerAPI.removeRoom();
      },
      moveUnit: function(data) {
        var points, unitId, users;
        unitId = data.id;
        points = data.points;
        users = room.users;
        users.forEach(function(player, id) {
          var playerSocket;
          playerSocket = player.get('socket');
          return playerSocket.emit('moveUnit', {
            id: unitId,
            points: points
          });
        });
      },
      playerReady: function() {
        var ready, users;
        ready = 0;
        users = room.users;
        user.set({
          ready: true
        });
        users.forEach(function(player, i) {
          var playerId, playerName, playerReady, playerSocket;
          playerName = player.get('name');
          playerSocket = player.get('socket');
          playerId = player.get('id');
          playerReady = player.get('ready');
          if (playerReady === true) return ready++;
        });
        if (ready === PLAYER_MAX) ServerAPI.playersReady();
      }
    };
    socket.on('disconnect', ClientEvents.disconnect);
    socket.on('playerReady', ClientEvents.playerReady);
    socket.on('moveUnit', ClientEvents.moveUnit);
    ServerAPI.setPlayerData();
    ServerAPI.playerJoin();
  });
});

console.log("listening to port " + PORT);
