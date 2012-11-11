# @toc
Mixin = require './mixin'
Point = require './point'

## Intersections
class Intersections extends Mixin
  ##### Intersections::intersects
  #
  intersects: (geometry) ->
    return false if geometry.bounds? and not @boundsCollide geometry
    output = false

    @eachIntersections geometry, ->
      output = true

    output

  ##### Intersections::intersections
  #
  intersections: (geometry) ->
    return null if geometry.bounds? and not @boundsCollide geometry
    output = []

    @eachIntersections geometry, (intersection) ->
      output.push intersection
      false

    if output.length > 0 then output else null

  ##### Intersections::boundsCollide
  #
  boundsCollide: (geometry) ->
    bounds1 = @bounds()
    bounds2 = geometry.bounds()

    not (
      bounds1.top > bounds2.bottom or
      bounds1.left > bounds2.right or
      bounds1.bottom < bounds2.top or
      bounds1.right < bounds2.left
    )
  ##### Intersections::eachIntersections
  #
  eachIntersections: (geometry, block, providesDataInCallback=false) ->
    points1 = @points()
    points2 = geometry.points()
    length1 = points1.length
    length2 = points2.length
    output = []

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

          if providesDataInCallback
            context =
              segment1: dif1
              segmentIndex1: i
              segmentStart1: sv1
              segmentEnd1: ev1
              segment2: dif2
              segmentIndex2: j
              segmentStart2: sv2
              segmentEnd2: ev2

          return if block.call this, cross, context

  ##### Intersections::perCrossing
  #
  perCrossing: (start1, dir1, start2, dir2) ->
    v3bx = start2.x - start1.x
    v3by = start2.y - start1.y
    perP1 = v3bx*dir2.y - v3by*dir2.x
    perP2 = dir1.x*dir2.y - dir1.y*dir2.x

    t = perP1 / perP2

    cx = start1.x + dir1.x*t
    cy = start1.y + dir1.y*t

    new Point cx, cy

module.exports = Intersections
