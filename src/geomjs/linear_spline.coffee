# @toc
mixinsjs = require 'mixinsjs'

{
  Sourcable,
  Formattable,
  include
} = mixinsjs

Point = require './point'
Intersections = require './mixins/intersections'
Geometry = require './mixins/geometry'
Spline = require './mixins/spline'
Path = require './mixins/path'

## LinearSpline
class LinearSpline
  include([
    Formattable('LinearSpline')
    Sourcable('geomjs.LinearSpline', 'vertices', 'bias')
    Geometry
    Path
    Intersections
    Spline(1)
  ]).in LinearSpline

  ##### LinearSpline::constructor
  #
  constructor: (vertices, bias) ->
    @initSpline vertices, bias

  #### Geometry API

  ##### LinearSpline::points
  #
  points: -> vertex.clone() for vertex in @vertices

  #### Spline API

  ##### LinearSpline::segments
  #
  segments: -> @vertices.length - 1

  ##### LinearSpline::validateVertices
  #
  validateVertices: (vertices) -> vertices.length >= 2

  ##### LinearSpline::drawVerticesConnections
  #
  drawVerticesConnections: ->

module.exports = LinearSpline
