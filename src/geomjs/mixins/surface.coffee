# @toc
Mixin = require './mixin'

## Surface
class Surface extends Mixin
  ##### Surface.attachTo
  #
  # See
  # [Mixin.attachTo](src_geomjs_mixins_mixin.html#mixinattachto)

  ##### Surface::acreage
  #
  # **Virtual method**
  acreage: -> null

  ##### Surface::randomPointInSurface
  #
  # **Virtual method**
  randomPointInSurface: -> null

  ##### Surface::contains
  #
  # **Virtual method**
  contains: (xOrPt, y) -> null

  ##### Surface::containsGeometry
  #
  containsGeometry: (geometry) ->
    geometry.points().every (point) => @contains point

module.exports = Surface
