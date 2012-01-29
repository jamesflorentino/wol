#= require wol/Ui
#= require wol/HexTile
#= require wol/Unit
#= require wol/HexLineContainer

@Wol

Views  = Wol.Views
Events = Wol.Events
Units  = Wol.Units

@after = (ms, cb) -> setTimeout cb, ms


class Wol.Views.GameView extends Views.View


  init: ->
    return
    @el               = $ @elName
    @canvas           = @el.find('canvas')
    @canvas[0].width  = @el.width()
    @canvas[0].height = @el.height()
    @stage         = new Stage @canvas[0]
    @bindEvents()
    window.DEBUG = true
    @model.start()


  bindEvents: ->
    @model.bind Events.ASSETS     , (e) => @__onAssets e
    @model.bind Events.SPAWN_UNIT , (e) => @__onSpawnUnit e
    @model.bind Events.UNIT_TURN  , (e) => @__onUnitTurn e
    @model.bind Events.MOVE_UNIT  , (e) => @__onMoveUnit e
    @events =
      tick: (e) => @render e
    return


  setConfigurations: ->
    config           = @model.get 'config'
    @hexList         = []
    @hexContainer.y  =
    @unitContainer.y =
    @terrain.y       = config.terrainY

    @hexContainer.x  =
    @unitContainer.x =
    @terrain.x       = config.terrainX

    hexImage    = @model.getAsset 'hex'
    gridRows    = config.gridRows
    gridColumns = config.gridColumns
    rowCount    = 0

    while rowCount < gridRows
      colCount = 0
      while colCount < gridColumns
        hex = new Views.HexTile
          tileX: colCount
          tileY: rowCount
          image: hexImage
        @hexList[hex.tileID] = hex
        @hexContainer.addChild hex.el
        colCount++
      rowCount++

    Ticker.useRAF = true
    Ticker.setFPS 30
    Ticker.addListener @events

    if window.DEBUG
      @debug()
    return


  play: ->
    Ticker.setPaused false
    return

  pause: ->
    console.log 'renderer paused'
    Ticker.setPaused true
    return

  render: ->
    @stage.update()
    return









  ##################################################
  # PUBLIC API
  ##################################################

  getHex: (x, y) ->
    @hexList["#{x}|#{y}"]

  addUnit: (unit) ->
    @units or= []
    @units.push unit
    @unitContainer.addChild unit.el
    return
  
  getUnit: (unitId) ->
    selectedUnit = @units.filter (unit) ->
      return unit.get('id') is unitId
    selectedUnit[0]


  getUnitByTile: (hex) ->
    selectedUnit = @units.filter (unit) ->
      tileX = unit.get 'tileX'
      tileY = unit.get 'tileY'
      tileX is hex.tileX and tileY is hex.tileY
    
    selectedUnit[0]


  showMoveTiles: (unit) ->
    tileX = unit.get 'tileX'
    tileY = unit.get 'tileY'
    hex        = @getHex tileX, tileY
    moveRadius = unit.get 'moveRadius'
    hex.select()
    selectedTiles = []
    tiles = hex.getAdjacentHexPoints radius: moveRadius
    tiles = @getTilesByPoints tiles

    actions = @unitActive.model.get 'actions'

    @lineContainer.start (@hexContainer.x + hex.x), (@hexContainer.y + hex.y)

    tiles.forEach (tile) =>
      tile.el.onClick = =>
        # show the confirmation box.
        if tile.selected and selectedTiles.last() is tile
          @uiConfirm.show (@hexContainer.x + tile.x), (@hexContainer.y + tile.y)
          return

        # Ignore previously selected tiles.
        if selectedTiles.indexOf(tile) > -1
          return
        
        # Return if the unit's action points is depleted
        return if actions is 0

        return if @getUnitByTile(tile)

        # Check if the current tile is adjacent
        # to the last tile selected.
        lastTile = hex
        lastTile = selectedTiles.last() if selectedTiles.length > 0
        surroundingTiles = @getTilesByPoints lastTile.getAdjacentHexPoints()
        return if surroundingTiles.indexOf(tile) is -1

        # Display the tile if it passes all conditions
        selectedTiles.push(tile)
        tile.select()
        
        @lineContainer.to (@hexContainer.x + tile.x), (@hexContainer.y + tile.y)
        actions--
        return

      tile.show()

    @uiConfirm.bind 'confirm', =>
      @uiConfirm.unbind()
      @uiConfirm.hide()
      tiles.forEach (tile) -> tile.hide()
      hex.hide()
      selectedTiles = [hex].concat selectedTiles
      @moveUnit unit, selectedTiles
      return

    @uiConfirm.bind 'cancel', =>
      @lineContainer.clear()
      @lineContainer.start (@hexContainer.x + hex.x), (@hexContainer.y + hex.y)
      selectedTiles.forEach (tile) -> tile.deselect()
      actions = @unitActive.model.get 'actions'
      selectedTiles = []
      return

    @uiActions.bind 'cancel', =>
      selectedTiles = []
      @lineContainer.clear()
      @uiActions.unbind()
      @uiConfirm.unbind()
      hex.show()
      tiles.forEach (tile) -> tile.hide()
      return
    return

  showMenu: ->
    return if !@checkUser()
    unit = @unitActive
    playerId = unit.get 'playerId'
    userId = @model.user.get 'playerId'
    hex = @getHex unit.get('tileX'), unit.get('tileY')
    menuX = @hexContainer.x + hex.x
    menuY = @hexContainer.y + hex.y - 170
    @uiActions.bind 'move', =>
      @uiActions.unbind()
      @showMoveTiles @unitActive
    @uiActions.show menuX, menuY


  checkUser: ->
    unit = @unitActive
    playerId = unit.get 'playerId'
    userId = @model.user.get 'playerId'
    playerId is userId



  # -------------------------------------
  # CLIENT TO SERVER
  # -------------------------------------
  moveUnit: (unit, tiles) ->
    unitId = unit.get 'id'
    hex = @getHex unit.get('tileX'), unit.get('tileY')
    points = []
    tiles.forEach (tile) ->
      points.push
        x: tile.tileX
        y: tile.tileY
   
    if window.DEBUG
     @__onMoveUnit id: unitId, points: points

    @model.moveUnit unitId, points
    return




  # -------------------------------------
  # SERVER COMMANDS
  # -------------------------------------

  getNextTurn: ->
    units = @units
    unitTurn = null

    # to prevent the loop for going forever
    # by checking if there's a chargeSpeed value in the unit list.
    hasCharge = false
    while !unitTurn
      for unit in units
        chargeSpeed  = unit.get 'chargeSpeed'
        randomCharge = Math.random() * 2
        charge       = unit.get 'charge'

        charge += chargeSpeed + randomCharge
        charge = 100 if charge > 100

        unit.set charge: charge
        hasCharge = true if chargeSpeed > 0
        unitTurn = unit if charge is 100
        break if unitTurn
      break if !hasCharge

    if unitTurn?
      @__onUnitTurn id: unit.get 'id'
    return
  
  getTilesByPoints: (points) ->
    tiles = []
    points.forEach (point) =>
      tile = @getHex point.x, point.y
      tiles.push tile if tile?
    tiles

  debug: ->
    stats = Wol.Stats.marine()
    stats.tileX = 0
    stats.tileY = 3
    stats.id = String().randomId()
    @__onSpawnUnit stats : stats

    if 1 < 2
      stats = Wol.Stats.marine()
      stats.tileX = 3
      stats.tileY = 3
      stats.id = String().randomId()
      @__onSpawnUnit stats : stats

    @getNextTurn()
    return



  ##################################################
  # CALLBACKS
  ##################################################
    
  __onMoveUnit: (data) ->
    # note: points are coordinates. not score.
    points = data.points
    unitId = data.id
    unit = @getUnit unitId
    selectedTiles = @getTilesByPoints points
    unitActive = @unitActive
    unitActive.bind 'move', =>
      @unitContainer.sortChildren (childA, childB) ->
        childA.index - childB.index
      return
    unitActive.bind 'moveEnd', =>
      unitActive.unbind 'moveEnd'
      unitActive.resetCharge()
      @lineContainer.clear()
      @getNextTurn()
      return
    hex = selectedTiles[0]
    unit.move hex.hide()
    unit.move selectedTiles.slice 1, selectedTiles.length

    if !@checkUser()
      @lineContainer.start (@hexContainer.x + hex.x), (@hexContainer.y + hex.y)
      selectedTiles.forEach (tile) =>
        @lineContainer.to (@hexContainer.x + tile.x), (@hexContainer.y + tile.y)


  __onUnitTurn: (data) ->
    unit  = @getUnit data.id
    hex   = @getHex unit.get('tileX'), unit.get('tileY')
    hex.show()
    @unitActive = unit
    @showMenu()
    
    return


  __onSpawnUnit: (data) ->
    stats      = data.stats
    unitType   = stats.type
    tileX      = stats.tileX
    tileY      = stats.tileY
    unit       = Units.createUnitByType unitType
    unit.set stats
    unit.flip data.facing
    unit.spawn()
    unit.move @getHex(tileX, tileY)
    @addUnit unit
    return


  __onAssets: (assets) ->
    bitmapBackground = @model.getAsset 'background'
    bitmapTerrain    = @model.getAsset 'terrain'

    @background    = new Bitmap bitmapBackground
    @terrain       = new Bitmap bitmapTerrain
    @hexContainer  = new Container()
    @lineContainer = new Wol.HexLineContainer()
    @unitContainer = new Container()
    @uiActions     = new Wol.Ui.Actions()
    @uiConfirm     = new Wol.Ui.Confirm()

    
    @stage.addChild @background
    @stage.addChild @terrain
    @stage.addChild @hexContainer
    @stage.addChild @lineContainer.el
    @stage.addChild @unitContainer

    @setConfigurations()

    return

