App = @GEWol


class App.Game

  el: null
  canvas: null
  assetManager: null
  config: null

  # Bitmaps
  background: null
  terrain: null

  # Containers
  hexes: null
  units: null

  # data
  hexDictionary: []
  unitDictionary: []
  unitList: []
  activeUnit: null

  constructor: (options) ->
    @el            = options.element
    @canvas        = @el.getElementsByTagName('canvas')[0]
    @canvas.width  = @el.clientWidth
    @canvas.height = @el.clientHeight

    assetManager = new App.AssetManager
    assets = App.Settings.assets
    config = App.Settings.settings
    assetManager.download assets, (e) =>
      @start()
      return

    App.assetManager = assetManager
    App.config = config

    return
 
    
  # startup functions
  start: ->
    @stage = new Stage @canvas
    @events =
      tick: =>
        @update()
        @render()
        return
    @setElements()
    @addEvents()
    @test()
    return

  setElements: ->
    background = App.assetManager.get 'background'
    terrain    = App.assetManager.get 'terrain'
    config     = App.config

    @background    = new Bitmap background
    @terrain       = new Bitmap terrain
    @hexes         = new Container
    @units         = new Container
    @userInterface = new App.ui.UserInterface

    @terrain.y     = config.terrainY

    @stage.addChild @background
    @stage.addChild @terrain
    @stage.addChild @hexes
    @stage.addChild @units

    @initUIEvents()

    @generateHexGrids()
    @moveTerrain config.terrainX, config.terrainY

    @initMouseEvents()
    @addMouseEvents()

    return

  initUIEvents: ->
    return

  initMouseEvents: ->
    @mouseEvents =
      onPress: =>
        @terrain.onMouseDown = null
        @stage.onMouseUp     = @mouseEvents.onMouseUp
        @stage.onMouseMove   = @mouseEvents.onMouseMove
        return
      onMouseUp: =>
        @stage.onMouseUp = null
        @stage.onMouseMove = null
        return
      onMouseMove: =>
        return
    return

  addMouseEvents: ->
    @terrain.onMouseDown = null
    return

  moveTerrain: (x,y) ->
    @terrain.x = @hexes.x = @units.x = x
    @terrain.y = @hexes.y = @units.y = y
    return
  

  generateHexGrids: ->
    config = App.config
    gridX = config.gridX
    gridY = config.gridY
    hexImage = App.assetManager.get 'hex'
 
    yy = 0
    while yy < gridY
      xx = 0
      while xx < gridX
        hex = new App.Hex
          tileX: xx
          tileY: yy
          bitmap: hexImage
        @hexes.addChild hex.el
        @hexDictionary["x#{xx}y#{yy}"] = hex
        xx++
      yy++
    
    hexSettings = config.tiles
    for i of hexSettings
      hexSetting = hexSettings[i]
      hex = @getHex hexSetting.x, hexSetting.y
      hex.set hexSetting
    return

  getHex: (x,y) ->
    @hexDictionary["x#{x}y#{y}"]

  addEvents: ->
    Ticker.useRAF = true
    Ticker.setFPS 30
    Ticker.addListener @events
    return

  update: ->
    return

  render: ->
    @stage.update()
    return
  
  pause: ->
    Ticker.setPaused true

  play: ->
    Ticker.setPaused false


  # ====================================================
  # MAIN API
  # ====================================================

  test: ->
    hex = @getHex 4,3
    unit = @addUnit 'marine'
    unit.move hex
    @setUnitTurn unit.id
    @pause()
    @render()
    return

  addUnit: (unitName, options) ->
    unit = @getUnitClass unitName
    unit.init()

    @units.addChild unit.el
    @unitList.push unit
    @unitDictionary[unit.id] = unit
    unit

  getUnitClass: (name) ->
    unit = new App.Marine if name.match /marine/
    unit
  
  setUnitTurn: (unitId) ->
    unit = @unitDictionary[unitId]
    @activeUnit = unit
    @userInterface.showActionMenu unit
    return

  showMoveTiles: (unitId) ->
    unit = @unitDictionary[unitId]
    hex = unit.hex
    hex.show()

