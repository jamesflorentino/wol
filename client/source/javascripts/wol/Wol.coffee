
Array.prototype.last = -> @[@length-1]

__implement = (obj, prop) ->
  if prop instanceof Object
    obj[key] = prop[key] for key of prop
  return


@Wol =
  Models      : {}
  Collections : {}
  Views       : {}
  Events      : {}
  Ui          : {}


class Wol.Events.EventDispatcher

  bind: (name, callback) ->
    @e or= {}
    @e[name] or= []
    @e[name].push callback
    return

  unbind: (name, callback) ->
    return if !@e
    if arguments.length is 0
      @e = {}
      return

    return if !@e[name]

    if !callback
      delete @e[name]
      return

    index = @e[name].indexOf callback
    @e[name].splice index, 1
    return

  trigger: (name, data) ->
    return if !@e
    return if !@e[name]
    @e[name].forEach (event) ->
      event data if event?


class Wol.Models.Model extends Wol.Events.EventDispatcher
  
  constructor: (options) ->
    @attributes = {}
    __implement(@attributes, options) if options?
    @init options

  init: (options) ->
    return

  set: (props) ->
    __implement(@attributes, props)
    return

  get: (name) ->
    @attributes or= {}
    @attributes[name]


class Wol.Views.View extends Wol.Events.EventDispatcher

  constructor: (options) ->
    __implement this, options
    @init options

  set: (props) ->
    @model or= new Wol.Models.Model
    @model.set props
    return

  get: (name) ->
    @model or= new Wol.Models.Model
    @model.get name

  
