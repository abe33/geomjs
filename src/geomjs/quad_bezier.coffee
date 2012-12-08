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

## QuadBezier
class QuadBezier
  include([
    Formattable('QuadBezier')
    Sourcable('geomjs.QuadBezier', 'vertices', 'bias')
    Geometry
    Path
    Intersections
    Spline(2)
  ]).in QuadBezier

  ##### QuadBezier::constructor
  #
  constructor: (vertices, bias=20) ->
    @initSpline vertices, bias

  ##### QuadBezier::pointInSegment
  #
  pointInSegment: (t, seg) ->
    pt = new Point()
    pt.x = (seg[0].x * @b1 (t)) +
           (seg[1].x * @b2 (t)) +
           (seg[2].x * @b3 (t))
    pt.y = (seg[0].y * @b1 (t)) +
           (seg[1].y * @b2 (t)) +
           (seg[2].y * @b3 (t))
    pt


  ##### QuadBezier::b1
  #
  b1: (t) -> ((1 - t) * (1 - t) )
  ##### QuadBezier::b2
  #
  b2: (t) -> (2 * t * (1 - t))
  ##### QuadBezier::b3
  #
  b3: (t) -> (t * t)

module.exports = QuadBezier
