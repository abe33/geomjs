# @toc
Point = require './point'

## Rectangle
class Rectangle

  ##### Rectangle::constructor
  #
  constructor: (@x=0, @y=0, @width=0, @height=0, @rotation=0) ->

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

  #### Rectangle Manipulation

  ##### Rectangle::setCenter
  #
  setCenter: (xOrPt, y) ->
    [x,y] = Point.coordsFrom xOrPt, y
    c = @center()

    @x += x - c.x
    @y += y - c.y

  ##### Rectangle::rotateAroundCenter
  #
  rotateAroundCenter: (rotation) ->
    {@x,@y} = @topLeft().rotateAround(@center(), rotation)
    @rotation += rotation

  ##### Rectangle::scaleAroundCenter
  #
  scaleAroundCenter: (scale) ->
    topLeft = @topLeft()
    dif = topLeft.subtract(@center()).scale(scale)
    {@x,@y} = topLeft.add(dif.scale(1 / 2))
    @width *= scale
    @height *= scale

  ##### Rectangle::inflateAroundCenter
  #
  inflateAroundCenter: (xOrPt, y) ->
    [x,y] = Point.coordsFrom xOrPt, y
    center = @center()
    @width += x
    @height += y
    @setCenter center


  #### Surface API

  ##### Rectangle::acreage
  #
  acreage: -> @width * @height

  #### Path API

  ##### Rectangle::length
  #
  length: -> @width * 2 + @height * 2

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
  toString: -> "[object Rectangle(#{x},#{y},#{width},#{height},#{rotation})]"

module.exports = Rectangle
