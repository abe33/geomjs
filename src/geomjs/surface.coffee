
class Surface
  @attach: (klass) -> klass::[k] = v for k,v of this when k isnt 'attach'
  @containsGeometry: (geometry) ->
    geometry.points().every (point) => @contains point

module.exports = Surface
