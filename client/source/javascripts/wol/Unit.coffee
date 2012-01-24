@Wol

Views = Wol.Views
FrameData =
  marine: {"images": ["marine.png"], "animations": {"onDieStart": [61, 88], "onMoveStart": [1, 3], "onMove": [4, 16], "onMoveEnd": [17, 23], "onDefendStart": [52, 54], "onAttackStart": [24, 51], "all": [0, 0], "onDefendEnd": [58, 60], "onDefend": [55, 57]}, "frames": {"regX": 60, "width": 112, "regY": 22, "height": 97, "count": 89}}


Wol.Views.createUnitByType = (unitType) ->
  switch unitType
    when 'marine' then unit = new Views.Marine
    else unit = null
  unit

class Wol.Views.Unit extends Wol.Views.View

  init: ->
    @el = new Container()
    return

  move: (hex) ->
    @el.x = hex.x
    @el.y = hex.y
    return


class Wol.Views.Marine extends Wol.Views.Unit

  init: ->
    super()
    image     = @model.getAsset 'marine'
    frameData = FrameData.marine
    frameData.images = [image]

    spriteSheet = new SpriteSheet frameData
    @animation  = new BitmapAnimation spriteSheet
    @el.addChild @animation
    @animation.gotoAndStop 0
    return
 

