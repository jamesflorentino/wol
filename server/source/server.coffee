PORT = 1337

Wol       = require './Wol.js'
io        = require("socket.io").listen(PORT)

units    = new Wol.GameUnits()
rooms    = new Wol.Rooms()
settings = new Wol.Settings()
grid     = new Wol.HexGrid()


PLAYER_MAX = 2

io.set 'log level', 1
io.sockets.on "connection", (socket) ->

  user = null


  # initialize the ClientEvents if the user sends the following:
  # username, racename, roomname
  socket.on 'setPlayerData', (data) ->

    room = rooms.getRoomByName data.room
    room = rooms.createRoom(data.room) if room is undefined
    return if room.users.length >= PLAYER_MAX

    roomId   = room.get 'id'
    roomName = room.get 'name'

    user = new Wol.User
      socket   : socket
      name     : data.name
      race     : data.race

    userId   = user.get 'id'
    userName = user.get 'name'

    room.addUser user
    grid.setMap data.map


    ServerAPI =

      setPlayerData: ->
        socket.emit 'setId',
          playerId:   userId
          message:  "Your public ID is #{userId}"
        return
    

      removeRoom: ->
        rooms.deleteRoom roomId
        return


      spawnUnit: (unit) ->
        playerId     = unit.get 'playerId'
        player       = room.find playerId
        playerName   = player.get 'name'
        unitName     = unit.get 'name'
        unitStats    = unit.attributes
        
        units.add unit

        users = room.users
        users.forEach (player) ->
          playerSocket = player.get 'socket'
          playerSocket.emit 'spawnUnit',
            stats: unitStats
            tileX: unitStats.tileX
            tileY: unitStats.tileY
        return

      unitTurn: (unit) ->
        unitId = unit.get 'id'
        unitName = unit.get 'name'
        users = room.users
        users.forEach (player) ->
          playerSocket = player.get 'socket'
          playerSocket.emit 'unitTurn',
            id: unitId
            message: "#{unitName} is making his move"
        return

      playersReady: ->
        users = room.users
        users.forEach (player, i) ->
          playerId     = player.get 'id'
          playerSocket = player.get 'socket'
          playerRace   = player.get 'race'
          unitName     = units.getDefaultUnitName playerRace
          playerSocket.emit 'playersReady', message: "Players are ready"

        playerId = users[0].get 'id'
        unit = units.createUnit 'marine'
        unit.set
          playerId: playerId
          tileX: 0
          tileY: 3
        ServerAPI.spawnUnit unit
        
        playerId = users[1].get 'id'
        unit = units.createUnit 'marine'
        unit.set
          playerId: playerId
          tileX: 3
          tileY: 3
        ServerAPI.spawnUnit unit


        ServerAPI.unitTurn unit
        return


      playerJoin: ->
        users = room.users
        users.forEach (player) ->
          playerSocket = player.get 'socket'
          playerName   = player.get 'name'
          playerId     = player.get 'id'
          console.log 'playerJoin', playerId
          playerSocket.emit 'playerJoin',
            id: playerId
            name: playerName
            message: "#{userName} has joined the game"
          if playerId isnt userId
            socket.emit 'playerJoin',
              id: playerId
              name: playerName
              message: "#{playerName} is waiting for battle."
          return
        return

          



    #------------------------------------------------------
    # Client Event Listeners
    #------------------------------------------------------
    ClientEvents =
      
      disconnect: ->
        users = room.users
        room.removeUser user
        users.forEach (player) ->
          playerSocket = player.get 'socket'
          playerSocket.emit 'playerLeave',
            id      : userId
            name    : userName
            message : "#{userName} has left the game."
          return
        ServerAPI.removeRoom() if users.length is 0
        return

      moveUnit: (data) ->
        unitId = data.id
        points = data.points
        users = room.users
        users.forEach (player, id) ->
          playerSocket = player.get 'socket'
          playerSocket.emit 'moveUnit',
            id: unitId
            points: points
        return
      
      playerReady: ->
        ready = 0
        users = room.users
        user.set ready: true
        users.forEach (player, i) ->
          playerName   = player.get 'name'
          playerSocket = player.get 'socket'
          playerId     = player.get 'id'
          playerReady  = player.get 'ready'
          ready++ if playerReady is true
        ServerAPI.playersReady() if ready is PLAYER_MAX
        return

      
      
    socket.on 'disconnect'  , ClientEvents.disconnect
    socket.on 'playerReady' , ClientEvents.playerReady
    socket.on 'moveUnit'    , ClientEvents.moveUnit

    ServerAPI.setPlayerData()
    ServerAPI.playerJoin()

    return

console.log "listening to port #{PORT}"
