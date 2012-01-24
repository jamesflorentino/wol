#= require wol/Unit

@Wol

Events = Wol.Events
Views = Wol.Views

class Wol.Views.UnitContainer extends Wol.Views.View

  init: ->
    @el = new Container()

    @initEvents()
    @bindEvents()
    return

  initEvents: ->
    events = {}
    events[Events.SPAWN] = (e) => @onSpawn e
    @events = events

  bindEvents: ->
    @model.bind Events.SPAWN, @events[Events.SPAWN]
    return

  onSpawn: (unitModel) ->
    @units or= []
    unitId         = unitModel.get 'id'
    unitName       = unitModel.get 'name'
    unitView       = @getUnitView unitName
    @units[unitId] = unitView
    unitView.model = unitModel
    @el.addChild unitView.el
    return

  getUnitView: (unitName) ->
    switch unitName
      when 'marine'
        unit = new Views.Marine model: @model
      else
        unit = null
    unit


