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

## CubicBezier
class CubicBezier
  include([
    Formattable('CubicBezier')
    Sourcable('geomjs.CubicBezier', 'vertices', 'bias')
    Geometry
    Path
    Intersections
    Spline(3)
  ]).in CubicBezier

  ##### CubicBezier::constructor
  #
  constructor: (vertices, bias=20) ->
    @initSpline vertices, bias

  ##### CubicBezier::pointInSegment
  #
  pointInSegment: (t, seg) ->
    pt = new Point()
    pt.x = (seg[0].x * @b1 (t)) +
           (seg[1].x * @b2 (t)) +
           (seg[2].x * @b3 (t)) +
           (seg[3].x * @b4 (t))
    pt.y = (seg[0].y * @b1 (t)) +
           (seg[1].y * @b2 (t)) +
           (seg[2].y * @b3 (t)) +
           (seg[3].y * @b4 (t))
    pt


  ##### CubicBezier::b1
  #
  b1: (t) -> ((1 - t) * (1 - t) * (1 - t))
  ##### CubicBezier::b2
  #
  b2: (t) -> (3 * t * (1 - t) * (1 - t))
  ##### CubicBezier::b3
  #
  b3: (t) -> (3 * t * t * (1 - t))
  ##### CubicBezier::b4
  #
  b4: (t) -> (t * t * t)

module.exports = CubicBezier
