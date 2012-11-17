# @toc
Mixin = require './mixin'

## Path
class Path extends Mixin
  ##### Path.attachTo
  #
  # See
  # [Mixin.attachTo](src_geomjs_mixins_mixin.html#mixinattachto)

  ##### Path::length
  #
  # **Virtual method**
  length: -> null

  ##### Path::pathPointAt
  #
  # **Virtual method**
  pathPointAt: (n, pathBasedOnLength=true) -> null

  ##### Path::pathOrientationAt
  #
  # **Virtual method**
  pathOrientationAt: (n, pathBasedOnLength=true) ->
    p1 = @pathPointAt n - 0.01
    p2 = @pathPointAt n + 0.01
    d = p2.subtract p1

    return d.angle()

  ##### Path::pathTangentAt
  #
  pathTangentAt: (n, accuracy=1 / 100, pathBasedOnLength=true) ->
    @pathPointAt((n + accuracy) % 1)
      .subtract(@pathPointAt((1 + n - accuracy) % 1))
      .normalize(1)

module.exports = Path
