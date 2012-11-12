# @toc
Point = require './point'
Equatable = require './equatable'
Formattable = require './formattable'
Geometry = require './geometry'
Surface = require './surface'
Path = require './path'
Intersections = require './intersections'

## Circle
class Circle
  Equatable('x','y','radius').attachTo Circle
  Formattable('Circle','x','y','radius').attachTo Circle
  Geometry.attachTo Circle
  Surface.attachTo Circle
  Path.attachTo Circle
  Intersections.attachTo Circle

  ##### Circle.eachCircleIntersections
  #
  @eachCircleIntersections: (geom1, geom2, block, data=false) ->
    [geom1, geom2] = [geom2, geom1] if geom2.classname?() is 'Circle'
    points = geom2.points()
    length = points.length
    output = []

    for i in [0..length-2]
      sv = points[i]
      ev = points[i+1]

      intersections = Circle.lineIntersections sv, ev, geom1
      for intersection in intersections
        return if block.call this, intersection, null

  ##### Circle.lineIntersections
  #
  @lineIntersections: (a, b, circle) ->
    c = circle.center()
    out = []

    _a = (b.x - a.x) * (b.x - a.x) +
         (b.y - a.y) * (b.y - a.y)
    _b = 2 * ((b.x - a.x) * (a.x - c.x) +
              (b.y - a.y) * (a.y - c.y))
    cc = c.x * c.x +
         c.y * c.y +
         a.x * a.x +
         a.y * a.y -
         2 * (c.x * a.x + c.y * a.y) - circle.radius * circle.radius
    deter = _b * _b - 4 * _a * cc

    if deter > 0
      e = Math.sqrt deter
      u1 = ( - _b + e ) / (2 * _a )
      u2 = ( - _b - e ) / (2 * _a )
      unless ((u1 < 0 || u1 > 1) && (u2 < 0 || u2 > 1))
        if 0 <= u2 and u2 <= 1
          out.push Point.interpolate a, b, u2

        if 0 <= u1 and u1 <= 1
          out.push Point.interpolate a, b, u1

    return out

  # Registers the fast intersections iterators for the Circle class
  Intersections.iterators['Circle'] = Circle.eachCircleIntersections

  ##### Circle::constructor
  #
  constructor: (radiusOrCircle, x, y, segments) ->
    [@radius,@x,@y,@segments] = @circleFrom radiusOrCircle, x, y, segments

  ##### Circle::center
  #
  center: -> new Point @x, @y

  #### Bounds

  ##### Circle::top
  #
  top: -> @y - @radius

  ##### Circle::bottom
  #
  bottom: -> @y + @radius

  ##### Circle::left
  #
  left: -> @x - @radius

  ##### Circle::right
  #
  right: -> @x + @radius

  ##### Circle::bounds
  #
  # See
  # [Geometry.bounds](src_geomjs_geometry.html#geometrybounds)

  ##### Circle::boundingBox
  #
  # See
  # [Geometry.boundingbox](src_geomjs_geometry.html#geometryboundingbox)

  #### Geometry API

  ##### Circle::points
  #
  points: ->
    step = 360 / @segments
    @pointAtAngle n * step for n in [0..@segments]

  ##### Circle::closedGeometry
  #
  closedGeometry: -> true

  ##### Circle::intersects
  #
  # See
  # [Intersections.intersects](src_geomjs_intersections.html#intersectionsintersects)

  ##### Circle::intersections
  #
  # See
  # [Intersections.intersections](src_geomjs_intersections.html#intersectionsintersections)

  ##### Circle::pointAtAngle
  #
  pointAtAngle: (angle) ->
    new Point @x + Math.cos(Math.degToRad(angle)) * @radius,
              @y + Math.sin(Math.degToRad(angle)) * @radius

  #### Surface API

  ##### Circle::acreage
  #
  acreage: -> @radius * @radius * Math.PI


  ##### Circle::randomPointInSurface
  #
  randomPointInSurface: (random) ->
    unless random?
      random = new chancejs.Random new chancejs.MathRandom

    pt = @pointAtAngle random.random(360)
    center = @center()
    dif = pt.subtract center
    center.add dif.scale Math.sqrt random.random()

  ##### Circle::contains
  #
  contains: (xOrPt, y) ->
    [x,y] = Point.coordsFrom xOrPt, y, true

    @center().subtract(x,y).length() <= @radius

  ##### Circle::containsGeometry
  #
  # See
  # [Surface.containsgeometry](src_geomjs_surface.html#surfacecontainsgeometry)

  #### Path API

  ##### Circle::length
  #
  length: -> @radius * Math.PI * 2

  ##### Circle::pathPointAt
  #
  pathPointAt: (n) -> @pointAtAngle n * 360

  ##### Circle::pathOrientationAt
  #
  # See
  # [Path.pathOrientationAt](src_geomjs_path.html#pathpathorientationat)

  ##### Circle::pathTangentAt
  #
  # See
  # [Path.pathTangentAt](src_geomjs_path.html#pathpathtangentat)

  #### Drawing API

  ##### Circle::stroke
  #
  # See
  # [Geometry.stroke](src_geomjs_geometry.html#geometrystroke)

  ##### Circle::fill
  #
  # See
  # [Geometry.fill](src_geomjs_geometry.html#geometryfill)

  ##### Circle::drawPath
  #
  drawPath: (context) ->
    context.beginPath()
    context.arc @x, @y, @radius, 0, Math.PI * 2

  #### Utilities

  ##### Circle::equals
  #
  # See
  # [Equatable.equals](src_geomjs_equatable.html#equatableequals)

  ##### Circle::clone
  #
  clone: -> new Circle this

  ##### Circle::toString
  #
  # See
  # [Formattable.toString](src_geomjs_formattable.html#formattabletostring)

  #### Circle::circleFrom
  #
  circleFrom: (radiusOrCircle, x, y, segments) ->
    radius = radiusOrCircle

    if typeof radiusOrCircle is 'object'
      {radius, x, y, segments} = radiusOrCircle

    radius = 1 unless Point.isFloat radius
    x = 0 unless Point.isFloat x
    y = 0 unless Point.isFloat y
    segments = 36 unless Point.isFloat segments

    [radius, x, y, segments]

module.exports = Circle
