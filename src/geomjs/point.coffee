
class Point
  @isPoint: (o) -> o? and o.x? and o.y?

  constructor: (x, y) ->
    [x,y] = @coordsFrom x, y
    [@x,@y] = @defaultToZero x, y

  length: -> Math.sqrt (@x * @x) + (@y * @y)

  add: (x, y) ->
    [x,y] = @coordsFrom x, y
    [x,y] = @defaultToZero x, y
    new Point @x + x, @y + y

  subtract: (x, y) ->
    [x,y] = @coordsFrom x, y
    [x,y] = @defaultToZero x, y
    new Point @x - x, @y - y

  coordsFrom: (x, y, strict=false) ->
    if typeof x is 'object'
      @notAPoint x if strict and not @isPoint x
      {x,y} = x if x?

    x = parseInt x if typeof x is 'string'
    y = parseInt y if typeof y is 'string'

    [x,y]

  defaultToZero: (x,y) ->
    x = if isNaN x then 0 else x
    y = if isNaN y then 0 else y
    [x,y]

  isPoint: (o) -> Point.isPoint o

  notAPoint: (pt) -> throw new Error "#{pt} isn't a point-like object"

module.exports = Point
