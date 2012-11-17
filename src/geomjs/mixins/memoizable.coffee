# @toc
Mixin = require './mixin'

## Memoizable
class Memoizable extends Mixin
  ##### Memoizable.attachTo
  #
  # See
  # [Mixin.attachTo](src_geomjs_mixins_mixin.html#mixinattachto)

  ##### Memoizable::memoized
  #
  memoized: (prop) ->
    if @memoizationKey() is @__memoizationKey__
      @__cache__?[prop]?
    else
      @__cache__ = {}
      false

  ##### Memoizable::memoFor
  #
  memoFor: (prop) -> @__cache__[prop]

  ##### Memoizable::memoize
  #
  memoize: (prop, value) ->
    @__cache__ ||= {}
    @__memoizationKey__ = @memoizationKey()
    @__cache__[prop] = value

  ##### Memoizable::memoizationKey
  #
  memoizationKey: -> @toString()

module.exports = Memoizable
