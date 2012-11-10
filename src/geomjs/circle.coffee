Point = require './point'
Geometry = require './geometry'

class Circle
  Geometry.attachTo Circle

  constructor: (@radius=1, @x=0, @y=0, @segments=36) ->

  center: -> new Point @x, @y

  #### Bounds
  top: -> @y - @radius
  bottom: -> @y + @radius
  left: -> @x - @radius
  right: -> @x + @radius

  #### Path API
  length: -> @radius * Math.PI * 2

  pathPointAt: (n) -> @pointAtAngle n * 360
  pathOrientationAt: (n) ->
    p1 = @pathPointAt n - 0.01
    p2 = @pathPointAt n + 0.01
    d = p2.subtract p1

    return d.angle()

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
