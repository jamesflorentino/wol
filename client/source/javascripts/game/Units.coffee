App = @GEWol

# ========================================================
# Lemurian Marine
# ========================================================
# Usage
# - Light infantry
# - Scout and Frontal Assault
# - Can upgrade to grenades that slow down units
#
# Animations
# - onMove
# - onMoveStart
# - onMoveEnd
# - onAttackStart
# - onDieStart
# --------------------------------------------------------
class App.Marine extends App.Unit

  init: ->
    assetManager = App.assetManager
    config = App.config
    img = assetManager.get 'marine'
    data = config.units.marine.frameData
    data.images = [img]
    spriteSheet = new SpriteSheet data
    animation = new BitmapAnimation spriteSheet
    animation.onAnimationEnd = (me, animationName) =>
      switch animationName
        when 'onMove'
          me.gotoAndPlay 'onMove'
        when 'onMoveStart'
          me.gotoAndPlay 'onMove'
      return

    @animation = animation

    @el.addChild @animation
    @animation.gotoAndStop 0

    return

  onWalkStart: ->
    super()
    @animation.gotoAndPlay 'onMoveStart'
    return
  
  onWalkEnd: ->
    super()
    @animation.gotoAndPlay 'onMoveEnd'
    return
