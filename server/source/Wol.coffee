Stats = require './UnitStats.js'


#################################
__randomID = (len = 10) ->
  strings = 'abcdefghijklmopqrstuvwxyz0123456789'
  randomStr = ''
  while len-- > -1
    index = Math.random() * strings.length
    randomStr += strings.substr index, 1
  randomStr

__implement = (obj, prop) ->
  obj[key] = prop[key] for key of prop
  return











#################################
class Settings

  constructor: ->
    @assets = []
    @config = {}
    return

  addConfig: (key, value) ->
    @config[key] = value
    return

  addAsset: (name, url) ->
    @assets.push
      name : name
      url  : url
    return





#################################
class Model

  constructor: (prop) ->
    @attributes or= {}
    if prop instanceof Object
      __implement @attributes, prop
    @set id: __randomID()
    @initialize prop

  initialize: (prop) -> this

  set: (prop) ->
    __implement @attributes, prop
    return
 
  get: (name) ->
    @attributes[name]



#################################
class User extends Model

  initialize: ->
    @set id: __randomID()
    return

  set: (prop) ->
    @attributes or= {}
    __implement @attributes, prop

  
  get: (name) ->
    @attributes or= {}
    @attributes[name]














class Hex extends Model

  initialize: ->
    tileX = @get 'tileX'
    tileY = @get 'tileY'
    @tileId = "#{tileX}_#{tileY}"


















class HexGrid

  setMap: (map) ->
    switch map
      when 'mp_lemuria'
        @setGrid 8, 8
      else
        @setGrid 5, 5
    return


  setGrid: (columns, rows) ->
    @__dict = {}
    rowCount = 0
    while rowCount < rows
      columnCount = 0
      while columnCount < columns
        hex = new Hex
          tileX: columnCount
          tileY: rowCount

        @__dict[hex.tileId] = hex
        columnCount++
      rowCount++
    return
  

  getTile: (x, y) ->
    @__dict["#{x}_#{y}"]
      











#################################
class Room extends Model
  initialize: ->
    @set id: __randomID()
    @users = []
    return

  addUser: (user) ->
    return if !user
    @users.push user
    return

  removeUser: (user) ->
    index = @users.indexOf user
    @users.splice index, 1

  find: (userId) ->
    result = @users.filter (player) ->
      playerId = player.get 'id'
      return true if playerId is userId
      return false
    result[0]




#################################
class Users
  constructor: ->
    return

  add: (user) ->
    @users or= []
    @users[user.id] = user
    @trigger 'add', user.id

  remove: (user) ->
    userId = user.id
    delete @users[user.id]
    @trigger 'remove', userId






#################################
class Rooms

  constructor: -> this

  joinRoom: (userName, roomId) ->
    return if !@list
    return if !@list[roomId]
    room = @list[roomId]
    room.addUser userName, roomId
    @trigger 'joinRoom', roomId
    return

  createRoom: (roomName) ->
    @list or= []
    room = new Room name: roomName
    roomId = room.get 'id'
    @list[roomId] = room
    room

  getRoomByName: (name) ->
    for roomId of @list
      room = @list[roomId]
      roomName = room.name
      break if roomName is name
    room
 
  getRoomList: ->
    list = []
    for roomId of @list
      room = @list[roomId]
      list.push room
    list


  deleteRoom: (roomId) ->
    delete @list[roomId]





#################################







#################################
class GameUnit extends Model

  initialize: (params) -> this

  move: (tileX, tileY) ->
    @set
      tileX: tileX
      tileY: tileY
    return










#################################
class GameUnits

  constructor: -> this

  add: (unit) ->
    @units or= []
    @units.push unit

  createUnit: (name, i) ->
    stat = Stats.getStats name
    unit = new GameUnit stat
    unitName = unit.get 'name'
    unit


  getDefaultUnitName: (race) ->
    name = ''
    switch race
      when 'lemurian'
        name = 'marine'
    name




#################################
exports.Settings = Settings
exports.Users    = Users
exports.Rooms    = Rooms
exports.User     = User
exports.GameUnits = GameUnits
exports.HexGrid  = HexGrid
