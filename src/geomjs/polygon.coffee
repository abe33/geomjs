# @toc
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
  Formattable('Polygon', 'vertices').attachTo Polygon
  Sourcable('geomjs.Polygon', 'vertices').attachTo Polygon
  Cloneable.attachTo Polygon
  Geometry.attachTo Polygon
  Intersections.attachTo Polygon
  Triangulable.attachTo Polygon
  Surface.attachTo Polygon
  Path.attachTo Polygon

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

  ##### Polygon::rotateAroundCenter
  #
  rotateAroundCenter: (rotation=0) ->
    center = @center()
    for vertex,i in @vertices
      @vertices[i] = vertex.rotateAround center, rotation
    this

  ##### Polygon::scaleAroundCenter
  #
  scaleAroundCenter: (scale) ->
    center = @center()
    for vertex,i in @vertices
      @vertices[i] = center.add vertex.subtract(center).scale(scale)
    this

  #### Geometry API

  ##### Polygon::points
  #
  points: -> @vertices.concat @vertices[0]

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

  length: ->
    length = 0
    points = @points()
    for i in [1..points.length-1]
      length += points[i-1].distance(points[i])
    length

  #### Memoization

  ##### Polygon::memoizationKey
  #
  memoizationKey: -> @vertices.map((pt) -> "#{pt.x},#{pt.y}").join ";"

  #### Utilities

  ##### Polygon::polygonFrom
  #
  polygonFrom: Polygon.polygonFrom

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
