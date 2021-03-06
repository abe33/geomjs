# @toc
mixinsjs = require 'mixinsjs'

{Mixin} = mixinsjs
Point = require '../point'

## Geometry
class Geometry extends Mixin
  ##### Geometry.attachTo
  #
  # See
  # [Mixin.attachTo](src_geomjs_mixins_mixin.html#mixinattachto)

  ##### Geometry::points
  #
  # **Virtual method**
  points: ->

  ##### Geometry::closedGeometry
  #
  # **Virtual method**
  closedGeometry: -> false

  #### Bounds

  # The `pointsBounds` private utility is meant to provides the default
  # bounds computation for a geometry, subclasses should implements their
  # own bounds methods if a faster implementation exist.
  pointsBounds = (points, mode, axis) ->
    Math[mode].apply Math, points.map (pt) -> pt[axis]

  ##### Geometry::top
  #
  top: -> pointsBounds @points(), 'min', 'y'

  ##### Geometry::bottom
  #
  bottom: -> pointsBounds @points(), 'max', 'y'

  ##### Geometry::left
  #
  left: -> pointsBounds @points(), 'min', 'x'

  ##### Geometry::right
  #
  right: -> pointsBounds @points(), 'max', 'x'

  ##### Geometry::bounds
  #
  bounds: ->
    top: @top()
    left: @left()
    right: @right()
    bottom: @bottom()

  ##### Geometry::boundingBox
  #
  boundingBox: ->
    # When running in nodejs, to avoid circular dependecies hell,
    # the `Rectangle` class is required lazily. In a browser this
    # case will never occurs since `Geometry` and `Rectangle` will
    # be both defined in the same scope.
    #
    # **Note:** The require call is removed as any other requires
    # when packaged for browsers.
    Rectangle = require '../rectangle'
    new Rectangle(
      @left(),
      @top(),
      @right() - @left(),
      @bottom() - @top()
    )

  #### Drawing API

  ##### Geometry::stroke
  #
  stroke: (context, color='#ff0000') ->
    return unless context?

    context.strokeStyle = color
    @drawPath context
    context.stroke()

  ##### Geometry::fill
  #
  fill: (context, color='#ff0000') ->
    return unless context?

    context.fillStyle = color
    @drawPath context
    context.fill()

  ##### Geometry::drawPath
  #
  drawPath: (context) ->
    points = @points()
    start = points.shift()
    context.beginPath()
    context.moveTo(start.x,start.y)
    context.lineTo(p.x,p.y) for p in points
    context.closePath()

module.exports = Geometry
