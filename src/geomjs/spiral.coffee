# @toc
mixinsjs = require 'mixinsjs'

{
  Equatable,
  Cloneable,
  Sourcable,
  Formattable,
  Memoizable,
  Parameterizable,
  include
} = mixinsjs

Point = require './point'
Ellipsis = require './ellipsis'
Geometry = require './mixins/geometry'
Path = require './mixins/path'
Intersections = require './mixins/intersections'

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

  ##### Spiral::constructor
  #
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

  ##### Spiral::center
  #
  center: -> new Point @x, @y

  ##### Spiral::ellipsis
  #
  ellipsis: ->
    return @memoFor 'ellipsis' if @memoized 'ellipsis'
    @memoize 'ellipsis', new Ellipsis this

  #### Spiral Manipulation

  ##### Spiral::translate
  #
  translate: (x,y) ->
    {x,y} = Point.pointFrom x, y
    @x += x
    @y += y
    this

  ##### Spiral::rotate
  #
  rotate: (rotation) ->
    @rotation += rotation
    this

  ##### Spiral::scale
  #
  scale: (scale) ->
    @radius1 *= scale
    @radius2 *= scale
    this

  #### Geometry API

  ##### Spiral::points
  #
  points: ->
    return @memoFor('points').concat() if @memoized 'points'
    points = []
    center = @center()
    ellipsis = @ellipsis()

    for i in [0..@segments]
      p = i / @segments
      points.push @pathPointAt p

    @memoize 'points', points

  #### Path API

  ##### Spiral::pathPointAt
  #
  pathPointAt: (pos, posBasedOnLength=true) ->
    center = @center()
    ellipsis = @ellipsis()
    PI2 = Math.PI * 2
    angle = @rotation + pos * PI2 * @twirl % PI2
    pt = ellipsis.pointAtAngle(angle)?.subtract(center).scale(pos)
    center.add pt

  #### Drawing API

  ##### Spiral::fill
  #
  fill: ->

  ##### Spiral::drawPath
  #
  drawPath: (context) ->
    points = @points()
    start = points.shift()
    context.beginPath()
    context.moveTo(start.x,start.y)
    context.lineTo(p.x,p.y) for p in points

  ##### Spiral::memoizationKey
  #
  memoizationKey = ->
    "#{@radius1};#{@radius2};#{@twirl};#{@x};#{@y};#{@rotation};#{@segments}"

module.exports = Spiral
