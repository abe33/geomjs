class Circle
  constructor: (@radius=0, @x=0, @y=0, @segments=36) ->

  #### Path API
  length: -> @radius * Math.PI * 2

  #### Surface API
  acreage: -> @radius * @radius * Math.PI

  #### Utilities
  equals: (o) -> o? and o.radius is @radius and o.x is @x and o.y is @y

module.exports = Circle
