# @toc
Point = require './point'
Path = require './path'
Surface = require './surface'
Geometry = require './geometry'
Rectangle = require './rectangle'

## Triangle
class Triangle
  Geometry.attachTo Triangle
  Surface.attachTo Triangle
  Path.attachTo Triangle

  ##### Triangle::constructor
  #
  constructor: (a, b, c) ->
    @invalidPoint 'a', a unless Point.isPoint a
    @invalidPoint 'b', b unless Point.isPoint b
    @invalidPoint 'c', c unless Point.isPoint c

    @a = new Point a
    @b = new Point b
    @c = new Point c

  #### Centers

  ##### Triangle::center
  #
  center: -> new Point (@a.x + @b.x + @c.x) / 3,
                       (@a.y + @b.y + @c.y) / 3

  ##### Triangle::abCenter
  ##### Triangle::acCenter
  ##### Triangle::bcCenter
  ['abCenter', 'acCenter', 'bcCenter'].forEach (k) ->
    [p1,p2] = k.split ''
    Triangle::[k] = -> @[p1].add @["#{p1}#{p2}"]().scale(0.5)

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

  #### Shape Properties

  ##### Triangle::equilateral
  #
  equilateral: ->
    Math.deltaBelowRatio(@ab().length(), @bc().length()) and
    Math.deltaBelowRatio(@ab().length(), @ac().length())

  ##### Triangle::isosceles
  #
  isosceles: ->
    Math.deltaBelowRatio(@ab().length(), @bc().length()) or
    Math.deltaBelowRatio(@ab().length(), @ac().length()) or
    Math.deltaBelowRatio(@bc().length(), @ac().length())

  ##### Triangle::rectangle
  #
  rectangle: ->
    sqr = 90
    Math.deltaBelowRatio(Math.abs(@abc()), sqr) or
    Math.deltaBelowRatio(Math.abs(@bac()), sqr) or
    Math.deltaBelowRatio(Math.abs(@acb()), sqr)

  #### Triangle Manipulation

  ##### Triangle::rotateAroundCenter
  #
  rotateAroundCenter: (rotation) ->
    center = @center()
    @a = @a.rotateAround center, rotation
    @b = @b.rotateAround center, rotation
    @c = @c.rotateAround center, rotation
    this

  ##### Triangle::scaleAroundCenter
  #
  scaleAroundCenter: (scale) ->
    center = @center()
    @a = center.add @a.subtract(center).scale(scale)
    @b = center.add @b.subtract(center).scale(scale)
    @c = center.add @c.subtract(center).scale(scale)
    this

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

  ##### Triangle::pointAtAngle
  #
  pointAtAngle: (angle) ->
    center = @center()
    vec = center.add Math.cos(Math.degToRad(angle))*10000,
                     Math.sin(Math.degToRad(angle))*10000
    @intersections(points: -> [center, vec])?[0]

  #### Surface API

  ##### Triangle::acreage
  #
  acreage: -> @ab().length() * @bc().length() * Math.abs(Math.sin(@abc())) / 2

  ##### Triangle::contains
  #
  contains: (xOrPt, y) ->
    [x,y] = Point.coordsFrom xOrPt, y
    p = new Point x,y

    v0 = @ac()
    v1 = @ab()
    v2 = p.subtract(@a)

    dot00 = v0.dot v0
    dot01 = v0.dot v1
    dot02 = v0.dot v2
    dot11 = v1.dot v1
    dot12 = v1.dot v2

    invDenom = 1 / (dot00 * dot11 - dot01 * dot01)
    u = (dot11 * dot02 - dot01 * dot12) * invDenom
    v = (dot00 * dot12 - dot01 * dot02) * invDenom

    v > 0 and v > 0 and u + v < 1

  ##### Triangle::containsGeometry
  #
  # See
  # [Surface.containsgeometry](src_geomjs_surface.html#surfacecontainsgeometry)

  ##### Triangle::randomPointInSurface
  #
  randomPointInSurface: (random) ->
    unless random?
      random = new chancejs.Random new chancejs.MathRandom

    a1 = random.get()
    a2 = random.get()
    p = @a.add(@ab().scale(a1))
          .add(@ca().scale(a2 * -1))

    if @contains p
      p
    else
      p.add @bcCenter().subtract(p).scale(2)

  #### Path API

  ##### Triangle::length
  #
  length: -> @ab().length() + @bc().length() + @ca().length()

  ##### Triangle::pathPointAt
  #
  pathPointAt: (n, pathBasedOnLength=true) ->
    [l1, l2] = @pathSteps pathBasedOnLength

    if n < l1
      @a.add @ab().scale Math.map n, 0, l1, 0, 1
    else if n < l2
      @b.add @bc().scale Math.map n, l1, l2, 0, 1
    else
      @c.add @ca().scale Math.map n, l2, 1, 0, 1

  ##### Triangle::pathOrientationAt
  #
  pathOrientationAt: (n, pathBasedOnLength=true) ->
    [l1, l2] = @pathSteps pathBasedOnLength

    if n < l1
      @ab().angle()
    else if n < l2
      @bc().angle()
    else
      @ca().angle()

  ##### Triangle::pathTangentAt
  #
  # See
  # [Path.pathTangentAt](src_geomjs_path.html#pathpathtangentat)

  ##### Triangle::pathSteps
  #
  pathSteps: (pathBasedOnLength) ->
    if pathBasedOnLength
      l = @length()
      l1 = @ab().length() / l
      l2 = l1 + @bc().length() / l
    else
      l1 = 1 / 3
      l2 = 2 / 3

    [l1,l2]

  #### Drawing API

  ##### Triangle::stroke
  #
  # See
  # [Geometry.stroke](src_geomjs_geometry.html#geometrystroke)

  ##### Triangle::fill
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
