# @toc
Point = require './point'
Formattable = require './mixins/formattable'
Sourcable = require './mixins/sourcable'
Intersections = require './mixins/intersections'
Geometry = require './mixins/geometry'
Spline = require './mixins/spline'
Path = require './mixins/path'

## LinearSpline
class LinearSpline
  Formattable('LinearSpline').attachTo LinearSpline
  Sourcable('geomjs.LinearSpline', 'vertices', 'bias').attachTo LinearSpline
  Geometry.attachTo LinearSpline
  Path.attachTo LinearSpline
  Intersections.attachTo LinearSpline
  Spline(1).attachTo LinearSpline

  ##### LinearSpline::constructor
  #
  constructor: (vertices, bias) ->
    @initSpline vertices, bias

  #### Geometry API

  ##### LinearSpline::points
  #
  points: -> @vertices.concat()

  #### Spline API

  ##### LinearSpline::segments
  #
  segments: -> @vertices.length - 1

  ##### LinearSpline::validateVertices
  #
  validateVertices: (vertices) -> vertices.length >= 2

  #### Drawing API

  ##### LinearSpline::fill
  #
  fill: ->

  ##### LinearSpline::drawPath
  #
  drawPath: (context) ->
    points = @points()
    start = points.shift()
    context.beginPath()
    context.moveTo(start.x,start.y)
    context.lineTo(p.x,p.y) for p in points

module.exports = LinearSpline
