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
  [
    Formattable('LinearSpline')
    Sourcable('geomjs.LinearSpline', 'vertices', 'bias')
    Geometry
    Path
    Intersections
    Spline(1)
  ].forEach (mixin) -> mixin.attachTo LinearSpline

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

  ##### LinearSpline::drawVerticesConnections
  #
  drawVerticesConnections: ->

module.exports = LinearSpline
