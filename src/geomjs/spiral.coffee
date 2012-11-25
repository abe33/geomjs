# @toc
{include} = require './include'
Point = require './point'
Ellipsis = require './ellipsis'
Equatable = require './mixins/equatable'
Formattable = require './mixins/formattable'
Geometry = require './mixins/geometry'
Cloneable = require './mixins/cloneable'
Memoizable = require './mixins/memoizable'
Sourcable = require './mixins/sourcable'
Path = require './mixins/path'
Intersections = require './mixins/intersections'
Parameterizable = require './mixins/parameterizable'

## Spiral
class Spiral
  PROPERTIES = ['radius1', 'radius2', 'twirl', 'x', 'y', 'rotation','segments']

  include([
    Equatable.apply(null, PROPERTIES)
    Formattable.apply(null, ['Spiral'].concat PROPERTIES)
    Parameterizable('spiralFrom', {
      radius1: 1
      radius2: 1
      twirl: 1
      x: 0
      y: 0
      rotation: 0
      segments: 36
    })
    Sourcable.apply(null, ['geomjs.Spiral'].concat PROPERTIES)
    Cloneable
    Memoizable
    Geometry
    Path
    Intersections
  ]).in Spiral

  constructor: (r1, r2, twirl, x, y, rot, segments) ->
    {
      @radius1
      @radius2
      @twirl
      @x
      @y
      @rotation
      @segments
    } = @spiralFrom r1, r2, twirl, x, y, rot, segments

  center: -> new Point @x, @y

  ellipsis: ->
    return @memoFor 'ellipsis' if @memoized 'ellipsis'
    @memoize 'ellipsis', new Ellipsis this

  points: ->
    return @memoFor('points').concat() if @memoized 'points'
    points = []
    center = @center()
    ellipsis = @ellipsis()

    for i in [0..@segments]
      p = i / @segments
      points.push @pathPointAt p

    @memoize 'points', points

  pathPointAt: (pos, posBasedOnLength=true) ->
    center = @center()
    ellipsis = @ellipsis()
    angle = pos * 360 * @twirl % 360
    pt = ellipsis.pointAtAngle(angle)?.subtract(center).scale(pos)
    center.add pt

  fill: ->

  drawPath: (context) ->
    points = @points()
    start = points.shift()
    context.beginPath()
    context.moveTo(start.x,start.y)
    context.lineTo(p.x,p.y) for p in points

  memoizationKey = ->
    "#{@radius1};#{@radius2};#{@twirl};#{@x};#{@y};#{@rotation};#{@segments}"

module.exports = Spiral
