Point = require './point'

class Rectangle
  constructor: (@x, @y, @width, @height) ->

  acreage: -> @width * @height

  topLeft: -> new Point @x, @y
  topRight: -> new Point @x+@width, @y
  bottomLeft: -> new Point @x, @y+@height
  bottomRight: -> new Point @x+@width, @y+@height

  topEdge: -> new Point @width, 0
  bottomEdge: -> new Point -@width, 0
  leftEdge: -> new Point 0, -@height
  rightEdge: -> new Point 0, @height

module.exports = Rectangle
