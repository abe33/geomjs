class Circle
  constructor: (@radius=0, @x=0, @y=0) ->


  #### Surface API
  acreage: -> @radius * @radius * Math.PI

module.exports = Circle
