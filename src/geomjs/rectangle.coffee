# @toc
Point = require './point'
chancejs = require 'chancejs'

## Rectangle
class Rectangle
  PROPERTIES = ['x','y','width','height','rotation']

  ##### Rectangle::constructor
  #
  constructor: (x, y, width, height, rotation) ->
    args = @defaultToZero.apply this, @rectangleFrom.apply this, arguments
    [@x,@y,@width,@height,@rotation] = args

  #### Corners

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
  bounds: ->
    top: @top()
    left: @left()
    right: @right()
    bottom: @bottom()

  ##### Rectangle::boundingBox
  #
  boundingBox: ->
    new Rectangle(
      @left(),
      @top(),
      @right() - @left(),
      @bottom() - @top()
    )

  #### Rectangle Manipulation

  ##### Rectangle::setCenter
  #
  setCenter: (xOrPt, y) ->
    [x,y] = Point.coordsFrom xOrPt, y
    c = @center()

    @x += x - c.x
    @y += y - c.y
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
    [x,y] = Point.coordsFrom xOrPt, y
    @width += x
    @height += y
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
    [x,y] = Point.coordsFrom xOrPt, y
    @inflateLeft x
    @inflateTop y
    this

  ##### Rectangle::inflateTopRight
  #
  inflateTopRight: (xOrPt, y) ->
    [x,y] = Point.coordsFrom xOrPt, y
    @inflateRight x
    @inflateTop y
    this

  ##### Rectangle::inflateBottomLeft
  #
  inflateBottomLeft: (xOrPt, y) ->
    [x,y] = Point.coordsFrom xOrPt, y
    @inflateLeft x
    @inflateBottom y
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

  #### Surface API

  ##### Rectangle::acreage
  #
  acreage: -> @width * @height

  ##### Rectangle::contains
  #
  contains: (xOrPt, y) ->
    [x,y] = Point.coordsFrom xOrPt, y
    {x,y} = new Point(x,y).rotateAround(@topLeft(), -@rotation)
    (@x <= x <= @x + @width) and (@y <= y <= @y + @height)

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

    Math.atan2 p.y, p.x

  ##### Rectangle::pathTangentAt
  #
  pathTangentAt: (n, accuracy=1 / 100, pathBasedOnLength=true) ->
    @pathPointAt((n + accuracy) % 1)
      .subtract(@pathPointAt((1 + n - accuracy) % 1))
      .normalize(1)

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
  stroke: (context, color='#ff0000') ->
    return unless context?

    context.strokeStyle = color
    @drawPath context
    context.stroke()

  ##### Rectangle::fill
  #
  fill: (context, color='#ff0000') ->
    return unless context?

    context.fillStyle = color
    @drawPath context
    context.fill()

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
  toString: ->
    "[object Rectangle(#{@x},#{@y},#{@width},#{@height},#{@rotation})]"

  ##### Rectangle::clone
  #
  clone: -> new Rectangle @x, @y, @width, @height, @rotation

  ##### Rectangle::equals
  #
  equals: (rectangle) ->
    return false unless rectangle?
    return false for p in PROPERTIES when rectangle[p] isnt @[p]
    true

  ##### Rectangle::paste
  #
  paste: (x, y, width, height, rotation) ->
    values = @rectangleFrom x, y, width, height, rotation
    PROPERTIES.forEach (k,i) =>
      @[k] = parseFloat values[i] if Point.isFloat values[i]

  ##### Rectangle::rectangleFrom
  #
  rectangleFrom: (xOrRect,y,width,height,rotation) ->
    x = xOrRect
    {x,y,width,height,rotation} = xOrRect if typeof xOrRect is 'object'
    [x,y,width,height,rotation]

  ##### Rectangle::defaultToZero
  #
  defaultToZero: (values...) ->
    values[i] = 0 for n,i in values when not Point.isFloat n
    values

module.exports = Rectangle
