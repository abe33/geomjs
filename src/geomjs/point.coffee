
class Point
  @isPoint: (pt) -> pt? and pt.x? and pt.y?

  constructor: (x, y) ->
    [x,y] = @coordsFrom x, y
    [@x,@y] = @defaultToZero x, y

  length: -> Math.sqrt (@x * @x) + (@y * @y)

  normalize: (length=1) ->
    @invalidLength length if isNaN parseFloat length
    l = @length()
    new Point @x / l * length, @y / l * length

  add: (x, y) ->
    [x,y] = @coordsFrom x, y
    [x,y] = @defaultToZero x, y
    new Point @x + x, @y + y

  subtract: (x, y) ->
    [x,y] = @coordsFrom x, y
    [x,y] = @defaultToZero x, y
    new Point @x - x, @y - y

  dot: (x, y) ->
    @noPoint 'dot' if not x? and not y?
    [x,y] = @coordsFrom x, y, true
    @x * x + @y * y

  distance: (x, y) ->
    @noPoint 'dot' if not x? and not y?
    [x,y] = @coordsFrom x, y, true
    @subtract(x,y).length()

  coordsFrom: (x, y, strict=false) ->
    if typeof x is 'object'
      @notAPoint x if strict and not @isPoint x
      {x,y} = x if x?

    x = parseFloat x if typeof x is 'string'
    y = parseFloat y if typeof y is 'string'

    [x,y]

  defaultToZero: (x,y) ->
    x = if isNaN x then 0 else x
    y = if isNaN y then 0 else y
    [x,y]

  isPoint: (pt) -> Point.isPoint pt

  notAPoint: (pt) -> throw new Error "#{pt} isn't a point-like object"
  noPoint: (method) -> throw new Error "#{method} was called without arguments"
  invalidLength: (l) -> throw new Error "Invalid length #{l} provided"

  clone: -> new Point this
  toString: -> "[object Point(#{@x},#{@y})]"


module.exports = Point
