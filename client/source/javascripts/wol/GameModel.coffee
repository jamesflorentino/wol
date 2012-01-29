#= require settings
#= require wol/UnitStats
#= require wol/AssetLoader




window.DEBUG = false

@Wol
@io



randomID = (len = 10) ->
  strings = 'abcdefghijklmopqrstuvwxyz0123456789'
  randomStr = ''
  while len-- > -1
    index = Math.random() * strings.length
    randomStr += strings.substr index, 1
  randomStr
 


Array.prototype.random = ->
  index = Math.random() * (this.length - 1)
  index = Math.round index
  this[index]




String.prototype.randomId = -> randomID()



randomNames = ['James','Doris','Blaise','Chloe','Arcturus','Kerrigan']
randomRooms = ['Alabastor', 'Belial', 'Lucifer', 'Iblis', 'Morrigan']





Events = Wol.Events

Events.ASSETS        = 'assets'
Events.CONNECT       = 'connect'
Events.SET_ID        = 'setId'
Events.PLAYERS_READY = 'playersReady'
Events.PLAYER_JOIN   = "playerJoin"
Events.PLAYER_LEAVE  = "playerLeave"
Events.SPAWN_UNIT    = 'spawnUnit'
Events.UNIT_TURN     = 'unitTurn'
Events.MOVE_UNIT     = 'moveUnit'





class Wol.Models.GameModel extends Wol.Models.Model



  constructor: ->
    super()
    raceName = 'lemurian'
    userName = randomNames.random()
    roomName = randomRooms.random()
    @set config: new Wol.Settings()
    @user = new Wol.Models.Model
      race: raceName
      name: userName
      room: roomName
    @createEvents()
    return




  createEvents: ->
    @events = {}
    event = @events
    return



  ########################################
  # Public API
  ########################################

  start: ->
    @__downloadAssets()
    @socket = io.connect 'http://localhost:1337/'
    socket = @socket
    socket.on Events.CONNECT       , (e) => @__onConnect e
    socket.on Events.SET_ID        , (e) => @__onSetId e
    socket.on Events.PLAYERS_READY , (e) => @__onPlayersReady e
    socket.on Events.PLAYER_JOIN   , (e) => @__onPlayerJoin e
    socket.on Events.PLAYER_LEAVE  , (e) => @__onPlayerLeave e
    socket.on Events.SPAWN_UNIT    , (e) => @__onSpawnUnit e
    socket.on Events.UNIT_TURN     , (e) => @__onUnitTurn e
    socket.on Events.MOVE_UNIT     , (e) => @__onMoveUnit e

    @bind Events.ASSETS, => @$testData()
    return





  $testData: ->
    return if DEBUG is true
    @socket.emit 'setPlayerData',
      name : @user.get('name')
      race : @user.get('race')
      room : @user.get('room')
      map  : @get('config').map
    return






  getAsset: (name) ->
    @assetLoader.get(name)


  getUserById: (playerId) ->
    @users or= []
    user = @users.filter (user) ->
      playerId is user.get 'playerId'
    user[0]


  moveUnit: (unitId, points) ->
    @socket.emit 'moveUnit',
      id: unitId
      points: points
    return


  ########################################
  # PRIVATE METHODS
  ########################################

  __downloadAssets: ->
    assetList = Wol.AssetList
    @assetLoader = new Wol.AssetLoader
    @assetLoader.download assetList, (assets) =>
      @__onAssets assets
      return
    return




  __setPlayerReady: ->
    return






  ########################################
  # CALLBACKS
  ########################################
  __onConnect: (data) ->
    return if @connected
    @connected = true
    return



  __onSetId: (data) ->
    @user.set data
    @socket.emit 'playerReady'
    return




  __onPlayerJoin: (data) ->
    @users or= []
    @users.push new Wol.Models.Model(data)
    console.log 'playerJoin :', data, data.message
    return




  __onPlayerLeave: (data) ->
    room = @user.get 'room'
    console.log 'playerLeave :', data.message
    return




  __onPlayersReady: (data) ->
    console.log 'playersReady :', data.message
    return




  __onSpawnUnit: (data) ->
    @trigger Events.SPAWN_UNIT, data
    return



  __onUnitTurn: (data) ->
    @trigger Events.UNIT_TURN, data
    return


  __onMoveUnit: (data) ->
    @trigger Events.MOVE_UNIT, data
    return



  __onAssets: (assets) ->
    Wol.getAsset = (name) => @getAsset name
    @trigger Events.ASSETS, assets
    return








