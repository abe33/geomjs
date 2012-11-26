# @toc
{include} = require './include'
Point = require './point'
Equatable = require './mixins/equatable'
Cloneable = require './mixins/cloneable'
Sourcable = require './mixins/sourcable'
Formattable = require './mixins/formattable'
Triangulable = require './mixins/triangulable'
Geometry = require './mixins/geometry'
Surface = require './mixins/surface'
Path = require './mixins/path'
Intersections = require './mixins/intersections'

## Polygon
class Polygon
  include([
    Formattable('Polygon', 'vertices')
    Sourcable('geomjs.Polygon', 'vertices')
    Cloneable
    Geometry
    Intersections
    Triangulable
    Surface
    Path
  ]).in Polygon

  #### Class Methods

  ##### Polygon.polygonFrom
  #
  @polygonFrom: (vertices) ->
    if vertices? and typeof vertices is 'object'
      isArray = Object::toString.call(vertices).indexOf('Array') isnt -1
      return vertices unless isArray
      {vertices}
    else
      vertices: null

  #### Instances Methods

  ##### Polygon::constructor
  #
  constructor: (vertices) ->
    {vertices} = @polygonFrom vertices

    @noVertices() unless vertices?
    @notEnougthVertices vertices if vertices.length < 3
    @vertices = vertices

  ##### Polygon::center
  #
  center: ->
    x = y = 0

    for vertex in @vertices
      x += vertex.x
      y += vertex.y

    x = x / @vertices.length
    y = y / @vertices.length

    new Point x, y

  #### Polygon Manipulation

  ##### Polygon::translate
  #
  translate: (x,y) ->
    {x,y} = Point.pointFrom x,y
    for vertex in @vertices
      vertex.x += x
      vertex.y += y
    this

  ##### Polygon::rotate
  #
  rotate: (rotation) ->
    center = @center()
    for vertex,i in @vertices
      @vertices[i] = vertex.rotateAround center, rotation
    this

  ##### Polygon::scale
  #
  scale: (scale) ->
    center = @center()
    for vertex,i in @vertices
      @vertices[i] = center.add vertex.subtract(center).scale(scale)
    this

  ##### Polygon::rotateAroundCenter
  #
  rotateAroundCenter: Polygon::rotate

  ##### Polygon::scaleAroundCenter
  #
  scaleAroundCenter: Polygon::scale

  #### Bounds

  ##### Polygon::top
  #
  # See
  # [Geometry.top](src_geomjs_mixins_geometry.html#geometrytop)

  ##### Polygon::bottom
  #
  # See
  # [Geometry.bottom](src_geomjs_mixins_geometry.html#geometrybottom)

  ##### Polygon::left
  #
  # See
  # [Geometry.left](src_geomjs_mixins_geometry.html#geometryleft)

  ##### Polygon::right
  #
  # See
  # [Geometry.right](src_geomjs_mixins_geometry.html#geometryright)

  ##### Polygon::bounds
  #
  # See
  # [Geometry.bounds](src_geomjs_mixins_geometry.html#geometrybounds)

  ##### Polygon::boundingBox
  #
  # See
  # [Geometry.boundingbox](src_geomjs_mixins_geometry.html#geometryboundingbox)

  #### Geometry API


  ##### Polygon::points
  #
  points: ->
    (vertex.clone() for vertex in @vertices).concat(@vertices[0].clone())

  ##### Polygon::triangles
  #
  # See
  # [Triangulable.triangles][1]
  # [1]: src_geomjs_mixins_triangulable.html#triangulabletriangles

  ##### Polygon::closedGeometry
  #
  closedGeometry: -> true

  ##### Polygon::intersects
  #
  # See
  # [Intersections.intersects][1]
  # [1]: src_geomjs_mixins_intersections.html#intersectionsintersects

  ##### Polygon::intersections
  #
  # See
  # [Intersections.intersections][1]
  # [1]: src_geomjs_mixins_intersections.html#intersectionsintersections

  ##### Polygon::pointAtAngle
  #
  pointAtAngle: (angle) ->
    center = @center()
    distance = (a,b) -> a.distance(center) - b.distance(center)
    vec = center.add Math.cos(Math.degToRad(angle))*10000,
                     Math.sin(Math.degToRad(angle))*10000
    @intersections(points: -> [center, vec])?.sort(distance)[0]

  #### Surface API

  ##### Polygon::acreage
  #
  acreage: ->
    acreage = 0
    acreage += tri.acreage() for tri in @triangles()
    acreage

  ##### Polygon::contains
  #
  contains: (x,y) ->
    return true for tri in @triangles() when tri.contains x,y
    false

  ##### Polygon::containsGeometry
  #
  # See
  # [Surface.containsgeometry][1]
  # [1]: src_geomjs_mixins_surface.html#surfacecontainsgeometry

  ##### Polygon::randomPointInSurface
  #
  randomPointInSurface: (random) ->
    unless random?
      random = new chancejs.Random new chancejs.MathRandom

    acreage = @acreage()
    triangles = @triangles()
    ratios = triangles.map (t, i) -> t.acreage() / acreage
    ratios[i] += ratios[i-1] for n,i in ratios when i > 0

    random.inArray(triangles, ratios, true).randomPointInSurface random

  #### Path API

  ##### Polygon::length
  #
  length: ->
    length = 0
    points = @points()
    for i in [1..points.length-1]
      length += points[i-1].distance(points[i])
    length

  ##### Polygon::pathPointAt
  #
  # See
  # [Path.pathPointAt](src_geomjs_mixins_geometry.html#pathpathpointat)

  ##### Polygon::pathOrientationAt
  #
  # See
  # [Path.pathOrientationAt][1]
  # [1]: src_geomjs_mixins_geometry.html#pathpathorientationat

  ##### Polygon::pathTangentAt
  #
  # See
  # [Path.pathTangentAt](src_geomjs_mixins_geometry.html#pathpathtangentat)

  #### Drawing API

  ##### Polygon::stroke
  #
  # See
  # [Geometry.stroke](src_geomjs_mixins_geometry.html#geometrystroke)

  ##### Polygon::fill
  #
  # See
  # [Geometry.fill](src_geomjs_mixins_geometry.html#geometryfill)

  ##### Polygon::drawPath
  #
  # See
  # [Geometry.drawPath](src_geomjs_mixins_geometry.html#geometrydrawpath)

  #### Memoization

  ##### Polygon::memoizationKey
  #
  memoizationKey: -> @vertices.map((pt) -> "#{pt.x},#{pt.y}").join ";"

  #### Utilities

  ##### Polygon::polygonFrom
  #
  polygonFrom: Polygon.polygonFrom

  ##### Polygon::toString
  #
  # See
  # [Formattable.toString][1]
  # [1]: src_geomjs_mixins_formattable.html#formattabletostring

  ##### Polygon::clone
  #
  # See
  # [Cloneable.clone](src_geomjs_mixins_cloneable.html#cloneableclone)

  ##### Polygon::equals
  #
  # See
  # [Equatable.equals](src_geomjs_mixins_equatable.html#equatableequals)

  #### Instance Errors Methods

  ##### Polygon::noVertices
  #
  noVertices: ->
    throw new Error 'No vertices provided to Polygon'

  ##### Polygon::notEnougthVertices
  #
  notEnougthVertices: (vertices) ->
    length = vertices.length
    throw new Error "Polygon must have at least 3 vertices, was #{length}"

module.exports = Polygon
