Point = require './point'

class Rectangle
  constructor: (@x=0, @y=0, @width=0, @height=0, @rotation=0) ->

  topLeft: -> new Point(@x, @y)
  topRight: -> new Point(@x, @y).add(@topEdge())
  bottomLeft: -> new Point(@x, @y).add(@leftEdge())
  bottomRight: -> new Point(@x, @y).add(@topEdge()).add(@leftEdge())

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

module.exports = Rectangle
