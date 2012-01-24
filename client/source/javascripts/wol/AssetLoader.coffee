class AssetLoader

  constructor: ->
    @__list = []
    @events =
      load: (e) => @onImageLoad e
    return

  get: (name) -> @__list[name].file if @__list[name]?

  download: (@list, @finished) ->
    @loaded = 0
    @list.forEach (item) =>
      # loading images for now
      image = new Image
      image.addEventListener 'load', @events.load
      image.src = item.url
      item.file = image
      item.type = 'image'

      @__list[item.name] = item
      return
    return

  onImageLoad: (e) ->
    @loaded++
    @finished @list if @loaded >= @list.length and @finished?
    return

@Wol.AssetLoader = AssetLoader
