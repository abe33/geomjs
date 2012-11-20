# @toc
Point = require './point'
Equatable = require './mixins/equatable'
Formattable = require './mixins/formattable'
Cloneable = require './mixins/cloneable'
Sourcable = require './mixins/sourcable'
Triangulable = require './mixins/triangulable'
Parameterizable = require './mixins/parameterizable'
Geometry = require './mixins/geometry'
Surface = require './mixins/surface'
Path = require './mixins/path'
Intersections = require './mixins/intersections'
chancejs = require 'chancejs'

## Rectangle
class Rectangle
  PROPERTIES = ['x','y','width','height','rotation']

  Equatable.apply(null, PROPERTIES).attachTo Rectangle
  Formattable.apply(null, ['Rectangle'].concat PROPERTIES).attachTo Rectangle
  Parameterizable('rectangleFrom', {
    x: NaN
    y: NaN
    width: NaN
    height: NaN
    rotation: NaN
  }).attachTo Rectangle
  Sourcable.apply(null, ['geomjs.Rectangle'].concat PROPERTIES)
    .attachTo Rectangle
  Cloneable.attachTo Rectangle
  Geometry.attachTo Rectangle
  Surface.attachTo Rectangle
  Path.attachTo Rectangle
  Triangulable.attachTo Rectangle
  Intersections.attachTo Rectangle

  ##### Rectangle.eachRectangleRectangleIntersections
  #
  @eachRectangleRectangleIntersections: (geom1, geom2, block, data=false) ->
    if geom1.equals geom2
      for p in geom1.points()
        return if block.call this, p
    else
      @eachIntersections geom1, geom2, block, data

  # Registers the fast intersections iterators for the Rectangle class
  iterators = Intersections.iterators
  k = 'RectangleRectangle'
  iterators[k] = Rectangle.eachRectangleRectangleIntersections

  ##### Rectangle::constructor
  #
  constructor: (x, y, width, height, rotation) ->
    args = @defaultToZero @rectangleFrom.apply this, arguments
    {@x,@y,@width,@height,@rotation} = args

  #### Corners

  ##### Rectangle::corners
  #
  corners: -> [@topLeft(), @topRight(), @bottomRight(), @bottomLeft()]

  ##### Rectangle::topLeft
  #
  topLeft: -> new Point(@x, @y)

  ##### Rectangle::topRight
  #
  topRight: -> @topLeft().add(@topEdge())

  ##### Rectangle::bottomLeft
  #
  bottomLeft: -> @topLeft().add(@leftEdge())

  ##### Rectangle::bottomRight
  #
  bottomRight: -> @topLeft().add(@topEdge()).add(@leftEdge())

  #### Centers

  ##### Rectangle::center
  #
  center: -> @topLeft().add(@topEdge().scale(0.5)).add(@leftEdge().scale(0.5))

  ##### Rectangle::topEdgeCenter
  #
  topEdgeCenter: -> @topLeft().add(@topEdge().scale(0.5))

  ##### Rectangle::bottomEdgeCenter
  #
  bottomEdgeCenter: -> @bottomLeft().add(@topEdge().scale(0.5))

  ##### Rectangle::leftEdgeCenter
  #
  leftEdgeCenter: -> @topLeft().add(@leftEdge().scale(0.5))

  ##### Rectangle::rightEdgeCenter
  #
  rightEdgeCenter: -> @topRight().add(@leftEdge().scale(0.5))

  #### Edges

  ##### Rectangle::edges
  #
  edges: -> [@topEdge(), @topRight(), @bottomRight(), @bottomLeft()]

  ##### Rectangle::topEdge
  #
  topEdge: -> new Point @width * Math.cos(Math.degToRad(@rotation)),
                        @width * Math.sin(Math.degToRad(@rotation))

  ##### Rectangle::leftEdge
  #
  leftEdge: ->
    new Point @height * Math.cos(Math.degToRad(@rotation) + Math.PI / 2),
              @height * Math.sin(Math.degToRad(@rotation) + Math.PI / 2)

  ##### Rectangle::bottomEdge
  #
  bottomEdge: -> @topEdge()

  ##### Rectangle::rightEdge
  #
  rightEdge: -> @leftEdge()

  #### Bounds

  ##### Rectangle::top
  #
  top: -> Math.min @y, @topRight().y, @bottomRight().y, @bottomLeft().y

  ##### Rectangle::bottom
  #
  bottom: -> Math.max @y, @topRight().y, @bottomRight().y, @bottomLeft().y

  ##### Rectangle::left
  #
  left: -> Math.min @x, @topRight().x, @bottomRight().x, @bottomLeft().x

  ##### Rectangle::right
  #
  right: -> Math.max @x, @topRight().x, @bottomRight().x, @bottomLeft().x

  ##### Rectangle::bounds
  #
  # See [Geometry.bounds](src_geomjs_mixins_geometry.html#geometrybounds)

  ##### Rectangle::boundingBox
  #
  # See
  # [Geometry.boundingbox](src_geomjs_mixins_geometry.html#geometryboundingbox)

  #### Rectangle Manipulation

  ##### Rectangle::setCenter
  #
  setCenter: (xOrPt, y) ->
    pt = Point.pointFrom(xOrPt, y).subtract(@center())

    @x += pt.x
    @y += pt.y
    this

  ##### Rectangle::rotateAroundCenter
  #
  rotateAroundCenter: (rotation) ->
    {@x,@y} = @topLeft().rotateAround(@center(), rotation)
    @rotation += rotation
    this

  ##### Rectangle::scaleAroundCenter
  #
  scaleAroundCenter: (scale) ->
    topLeft = @topLeft()
    dif = topLeft.subtract(@center()).scale(scale)
    {@x,@y} = topLeft.add(dif.scale(1 / 2))
    @width *= scale
    @height *= scale
    this

  ##### Rectangle::inflateAroundCenter
  #
  inflateAroundCenter: (xOrPt, y) ->
    center = @center()
    @inflate xOrPt, y
    @setCenter center
    this

  ##### Rectangle::inflate
  #
  inflate: (xOrPt, y) ->
    pt = Point.pointFrom xOrPt, y
    @width += pt.x
    @height += pt.y
    this

  ##### Rectangle::inflateLeft
  #
  inflateLeft: (inflate) ->
    @width += inflate
    offset = @topEdge().normalize(-inflate)
    {@x,@y} = @topLeft().add(offset)
    this

  ##### Rectangle::inflateRight
  #
  inflateRight: (inflate) ->
    @width += inflate
    this

  ##### Rectangle::inflateTop
  #
  inflateTop: (inflate) ->
    @height += inflate
    offset = @leftEdge().normalize(-inflate)
    {@x,@y} = @topLeft().add(offset)
    this

  ##### Rectangle::inflateBottom
  #
  inflateBottom: (inflate) ->
    @height += inflate
    this

  ##### Rectangle::inflateTopLeft
  #
  inflateTopLeft: (xOrPt, y) ->
    pt = Point.pointFrom xOrPt, y
    @inflateLeft pt.x
    @inflateTop pt.y
    this

  ##### Rectangle::inflateTopRight
  #
  inflateTopRight: (xOrPt, y) ->
    pt = Point.pointFrom xOrPt, y
    @inflateRight pt.x
    @inflateTop pt.y
    this

  ##### Rectangle::inflateBottomLeft
  #
  inflateBottomLeft: (xOrPt, y) ->
    pt = Point.pointFrom xOrPt, y
    @inflateLeft pt.x
    @inflateBottom pt.y
    this

  ##### Rectangle::inflateBottomRight
  #
  inflateBottomRight: (xOrPt, y) -> @inflate xOrPt, y

  #### Geometry API

  ##### Rectangle::closedGeometry
  #
  closedGeometry: -> true

  ##### Rectangle::points
  #
  points: ->
    [@topLeft(), @topRight(), @bottomRight(), @bottomLeft(), @topLeft()]

  ##### Rectangle::intersects
  #
  # See [Intersections.intersects][1]
  # [1]: src_geomjs_mixins_intersections.html#intersectionsintersects

  ##### Rectangle::intersections
  #
  # See [Intersections.intersections][1]
  # [1]: src_geomjs_mixins_intersections.html#intersectionsintersections

  ##### Rectangle::pointAtAngle
  #
  pointAtAngle: (angle) ->
    center = @center()
    vec = center.add Math.cos(Math.degToRad(angle))*10000,
                     Math.sin(Math.degToRad(angle))*10000
    @intersections(points: -> [center, vec])?[0]

  #### Surface API

  ##### Rectangle::acreage
  #
  acreage: -> @width * @height

  ##### Rectangle::contains
  #
  contains: (xOrPt, y) ->
    {x,y} = new Point(xOrPt, y).rotateAround(@topLeft(), -@rotation)
    (@x <= x <= @x + @width) and (@y <= y <= @y + @height)

  ##### Rectangle::containsGeometry
  #
  # See [Surface.containsgeometry][1]
  # [1]: src_geomjs_mixins_surface.html#surfacecontainsgeometry

  ##### Rectangle::randomPointInSurface
  #
  randomPointInSurface: (random) ->
    unless random?
      random = new chancejs.Random new chancejs.MathRandom
    @topLeft()
      .add(@topEdge().scale random.get())
      .add(@leftEdge().scale random.get())

  #### Path API

  ##### Rectangle::length
  #
  length: -> @width * 2 + @height * 2

  ##### Rectangle::pathPointAt
  #
  pathPointAt: (n, pathBasedOnLength=true) ->
    [p1,p2,p3] = @pathSteps pathBasedOnLength

    if n < p1
      @topLeft().add @topEdge().scale Math.map n, 0, p1, 0, 1
    else if n < p2
      @topRight().add @rightEdge().scale Math.map n, p1, p2, 0, 1
    else if n < p3
      @bottomRight().add @bottomEdge().scale Math.map(n, p2, p3, 0, 1) * -1
    else
      @bottomLeft().add @leftEdge().scale Math.map(n, p3, 1, 0, 1) * -1

  ##### Rectangle::pathOrientationAt
  #
  pathOrientationAt: (n, pathBasedOnLength=true) ->
    [p1,p2,p3] = @pathSteps pathBasedOnLength

    if n < p1
      p = @topEdge()
    else if n < p2
      p = @rightEdge()
    else if n < p3
      p = @bottomEdge().scale -1
    else
      p = @leftEdge().scale -1

    p.angle()

  ##### Rectangle::pathTangentAt
  #
  # See
  # [Path.pathTangentAt](src_geomjs_mixins_geometry.html#pathpathtangentat)

  ##### Rectangle::pathSteps
  #
  pathSteps: (pathBasedOnLength=true) ->
    if pathBasedOnLength
      l = @length()
      p1 = @width / l
      p2 = (@width + @height) / l
      p3 = p1 + p2
    else
      p1 = 1 / 4
      p2 = 1 / 2
      p3 = 3 / 4

    [p1, p2, p3]

  #### Drawing API

  ##### Rectangle::stroke
  #
  # See [Geometry.stroke](src_geomjs_mixins_geometry.html#geometrystroke)

  ##### Rectangle::fill
  #
  # See [Geometry.fill](src_geomjs_mixins_geometry.html#geometryfill)

  ##### Rectangle::drawPath
  #
  drawPath: (context) ->
    context.beginPath()
    context.moveTo(@x, @y)
    context.lineTo(@topRight().x, @topRight().y)
    context.lineTo(@bottomRight().x, @bottomRight().y)
    context.lineTo(@bottomLeft().x, @bottomLeft().y)
    context.lineTo(@x, @y)
    context.closePath()

  #### Utilities

  ##### Rectangle::toString
  #
  # See [Formattable.toString][1]
  # [1]: src_geomjs_mixins_formattable.html#formattabletostring

  ##### Rectangle::clone
  #
  # See [Cloneable.clone](src_geomjs_mixins_cloneable.html#cloneableclone)

  ##### Rectangle::equals
  #
  # See [Equatable.equals](src_geomjs_mixins_equatable.html#equatableequals)

  ##### Rectangle::paste
  #
  paste: (x, y, width, height, rotation) ->
    values = @rectangleFrom x, y, width, height, rotation
    @[k] = parseFloat v for k,v of values when Math.isFloat v

  ##### Rectangle::defaultToZero
  #
  defaultToZero: (values) ->
    values[k] = 0 for k,v of values when not Math.isFloat v
    values

module.exports = Rectangle
