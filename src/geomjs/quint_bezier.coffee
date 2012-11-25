# @toc
{include} = require './include'
Point = require './point'
Formattable = require './mixins/formattable'
Sourcable = require './mixins/sourcable'
Intersections = require './mixins/intersections'
Geometry = require './mixins/geometry'
Spline = require './mixins/spline'
Path = require './mixins/path'

## QuintBezier
class QuintBezier
  include([
    Formattable('QuintBezier')
    Sourcable('geomjs.QuintBezier', 'vertices', 'bias')
    Geometry
    Path
    Intersections
    Spline(4)
  ]).in QuintBezier

  ##### QuintBezier::constructor
  #
  constructor: (vertices, bias=20) ->
    @initSpline vertices, bias

  ##### QuintBezier::pointInSegment
  #
  pointInSegment: (t, seg) ->
    pt = new Point()
    pt.x = (seg[0].x * @b1 (t)) +
           (seg[1].x * @b2 (t)) +
           (seg[2].x * @b3 (t)) +
           (seg[3].x * @b4 (t)) +
           (seg[4].x * @b5 (t))
    pt.y = (seg[0].y * @b1 (t)) +
           (seg[1].y * @b2 (t)) +
           (seg[2].y * @b3 (t)) +
           (seg[3].y * @b4 (t)) +
           (seg[4].y * @b5 (t))
    pt

  ##### QuintBezier::b1
  #
  b1: (t) -> ((1 - t) * (1 - t) * (1 - t) * (1 - t))
  ##### QuintBezier::b2
  #
  b2: (t) -> (4 * t * (1 - t) * (1 - t) * (1 - t))
  ##### QuintBezier::b3
  #
  b3: (t) -> (6 * t * t * (1 - t) * (1 - t))
  ##### QuintBezier::b4
  #
  b4: (t) -> (4 * t * t * t * (1 - t))
  ##### QuintBezier::b5
  #
  b5: (t) -> (t * t * t * t)

module.exports = QuintBezier
