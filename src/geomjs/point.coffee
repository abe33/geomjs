class Point
  @isPoint: (pt) -> pt? and pt.x? and pt.y?
  @isFloat = (n) -> not isNaN parseFloat n

  @polar: (angle, length=1) -> new Point Math.sin(angle) * length,
                                         Math.cos(angle) * length

  @interpolate: () ->
    args = []; args[i] = v for v,i in arguments

    if @isPoint args[0] then pt1 = args.shift()
    else if @isFloat(args[0]) and @isFloat(args[1])
      pt1 = new Point args[0], args[1]
      args.splice 0, 2
    else @pointNotFound(args, 'first')

    if @isPoint args[0] then pt2 = args.shift()
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

  angle: -> Math.atan2(@y, @x) * 180 / Math.PI

  angleWith: (x, y) ->
    @noPoint 'dot' if not x? and not y?
    [x, y] = @coordsFrom x, y, true

    d = @normalize().dot new Point(x,y).normalize()

    Math.acos(Math.abs(d)) * (if d < 0 then -1 else 1) * 180 / Math.PI

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

  scale: (n) ->
    @invalidScale n unless @isFloat n
    new Point @x * n, @y * n

  rotate: (n) ->
    @invalidRotation n unless @isFloat n
    l = @length()
    a = Math.atan2(@y, @x) + n / 180 * Math.PI
    x = Math.cos(a) * l
    y = Math.sin(a) * l
    new Point x, y

  rotateAround: (x, y, a) ->
    a = y if @isPoint x
    [x, y] = @coordsFrom x, y, true

    @subtract(x,y).rotate(a).add(x,y)

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
  isFloat: (n) -> Point.isFloat n

  notAPoint: (pt) ->
    throw new Error "#{pt} isn't a point-like object"
  noPoint: (method) ->
    throw new Error "#{method} was called without arguments"
  invalidLength: (l) ->
    throw new Error "Invalid length #{l} provided"
  invalidScale: (s) ->
    throw new Error "Invalid scale #{s} provided"
  invalidRotation: (a) ->
    throw new Error "Invalid rotation #{a} provided"

  clone: -> new Point this
  toString: -> "[object Point(#{@x},#{@y})]"


module.exports = Point
