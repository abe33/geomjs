class Rectangle
  constructor: (@x, @y, @width, @height) ->

  acreage: -> @width * @height

module.exports = Rectangle
