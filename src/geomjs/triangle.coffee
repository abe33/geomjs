# @toc
Point = require './point'
Surface = require './surface'
Geometry = require './geometry'
Rectangle = require './rectangle'

## Triangle
class Triangle
  Geometry.attachTo Triangle
  Surface.attachTo Triangle

  ##### Triangle::constructor
  #
  constructor: (a, b, c) ->
    @invalidPoint 'a', a unless Point.isPoint a
    @invalidPoint 'b', b unless Point.isPoint b
    @invalidPoint 'c', c unless Point.isPoint c

    @a = new Point a
    @b = new Point b
    @c = new Point c

  #### Edges

  ##### Triangle::ab
  ##### Triangle::ac
  ##### Triangle::ba
  ##### Triangle::bc
  ##### Triangle::ca
  ##### Triangle::cb
  ['ab','ac','ba', 'bc', 'ca', 'cb'].forEach (k) ->
    [p1,p2] = k.split ''
    Triangle::[k] = -> @[p2].subtract @[p1]

  #### Angles

  ##### Triangle::abc
  ##### Triangle::bac
  ##### Triangle::acb
  ['abc', 'bac', 'acb'].forEach (k) ->
    [p1,p2,p3] = k.split ''
    Triangle::[k] = -> @["#{p2}#{p1}"]().angleWith @["#{p2}#{p3}"]()

  #### Bounds

  # Triangle::top
  #
  top: -> Math.min @a.y, @b.y, @c.y

  # Triangle::bottom
  #
  bottom: -> Math.max @a.y, @b.y, @c.y

  # Triangle::left
  #
  left: -> Math.min @a.x, @b.x, @c.x

  # Triangle::right
  #
  right: -> Math.max @a.x, @b.x, @c.x

  ##### Triangle::bounds
  #
  bounds: ->
    top: @top()
    left: @left()
    right: @right()
    bottom: @bottom()

  ##### Triangle::boundingBox
  #
  boundingBox: ->
    new Rectangle(
      @left(),
      @top(),
      @right() - @left(),
      @bottom() - @top()
    )

  #### Geometry API

  ##### Triangle::closedGeometry
  #
  closedGeometry: -> true

  ##### Triangle::points
  #
  points: -> [@a.clone(), @b.clone(), @c.clone(), @a.clone()]

  ##### Triangle::intersects
  #
  # See
  # [Geometry.intersects](src_geomjs_geometry.html#geometryintersects)

  ##### Triangle::intersections
  #
  # See
  # [Geometry.intersections](src_geomjs_geometry.html#geometryintersections)

  #### Surface API

  ##### Triangle::acreage
  #
  acreage: -> @ab().length() * @bc().length() * Math.abs(Math.sin(@abc())) / 2


  ##### Triangle::containsGeometry
  #
  # See
  # [Surface.containsgeometry](src_geomjs_surface.html#surfacecontainsgeometry)

  ##### Triangle::length
  #
  length: -> @ab().length() + @bc().length() + @ca().length()

  #### Drawing API

  ##### Rectangle::stroke
  #
  # See
  # [Geometry.stroke](src_geomjs_geometry.html#geometrystroke)

  ##### Rectangle::fill
  #
  # See
  # [Geometry.fill](src_geomjs_geometry.html#geometryfill)

  ##### Triangle::drawPath
  #
  drawPath: (context) ->
    context.beginPath()
    context.moveTo @a.x, @a.y
    context.lineTo @b.x, @b.y
    context.lineTo @c.x, @c.y
    context.lineTo @a.x, @a.y
    context.closePath()

  ##### Triangle::invalidPoint
  #
  invalidPoint: (k,v) -> throw new Error "Invalid point #{v} for vertex #{k}"

module.exports = Triangle
