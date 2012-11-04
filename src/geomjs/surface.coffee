# @toc

## Surface
class Surface

  ##### Surface.attachTo
  #
  @attachTo: (klass) -> klass::[k] = v for k,v of this when k isnt 'attachTo'

  ##### Surface.containsGeometry
  #
  @containsGeometry: (geometry) ->
    geometry.points().every (point) => @contains point

module.exports = Surface
