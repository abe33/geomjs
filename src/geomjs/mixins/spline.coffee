# @toc
Mixin = require './mixin'
Memoizable = require './memoizable'
Point = require '../point'

## Spline
Spline = (segmentSize) ->
  #
  class ConcretSpline extends Mixin
    Memoizable.attachTo ConcretSpline

    ##### Spline.attachTo
    #
    # See
    # [Mixin.attachTo](src_geomjs_mixins_mixin.html#mixinattachto)

    ##### Spline.included
    #
    @included: (klass) ->
      klass::clone = ->
        new klass @vertices.map((pt) -> pt.clone()), @bias

      klass.segmentSize = -> segmentSize

    ##### Spline::initSpline
    #
    initSpline: (@vertices, @bias=20) ->
      unless @validateVertices @vertices
        throw new Error "The number of vertices for #{this} doesn't match"

    ##### Spline::points
    #
    points: ->
      return @memoFor('points').concat() if @memoized 'points'
      segments = @segments() * @bias
      points = (@pathPointAt i / segments for i in [0..segments])
      @memoize('points', points).concat()

    ##### Spline::validateVertices
    #
    validateVertices: (vertices) ->
      vertices.length % segmentSize is 1 and
      vertices.length >= segmentSize + 1

    ##### Spline::segments
    #
    segments: ->
      return 0 if not @vertices? or @vertices.length is 0
      return @memoFor 'segments' if @memoized 'segments'
      @memoize 'segments', (@vertices.length - 1) / segmentSize

    ##### Spline::segmentSize
    #
    segmentSize: -> segmentSize

    ##### Spline::segment
    #
    segment: (index) ->
      if index < @segments()
        k = "segment#{index}"
        return @memoFor k if @memoized k
        @memoize k, @vertices
          .concat()
          .slice(index * segmentSize, (index + 1) * segmentSize + 1)
      else
        null

    ##### Spline::length
    #
    length: -> @measure @bias

    ##### Spline::measure
    #
    measure: (bias) ->
      return @memoFor 'measure' if @memoized 'measure'
      length = 0
      length += @measureSegment @segment(i), bias for i in [0..@segments()-1]
      @memoize 'measure', length

    ##### Spline::measureSegment
    #
    measureSegment: (segment, bias) ->
      k = "segment#{segment}_#{bias}Length"
      return @memoFor k if @memoized k

      step = 1 / bias
      length = 0

      for i in [1..bias]
        length += @pointInSegment((i-1) * step, segment)
                    .distance(@pointInSegment(i * step, segment))

      @memoize k, length

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
      segments = @segments()

      for i in [0..segments-1]
        segment = @segment i
        stepLength = @measureSegment(segment, @bias) / length

        if walked + stepLength > pos
          innerStepPos = Math.map pos, walked, walked + stepLength, 0, 1
          return @pointInSegment innerStepPos, segment

        walked += stepLength

    ##### Spline::walkPathBasedOnSegments
    #
    walkPathBasedOnSegments: (pos) ->
      segments = @segments()
      pos = pos * segments
      segment = Math.floor pos
      segment -= 1 if segment is segments
      @pointInSegment pos - segment, @segment segment

    #### Drawing API

    ##### Spline::fill
    #
    fill: ->

    ##### Spline::drawPath
    #
    drawPath: (context) ->
      points = @points()
      start = points.shift()
      context.beginPath()
      context.moveTo(start.x,start.y)
      context.lineTo(p.x,p.y) for p in points

    ##### Spline::drawVertices
    #
    drawVertices: (context, color) ->
      context.fillStyle = color
      for vertex in @vertices
        context.beginPath()
        context.arc vertex.x, vertex.y, 2, 0, Math.PI*2
        context.fill()
        context.closePath()

    ##### Spline::drawVerticesConnections
    #
    drawVerticesConnections: (context, color) ->
      context.strokeStyle = color
      for i in [1..@vertices.length-1]
        vertexStart = @vertices[i-1]
        vertexEnd = @vertices[i]
        context.beginPath()
        context.moveTo vertexStart.x, vertexStart.y
        context.lineTo vertexEnd.x, vertexEnd.y
        context.stroke()
        context.closePath()

    ##### Spline::memoizationKey
    #
    memoizationKey: ->
      @vertices.map((pt) -> "#{pt.x};#{pt.y}").join(';')

module.exports = Spline
