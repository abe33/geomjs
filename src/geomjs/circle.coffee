Point = require './point'
Geometry = require './geometry'

class Circle
  Geometry.attachTo Circle

  constructor: (@radius=0, @x=0, @y=0, @segments=36) ->

  #### Bounds
  top: -> @y - @radius
  bottom: -> @y + @radius
  left: -> @x - @radius
  right: -> @x + @radius

  #### Path API
  length: -> @radius * Math.PI * 2

  #### Surface API
  acreage: -> @radius * @radius * Math.PI

  #### Geometry API
  points: ->
    step = 360 / @segments
    @pointAtAngle n * step for n in [0..@segments]

  pointAtAngle: (angle) ->
    new Point @x + Math.cos(Math.degToRad(angle)) * @radius,
              @y + Math.sin(Math.degToRad(angle)) * @radius

  drawPath: (context) ->
    context.beginPath()
    context.arc @x, @y, @radius, 0, Math.PI * 2

  #### Utilities
  equals: (o) -> o? and o.radius is @radius and o.x is @x and o.y is @y

module.exports = Circle
