# @toc

## Surface
class Surface

  ##### Surface.attachTo
  #
  @attachTo: (klass) -> klass::[k] = v for k,v of Surface.prototype

  ##### Surface::containsGeometry
  #
  containsGeometry: (geometry) ->
    geometry.points().every (point) => @contains point

module.exports = Surface
