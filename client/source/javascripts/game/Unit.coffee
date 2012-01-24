App = @GEWol

randomId = ->
  s = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
  id = ""
  while id.length < 10
    id += s.substr(Math.random() * (s.length-1), 1)
  id

stat = App.StatNames

class App.Unit
  # core properties
  config: null
  assetManager: null

  constructor: (options) ->
    @offsetX = 0
    @offsetY = 0
    @id      = randomId()
    @el      = new Container
    @actions = new Array()
    @initStats()
    return

  initStats: ->
    @stats   = new App.Stats
    @stats.add stat.HEALTH, 0, 100
    @stats.add stat.ENERGY, 0 , 50
    @stats.add stat.ACTIONS, 0, 10
    @stats.add stat.CHARGE, 0, 100
    @stats.add stat.MOVE_RADIUS, 3, 3
    @stats.add stat.CHARGE_SPEED, 10, 100
    @stats.add stat.ARMOR, 0, 0
    @stats.add stat.BARRIER, 0, 0
    @stats.add stat.WALK_SPEED, 0, 1000
    return

  # =========================================
  # MAIN API
  # =========================================
  # initializes the unit
  # assigns the assetManager, and config
  init: ->
    return

  move: (hex) ->
    targetX = hex.x + @offsetX
    targetY = hex.y + @offsetY
    walkSpeed = @stats.get(stat.WALK_SPEED).val
    if !@hex
      @el.x = targetX
      @el.y = targetY
    else
      @onWalkStart()
      Tween.get(@el)
        .to({x:targetX, y:targetY}, 1000)
        .call => @onWalkEnd()
    @hex = hex
    return

  applyStats: (data) ->
    for key of data
      stat = @stats.get key
      stat.setMaxValue data[key]
    return

  onWalkStart: -> return
  onWalkEnd: -> return

