App = @GEWol

class App.Stats
  _stats: []

  constructor: ->
    return

  add: (name, min, max) ->
    stat = new App.Stat
      name: name
      min: min
      max: max
    @_stats[name] = stat
    stat
  
  get: (name) ->
    @_stats[name]

class App.Stat
  max: 0
  min: 0
  val: 0
  name: null
  constructor: (options) ->
    return if !options
    for key of options
      @[key] = options[key]

    @val = @max
    return

  setValue: (@value) ->
    @value = @min if @value < @min
    return

  setMaxValue: (@max) ->
    @val = @max
    return
