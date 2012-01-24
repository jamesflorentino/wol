@Wol

width = 126
height = 86
offsetX = 63
offsetY = 22


class Wol.Views.HexTile extends Wol.Views.View

  init: ->
    @el     = new Bitmap @image
    @tileID = "#{@tileX}|#{@tileY}"
    @x      =
    @el.x   = width * @tileX
    @y      =
    @el.y   = (height - offsetY) * @tileY
    @width  = width
    @height = height
    @el.x += offsetX if @tileY % 2
    return

  hide: ->
    @el.visible = false
    return

  show: ->
    @el.visible = true
    return
