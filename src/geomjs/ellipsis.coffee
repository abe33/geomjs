# @toc
Point = require './point'
Equatable = require './equatable'
Formattable = require './formattable'
Geometry = require './geometry'
Surface = require './surface'
Path = require './path'

## Ellipsis
class Ellipsis
  Equatable('radius1', 'radius2', 'x', 'y', 'rotation').attachTo Ellipsis
  Formattable('Ellipsis', 'radius1', 'radius2', 'x', 'y', 'rotation')
    .attachTo Ellipsis
  Geometry.attachTo Ellipsis
  Surface.attachTo Ellipsis
  Path.attachTo Ellipsis

  ##### Ellipsis::constructor
  #
  constructor: (r1, r2, x, y, rot, segments) ->
    [@radius1, @radius2, @x, @y, @rotation, @segments] = @ellipsisFrom r1, r2,
                                                                       x, y,
                                                                       rot,
                                                                       segments

  ##### Ellipsis::center
  #
  center: -> new Point @x, @y

  #### Bounds

  ##### Ellipsis::left
  #
  left: ->
    phi = Math.degToRad @rotation
    t = Math.atan(-@radius2 * Math.tan(phi) / @radius1) + Math.PI
    @x + @radius1*Math.cos(t)*Math.cos(phi) -
         @radius2*Math.sin(t)*Math.sin(phi)

  ##### Ellipsis::right
  #
  right: ->
    phi = Math.degToRad @rotation
    t = Math.atan(-@radius2 * Math.tan(phi) / @radius1)
    @x + @radius1*Math.cos(t)*Math.cos(phi) -
         @radius2*Math.sin(t)*Math.sin(phi)

  ##### Ellipsis::bottom
  #
  bottom: ->
    phi = Math.degToRad @rotation
    t = Math.atan(@radius2 * (Math.cos(phi) / Math.sin(phi)) / @radius1)
    @y + @radius1*Math.cos(t)*Math.sin(phi) +
         @radius2*Math.sin(t)*Math.cos(phi)

  ##### Ellipsis::top
  #
  top: ->
    phi = Math.degToRad @rotation
    t = Math.atan(@radius2 * (Math.cos(phi) / Math.sin(phi)) / @radius1) + Math.PI
    @y + @radius1*Math.cos(t)*Math.sin(phi) +
         @radius2*Math.sin(t)*Math.cos(phi)

  ##### Ellipsis::bounds
  #
  # See
  # [Geometry.bounds](src_geomjs_geometry.html#geometrybounds)

  ##### Ellipsis::boundingBox
  #
  # See
  # [Geometry.boundingbox](src_geomjs_geometry.html#geometryboun

  #### Geometry API

  ##### Ellipsis::points
  #
  points: ->
    @pathPointAt n / @segments for n in [0..@segments]

  ##### Ellipsis::closedGeometry
  #
  closedGeometry: -> true

  ##### Ellipsis::pointAtAngle
  #
  pointAtAngle: (angle) ->
    center = @center()
    vec = center.add Math.cos(Math.degToRad(angle))*10000,
                     Math.sin(Math.degToRad(angle))*10000
    @intersections(points: -> [center, vec])?[0]

  ##### Ellipsis::intersects
  #
  # See
  # [Geometry.intersects](src_geomjs_geometry.html#geometryintersects)

  ##### Ellipsis::intersections
  #
  # See
  # [Geometry.intersections](src_geomjs_geometry.html#geometryintersections)

  #### Surface API

  ##### Ellipsis::acreage
  #
  acreage: -> Math.PI * @radius1 * @radius2

  ##### Ellipsis::randomPointInSurface
  #
  randomPointInSurface: (random) ->
    unless random?
      random = new chancejs.Random new chancejs.MathRandom

    pt = @pathPointAt random.get()
    center = @center()
    dif = pt.subtract center
    center.add dif.scale Math.sqrt random.random()

  ##### Ellipsis::contains
  #
  contains: (xOrPt, y) ->
    [x,y] = Point.coordsFrom xOrPt, y
    p = new Point(x,y)
    c = @center()
    d = p.subtract c
    a = d.angle()
    p2 = @pointAtAngle a
    c.distance(p2) >= c.distance(p)

  ##### Ellipsis::containsGeometry
  #
  # See
  # [Surface.containsgeometry](src_geomjs_surface.html#surfacecontainsgeometry)


  #### Path API

  ##### Ellipsis::length
  #
  length: -> Math.PI * (3*(@radius1 + @radius2) -
             Math.sqrt((3* @radius1 + @radius2) * (@radius1 + @radius2 *3)))

  ##### Ellipsis::pathPointAt
  #
  pathPointAt: (n) ->
    a = n * Math.PI * 2
    p = new Point Math.cos(a) * @radius1, Math.sin(a) * @radius2

    @center().add p.rotate(@rotation)

  ##### Circle::pathOrientationAt
  #
  # See
  # [Path.pathOrientationAt](src_geomjs_path.html#pathpathorientationat)

  ##### Ellipsis::pathTangentAt
  #
  # See
  # [Path.pathTangentAt](src_geomjs_path.html#pathpathtangentat)

  #### Drawing API

  ##### Ellipsis::stroke
  #
  # See
  # [Geometry.stroke](src_geomjs_geometry.html#geometrystroke)

  ##### Ellipsis::fill
  #
  # See
  # [Geometry.fill](src_geomjs_geometry.html#geometryfill)

  ##### Ellipsis::drawPath
  #
  drawPath: (context) ->
    context.save()
    context.translate(@x, @y)
    context.rotate(Math.degToRad @rotation)
    context.scale(@radius1, @radius2)
    context.beginPath()
    context.arc(0,0,1,0, Math.PI*2)
    context.closePath()
    context.restore()

  #### Utilities

  ##### Ellipsis::clone
  #
  clone: -> new Ellipsis this

  ##### Ellipsis::equals
  #
  # See
  # [Equatable.equals](src_geomjs_equatable.html#equatableequals)

  ##### Ellipsis::toString
  #
  # See
  # [Formattable.toString](src_geomjs_formattable.html#formattabletostring)

  ##### Ellipsis::ellipsisFrom
  #
  ellipsisFrom: (radius1, radius2, x, y, rotation, segments) ->
    if typeof radius1 is 'object'
      {radius1, radius2, x, y, rotation, segments} = radius1

    radius1 = 1 unless Point.isFloat radius1
    radius2 = 1 unless Point.isFloat radius2
    x = 0 unless Point.isFloat x
    y = 0 unless Point.isFloat y
    rotation = 0 unless Point.isFloat rotation
    segments = 36 unless Point.isFloat segments

    [radius1, radius2, x, y, rotation, segments]

module.exports = Ellipsis
