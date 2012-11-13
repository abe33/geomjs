# @toc
Point = require './point'
Equatable = require './mixins/equatable'
Formattable = require './mixins/formattable'
Cloneable = require './mixins/cloneable'
Parameterizable = require './mixins/parameterizable'
Geometry = require './mixins/geometry'
Surface = require './mixins/surface'
Path = require './mixins/path'
Intersections = require './mixins/intersections'

class Diamond
  PROPERTIES = ['x','y','top','left','bottom','right']

  Formattable.apply(Formattable,['Diamond'].concat PROPERTIES).attachTo Diamond
  Parameterizable('diamondFrom',{
    top: 1
    right: 1
    bottom: 1
    left: 1
    x: 0
    y: 0
    rotation: 0
  }).attachTo Diamond
  Equatable.apply(Equatable, PROPERTIES).attachTo Diamond
  Cloneable.attachTo Diamond

  constructor: (top, right, bottom, left, x, y, rotation) ->
    args = @diamondFrom top, right, bottom, left, x, y, rotation
    {@top, @right, @bottom, @left, @x, @y, @rotation} = args

module.exports = Diamond
