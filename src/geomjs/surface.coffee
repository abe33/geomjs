# @toc

## Surface
class Surface

  ##### Surface.attachTo
  #
  @attachTo: (klass) -> klass::[k] = v for k,v of Surface.prototype

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
