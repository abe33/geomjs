
class Point
  @isPoint: (o) -> o? and o.x? and o.y?

  constructor: (x, y) ->
    [x,y] = @coordsFrom x, y
    @x = if isNaN x then 0 else x
    @y = if isNaN y then 0 else y

  length: -> Math.sqrt (@x * @x) + (@y * @y)

  add: (x, y) ->
    [x,y] = @coordsFrom x, y, true
    new Point @x + x, @y + y

  subtract: (x, y) ->
    [x,y] = @coordsFrom x, y, true
    new Point @x - x, @y - y

  coordsFrom: (x, y, strict=false) ->
    if typeof x is 'object'
      if strict and not @isPoint x
        throw new Error "#{x} isn't a point-like object"
      {x,y} = x

    x = parseInt x if typeof x is 'string'
    y = parseInt y if typeof y is 'string'

    [x,y]

  isPoint: (o) -> Point.isPoint o


module.exports = Point
