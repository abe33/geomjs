# @toc
Mixin = require './mixin'
Memoizable = require './memoizable'
Point = require '../point'

## Spline
Spline = (segmentSize) ->

  #
  class _ extends Mixin
    Memoizable.attachTo _

    ##### Spline.attachTo
    #
    # See
    # [Mixin.attachTo](src_geomjs_mixins_mixin.html#mixinattachto)

    ##### Spline.included
    #
    @included: (klass) ->
      klass::clone = ->
        new klass @vertices.map((pt) -> pt.clone()), @bias

    ##### Spline::initSpline
    #
    initSpline: (@vertices, @bias=20) ->
      unless @validateVertices @vertices
        throw new Error "The number of vertices for #{this} doesn't match"

    ##### Spline::validateVertices
    #
    validateVertices: -> true

    ##### Spline::segmentSize
    #
    segmentSize: -> segmentSize

    ##### Spline::segment
    #
    segment: (index) ->
      if index < @segments()
        @vertices
          .concat()
          .slice(index * segmentSize, (index + 1) * segmentSize + 1)
      else
        null

    ##### Spline::pointInSegment
    #
    pointInSegment: (position, segment) ->
      Point.interpolate segment[0], segment[1], position

    ##### Spline::length
    #
    length: -> @measure @bias

    ##### Spline::measure
    #
    measure: (bias) ->
      length = 0
      length += @measureSegment @segment(i), bias for i in [0..@segments()-1]
      length

    ##### Spline::measureSegment
    #
    measureSegment: (segment, bias) ->
      step = 1 / bias
      length = 0

      for i in [1..bias]
        length += @pointInSegment((i-1) * step, segment)
                    .distance(@pointInSegment(i * step, segment))

      length

    ##### Spline::pathPointAt
    #
    pathPointAt: (pos, pathBasedOnLength=true) ->
      pos = 0 if pos < 0
      pos = 1 if pos > 1

      return @vertices[0] if pos is 0
      return @vertices[@vertices.length - 1] if pos is 1

      if pathBasedOnLength
        @walkPathBasedOnLength pos
      else
        @walkPathBasedOnSegments pos

    ##### Spline::walkPathBasedOnLength
    #
    walkPathBasedOnLength: (pos) ->
      walked = 0
      length = @length()
      points = @points()

      for i in [1..points.length-1]
        p1 = points[i-1]
        p2 = points[i]
        stepLength = p1.distance(p2) / length

        if walked + stepLength > pos
          innerStepPos = Math.map pos, walked, walked + stepLength, 0, 1
          return p1.add p2.subtract(p1).scale(innerStepPos)

        walked += stepLength

    ##### Spline::walkPathBasedOnSegments
    #
    walkPathBasedOnSegments: (pos) ->
      segments = @segments()
      pos = pos * segments
      segment = Math.floor pos
      segment -= 1 if segment is segments

      @pointInSegment pos - segment, @segment segment

module.exports = Spline
