@Wol

Views = Wol.Views
FrameData =
  marine: {"images": ["marine.png"], "animations": {"onDieStart": [61, 88], "onMoveStart": [1, 3], "onMove": [4, 16], "onMoveEnd": [17, 23], "onDefendStart": [52, 54], "onAttackStart": [24, 51], "all": [0, 0], "onDefendEnd": [58, 60], "onDefend": [55, 57]}, "frames": {"regX": 30, "width": 112, "regY": 80, "height": 97, "count": 89}}


Wol.Units =
  getAnimation: (frameDataName, images) ->
    frameData   = @getFrameData frameDataName, images
    spriteSheet = new SpriteSheet frameData
    animation   = new BitmapAnimation spriteSheet
    animation

  getFrameData: (frameDataName, images) ->
    frameData = FrameData[frameDataName]
    frameData.images = images
    frameData

  createUnitByType: (type) ->
    unit = null
    switch type
      when 'marine'
        unit = new Wol.Views.Marine
      else
        unit = new Wol.Views.Unit
    unit

Units = Wol.Units

class Wol.Views.Unit extends Wol.Views.View

  init: ->
    @el = new Container()
    @walkSpeed = 100

  resetCharge: ->
    @model.set charge: 0
    return

  spawn: ->
    tileX = @get 'tileX'
    tileY = @get 'tileY'
    @setTilePosition tileX, tileY
    @resetCharge()
    return

  move: (params) ->
    if params instanceof Views.HexTile
      hex = params
      @el.x = hex.x
      @el.y = hex.y
    if params instanceof Array
      @moveThroughTiles params
    return

  moveThroughTiles: (tiles) =>
    @onMoveStart()
    prevx = @el.x
    tween = Tween.get(@el)
    tiles.forEach (tile, i) =>
      tween = tween.call =>
        @el.scaleX = (if tile.x > prevx then 1 else -1)
        prevx = tile.x
        @onMove()
        return
      tween = tween.to({x:tile.x, y:tile.y}, @walkSpeed)
      @setTilePosition tile.tileX, tile.tileY

      return
    tween = tween.call => @onMoveEnd()
    return

  flip: (facing) ->
    @el.scaleX = (if facing is 'left' then -1 else 1)
    return

  setTilePosition: (tileX, tileY) ->
    @set tileX: tileX, tileY: tileY
    @el.index = tileX + tileY
    return

  onMove: -> @trigger 'move'
  onMoveStart: -> return
  onMoveEnd: -> @trigger 'moveEnd'
  onSpawn: -> return


class Wol.Views.AnimatedUnit extends Wol.Views.Unit

  init: ->
    super()
    @setAnimation()
    @setAnimationEvents()
    @onSpawn()
    return

  setAnimation: ->
    @animation  = Units.getAnimation @frameDataName, @images
    @el.addChild @animation
    @animation.gotoAndStop 0
    return



class Wol.Views.Marine extends Wol.Views.AnimatedUnit

  setAnimation: ->
    @walkSpeed = 600
    @frameDataName = 'marine'
    @images = [
      Wol.getAsset 'marine'
    ]
    super()

  setAnimationEvents: ->
    @animation.onAnimationEnd = (a, name) ->
      switch name
        when 'onMoveStart' then a.gotoAndPlay 'onMove'
        when 'onMove'      then a.gotoAndPlay 'onMove'
      return
    return

  onSpawn: ->
    @animation.gotoAndStop 0

  onMoveStart: ->
    @animation.gotoAndPlay 'onMoveStart'
    super()

  onMoveEnd: ->
    @animation.gotoAndPlay 'onMoveEnd'
    super()
    return

