

class Point
  @isPoint: (pt) -> pt? and pt.x? and pt.y?
  @isFloat = (n) -> typeof n is 'number' or not isNaN parseFloat n

  @polar: (angle, length=1) -> new Point Math.sin(angle) * length,
                                         Math.cos(angle) * length

  @interpolate: () ->
    args = []; args[i] = v for v,i in arguments

    if typeof args[0] is 'object' then pt1 = args.shift()
    else if @isFloat(args[0]) and @isFloat(args[1])
      pt1 = new Point args[0], args[1]
      args.splice 0, 2
    else @pointNotFound(args, 'first')

    if typeof args[0] is 'object' then pt2 = args.shift()
    else if @isFloat(args[0]) and @isFloat(args[1])
      pt2 = new Point args[0], args[1]
      args.splice 0, 2
    else @pointNotFound(args, 'second')

    pos = parseFloat args.shift()
    @missingPosition pos if isNaN pos

    dif = pt2.subtract(pt1)
    new Point pt1.x + dif.x * pos,
              pt1.y + dif.y * pos

  @missingPosition: (pos) ->
    throw new Error "Point.interpolate require a position but #{pos} was given"
  @pointNotFound: (args, pos) ->
    throw new Error "Can't find the #{pos} point in Point.interpolate arguments #{args}"

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

  paste: (x, y) ->
    [x,y] = @coordsFrom x, y
    @x = x if typeof x is 'number'
    @y = y if typeof y is 'number'
    this

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
