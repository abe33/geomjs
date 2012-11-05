class Path
  ##### Path.attachTo
  #
  @attachTo: (klass) -> klass::[k] = v for k,v of this when k isnt 'attachTo'

  ##### Path::pathTangentAt
  #
  @pathTangentAt: (n, accuracy=1 / 100, pathBasedOnLength=true) ->
    @pathPointAt((n + accuracy) % 1)
      .subtract(@pathPointAt((1 + n - accuracy) % 1))
      .normalize(1)

module.exports = Path
