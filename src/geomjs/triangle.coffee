Point = require './point'
Surface = require './surface'
Geometry = require './geometry'

class Triangle
  Geometry.attachTo Triangle
  Surface.attachTo Triangle

  constructor: (a, b, c) -> @initialize a, b, c

  initialize: (a, b, c) ->
    @invalidPoint 'a', a unless Point.isPoint a
    @invalidPoint 'b', b unless Point.isPoint b
    @invalidPoint 'c', c unless Point.isPoint c

    @a = new Point a
    @b = new Point b
    @c = new Point c

  length: -> @ab().length() + @bc().length() + @ca().length()
  acreage: -> @ab().length() * @bc().length() * Math.abs(Math.sin(@abc())) / 2
  closedGeometry: -> true

  ['ab','ac','ba', 'bc', 'ca', 'cb'].forEach (k) ->
    [p1,p2] = k.split ''
    Triangle::[k] = -> @[p2].subtract @[p1]

  ['abc', 'bac', 'acb'].forEach (k) ->
    [p1,p2,p3] = k.split ''
    Triangle::[k] = -> @["#{p2}#{p1}"]().angleWith @["#{p2}#{p3}"]()

  drawPath: (context) ->
    context.beginPath()
    context.moveTo @a.x, @a.y
    context.lineTo @b.x, @b.y
    context.lineTo @c.x, @c.y
    context.lineTo @a.x, @a.y
    context.closePath()

  invalidPoint: (k,v) -> throw new Error "Invalid point #{v} for vertex #{k}"

module.exports = Triangle
