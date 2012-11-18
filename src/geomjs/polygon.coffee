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

  @polygonFrom: (vertices) ->
    if vertices? and typeof vertices is 'object'
      isArray = Object::toString.call(vertices).indexOf('Array') isnt -1
      return vertices unless isArray
      {vertices}
    else
      vertices: null

  constructor: (vertices) ->
    {vertices} = @polygonFrom vertices

    @noVertices() unless vertices?
    @notEnougthVertices vertices if vertices.length < 3
    @vertices = vertices

  points: -> @vertices.concat @vertices[0]

  polygonFrom: Polygon.polygonFrom

  acreage: ->
    acreage = 0
    acreage += tri.acreage() for tri in @triangles()
    acreage

  contains: (x,y) ->
    return true for tri in @triangles() when tri.contains x,y
    false

  memoizationKey: -> @vertices.map((pt) -> "#{pt.x},#{pt.y}").join ";"

  noVertices: ->
    throw new Error 'No vertices provided to Polygon'

  notEnougthVertices: (vertices) ->
    length = vertices.length
    throw new Error "Polygon must have at least 3 vertices, was #{length}"



module.exports = Polygon
