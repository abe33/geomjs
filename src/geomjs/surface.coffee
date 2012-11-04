
class Surface
  @attachTo: (klass) -> klass::[k] = v for k,v of this when k isnt 'attachTo'
  @containsGeometry: (geometry) ->
    geometry.points().every (point) => @contains point

module.exports = Surface
