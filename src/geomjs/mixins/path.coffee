# @toc
Mixin = require './mixin'
Point = require '../point'

## Path
class Path extends Mixin
  ##### Path.attachTo
  #
  # See
  # [Mixin.attachTo](src_geomjs_mixins_mixin.html#mixinattachto)

  ##### Path::length
  #
  # **Virtual method**
  length: -> null

  ##### Path::pathPointAt
  #
  # **Virtual method**
  pathPointAt: (pos, pathBasedOnLength=true) ->
    pos = 0 if pos < 0
    pos = 1 if pos > 1
    points = @points()

    return points[0] if pos is 0
    return points[points.length - 1] if pos is 1

    if pathBasedOnLength
      @walkPathBasedOnLength pos, points
    else
      @walkPathBasedOnSegments pos, points

  ##### Path::pathOrientationAt
  #
  # **Virtual method**
  pathOrientationAt: (n, pathBasedOnLength=true) ->
    p1 = @pathPointAt n - 0.01
    p2 = @pathPointAt n + 0.01
    d = p2.subtract p1

    return d.angle()

  ##### Path::pathTangentAt
  #
  pathTangentAt: (n, accuracy=1 / 100, pathBasedOnLength=true) ->
    @pathPointAt((n + accuracy) % 1)
      .subtract(@pathPointAt((1 + n - accuracy) % 1))
      .normalize(1)

  ##### Path::walkPathBasedOnLength
  #
  walkPathBasedOnLength: (pos, points) ->
    walked = 0
    length = @length()

    for i in [1..points.length-1]
      p1 = points[i-1]
      p2 = points[i]
      stepLength = p1.distance(p2) / length

      if walked + stepLength > pos
        innerStepPos = Math.map pos, walked, walked + stepLength, 0, 1
        return p1.add p2.subtract(p1).scale(innerStepPos)

      walked += stepLength

  ##### Path::walkPathBasedOnSegments
  #
  walkPathBasedOnSegments: (pos, points) ->
    segments = points.length - 1
    pos = pos * segments
    segment = Math.floor pos
    segment -= 1 if segment is segments
    Point.interpolate points[segment], points[segment + 1], pos - segment

module.exports = Path
