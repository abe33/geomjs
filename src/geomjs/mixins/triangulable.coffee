# @toc
Mixin = require './mixin'
Memoizable = require './memoizable'
Triangle = require '../triangle'
Point = require '../point'

## Triangulable
class Triangulable extends Mixin
  Memoizable.attachTo Triangulable

  #### Private Utilities

  ##### arrayCopy
  #
  arrayCopy = (arrayTo, arrayFrom) -> arrayTo[i] = n for n,i in arrayFrom

  ##### ptInTri
  #
  ptInTri = (pt, v1, v2, v3) ->
    denom = (v1.y - v3.y) * (v2.x - v3.x) + (v2.y - v3.y) * (v3.x - v1.x)
    b1 = ((pt.y - v3.y) * (v2.x - v3.x) + (v2.y - v3.y) * (v3.x - pt.x)) / denom
    b2 = ((pt.y - v1.y) * (v3.x - v1.x) + (v3.y - v1.y) * (v1.x - pt.x)) / denom
    b3 = ((pt.y - v2.y) * (v1.x - v2.x) + (v1.y - v2.y) * (v2.x - pt.x)) / denom
    return false if b1 < 0 or b2 < 0 or b3 < 0
    true

  ##### polyArea
  #
  polyArea = (pts) ->
    sum = 0
    i = 0
    l = pts.length

    for i in [0..l-1]
      sum += pts[i].x * pts[(i + 1) % l].y - pts[(i + 1) % l].x * pts[i].y

    sum / 2

  ##### triangulate
  #
  triangulate = (vertices) ->
    return if vertices.length < 4

    pts = vertices
    refs = (i for n,i in pts)
    ptsArea = []
    i = 0
    l = refs.length

    while i < l
      ptsArea[i] = pts[refs[i]].clone()
      ++i
    pArea = polyArea(ptsArea)
    cr = []
    nr = []
    r1 = undefined
    r2 = undefined
    r3 = undefined
    v0 = undefined
    v1 = undefined
    v2 = undefined
    arrayCopy cr, refs
    while cr.length > 3
      i = 0
      l = cr.length

      while i < l
        r1 = cr[i % l]
        r2 = cr[(i + 1) % l]
        r3 = cr[(i + 2) % l]
        v1 = pts[r1]
        v2 = pts[r2]
        v3 = pts[r3]
        ok = true
        j = (i + 3) % l

        while j isnt i
          ptsArea = [v1, v2, v3]
          tArea = polyArea(ptsArea)
          if (pArea < 0 and tArea > 0) or (pArea > 0 and tArea < 0) or ptInTri(pts[cr[j]], v1, v2, v3)
            ok = false
            break
          j = (j + 1) % l
        if ok
          nr.push r1
          nr.push r2
          nr.push r3
          cr.splice (i + 1) % l, 1
          break
        ++i
    nr.push cr[0]
    nr.push cr[1]
    nr.push cr[2]
    triangulated = true

    return nr

  #### Mixin Methods

  ##### Triangulable::triangles
  #
  triangles: ->
    return @memoFor 'triangles' if @memoized 'triangles'

    vertices = @points()
    vertices.pop()
    indices = triangulate vertices
    triangles = []
    for i in [0..indices.length / 3 -1]
      index = i * 3
      a = vertices[indices[index]]
      b = vertices[indices[index+1]]
      c = vertices[indices[index+2]]
      triangles.push new Triangle a, b, c

    @memoize 'triangles', triangles


module.exports = Triangulable
