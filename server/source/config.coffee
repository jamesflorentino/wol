randomID = (len = 10) ->
  strings = 'abcdefghijklmopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUV0123456789'
  randomStr = ''
  while len-- > -1
    index = Math.random() * strings.length
    randomStr += strings.substr index, 1
  randomStr

class Settings

  constructor: ->
    @assets = []
    @config = {}
    return

  addConfig: (key, value) ->
    @config[key] = value
    return

  addAsset: (name, url) ->
    @assets.push
      name : name
      url  : url
    return


settings = new Settings()

settings.addAsset 'background' , '/images/background.png'
settings.addAsset 'terrain'    , '/images/terrain.png'
settings.addAsset 'hex'        , '/images/hex.png'
settings.addAsset 'marine'     , '/images/marine.png'

settings.addConfig 'terrainX'    , -40
settings.addConfig 'terrainY'    , 100
settings.addConfig 'gridColumns' , 8
settings.addConfig 'gridRows'    , 8
settings.addConfig 'hexWidth'    , 126
settings.addConfig 'hexHeight'   , 86
settings.addConfig 'hexOffsetX'  , 63
settings.addConfig 'hexOffsetY'  , 22

exports.assets = settings.assets
exports.config = settings.config
