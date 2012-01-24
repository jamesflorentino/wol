#= require wol/HexTile
#= require wol/Unit

@Wol

Views = Wol.Views
Events = Wol.Events

class Wol.Views.GameView extends Views.View

  init: ->
    @el     = $ @elName
    @canvas = @el.find 'canvas'
    @canvas[0].width = @el.width()
    @canvas[0].height = @el.height()
    @stage  = new Stage @canvas[0]

    @initEvents()
    @bindEvents()
    @model.start()
    return

  initEvents: ->
    event = {}
    event[Events.SETTINGS] = (e) => @onSettings e
    event[Events.ASSETS]   = (e) => @onAssets e
    event[Events.SPAWN]    = (e) => @onSpawn e
    event.tick             = => @render()
    @e = event
    return

  bindEvents: ->
    @model.bind Events.SETTINGS , @e[Events.SETTINGS]
    @model.bind Events.ASSETS   , @e[Events.ASSETS]
    return

  setConfigurations: ->
    config = @model.get 'config'

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
        hex = new Wol.Views.HexTile
          tileX: colCount
          tileY: rowCount
          image: hexImage
        @hexList[hex.tileID] = hex
        @hexContainer.addChild hex.el
        colCount++
      rowCount++

    return

  render: ->
    @stage.update()
    return


  test: ->
    @model.spawnUnit()
    @render()
    return

  # Callbacks

  onSettings: (settings) ->
    return

  onAssets: (assets) ->
    bitmapBackground = @model.getAsset 'background'
    bitmapTerrain    = @model.getAsset 'terrain'

    @background    = new Bitmap bitmapBackground
    @terrain       = new Bitmap bitmapTerrain
    @hexContainer  = new Container
    @unitContainer = new Container

    @stage.addChild @background
    @stage.addChild @terrain
    @stage.addChild @hexContainer
    @stage.addChild @unitContainer

    @setConfigurations()

    @test()
    return

  onSpawn: (unitModel) ->
    @units or= []
    unitId = unitModel.get 'id'
    switch unitModel.get 'type'
      when 'marine'
        unitView = new View.Marine model: unitModel
      else unitView = new View.Unit model: unitModel

    @units[unitId] = unitView
    return

