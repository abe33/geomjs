Point = require './point'

class Geometry
  @attachTo: (klass) -> klass::[k] = v for k,v of this when k isnt 'attachTo'
  @intersects: (geometry) ->
    points1 = @points()
    points2 = geometry.points()
    length1 = points1.length
    length2 = points2.length

    for i in [0..length1-2]
      sv1 = points1[i]
      ev1 = points1[i+1]
      dif1 = ev1.subtract sv1

      for j in [0..length2-2]
        sv2 = points2[j]
        ev2 = points2[j+1]
        dif2 = ev2.subtract sv2

        cross = @perCrossing sv1, dif1, sv2, dif2
        d1 = cross.subtract ev1
        d2 = cross.subtract sv1
        d3 = cross.subtract ev2
        d4 = cross.subtract sv2

        if d1.length() <= dif1.length() and
           d2.length() <= dif1.length() and
           d3.length() <= dif2.length() and
           d4.length() <= dif2.length()
          return true

    return false

  @perCrossing: (start1, dir1, start2, dir2) ->
    v3bx = start2.x - start1.x
    v3by = start2.y - start1.y
    perP1 = v3bx*dir2.y - v3by*dir2.x
    perP2 = dir1.x*dir2.y - dir1.y*dir2.x

    t = perP1 / perP2

    cx = start1.x + dir1.x*t
    cy = start1.y + dir1.y*t

    new Point cx, cy

module.exports = Geometry
