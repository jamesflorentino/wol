App = @GEWol

getIntersectHexes = (x, y, radius = 1, gap = 0) ->
  tiles = []
  i = 1 + gap

  while i < radius + 1
    list = getEast x, y, i, true
    tiles = tiles.concat list

    list = getSouthEast x, y, i, true
    tiles = tiles.concat list
      
    list = getSouthWest x, y, i, true
    tiles = tiles.concat list

    list = getWest x, y, i, true
    tiles = tiles.concat list

    list = getNorthWest x, y, i, true
    tiles = tiles.concat list

    list = getNorthEast x, y, i, true
    tiles = tiles.concat list
    i++
  tiles

getConeHexes = (x, y, radius = 1, gap = 0) ->
  tiles = []
  i = 1 + gap

  while i < radius + 1
    list = getEast x, y, i
    tiles = tiles.concat list

    list = getSouthEast x, y, i, true
    tiles = tiles.concat list
      
    list = getSouthWest x, y, i, false
    tiles = tiles.concat list

    list = getWest x, y, i, false
    tiles = tiles.concat list

    list = getNorthWest x, y, i, true
    tiles = tiles.concat list

    list = getNorthEast x, y, i
    tiles = tiles.concat list
    i++
  tiles


getLinearHexes = (x, y, radius = 1, gap = 0) ->
  tiles = []
  i = 1 + gap
  while i < radius + 1
    list = getEast x, y, i, true
    tiles = tiles.concat list

    list = getWest x, y, i, true
    tiles = tiles.concat list
    i++
  tiles

getAdjacentHexes = (x, y, radius = 1, gap = 0) ->
  tiles = []
  i = 1 + gap
  while i < radius + 1
    list = getSouthEast x, y, i
    tiles = tiles.concat list

    list = getNorthEast x, y, i
    tiles = tiles.concat list

    list = getSouthWest x, y, i
    tiles = tiles.concat list

    list = getNorthWest x, y, i
    tiles = tiles.concat list

    list = getWest x, y, i
    tiles = tiles.concat list
    
    list = getEast x, y, i
    tiles = tiles.concat list

    i++

  tiles

getEast = (x, y, radius, skipIteration) ->
  tiles = []
  i = 0
  offsetX = radius * 0.5
  offsetX = Math.floor offsetX
  while i < radius
    yy = y + i
    xx = x + radius - Math.ceil(i * 0.5)
    xx++ if y % 2 and yy % 2 is 0
    tiles.push
      x: xx
      y: yy
    i++
    break if skipIteration
  tiles

getWest = (x, y, radius, skipIteration) ->
  tiles = []
  i = 0
  offsetX = radius * 0.5
  offsetX = Math.floor offsetX
  while i < radius
    yy = y - i
    xx = x - radius + Math.floor(i * 0.5)
    xx++ if y % 2 and yy % 2 is 0
    tiles.push
      x: xx
      y: yy
    i++
    break if skipIteration
  tiles

getNorthWest = (x, y, radius, skipIteration) ->
  tiles = []
  i = 0
  offsetX = radius * 0.5
  offsetX = Math.ceil offsetX
  while i < radius
    xx = x + i - offsetX
    yy = y - radius
    xx++ if y % 2 and radius % 2
    tiles.push
      x: xx
      y: yy
    break if skipIteration
    i++

  tiles

getSouthWest = (x, y, radius, skipIteration) ->
  tiles = []
  i = 0
  offsetX = radius * 0.5
  offsetX = Math.ceil offsetX
  while i < radius
    yy = y + radius - i
    xx = x - i - offsetX + Math.ceil(i * 0.5)
    xx++ if yy % 2 is 0 and y % 2 and radius % 2
    xx-- if radius % 2 is 0 and y % 2 is 0 and yy % 2
    tiles.push
      x: xx
      y: yy
    break if skipIteration
    i++
  tiles

getNorthEast = (x, y, radius, skipIteration) ->
  tiles = []
  i = 0
  offsetX = radius * 0.5
  offsetX = Math.floor offsetX
  while i < radius
    yy = y - radius + i
    xx = x + i + offsetX - Math.floor(i * 0.5)
    xx++ if yy % 2 is 0 and y % 2 and radius % 2
    xx-- if radius % 2 is 0 and y % 2 is 0 and yy % 2
    tiles.push
      x: xx
      y: yy
    i++
    break if skipIteration
  tiles

getSouthEast = (x, y, radius, skipIteration) ->
  tiles = []
  i = 0
  offsetX = radius * 0.5
  offsetX = Math.floor offsetX
  while i < radius
    xx = x - i + offsetX
    yy = y + radius
    xx++ if y % 2 and radius % 2
    tiles.push
      x: xx
      y: yy
    i++
    break if skipIteration
  tiles

class App.Hex

  el: null
  x: 0
  y: 0

  constructor: (options) ->
    for prop of options
      @[prop] = options[prop]

    config = App.Settings.settings
    tileX = @tileX
    tileY = @tileY
    tileWidth = config.tileWidth
    tileHeight = config.tileHeight
    tileOffsetX = config.tileOffsetX
    tileOffsetY = config.tileOffsetY

    @el = new Bitmap @bitmap
    @el.x = tileX * tileWidth
    @el.y = tileY * (tileHeight - tileOffsetY)
    @el.x += tileOffsetX if tileY % 2
    @x = @el.x + tileWidth * 0.5
    @y = @el.y + tileHeight * 0.5
    @hide()
    return
  
  set: (setting) ->
    status = setting.status
    
    if status.match /hidden|empty/
      @el.visible = false
 
  show: ->
    @el.alpha = 1
    #@el.visible = true
    return

  hide: ->
    @el.alpha = .4
    #@el.visible = false
    return

  showTiles: (options) ->
    radius = options.radius
    type = options.type
    gap = options.gap
    patternMethod = getAdjacentHexes
    switch type
      when 'intersect'
        patternMethod = getIntersectHexes
      when 'conic'
        patternMethod = getConeHexes
      when 'linear'
        patternMethod = getLinearHexes
        break

    tiles = patternMethod @tileX, @tileY, radius
    tiles or []
