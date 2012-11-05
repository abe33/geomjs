
Point = require '../../../lib/geomjs/point'
Triangle = require '../../../lib/geomjs/triangle'

global.triangle = (a,b,c) ->
  a = new Point 1,2 unless a?
  b = new Point 3,4 unless b?
  c = new Point 1,5 unless c?
  new Triangle a, b, c

triangle.isosceles = ->
  triangle new Point(1,1),
           new Point(3,1),
           new Point(2,4)

triangle.rectangle = ->
  triangle new Point(1,1),
           new Point(3,1),
           new Point(2,4)

triangle.equilateral = ->
  triangle new Point( 4, 0),
           new Point(-6, 0),
           new Point(-1, 3*Math.sqrt(5))

triangle.withPointLike = (a,b,c) ->
  a = x: 1, y: 2 unless a?
  b = x: 3, y: 4 unless b?
  c = x: 1, y: 5 unless c?
  triangle a, b, c

global.triangleData = (a,b,c) ->
  a = new Point 1,2 unless a?
  b = new Point 3,4 unless b?
  c = new Point 1,5 unless c?
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

triangleData.isosceles = ->
  triangleData new Point(1,1),
               new Point(3,1),
               new Point(2,4)

triangleData.rectangle = ->
  triangleData new Point(1,1),
               new Point(3,1),
               new Point(2,4)

triangleData.equilateral = ->
  triangleData new Point( 4, 0),
               new Point(-6, 0),
               new Point(-1, 3*Math.sqrt(5))

