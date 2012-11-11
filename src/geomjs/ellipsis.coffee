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
  Surface.attachTo Ellipsis
  Path.attachTo Ellipsis

  constructor: (r1, r2, x, y, rot, segments) ->
    [@radius1, @radius2, @x, @y, @rotation, @segments] = @ellipsisFrom r1, r2,
                                                                       x, y,
                                                                       rot,
                                                                       segments

  center: -> new Point @x, @y

  #### Geometry API

  points: ->
    @pathPointAt n / @segments for n in [0..@segments]

  closedGeometry: -> true

  pointAtAngle: (angle) ->
    center = @center()
    vec = center.add Math.cos(Math.degToRad(angle))*10000,
                     Math.sin(Math.degToRad(angle))*10000
    @intersections(points: -> [center, vec])?[0]


  #### Path API

  length: -> Math.PI * (3*(@radius1 + @radius2) -
             Math.sqrt((3* @radius1 + @radius2) * (@radius1 + @radius2 *3)))

  pathPointAt: (n) ->
    a = n * Math.PI * 2
    p = new Point Math.cos(a) * @radius1, Math.sin(a) * @radius2

    @center().add p.rotate(@rotation)

  pathOrientationAt: (n) ->
    p1 = @pathPointAt n - 0.01
    p2 = @pathPointAt n + 0.01
    d = p2.subtract p1

    return d.angle()

  #### Surface API

  acreage: -> Math.PI * @radius1 * @radius2

  randomPointInSurface: (random) ->
    unless random?
      random = new chancejs.Random new chancejs.MathRandom

    pt = @pathPointAt random.get()
    center = @center()
    dif = pt.subtract center
    center.add dif.scale Math.sqrt random.random()

  contains: (xOrPt, y) ->
    [x,y] = Point.coordsFrom xOrPt, y
    p = new Point(x,y)
    c = @center()
    d = p.subtract c
    a = d.angle()
    p2 = @pointAtAngle a
    c.distance(p2) >= c.distance(p)


  #### Drawing API

  drawPath: (context) ->
    context.save()
    context.translate(@x, @y)
    context.rotate(Math.degToRad @rotation)
    context.scale(@radius1, @radius2)
    context.beginPath()
    context.arc(0,0,1,0, Math.PI*2)
    context.closePath()
    context.restore()

  #### Utilities

  clone: -> new Ellipsis this

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
