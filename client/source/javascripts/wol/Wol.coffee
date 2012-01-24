
__implement = (target, obj) ->
  target[key] = obj[key] for key of obj
  return


@Wol =
  Models      : {}
  Collections : {}
  Views       : {}
  Events      : {}


class Wol.Models.Model
  
  constructor: (options) ->
    @attributes = {}
    @e = []
    __implement(@attributes, options) if options?
    @init options

  init: (options) ->
    return

  bind: (name, callback) ->
    @e[name] or= []
    @e[name].push callback
    return

  unbind: (name, callback) ->
    return if !@e[name]
    @e.splice @e[name].indexOf(callback)
    return

  trigger: (name, data) ->
    return if !@e[name]
    @e[name].forEach (event) ->
      event data

  set: (props) ->
    __implement(@attributes, props)
    return

  get: (name) ->
    @attributes[name]


class Wol.Views.View

  constructor: (options) ->
    __implement(this, options) if options?
    @init options

