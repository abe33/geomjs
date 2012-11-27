
Point = require '../../../lib/geomjs/point'
Triangle = require '../../../lib/geomjs/triangle'

pt = point(1,0)
v = point(4,0)
v2 = v.rotate(Math.PI * 2 / 6)

factories =
  default: ->
    [
      new Point 1,2
      new Point 3,4
      new Point 1,5
    ]
  isosceles: ->
    [
      new Point 1,1
      new Point 3,1
      new Point 2,4
    ]
  rectangle: ->
    [
      new Point 1,1
      new Point 3,1
      new Point 3,4
    ]
  equilateral: ->
    [
      pt
      pt.add(v)
      pt.add(v2)
    ]

global.triangle = (a,b,c) ->
  a = factories.default()[0] unless a?
  c = factories.default()[2] unless c?
  b = factories.default()[1] unless b?
  new Triangle a, b, c

global.triangleData = (a,b,c) ->
  a = factories.default()[0] unless a?
  c = factories.default()[2] unless c?
  b = factories.default()[1] unless b?
  data =
    a: a
    b: b
    c: c

  data.merge
    ab: b.subtract a
    ac: c.subtract a
    ba: a.subtract b
    bc: c.subtract b
    ca: a.subtract c
    cb: b.subtract c

  data.merge
    top: Math.min a.y, b.y, c.y
    bottom: Math.max a.y, b.y, c.y
    left: Math.min a.x, b.x, c.x
    right: Math.max a.x, b.x, c.x

  data.merge
    abc: data.ba.angleWith data.bc
    bac: data.ab.angleWith data.ac
    acb: data.ca.angleWith data.cb

  data.merge
    bounds:
      top: data.top
      bottom: data.bottom
      left: data.left
      right: data.right

  data.merge
    center:
      x: (a.x + b.x + c.x) / 3
      y: (a.y + b.y + c.y) / 3
    abCenter: a.add data.ab.scale(0.5)
    acCenter: a.add data.ac.scale(0.5)
    bcCenter: b.add data.bc.scale(0.5)

  data.merge
    length: data.ab.length() + data.bc.length() + data.ca.length()
    acreage: data.ab.length() *
             data.bc.length() *
             Math.abs(Math.sin(data.abc)) / 2

  data

['isosceles', 'rectangle', 'equilateral'].forEach (k) ->
  triangle[k] = -> triangle.apply global, factories[k]()
  triangleData[k] = -> triangleData.apply global, factories[k]()

triangle.withPointLike = (a,b,c) ->
  a = x: 1, y: 2 unless a?
  b = x: 3, y: 4 unless b?
  c = x: 1, y: 5 unless c?
  triangle a, b, c

