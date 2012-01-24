class GEWol.AssetManager

  _dictionary: []
  loaded: 0
  constructor: ->
    @events =
      load: (e) =>
        @loaded++
        @onFinished() if @loaded is @files.length
        return
      error: (e) =>
        console.log 'error'
        return
    return

  download: (files, complete) ->
    @complete = complete
    @files = files
    @files.forEach (item) =>
      
      image = new Image
      image.addEventListener 'load', @events.load
      image.addEventListener 'error', @events.error
      image.src = item.url
      item.file = image
      @_dictionary[item.name] = image
      return
    return
  
  onFinished: (files) ->
    @complete() if @complete
    
  get: (name) ->
    asset = @_dictionary[name]
    throw "asset name `#{name}` not found" if !asset
    asset
