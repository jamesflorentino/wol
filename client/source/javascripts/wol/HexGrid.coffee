#= require wol/HexTile

@Wol

class Wol.Views.HexGrid extends Wol.Views.View

  init: ->
    @el = new Container
    @__list = []
    @generateTiles()
    return

  generateTiles: ->
    config  = @model.get 'config'
    columns = config.gridColumns
    rows    = config.gridRows

    rowCount = 0
    while rowCount < rows
      columnCount = 0
      while columnCount < columns
        @addTile columnCount, rowCount
        columnCount++
      rowCount++
    return

  addTile: (tileX, tileY) ->
    hex = new Wol.Views.HexTile
      tileX: tileX
      tileY: tileY
      model: @model
    @__list[hex.tileID] = hex
    @el.addChild hex.el
    return
