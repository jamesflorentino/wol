App = @GEWol

App.UIEvents =
  MOVE : 'onMove'
  ACT  : 'onAct'
  SKIP : 'onSkip'

App.ui = {}
class App.ui.TurnList
  constructor: ->
    return
  turns: ->
    return

class App.ui.ActionMenu extends Backbone.View
  initialize: ->
    @el   = $ '#actionMenu'
    @skip = @el.find '.skip'
    @move = @el.find '.move'
    @act  = @el.find '.act'
    @skip.bind 'click', => @hide()
    @move.bind 'click', => @trigger 'onMove'
    return

  show: (x, y) ->
    translate = "translate(#{x}px, #{y}px)"
    @el.css
      '-webkit-transform': translate
      '-moz-transform': translate
      '-o-transform': translate
      '-ms-transform': translate

    @el.addClass 'active'
    return

  hide: ->
    @el.removeClass()

class App.ui.UserInterface extends Backbone.View
  initialize: (options) ->
    @el = $ '#mainUi'
    @actionMenu = new App.ui.ActionMenu
    @events =
      MOVE : (e) => @trigger App.UIEvents.MOVE
      ACT  : (e) => @trigger App.UIEvents.ACT
      SKIP : (e) => @trigger App.UIEvents.SKIP

    @enableEvents()

    return

  enableEvents: ->
    @bind App.UIEvents.MOVE , @events[MOVE]
    @bind App.UIEvents.ACT  , @events[ACT]
    @bind App.UIEvents.SKIP , @events[SKIP]
    return

  disableEvents: ->
    @unbind App.UIEvents.MOVE , @events[MOVE]
    @unbind App.UIEvents.ACT  , @events[ACT]
    @unbind App.UIEvents.SKIP , @events[SKIP]
    return



  showActionMenu: (unit) ->
    @actionMenu.show unit.el.x, unit.el.y
    return

