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

  constructor: (r1, r2, x, y, rot, segments) ->
    [@radius1, @radius2, @x, @y, @rotation, @segments] = @ellipsisFrom r1, r2,
                                                                       x, y,
                                                                       rot,
                                                                       segments

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
