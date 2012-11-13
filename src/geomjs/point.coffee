# This file define the `Point` primitive used by various entites of geomjs.
#@toc
require './math'

Equatable = require './equatable'
Formattable = require './formattable'
Parameterizable = require './parameterizable'

## Point

# A `Point` represent a location in a two-dimensional space.
#
# A point with coordinates (0,0) can be constructed with:
#
#     new Point
#     new Point 0, 0
#     new Point x: 0, y: 0
#
# **Note:** Any functions in geomjs that accept a `Point` object also allow
# to use numbers instead, this is obviously also the case in the `Point`
# class. For more details about how to achieve the same behavior in your own
# functions please refer to the [`Point.pointFrom`](#pointcoordsfrom) method.
class Point
  Equatable('x', 'y').attachTo Point
  Formattable('Point','x', 'y').attachTo Point

  ##### Point.pointFrom
  #
  # Returns an array containing the x and y of a point according
  # to the provided arguments:
  #
  #     translate = (xOrPt, y) ->
  #       {x,y} = Point.pointFrom xOrPt, y
  #       # ...
  #
  # The first argument can be either an object or a number.
  # In the case the argument is an object, the function will
  # extract the x and y values from it. However, if the `strict`
  # argument is `true`, the function will throw an error if
  # the object does not have either x or y property:
  #
  #     Point.pointFrom x: 10            # will not throw
  #     Point.pointFrom x: 10, 0, true   # will throw
  #
  # In the case the object is incomplete or empty, and with
  # the strict mode disabled, the missing property will end
  # being set to `NaN`.
  #
  #     {x,y} = Point.pointFrom x: 10 # [10, NaN]
  #
  # Strings are allowed as arguments as well as values for
  # the x and y properties of the passed-in object:
  #
  #     {x,y} = Point.pointFrom '2.6', '5.4'
  #     {x,y} = Point.pointFrom x: '2.6', y: '5.4'
  #
  # For further examples, feel free to take a look at the
  # methods of the `Point` class.
  Parameterizable('pointFrom', x: 0, y: 0, true).attachTo Point

  #### Class Methods

  ##### Point.isPoint
  #
  # Returns `true` if the passed-in object pass the requirments
  # to be a point. Valid points are objects that possess a x and
  # a y property.
  #
  #     Point.isPoint new Point  # true
  #     Point.isPoint x: 0, y: 0 # true
  #     Point.isPoint x: 0       # false
  @isPoint: (pt) -> pt? and pt.x? and pt.y?

  ##### Point.polar
  #
  # Converts polar coordinates in cartesian coordinates.
  #
  #     Point.polar 90, 10 # [object Point(0,10)]
  @polar: (angle, length=1) -> new Point Math.sin(angle) * length,
                                         Math.cos(angle) * length

  ##### Point.interpolate
  #
  # Returns a point between `pt1` and `pt2` at a ratio corresponding to `pos`.
  #
  # The `Point.interpolate` method supports all the following forms:
  #
  #     Point.interpolate pt1, pt2, pos
  #     Point.interpolate x1, y1, pt2, pos
  #     Point.interpolate pt1, x2, y2, pos
  #     Point.interpolate x1, x2, x2, y2, pos
  @interpolate: (pt1, pt2, pos) ->
    args = []; args[i] = v for v,i in arguments

    # Utility function that extract a point from `args`
    # and removes the values it used from it.
    extract = (args, name) =>
      pt = null
      if @isPoint args[0] then pt = args.shift()
      else if Math.isFloat(args[0]) and Math.isFloat(args[1])
        pt = new Point args[0], args[1]
        args.splice 0, 2
      else @missingPoint args, name
      pt

    pt1 = extract args, 'first'
    pt2 = extract args, 'second'
    pos = parseFloat args.shift()
    @missingPosition pos if isNaN pos

    dif = pt2.subtract(pt1)
    new Point pt1.x + dif.x * pos,
              pt1.y + dif.y * pos

  #### Class Error Methods

  ##### Point.missingPosition
  #
  # Throws an error for a missing position in `Point.interpolate`.
  @missingPosition: (pos) ->
    throw new Error "Point.interpolate require a position but #{pos} was given"

  ##### Point.missingPoint
  #
  # Throws an error for a missing point in `Point.interpolate`.
  @missingPoint: (args, pos) ->
    throw new Error "Can't find the #{pos} point in Point.interpolate arguments #{args}"

  #### Instances Methods

  ##### Point::constructor
  #
  # Whatever is passed to the `Point` constructor, a valid point
  # is always returned. All invalid properties will be default to `0`.
  #
  # A point be constructed with the following forms:
  #
  #     new Point
  #     new Point 0, 0
  #     new Point x: 0, y: 0
  constructor: (xOrPt, y) ->
    {x,y} = @pointFrom xOrPt, y
    [@x,@y] = @defaultToZero x, y

  ##### Point::length
  #
  # Returns the length of the current vector represented by this point.
  #
  #     length = point.length()
  length: -> Math.sqrt (@x * @x) + (@y * @y)

  ##### Point::angle
  #
  # Returns the angle in degrees formed by the vector.
  #
  #     angle = point.angle()
  angle: -> Math.radToDeg Math.atan2 @y, @x

  ##### Point::angleWith
  #
  # Given a triangle formed by this point, the passed-in point
  # and the origin (0,0), the `Point::angleWith` method will
  # return the angle in degrees formed by the two vectors at
  # the origin.
  #
  #     point1 = new Point 10, 0
  #     point2 = new Point 10, 10
  #     angle = point1.angleWith point2
  #     # angle = 45
  angleWith: (xOrPt, y) ->
    @noPoint 'dot' if not xOrPt? and not y?
    {x,y} = @pointFrom xOrPt, y, true

    d = @normalize().dot new Point(x,y).normalize()

    Math.radToDeg Math.acos(Math.abs(d)) * (if d < 0 then -1 else 1)

  #### Point Manipulation

  ##### Point::normalize
  #
  # Returns a new point of length `length`.
  #
  #     normalized = point.normalize()
  #     normalized.length() # 1
  #
  #     normalized = point.normalize(6)
  #     normalized.length() # 6
  normalize: (length=1) ->
    @invalidLength length unless Math.isFloat length
    l = @length()
    new Point @x / l * length, @y / l * length

  ##### Point::add
  #
  # Returns a new point resulting of the addition of the
  # passed-in point to this point.
  #
  #     point = new Point 4, 4
  #     inc = point.add 1, 5
  #     inc = point.add x: 0.2
  #     inc = point.add new Point 1.8, 8
  #     # inc = [object Point(7,17)]
  add: (xOrPt, y) ->
    {x,y} = @pointFrom xOrPt, y
    [x,y] = @defaultToZero x, y
    new Point @x + x, @y + y

  ##### Point::subtract
  #
  # Returns a new point resulting of the subtraction of the
  # passed-in point to this point.
  #
  #     point = new Point 4, 4
  #     inc = point.subtract 1, 5
  #     inc = point.subtract x: 0.2
  #     inc = point.subtract new Point 1.8, 8
  #     # inc = [object Point(2,-9)]
  subtract: (xOrPt, y) ->
    {x,y} = @pointFrom xOrPt, y
    [x,y] = @defaultToZero x, y
    new Point @x - x, @y - y

  ##### Point::dot
  #
  # Returns the dot product of this point and the passed-in point.
  #
  #     dot = new Point(5,6).dot(7,8)
  #     # dot = 83
  dot: (xOrPt, y) ->
    @noPoint 'dot' if not xOrPt? and not y?
    {x,y} = @pointFrom xOrPt, y, true
    @x * x + @y * y

  ##### Point::distance
  #
  # Returns the distance between this point and the passed-in point.
  #
  #     distance = new Point(0,2).distance(2,2)
  #     # distance = 2
  distance: (xOrPt, y) ->
    @noPoint 'dot' if not xOrPt? and not y?
    {x,y} = @pointFrom xOrPt, y, true
    @subtract(x,y).length()

  ##### Point::scale
  #
  # Returns a new point which is a scaled copy of the current point.
  #
  #     point = new Point 1, 1
  #     scaled = point.scale 2
  #     # scaled = [object Point(2,2)]
  scale: (n) ->
    @invalidScale n unless Math.isFloat n
    new Point @x * n, @y * n

  ##### Point::rotate
  #
  # Returns a new point which is the result of rotating the
  # current point around the origin (0,0).
  #
  #     point = new Point 10, 0
  #     rotated = point.rotate 90
  #     # rotated = [object Point(0,10)]
  rotate: (n) ->
    @invalidRotation n unless Math.isFloat n
    l = @length()
    a = Math.atan2(@y, @x) + Math.degToRad(n)
    x = Math.cos(a) * l
    y = Math.sin(a) * l
    new Point x, y

  ##### Point::rotateAround
  #
  # Returns a new point which is the result of rotating the
  # current point around the passed-in point.
  #
  #     point = new Point 10, 0
  #     origin = new Point 20, 0
  #     rotated = point.rotateAround origin, 90
  #     # rotated = [object Point(20, -10)]
  rotateAround: (xOrPt, y, a) ->
    a = y if @isPoint xOrPt
    {x,y} = @pointFrom xOrPt, y, true

    @subtract(x,y).rotate(a).add(x,y)

  #### Utilities

  ##### Point::isPoint
  #
  # Alias the `Point.isPoint` method in instances.
  isPoint: (pt) -> Point.isPoint pt

  ##### Point::defaultToZero
  #
  # Returns the two arguments x and y in an array where arguments
  # that were `NaN` are replaced by `0`.
  defaultToZero: (x, y) ->
    x = if isNaN x then 0 else x
    y = if isNaN y then 0 else y
    [x,y]

  ##### Point::paste
  #
  # Copy the values of the passed-in point into this point.
  #
  #     point = new Point
  #     point.paste 1, 7
  #     # point = [object Point(5,7)]
  #
  #     point.paste new Point 4, 4
  #     # point = [object Point(4,4)]
  paste: (xOrPt, y) ->
    {x,y} = @pointFrom xOrPt, y
    @x = x unless isNaN x
    @y = y unless isNaN y
    this

  ##### Point::equals
  #
  # See
  # [Equatable.equals](src_geomjs_equatable.html#equatableequals)

  ##### Point::clone
  #
  # Returns a copy of the current point.
  clone: -> new Point this

  ##### Point::toString
  #
  # See
  # [Formattable.toString](src_geomjs_formattable.html#formattabletostring)

  #### Instances Error Methods

  ##### Point::noPoint
  #
  # A generic error helper used by methods that require a point argument
  # and was called without it.
  noPoint: (method) ->
    throw new Error "#{method} was called without arguments"

  ##### Point::invalidLength
  #
  # Throws an error for an invalid length in `Point::normalize` method.
  invalidLength: (l) ->
    throw new Error "Invalid length #{l} provided"

  ##### Point::invalidScale
  #
  # Throws an error for an invalid scale in `Point::scale` method.
  invalidScale: (s) ->
    throw new Error "Invalid scale #{s} provided"

  ##### Point::invalidRotation
  #
  # Throws an error for an invalid rotation in `Point::rotate`
  # and `Point::rotateAround` method.
  invalidRotation: (a) ->
    throw new Error "Invalid rotation #{a} provided"

module.exports = Point
