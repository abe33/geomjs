Point = require './point'

class Rectangle
  constructor: (@x=0, @y=0, @width=0, @height=0, @rotation=0) ->

  topLeft: -> new Point(@x, @y)
  topRight: -> @topLeft().add(@topEdge())
  bottomLeft: -> @topLeft().add(@leftEdge())
  bottomRight: -> @topLeft().add(@topEdge()).add(@leftEdge())

  center: -> @topLeft().add(@topEdge().scale(0.5)).add(@leftEdge().scale(0.5))
  topEdgeCenter: -> @topLeft().add(@topEdge().scale(0.5))
  bottomEdgeCenter: -> @bottomLeft().add(@topEdge().scale(0.5))
  leftEdgeCenter: -> @topLeft().add(@leftEdge().scale(0.5))
  rightEdgeCenter: -> @topRight().add(@leftEdge().scale(0.5))

  topEdge: -> new Point @width * Math.cos(Math.degToRad(@rotation)),
                        @width * Math.sin(Math.degToRad(@rotation))
  leftEdge: ->
    new Point @height * Math.cos(Math.degToRad(@rotation) + Math.PI / 2),
              @height * Math.sin(Math.degToRad(@rotation) + Math.PI / 2)

  bottomEdge: -> @topEdge()
  rightEdge: -> @leftEdge()

  top: -> Math.min @y, @topRight().y, @bottomRight().y, @bottomLeft().y
  bottom: -> Math.max @y, @topRight().y, @bottomRight().y, @bottomLeft().y
  left: -> Math.min @x, @topRight().x, @bottomRight().x, @bottomLeft().x
  right: -> Math.max @x, @topRight().x, @bottomRight().x, @bottomLeft().x

  #### Surface API
  acreage: -> @width * @height

  #### Path API
  length: -> @width * 2 + @height * 2

  #### Drawing API
  stroke: (context, color='#ff0000') ->
    return unless context?

    context.strokeStyle = color
    @drawPath context
    context.stroke()

  fill: (context, color='#ff0000') ->
    return unless context?

    context.fillStyle = color
    @drawPath context
    context.fill()

  drawPath: (context) ->
    context.beginPath()
    context.moveTo(@x, @y)
    context.lineTo(@topRight().x, @topRight().y)
    context.lineTo(@bottomRight().x, @bottomRight().y)
    context.lineTo(@bottomLeft().x, @bottomLeft().y)
    context.lineTo(@x, @y)
    context.closePath()

  toString: -> "[object Rectangle(#{x},#{y},#{width},#{height},#{rotation})]"

module.exports = Rectangle
