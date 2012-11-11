# @toc
Point = require './point'
Equatable = require './equatable'
Formattable = require './formattable'
Geometry = require './geometry'
Surface = require './surface'
Path = require './path'

## Ellipsis
class Ellipsis
  Equatable('radius1', 'radius2', 'x', 'y', 'rotation').attachTo Ellipsis
  Formattable('Ellipsis', 'radius1', 'radius2', 'x', 'y', 'rotation')
    .attachTo Ellipsis
  Geometry.attachTo Ellipsis
  # Surface.attachTo Ellipsis
  # Path.attachTo Ellipsis

  constructor: (r1, r2, x, y, rot, segments) ->
    [@radius1, @radius2, @x, @y, @rotation, @segments] = @ellipsisFrom r1, r2,
                                                                       x, y,
                                                                       rot,
                                                                       segments

  center: -> new Point @x, @y

  acreage: -> Math.PI * @radius1 * @radius2
  length: -> Math.PI * (3*(@radius1 + @radius2) -
             Math.sqrt((3* @radius1 + @radius2) * (@radius1 + @radius2 *3)))

  closedGeometry: -> true

  left: ->
    phi = Math.degToRad @rotation
    t = Math.atan(-@radius2 * Math.tan(phi) / @radius1) + Math.PI
    @x + @radius1*Math.cos(t)*Math.cos(phi) -
         @radius2*Math.sin(t)*Math.sin(phi)
  right: ->
    phi = Math.degToRad @rotation
    t = Math.atan(-@radius2 * Math.tan(phi) / @radius1)
    @x + @radius1*Math.cos(t)*Math.cos(phi) -
         @radius2*Math.sin(t)*Math.sin(phi)
  bottom: ->
    phi = Math.degToRad @rotation
    t = Math.atan(@radius2 * Math.cos(phi) / @radius1)
    @y + @radius1*Math.sin(t)*Math.cos(phi) +
         @radius2*Math.cos(t)*Math.sin(phi)
  top: ->
    phi = Math.degToRad @rotation
    t = Math.atan(@radius2 * Math.cos(phi) / @radius1) + Math.PI
    @y + @radius1*Math.sin(t)*Math.cos(phi) +
         @radius2*Math.cos(t)*Math.sin(phi)

  clone: -> new Ellipsis this

  drawPath: (context) ->
    context.save()
    context.translate(@x, @y)
    context.rotate(Math.degToRad @rotation)
    context.scale(@radius1, @radius2)
    context.beginPath()
    context.arc(0,0,1,0, Math.PI*2)
    context.closePath()
    context.restore()

  points: ->
    step = 360 / @segments
    @pathPointAt n * step for n in [0..@segments]

  pathPointAt: (n) ->
    a = Math.degToRad n
    p = new Point Math.cos(a) * @radius1, Math.sin(a) * @radius2

    @center().add p.rotate(@rotation)

  ellipsisFrom: (radius1, radius2, x, y, rotation, segments) ->
    if typeof radius1 is 'object'
      {radius1, radius2, x, y, rotation, segments} = radius1

    radius1 = 1 unless Point.isFloat radius1
    radius2 = 1 unless Point.isFloat radius2
    x = 0 unless Point.isFloat x
    y = 0 unless Point.isFloat y
    rotation = 0 unless Point.isFloat rotation
    segments = 36 unless Point.isFloat segments

    [radius1, radius2, x, y, rotation, segments]

module.exports = Ellipsis
