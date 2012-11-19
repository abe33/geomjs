# @toc
Point = require './point'
Equatable = require './mixins/equatable'
Formattable = require './mixins/formattable'
Geometry = require './mixins/geometry'
Surface = require './mixins/surface'
Cloneable = require './mixins/cloneable'
Memoizable = require './mixins/memoizable'
Sourcable = require './mixins/sourcable'
Path = require './mixins/path'
Intersections = require './mixins/intersections'
Parameterizable = require './mixins/parameterizable'

## Ellipsis
class Ellipsis
  Equatable('radius1', 'radius2', 'x', 'y', 'rotation').attachTo Ellipsis
  Formattable('Ellipsis', 'radius1', 'radius2', 'x', 'y', 'rotation')
    .attachTo Ellipsis
  Parameterizable('ellipsisFrom', {
    radius1: 1
    radius2: 1
    x: 0
    y: 0
    rotation: 0
    segments: 36
  }).attachTo Ellipsis
  Sourcable('geomjs.Ellipsis','radius1','radius2','x','y').attachTo Ellipsis
  Cloneable.attachTo Ellipsis
  Memoizable.attachTo Ellipsis
  Geometry.attachTo Ellipsis
  Surface.attachTo Ellipsis
  Path.attachTo Ellipsis
  Intersections.attachTo Ellipsis

  ##### Ellipsis::constructor
  #
  constructor: (r1, r2, x, y, rot, segments) ->
    {@radius1,@radius2,@x,@y,@rotation,@segments} = @ellipsisFrom r1, r2,
                                                                  x, y, rot,
                                                                  segments

  ##### Ellipsis::center
  #
  center: -> new Point @x, @y

  #### Bounds

  ##### Ellipsis::left
  #
  left: -> Math.min.apply Math, @xBounds()

  ##### Ellipsis::right
  #
  right: -> Math.max.apply Math, @xBounds()

  ##### Ellipsis::bottom
  #
  bottom: -> Math.max.apply Math, @yBounds()

  ##### Ellipsis::top
  #
  top: -> Math.min.apply Math, @yBounds()

  ##### Ellipsis::xBounds
  #
  xBounds: ->
    phi = Math.degToRad @rotation
    t = Math.atan(-@radius2 * Math.tan(phi) / @radius1)
    [t, t+Math.PI].map (t) =>
      @x + @radius1*Math.cos(t)*Math.cos(phi) -
           @radius2*Math.sin(t)*Math.sin(phi)

  ##### Ellipsis::yBounds
  #
  yBounds: ->
    phi = Math.degToRad @rotation
    t = Math.atan(@radius2 * (Math.cos(phi) / Math.sin(phi)) / @radius1)
    [t, t+Math.PI].map (t) =>
      @y + @radius1*Math.cos(t)*Math.sin(phi) +
           @radius2*Math.sin(t)*Math.cos(phi)

  ##### Ellipsis::bounds
  #
  # See
  # [Geometry.bounds](src_geomjs_mixins_geometry.html#geometrybounds)

  ##### Ellipsis::boundingBox
  #
  # See
  # [Geometry.boundingbox](src_geomjs_mixins_geometry.html#geometryboundingbox)

  #### Geometry API

  ##### Ellipsis::points
  #
  points: ->
    @pathPointAt n / @segments for n in [0..@segments]

  ##### Ellipsis::triangles
  #
  triangles: ->
    return @memoFor 'triangles' if @memoized 'triangles'

    triangles = []
    points = @points()
    center = @center()
    for i in [1..points.length-1]
      triangles.push new Triangle center, points[i-1], points[i]

    @memoize 'triangles', triangles


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
  # [Intersections.intersects](src_geomjs_mixins_intersections.html#intersectionsintersects)

  ##### Ellipsis::intersections
  #
  # See
  # [Intersections.intersections](src_geomjs_mixins_intersections.html#intersectionsintersections)

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
    p = new Point xOrPt, y
    c = @center()
    d = p.subtract c
    a = d.angle()
    p2 = @pointAtAngle a
    c.distance(p2) >= c.distance(p)

  ##### Ellipsis::containsGeometry
  #
  # See
  # [Surface.containsgeometry](src_geomjs_mixins_surface.html#surfacecontainsgeometry)


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

  ##### Ellipsis::pathOrientationAt
  #
  # See
  # [Path.pathOrientationAt](src_geomjs_mixins_path.html#pathpathorientationat)

  ##### Ellipsis::pathTangentAt
  #
  # See
  # [Path.pathTangentAt](src_geomjs_mixins_path.html#pathpathtangentat)

  #### Drawing API

  ##### Ellipsis::stroke
  #
  # See
  # [Geometry.stroke](src_geomjs_mixins_geometry.html#geometrystroke)

  ##### Ellipsis::fill
  #
  # See
  # [Geometry.fill](src_geomjs_mixins_geometry.html#geometryfill)

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

  #### Memoization

  ##### Circle::memoizationKey
  #
  memoizationKey: -> "#{@radius1};#{@radius2};#{@x};#{@y};#{@segments}"

  #### Utilities

  ##### Ellipsis::clone
  #
  # See
  # [Cloneable.clone](src_geomjs_mixins_cloneable.html#cloneableclone)

  ##### Ellipsis::equals
  #
  # See
  # [Equatable.equals](src_geomjs_mixins_equatable.html#equatableequals)

  ##### Ellipsis::toString
  #
  # See
  # [Formattable.toString](src_geomjs_mixins_formattable.html#formattabletostring)

module.exports = Ellipsis
