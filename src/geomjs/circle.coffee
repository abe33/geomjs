# @toc
Point = require './point'
Geometry = require './geometry'
Surface = require './surface'
Path = require './path'

## Circle
class Circle
  Geometry.attachTo Circle
  Surface.attachTo Circle
  Path.attachTo Circle

  ##### Circle::constructor
  #
  constructor: (@radius=1, @x=0, @y=0, @segments=36) ->


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
  # [Geometry.intersects](src_geomjs_geometry.html#geometryintersects)

  ##### Circle::intersections
  #
  # See
  # [Geometry.intersections](src_geomjs_geometry.html#geometryintersections)

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
  pathOrientationAt: (n) ->
    p1 = @pathPointAt n - 0.01
    p2 = @pathPointAt n + 0.01
    d = p2.subtract p1

    return d.angle()

  ##### Circle::pathTangentAt
  #
  # See
  # [Path.pathTangentAt](src_geomjs_path.html#pathpathtangentat)

  ##### Drawing API

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
  equals: (o) -> o? and o.radius is @radius and o.x is @x and o.y is @y

  ##### Circle::clone
  #
  clone: -> new Circle(@radius, @x, @y, @segments)

  ##### Circle::toString
  #
  toString: -> "[object Circle(radius=#{@radius},x=#{@x},y=#{@y})]"

module.exports = Circle
