#= require wol/AssetLoader
#= require wol/UnitModel

randomID = (len = 10) ->
  strings = 'abcdefghijklmopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUV0123456789'
  randomStr = ''
  while len-- > -1
    index = Math.random() * strings.length
    randomStr += strings.substr index, 1
  randomStr
      
@Wol
@io

Events          = Wol.Events
Events.SETTINGS = 'onSettings'
Events.ASSETS   = 'onAssets'
Events.SPAWN    = 'onUnitSpawn'

class Wol.Models.GameModel extends Wol.Models.Model

  # Public API
  start: ->
    socket = io.connect 'http://localhost:1337/'
    socket.on 'settings' , (e) => @__onSettings e
    socket.on 'spawn'    , (e) => @__onSpawn e
    return

  getAsset: (name) -> @assetLoader.get(name)

  # Private Methods

  spawnUnit: ->
    @__onSpawn
      id: randomID()
      name: 'marine'
      tileX: 0
      tileY: 0
    return

  # Private Callbacks
  __onSettings: (settings) ->
    return if @get('config')?
    @set
      assets: settings.assets
      config: settings.config

    @trigger Events.SETTINGS, @get('config')

    assetLoader = new Wol.AssetLoader
    assetLoader.download @get('assets'), (assets) => @__onAssets assets

    @assetLoader = assetLoader
    return

  __onAssets: (assets) ->
    @set
      assets: assets
    @trigger Events.ASSETS, @get('assets')
    return

  __onSpawn: (unitData) ->
    @__units or= []
    unitModel = new Wol.Models.UnitModel unitData
    @trigger Events.SPAWN, unitModel
    return
    
  #-------------------------------------
